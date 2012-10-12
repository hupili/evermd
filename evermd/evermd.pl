#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin $Script) ;
my $fn_execute = "$Bin/$Script" ;
my $dir_execute = $Bin ;
use File::Temp qw(tempfile tempdir) ;
use URI::Escape ;
use Digest::MD5 qw(md5 md5_hex md5_base64) ;

my $_exe_markdown = "$dir_execute/../third/github-markdown/bin/github-markdown.rb" ;
#my $_exe_markdown = "pandoc" ;
my $_exe_transformula = "$dir_execute/transformula.sh" ;

our $ARGC = @ARGV ;
our %opt ;
our $fn_input ;
our @headings = () ;

sub usage {
	print STDERR << "EOF" ;
usage: evermd [-t {template}] [-n {marker}] [-o fn_output] [fn_input]
    -t: Specify the template filename.
    -n: Specify the marker that evermd should substitute in the 
        template. When -n is not passed, the default marker evermd 
        use is "{evermd:template:text}". 
    -o: Output filename. If not specified, output to STDOUT. 
    [fn_input]: Input filename. If not specified, input from STDIN. 
cautions:
    -n: This is and PerlRE. e.g. If your marker name is "[% body %]", 
        Then your CLI should look like:
            evermd -t {template} -n '\\[%body%\\]'
EOF
	exit ;
}

our $_dir_eq = "_eq" ;

sub init{
	use Getopt::Std;
	my $opt_string = 't:n:o:hv';
	getopts( "$opt_string", \%opt ) or usage();
	usage() if ($opt{h} or $opt{v});

	#for my $k(keys %opt){
	#	print $k, "\t", $opt{$k} , "\n";	
	#}
	#print "@ARGV" ;
	#exit 0 ;

	$fn_input = shift @ARGV ;

	(!defined($fn_input) || -f $fn_input) or die("input file not exist: $fn_input\n") ;
	((defined($opt{t}) && defined($opt{n})) || (! $opt{t} && !$opt{n})) or 
	   die("option t and n must come together!\n") ;

	if (defined($fn_input)) {
		my $_dir = `dirname $fn_input` ;
		chomp($_dir) ;
		$_dir_eq = "$_dir/$_dir_eq" ;
	}
	`mkdir -p $_dir_eq` ;
}

sub input {
	my @tmp ;
	if (! defined($fn_input) || $fn_input eq "-" ){
		@tmp = <STDIN> ;	
	} else {
		open f_input, "<$fn_input" or die("no such file: $fn_input\n") ;
		@tmp = <f_input> ;
	}
	return @tmp ;
}

# returns: ($filehandle, $filename)
sub open_tmp {
	return tempfile(UNLINK => 1, SUFFIX => "evermd") ;
}

# In evermd preprocessing section. 
# You can specify some additional attributes. 
# They can be HTML attributes (usual case). 
# Or they can be something evernote understands. 
# How to interpret the attributes depends on 
# evermd implementation. It's suggested not to 
# use them since both markdown and evermd 
# intends to introduce a super simple syntax. 
# This extension only leaves a backup for 
# functions people may think important. 
our %h_attrs = () ;

sub parse_table_line{
	my ($type, $line) = @_ ;
	my $row = "" ;

	$line =~ s/(&+ )([^&]+)/$1$2\n/g ;
	for my $cell(split "\n", $line){
		if ($cell =~ /(&+ )([^&]*)/){
			my $col = length($1) - 1 ;
			my $text = $2 ;
			my $colstr = "" ;
			if ( $col > 1 ){
				$colstr = "colspan=$col" ;
			}
			$row .= "<$type $colstr>$text</$type>" ;
		}
	}
	return "<tr>$row</tr>\n" ;
}

sub parse_table{
	my ($text) = @_ ;
	my $body = "" ;

	# parse line continuation
	$text =~ s/\\\n//g ;		

	my @a_lines = split "\n", $text ;

	# parse header
	if ( $a_lines[0] =~ /^---/ ){
		shift @a_lines ;
	} elsif ( $a_lines[1] =~ /^---/ ){
		$body = parse_table_line("th",  shift @a_lines) ;
		shift @a_lines ;
	} else {
		die("ill evermd table notation:".
		"'---' should appear at 1st or 2nd row.") ;
	}

	# parse rows
	for my $line(@a_lines){
		$body .= parse_table_line("td", $line)
	}

	my $style = "" ;
	#for my $k(keys %h_attrs){print STDERR $k} ;
	if (exists $h_attrs{"style"}){
		my $css_string = $h_attrs{"style"} ;
		$style = qq(style="$css_string") ;
	}
	#return "<table>\n$body\n</table>" ;
	return "<table border=1 $style>\n$body\n</table>" ;
}

