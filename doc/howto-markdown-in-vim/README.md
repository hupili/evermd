# Configure VIM for MarkDown (Topic Tag List)

## Prerequisite

You should know the following things first:

   * VIM: [http://www.vim.org/](http://www.vim.org/)
   * Taglist: [http://vim-taglist.sourceforge.net/](http://vim-taglist.sourceforge.net/)
   * ctags: [http://ctags.sourceforge.net/](http://ctags.sourceforge.net/)

## Syntax

There are some existing works to highlight Markdown documents:
[https://github.com/tpope/vim-markdown](https://github.com/tpope/vim-markdown)

This one is already very good. 
I will tweak some points later. 

## List Topics 

To help fast navigate in a md document, 
it's critical to have the topic lists. 
It's a pity that I did not find complete 
solution on this issue. 

Here's one off-the-shelf plugin, tocdown:
[http://www.vim.org/scripts/script.php?script_id=3856](http://www.vim.org/scripts/script.php?script_id=3856)

It solves the problem, but I just don't want to 
use more plugins. I want to figure out a way to 
let the existing plugins work. 
It turns out that VIM plugin "Taglist" and the universal 
tag generator "ctags" do solve the problem. 
Here's the HOWTO. 

### Overall Description

The Tlist work in the following prcess:

   * VIM identifies the filetype. 
   * Tlist parse the current file using filetype. 
   * ctags is the backend for Tlist parsing. 
   * Tlist then show categorized tags in a side bar. 

### VIM filetype Identification 

The simplest way is to add this line in ".vimrc":

	au BufNewFile,BufRead *.md set filetype=markdown
	
You can also set other commonly used extensions like \*.mkd \*.markdown
(comma separated).
If you installed the "vim-markdown" plugin mentioned in the 
previous section, you already have markdown detection logic there. 
(If the filetype is not detected, how to highlight syntax?)
Then you don't worry about this section. 

### ctags Support

ctags is a powerful tool. 
You can pass command line options in to support parsing any files. 
The "$HOME/.ctags" file stores user specified commands. 
They will be loaded at each invokation of ctags sequentially. 
You can put the following lines in the config file:

	--langdef=markdown
	--langmap=markdown:.md
	--regex-markdown=/^#[ \t]+(.*)/-\1/h,heading1/
	--regex-markdown=/^##[ \t]+(.*)/-  \1/h,heading2/
	--regex-markdown=/^###[ \t]+(.*)/-    \1/h,heading3/
	--regex-markdown=/^####[ \t]+(.*)/-      \1/h,heading4/
	--regex-markdown=/^#####[ \t]+(.*)/-        \1/h,heading5/
	--regex-markdown=/^######[ \t]+(.*)/-          \1/h,heading6/
	--regex-markdown=/^#######[ \t]+(.*)/-            \1/h,heading7/

Here's the explanation:

   * "langdef" defines a new language
   * "langmap" maps the suffices to a language
   * "--regex-{language}" specify the parsing regular expressions.
   The three parts of "/{1}/{2}/{3}/" are:
      * Matching pattern. 
      * Substitution pattern. This is used to generate tag names shown on the side bar. 
      * The single character before the comma specifies the type. 
      The rest after comma is description. 
      You can treat them as comments. 

Note that in the substitution pattern, I add many blanks. 
This is to help indent the headings in tag bar. 
The preceding "-" is essential, or Tlist will trim the string.

### Tlist settings

Configure the last piece in "$HOME/.ctags":

	let g:tlist_markdown_settings = 'markdown;h:Headlins'

The meanings are intuitive. 
"Headlines" is the category title shown in Tlist bar. 

### Screenshot

<img src="https://raw.github.com/hupili/evermd/tree/master/doc/howto-markdown-in-vim/screen1.jpg" />
