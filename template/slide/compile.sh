#!/bin/bash

name="myslide"
evermd -t slide.t.html -n '\[% body %\]' -o ${name}.html ${name}.md
evermd -t slide-print.t.html -n '\[% body %\]' -o ${name}-print.html ${name}.md
