#!/usr/bin/env perl 

use strict ;

my $ARGC = @ARGV ;

sub parse_table_line{
	my ($type, $line) = @_ ;
	my $row = "" ;

	$line =~ s/(&+ )([^&]+)/\1\2\n/g ;
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
	#return "<table>\n$body\n</table>" ;
	return "<table border=1>\n$body\n</table>" ;
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

sub parse{
	my ($marker, $text) = @_ ;
	if ($marker eq "table") {
		return parse_table($text) ;
	} elsif ($marker eq "css") {
		return parse_css($text) ;
	} else {
		die("unknown marker $marker") ;
	}
}

# ========= main ===========

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

exit 0 ;
