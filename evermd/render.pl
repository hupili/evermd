#!/usr/bin/env perl 

use strict;
use warnings;
use Template;
use base 'Exporter' ;
use FindBin qw($Bin $Script) ;
our $fn_execute = "$Bin/$Script" ;
our $dir_execute = $Bin ;

sub render_template2file{
	my ($fn_template, $vars, $output_file) = @_ ;

	my $config = {
		INCLUDE_PATH => "$dir_execute/template",  # or list ref
		INTERPOLATE  => 1,               # expand "$var" in plain text
		POST_CHOMP   => 1,               # cleanup whitespace 
		#PRE_PROCESS  => 'header',        # prefix each template
		EVAL_PERL    => 1,               # evaluate Perl code blocks
	};

	# create Template object
	my $template = Template->new($config);
	# process input template, substituting variables
	my $ret = $template->process($fn_template, $vars, $output_file) ;
	return $ret ;
}

sub main {
	my $body = `cat index.tex` ;
	render_template2file('latex.tex', {body => $body}, 'test.tex') ;
}

# === main ===
main() ;
