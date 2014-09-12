Out of maintenance notice:

This repo is two years old and out of maintenance.
The scripts may still run, with some environment steup.
However, I would recommend you to many other MD locales which already support the features proposed in this project.
During the first year I use MD, I find it's inconvenient and extend it in this project.
Apparently, people have realized similar problems and worked in different directions.
There might be a hundred MD locales out there with compilers implemented in different languages.
At the second year, I tried to make the [2.0 proposal](http://blog.hupili.net/p--20130731-markdown-extension/).
It was out of OCD or perfectionist. 
Now my new take is: let MD do what it is good at.
Look at the new features from this repo and other extensions.
They are useful but seldom used..
The only exception is TeX formula. 
Now, nearly everyone supports it via MathJax, a de facto standard.
That is because we really need to write formula a lot. 
However, we do not deadly need tables and other fancy stuffs.

Nevertheless, this repo is still useful for people to find some Perl sample codes.

------------


# evermd

Ever MarkDown! Solution Stacks for Markdown Usage

## Legend

One day, two coders met on their way home. 

One asked: have you ever marked down?

The other replied: sure! I have Ever MarkDown (evermd)! It's awesome!

> It seems the second guy missed the sound of "-ed". `-_-//`

## Introduction

MarkDown is an elegant language to structure a passage. 
Once you use it several times, you'll never forget the 
concise way of formatting. 
You focus more on the semantic part rather than 
the appearance then. 

You may have also noticed that MarkDown looks like
the younger brother of MarkUp (according to the name). 
That's true. 
It's younger but more powerful. 
It's not so mature, so there are some 
problems in writing or compiling. 

This repo collects Markdown related issues and solutions. 
Of course, the configurations are for my own flavour. 

## About the Repo

This project mainly contains some articles 
to help you better experience MarkDown. 
Just click into different directories and read them. 

To get all the files in this project, 

	git clone https://github.com/hupili/evermd.git
	git submodule init
	git submodule update

## Dependency

   * `perl`
   * `URI::Escape` module:
   can be installed by `[sudo] cpan install URI::Escape`

## How to Use evermd

evermd is my extension to Markdown. 
To execute it, you need the following:

   * A Perl interpreter. (only prerequisite by default)
   * An executable Markdown backend. 
   (e.g. original `markdown` Perl script, Github-flavoured markdown in the `third` directory)

Deploy steps:

   * Clone the whole Git repo (and all submodules if needed). 
   Just like what is documented in the last section. 
   * Go to `evermd` directory and execute `deploy.sh`. 
   An executable bash script called `evermd` will be created there. 
   * Copy the newly created `evermd` script to anywhere in your 
   $PATH variables so that you can execute it everywhere.  

Note that without doing those steps you are still able to 
execute `evermd.pl` directly with full path (full or relative). 

Check the help documents:

	evermd -h

If you execute with full path, the command may look like: (under current dir)

	./evermd.pl -h

You can test the functions by:

	cd test-suite
	evermd -o t1-test.html t1.md

`t1-test.html` should have same content as `t1.html` 
except for the embedded time. 

Any other problems, feel free to open an issue. 
Please specify the environment and the outcome you encounter. 

## Reference

   * css/markdown.css : 
   [https://github.com/clownfart/Markdown-CSS](https://github.com/clownfart/Markdown-CSS)

## License

![copyleft](http://unlicense.org/pd-icon.png)

[http://unlicense.org/](http://unlicense.org/)
