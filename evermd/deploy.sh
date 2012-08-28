#!/usr/bin/env bash

cur_dir=`pwd`
echo $cur_dir
cur_dir=`echo "$cur_dir" | sed 's/\//\\\\\//g' `
# I know the above line has too many "\"s...
# It just works in that way, see the following 
# example and you'll find the reason...
# The first '\\\\' is for bash, and sed see '\\'.
#echo `echo sed 's/\//\\\\\//g' `
echo $cur_dir
sed -i "s/<<DIR_EVERMD>>/$cur_dir/g" evermd

exit 0 
