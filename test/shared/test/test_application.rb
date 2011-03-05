STDOUT.sync = true

require "rubygems"

$:.unshift File.expand_path("../../../../../lib", __FILE__)
require File.expand_path("../../../../../lib/rich_support", __FILE__)

class TestApplication < Rich::Support::Test::Application
#   class << self
#
#     def setup(&block)
#       log "\n".ljust 145, "="
#       log "Setting up test environment for Rails #{rails_version}\n"
#       log "\n".rjust 145, "="
#
#       restore_all
#       stash_all
#
#       yield self if block_given?
#
#       prepare_database
#
#       log "\n".rjust 145, "="
#       log "Environment for Rails #{rails_version} is ready for testing"
#       log "=" .ljust 144, "="
#
#       @prepared = true
#       run
#     end
#
#   private
#
#     def run
#       ENV["RAILS_ENV"] = "test"
#
#       require File.expand_path("../../../config/environment.rb", __FILE__)
#       require "#{"rails/" if Rails::VERSION::MAJOR >= 3}test_help"
#
#       Dir[File.expand_path("../**/*.rb", __FILE__)].each do |file|
#         require file
#       end
#
#       puts "\nRunning Rails #{Rails::VERSION::STRING}\n\n"
#     end
#
#   end
end