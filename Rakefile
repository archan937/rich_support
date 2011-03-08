require "bundler"
Bundler::GemHelper.install_tasks

require "rake/testtask"
require "rake/rdoctask"

desc "Default: run tests."
task :default => :test

task :test do
  Rake::Task["test:all"].execute
end

namespace :test do
  desc "Test the Rich-Support tests in Rails 2 and 3."
  task :all do
    # system "suit test:all"
  end
  desc "Test the Rich-Support tests in Rails 2."
  task :"rails-2" do
    # system "suit test:rails-2"
  end
  desc "Test the Rich-Support tests in Rails 3."
  task :"rails-3" do
    # system "suit test:rails-3"
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