sub parse_css{
	my ($text) = @_ ;
	return qq(<link href="$text" rel="stylesheet" type="text/css" />\n)
	# The following way is suggested by some blog authors. 
	# In my test, it does not show any difference from the above one. 
	# Both are surrended by <p></p> labels after markdown translation. 
	# Towards this end, I stick to the latest standard way. 
	#return qq(<link href="$text" rel="stylesheet" type="text/css"></link>\n)
}

# evermd defined variables. 
# One ususally use them to get some environment information. 
sub parse_var{
	my ($text) = @_ ;
	chomp $text ;
	$text =~ s/^\s+//g ;
	$text =~ s/\s+$//g ;
	if ($text eq "now") {
		return `date` ;
	} elsif ($text eq "evermd") {
		return "This document is built by "
			. "[evermd](https://github.com/hupili/evermd)\n" ;
	} elsif ($text eq "toc") {
		my $tmp = "" ;
		for my $he(@headings){
			my $h = $he->{heading} ;
			my $id = $he->{id} ;
			my $l = $he->{level} ;
			my $sp = " " x ($l * 3) ;
			$tmp .= "$sp* [$h](#$id)\n" ;
		}
		$tmp = qq(\n<a id="__toc__"></a>TOC:\n$tmp) ;
		#print STDERR $tmp; 
		return $tmp ;
	} else {
		die("unkown variable: $text\n") ;
	}
}

sub parse_attribute{
	my ($text) = @_ ;
	my @a_lines = split "\n", $text ;
	chomp $a_lines[0] ;
	chomp $a_lines[1] ;
	$h_attrs{$a_lines[0]} = $a_lines[1] ;
	return ""
}

sub parse_comment{
	my ($text) = @_ ;
	return "" ;
}

sub parse_formula{
	my ($text) = @_ ;
	$text = uri_escape($text) ;
	my $fn = md5_hex($text) ;
	$fn = "$_dir_eq/$fn.png" ;
	my $path = $fn ;
	my $url = $fn ;
	my $ret = system qq($_exe_transformula $text $path) ;
	if ($ret == 0) {
		return "![$fn]($url)" ;
	} else {
		return "!formular parse error!" ;	
	}
}
	
sub parse{
	my ($marker, $text) = @_ ;
	if ($marker eq "table") {
		return parse_table($text) ;
	} elsif ($marker eq "css") {
		return parse_css($text) ;
	} elsif ($marker eq "attribute"){
		return parse_attribute($text) ;
	} elsif ($marker eq "var"){
		return parse_var($text) ;
	} elsif ($marker eq "comment"){
		return parse_comment($text) ;
	} elsif ($marker eq "formula"){
		return parse_formula($text) ;
	} elsif ($marker eq "bformula"){
		return "\n" . parse("formula", $text) . "\n";
	} else {
		die("unknown marker $marker") ;
	}
}

# input: a single line string
# output: an array, each formula is on an individual line
sub isolate_formula {
	my ($line) = @_ ;
	#my @tmp = () ;
	if ( $line =~ /(\$.+?\$)/ ){
		$line =~ s/(\$.+?\$)/evermd-formula-marker$1evermd-formula-marker/g ;
		#@tmp = split "evermd-formula-marker", $line; 
		return split "evermd-formula-marker", $line; 
	} else {
		return ($line) ;
	}
}

sub parse_inline_formula {
	my ($line) = @_ ;
	my @tmp = () ;
	chomp ($line) ;
	for my $part(isolate_formula($line)){
		#print STDERR "part:$part\n" ; 
		if ($part =~ /\$(.+)\$/) {
			push @tmp, parse("formula", $1) ;
			#print STDERR "parse formula: $1\n" ;
		} else {
			push @tmp, $part ;
			#print STDERR "direct push\n" ;
		}
	}
	$line = join("", @tmp) ;
	$line .= "\n" ;
	return $line ;
}


