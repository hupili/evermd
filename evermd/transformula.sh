#!/usr/bin/env bash
#
#Encapsulate the backend of formula translation in this script. 

if [[ $# == 2 ]]; then
	formula=$1
	output=$2
else
	echo "usage: $0 {formula} {output}"
	exit 255 
fi

formula="\large $formula"

# Example 1:
#url="http://chart.apis.google.com/chart?cht=tx&chl=$formula"
#
#Google API is not as powerful as the following codecogs
#
#try:
#   ./transformula.sh '\left\lbrace\begin{matrix}a&a\\b&d\end{matrix}\right.' test.png

# Example 2:
#http://latex.codecogs.com/gif.latex?\huge%20y=m%281-\beta%29
#The above url will generate a formula with "huge" font

url="http://www.codecogs.com/png.latex?$formula"

if [[ ! -e $output ]]; then
	wget --quiet -O $output "$url"
	exit $?
else
	exit 0 
fi

