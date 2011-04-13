# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rich/support/version"

Gem::Specification.new do |s|
  s.name        = "rich_support"
  s.version     = Rich::Support::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Engel"]
  s.email       = ["paul.engel@holder.nl"]
  s.homepage    = "https://github.com/archan937/rich_support"
  s.summary     = %q{A small gem making your own gem Rails 2 and 3 compliant and providing the String class a few goodies}
  s.description = %q{Rich-Support is a small module of E9s (http://github.com/archan937/e9s) making your own gem Rails 2 and 3 compliant. It also adds a small amount of handy methods to the String class.}

  s.rubyforge_project = "rich_support"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end