# input: array of lines
# output: string of preprocessed MD
sub evermd_pre {
	my @a_input = @_ ;
	my $str_pre = "" ; # the preprocessed result of evermd
	my $cur_marker = "" ;
	my $cur_text = "" ;
	my $is_in_code_block = 0 ;
	my $is_in_formula_block = 0 ;
	for my $line(@a_input){
		# parse code region
		if ($line =~ /^```/) {
			$is_in_code_block = ! $is_in_code_block ;
		}
		if ($is_in_code_block) {
			$str_pre .= $line ;
			next ;
		}
		# By evermd convention, evermd marker appears at the 
		# beginning of each line. So using tab (4 blanks) 
		# style code block is safe. 

		if ($line =~ /^\$\$/) {
			$is_in_formula_block = ! $is_in_formula_block ;
			if ($is_in_formula_block){
				$line = "{evermd:bformula:begin}" ;
			} else {
				$line = "{evermd:bformula:end}" ;
			}
		}

		$line = parse_inline_formula($line) ;

		# parsing 1st version evermd tags
		if ($line =~ /^\{evermd:(.+):begin\}/) {
			my $tmp = $1 ;
			#print STDERR $1 ;
			if ($cur_marker ne "") {
				die("evermd marker unpaired(begin)") ;
			} else {
				$cur_marker = $tmp ;
				$cur_text = "" ;
			}
			next ;
		}
		if ($line =~ /^\{evermd:(.+):end\}/) {
			my $tmp = $1 ;
			if ($cur_marker ne $tmp) {
				die("evermd marker unpaired(end)") ;
			} else {
				$str_pre .= parse($cur_marker, $cur_text) ; 
				if ($cur_marker ne "attribute"){
					# Clear remembered attributes after each evermd 
					# pre-processing section. 
					%h_attrs = () ;
				}
				$cur_marker = "" ;
			}
			next ;
		}
		if ( $cur_marker ne "" ){
			# inside evermd marker
			$cur_text .= $line ;	
		} else {
			# normal text (MD standard)
			$str_pre .= $line ;
		}
	}
	return $str_pre ;
}

# When -t and -n are specified, 
# embed the MD output to a template. 
sub evermd_embed {
	my ($template, $name, $text) = @_ ;
	#print STDERR $template, "\n" ;
	#print STDERR $name, "\n" ;
	my $out = "" ;
	open(f_temp, "<$template") or die("can not open template: $template") ;
	while (my $line = <f_temp>){
		#$out .= $line ;
		if ( $line =~ /$name/ ){
			$out .= $text ;	
		} else {
			$out .= $line ;
		}
	}
	close f_temp ;
	return $out ;
}

sub heading_name2id {
	my ($name) = @_ ;
	$name =~ s/\s/_/g ;
	$name =~ s/[\.\[\]\(\)]/_/g ;
	return $name
}

sub heading_filter_name {
	my ($name) = @_ ;
	$name =~ s/[\[\]]/_/g ;
	return $name ;
}

# 1. extract headings for later making TOC
# 2. put book mark tags before headings
sub evermd_get_headings {
	my @in = @_ ;
	my @out = () ;
	@headings = () ;
	my $counter = 0 ;
	for my $line(@in){
		if ($line =~ /^\s*(#+) (.+)$/ ){
			my $hash = $1 ;
			my $h = $2 ;
			my $level = length($hash) ;
			$level -- ;
			if ( $level > 0 ) {
				$counter ++ ;
				$h =~ s/#//g ;
				$h = heading_filter_name($h) ;
				my $id = heading_name2id($h) ;
				$id = "h${counter}_$id" ; #solve heading repitition problem
				push @headings, {heading=>$h, id=>$id, level=>$level} ;
				push @out, qq(\n<a id="$id"></a>\n) ;
			}
		} 
		push @out, $line ;
	}
	return @out ;
}

sub output {
	my ($text) = @_ ;

	$text =~ s/\r\n/\n/g ;

	if (defined($opt{o})) {
		open f_out, ">$opt{o}" ;
		print f_out $text ;
		close f_out ;
	} else {
		print STDOUT $text ;
	}
}

# To help Tlist find this point
sub main {
	my @in = input() ;
	@in = evermd_get_headings(@in) ;
	my $str_pre = evermd_pre(@in) ;
	#my $str_pre = evermd_pre(isolate_formula(input())) ;
	#print $str_pre ;

	my ($fh_pre, $fn_pre) = open_tmp() ;
	print $fh_pre $str_pre ;

	#print STDERR $str_pre ;

	my $str_post = `cat $fn_pre | $_exe_markdown` ;

	if (defined($opt{t}) && defined($opt{n})) {
		output(evermd_embed($opt{t}, $opt{n}, $str_post)) ;
	} else { 
		output($str_post) ;
	}
}

# ==== main ====
init() ;
main() ;

exit 0 ;
