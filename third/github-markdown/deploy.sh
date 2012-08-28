#!/usr/bin/env bash

cd ext/markdown ; ruby extconf.rb ; make ; cd -
cp ext/markdown/markdown.so bin/

exit 0 
