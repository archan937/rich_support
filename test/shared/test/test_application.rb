STDOUT.sync = true

unless defined?(Rich::Support)
  $:.unshift File.expand_path("../../../../../lib", __FILE__)
  require "rubygems"
  require "rich_support"
end

class TestApplication < Rich::Support::Test::Application
end