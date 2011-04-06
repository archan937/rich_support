require "bundler"
Bundler::GemHelper.install_tasks

require "rake/testtask"
require "rake/rdoctask"
require "rich/support/core/string/colorize"

desc "Default: run unit tests."
task :default => :test

desc "Test Rich-Support."
task :test do
  begin
    require "gem_suit"
    system "suit test unit -v"
  rescue LoadError
    puts "Please install GemSuit with 'gem install gem_suit'".red
  end
end

desc "Generate documentation for Rich-Support."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "Rich-Support"
  rdoc.options << "--line-numbers" << "--inline-source"
  rdoc.rdoc_files.include "README.textile"
  rdoc.rdoc_files.include "MIT-LICENSE"
  rdoc.rdoc_files.include "lib/**/*.rb"
end