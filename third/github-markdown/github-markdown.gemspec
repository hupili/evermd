# encoding: utf-8
Gem::Specification.new do |s|
  s.name = 'github-markdown'
  s.version = '0.5.1'
  s.summary = 'The Markdown parser for GitHub.com'
  s.description = 'Self-contained Markdown parser for GitHub, with all our custom extensions'
  s.date = '2012-07-08'
  s.email = 'vicent@github.com'
  s.homepage = 'http://github.github.com/github-flavored-markdown/'
  s.authors = ['GitHub, Inc']
  # = MANIFEST =
  s.files = %w[
    Rakefile
    bin/gfm
    ext/markdown/autolink.c
    ext/markdown/autolink.h
    ext/markdown/buffer.c
    ext/markdown/buffer.h
    ext/markdown/extconf.rb
    ext/markdown/gh-markdown.c
    ext/markdown/houdini.h
    ext/markdown/houdini_href_e.c
    ext/markdown/houdini_html_e.c
    ext/markdown/html.c
    ext/markdown/html.h
    ext/markdown/html_blocks.h
    ext/markdown/markdown.c
    ext/markdown/markdown.h
    ext/markdown/plaintext.c
    ext/markdown/plaintext.h
    ext/markdown/stack.c
    ext/markdown/stack.h
    github-markdown.gemspec
    lib/github/markdown.rb
    test/gfm_test.rb
  ]
  # = MANIFEST =
  s.test_files = ["test/gfm_test.rb"]
  s.extensions = ["ext/markdown/extconf.rb"]
  s.require_paths = ["lib"]
  s.add_development_dependency "rake-compiler"
end
