#!/bin/bash
#
# Compile all MD documents under one directory:
#    * Search for all *.md files under {dir}
#    * Find their corresponding *.html
#    * If x.md is modified later than x.html, 
#      compile it; Else skip. 
#    * See below for the compile commands, you 
#      should make them available before invoking 
#      this script. 

if [[ $# == 1 ]] ; then
	dir=$1
else
	echo "usage: $0 {dir}"
	exit 255
fi

if [[ ! -d $dir ]]; then
	echo "no $dir!"
	exit 255
fi

for source in `find $dir -name "*.md"`
do
	echo source: $source
	output=`echo "$source" | sed 's/\.md$/.html/'`
	echo output: $output
	source_time=`stat $source | grep Modify | sed 's/^Modify://g'`
	source_time=`date -d"$source_time" +%s`
	echo source_time: $source_time
	if [[ -f $output ]]; then
		output_time=`stat $output | grep Modify | sed 's/^Modify://g'`
		output_time=`date -d"$output_time" +%s`
		echo output_time: $output_time
	else
		echo "output file does not exist. writting..."
	fi
	if [[ $source_time > $output_time ]]; then
		# NOTICE:
		#     Uncomment any of the following compile command that is 
		#     available in your environment. 

		# 1: Plain evermd usage, support all evermd flavoured notations
		#    This is useful for compiling offline documents. 
		#cat "$source" | evermd > $output

		# 2: evermd with template, can embed the MD output to an HTML
		#    framework. This is most useful for your personal webpage
		#    You may want to change "general.t.html" to another template. 
		evermd -o $output -t general.t.html -n '\[% body %\]' $source

		# 3: Original markdown. Least function but best compatibility. 
		#cat "$source" | markdown > $output
		echo '[compile]'
	else
		echo '[skip]'
	fi
done
