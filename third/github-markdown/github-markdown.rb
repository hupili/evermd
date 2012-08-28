#!/usr/bin/env ruby

# GitHub Markdown Rendering class
#
# Provides a Markdown rendering method as a singleton, and two
# auxiliary functions
#
# There are two kinds of Markdown in GitHub.com:
#
# - Plain Markdown: used in Wikis, Pages and GitHub::Markup (READMEs).
#   This is standards-compliant Markdown, with some of the PHP-Markdown
#   extensions:
#
# - GitHub-flavored Markdown: used in user-input text, such as comments.
#   Same extensions as Plain Markdown, and additionally the following
#   extensions:
#
# GitHub::Markdown.render(content)
# #=> Rendered Markdown as HTML plaintext with the default extensions
#
# GitHub::Markdown.render_gfm(content)
# #=> Rendered GitHub-flavored Markdown as HTML plaintext
#
# GitHub::Markdown._to_html(content, mode) { |code, lang| ... }
# #=> Rendered Markdown with the given mode as HTML plaintext
module GitHub
  class Markdown
    def self.render(content)
      self.to_html(content, :markdown)
    end

    def self.render_gfm(content)
      self.to_html(content, :gfm)
    end
  end
end

# hupili
# 20120828
#
# To allow the translator to be executed from anywhere,
# we first calculate the location of the script and 
# load the so file accordingly. 
#
#TODO:
#    Export the interface from C directly. 
#    Remove any ruby dependency. 
#    I heard people saying 'sundown' is the backend 
#    of github's redcarpet. But that one does not 
#    produce what we see on Github. The 'redcarpet' 
#    prooject on Github also do not produce the 
#    expected output.

# Load the actual C extension
bin_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = bin_dir
require lib_dir + '/markdown.so'

# STDIN, STDOUT wrapper
puts GitHub::Markdown.render(STDIN.read())
