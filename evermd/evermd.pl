#!/usr/bin/env perl 

use strict ;

#my $ARGC = @ARGV ;

sub parse_table {
	my ($text) = @_ ;
	my $body = "" ;

	# parse line continuation
	$text =~ s/\\\n//g ;		

	my @a_lines = split "\n", $text ;

	# parse header
	if ( $a_lines[0] =~ /^---/ ){
		shift @a_lines ;
	} elsif ( $a_lines[1] =~ /^---/ ){
		for my $h(split "&", shift @a_lines){
			$body .= "<th>$h</th>" ;
		}
		$body = "<tr>$body</tr>\n" ;
		shift @a_lines ;
	} else {
		die("ill evermd table notation:".
		"'---' should appear at 1st or 2nd row.") ;
	}

	# parse rows
	for my $line(@a_lines){
		my $row = "" ;
		for my $cell(split "&", $line){
			$row .= "<td>$cell</td>" ;
		}
		$body .= "<tr>$row</tr>\n" ;
	}
	#return "<table>\n$body\n</table>" ;
	return "<table border=1>\n$body\n</table>" ;
}

sub parse {
	my ($marker, $text) = @_ ;
	if ($marker eq "table") {
		return parse_table($text) ;
	}
	else {
		die("unknown marker $marker") ;
	}
}

# ========= main ===========

open f_med, " | markdown > /dev/stdout" ;
my $str = `cat test.md` ;

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
