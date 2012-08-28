#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin $Script) ;
my $fn_execute = "$Bin/$Script" ;
my $dir_execute = $Bin ;

my $_exe_markdown = "$dir_execute/../third/github-markdown/bin/github-markdown.rb" ;

my $ARGC = @ARGV ;
#print $ARGC ;

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
			. "[evermd](https://github.com/hupili/evermd)"
	} else {
		die("unkown variable: $text\n") ;
	}
}

sub parse_attribute{
	my ($text) = @_ ;
	my @a_lines = split "\n", $text ;
	chomp $a_lines[0] ;
	chomp $a_lines[1] ;
	#print STDERR "@a_lines" ;
	$h_attrs{$a_lines[0]} = $a_lines[1] ;
	return ""
}

sub parse_comment{
	my ($text) = @_ ;
	return "" ;
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
	} else {
		die("unknown marker $marker") ;
	}
}

# To help Tlist find this point
sub main {
	open f_med, " | markdown > /dev/stdout" ;

	my $cur_marker = "" ;
	my $cur_text = "" ;
	while (my $line = <STDIN>){
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
				#print STDERR parse($cur_marker, $cur_text) ;
				print f_med parse($cur_marker, $cur_text) ;
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
			$cur_text .= $line ;	
		} else {
			print f_med $line ;
		}
	}
	close f_med ;
}

# ==== main ====
main() ;

exit 0 ;
