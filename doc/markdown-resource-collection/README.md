# Markdown Resource Collection



## Basic Tutorials

## Parser Implementations

### Python

#### python-markdown

Project:
[http://freewisdom.org/projects/python-markdown/](http://freewisdom.org/projects/python-markdown/)

Features:

   * Features like Attibutes, **Middle-word Emphsis** , Footnotes are all useful
   to individualize the md document. 
   [http://freewisdom.org/projects/python-markdown/Features](http://freewisdom.org/projects/python-markdown/Features)
   * Support of Attributes. The notation is simpler than evermd. 
   [http://six.pairlist.net/pipermail/markdown-discuss/2005-August/001486.html](http://six.pairlist.net/pipermail/markdown-discuss/2005-August/001486.html)
   * It supports extensions. In terms of architecture, this is a big advantage. 
   [http://www.freewisdom.org/projects/python-markdown/Available_Extensions](http://www.freewisdom.org/projects/python-markdown/Available_Extensions)
   * Ext:Fenced Codes. This is already supported in late versions of md parser. 
   Github also has its on flavoured notation to define languages. 
   [http://freewisdom.org/projects/python-markdown/Fenced_Code_Blocks](http://freewisdom.org/projects/python-markdown/Fenced_Code_Blocks)
   (To see why I think **Middle-word Emphsis** is important, 
   Just look at the last three word of this url. 
   I expect to see "Fenced\_Code\_Blocks".)
   * Ext:Table. The syntax is much heavy than that of evermd. 
   I think it contradicts with the basic design philosophy of markdown. 
   [http://freewisdom.org/projects/python-markdown/Tables](http://freewisdom.org/projects/python-markdown/Tables)


### [Ruby Wrapped C] Github-markdown
   
This seems the official parser used by github:

[http://rubygems.org/gems/github-markdown](http://rubygems.org/gems/github-markdown)

This one is awesome. It can generate the same output as Github. 
I also tried their 'redcarpet' project or even the more lower level 'sundown',
they do not output the expected HTML, especially when many codes are involved. 

## Feature Discussions

### Table of Contents

   * [http://stackoverflow.com/questions/9721944/automatic-toc-in-github-flavoured-markdown](http://stackoverflow.com/questions/9721944/automatic-toc-in-github-flavoured-markdown)

## Related Stuffs

### markdown-here

It is a powerful plugin for browsers and Thunderbird, 
so that you can write emails using MD. 

   * Project: <https://github.com/adam-p/markdown-here>
   * The author's [notes](https://github.com/adam-p/markdown-here/blob/master/NOTES.md)

### jemdoc

See the [cheatsheet](http://jemdoc.jaboc.net/cheatsheet.html) for its syntax. 
See [Github repo](https://github.com/jem/jemdoc)

Remarks:

   * Jemdoc has many users for academic homepage. 
   * The syntax is a bit different from MD and Latex. I still prefer the EMD flavour. 
   * The [latex2png](https://github.com/jem/jemdoc/blob/master/latexmath2png.py) converter is worth looking at. 
   It's useful to include it in EMD as an option for equation rendering. 
   Needs local command line support of `latex`.

### Light-weight Markup Language

[http://en.wikipedia.org/wiki/Lightweight_markup_language](http://en.wikipedia.org/wiki/Lightweight_markup_language)

### org-mode 

[http://www.gnu.org/software/emacs/manual/html_node/org/Embedded-LaTeX.html](http://www.gnu.org/software/emacs/manual/html_node/org/Embedded-LaTeX.html)

Pointed from: 
[http://stackoverflow.com/questions/2188884/how-can-i-mix-latex-in-with-markdown](http://stackoverflow.com/questions/2188884/how-can-i-mix-latex-in-with-markdown)

The table mode is as concise as evermd. 

### Multi Mark Down

A super set of MD:

[http://fletcherpenney.net/multimarkdown/features/](http://fletcherpenney.net/multimarkdown/features/)

### mimetex.cgi

Pointed from: 
[http://stackoverflow.com/questions/2188884/how-can-i-mix-latex-in-with-markdown](http://stackoverflow.com/questions/2188884/how-can-i-mix-latex-in-with-markdown)

This seems to be HTTP interface to compile formulae to pictures. 
There are some alternatives to this part, such as wikipedia's formulae compilation. 

People use it to do pre-processing to enable MD's support of formula. 

It is slow. 

### Qute

Official website:
[http://www.inkcode.net/qute](http://www.inkcode.net/qute)

Github repo:
[https://github.com/fbreuer/qute-html5](https://github.com/fbreuer/qute-html5)

This editor looks good:
   * Clean interface. 
   * Per paragraph preview. 
   * Amazingly integrate MD and Tex together.. (Tex $$ is supported)

### HTML 2 Markdown

Project page:
[http://www.codefu.org/wiki/Main/Html2markdown](http://www.codefu.org/wiki/Main/Html2markdown)

### RST

It is widely adopted in Python community. 
The sphinx auto documentation tool uses rst. 

[http://docutils.sourceforge.net/rst.html](http://docutils.sourceforge.net/rst.html)

## For Developers

### Markdown Test Suites

#### Test Suite From Original Author

Download from this link:
[http://daringfireball.net/projects/downloads/MarkdownTest_1.0.zip](http://daringfireball.net/projects/downloads/MarkdownTest_1.0.zip)

I find this from the following discussion:
[http://six.pairlist.net/pipermail/markdown-discuss/2004-December/000909.html](http://six.pairlist.net/pipermail/markdown-discuss/2004-December/000909.html)
