# github-markdown

This module is downloaded from:
[http://rubygems.org/gems/github-markdown](http://rubygems.org/gems/github-markdown)

I had a hard time installing as a gem try to run it. 
After inspecting the directory tree, I think I can 
hard quote the entire project here. 

## Deploy

To deploy, run:
```
bash deploy.sh
```

You will see three files under "bin":
   * gfm  : executable from original project
   * github-markdown.rb : the simple wrapper I adapted from 'markdown.rb'
   * markdown.so : the binary to perform the real task

You can copy them to other places. 
Please keep 'github-markdown.rb' and 'markdown.so' in the same folder. 

## Troubleshooting

### "can't find header files for ruby."

You may want to install the development package of ruby. Usually the name "ruby-devel" or "ruby-dev". 

e.g. 

```
yum install ruby-devel
```