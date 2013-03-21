#!/bin/bash

if [[ $# == 2 ]]; then
	fn_in="$1"
	fn_out="$2"
else
	echo "usage: $0 {fn_md} {fn_html}"
	exit 255
fi

# Use Github Api to render GFM

URL="https://api.github.com/markdown/raw"

wget --post-file=$fn_in -O $fn_out --header "Content-Type: text/x-markdown" $URL 

exit 0 
