require "thor/group"
require "rich/support/test/application/utils"
require "rich/support/test/application/stashing"
require "rich/support/test/application/actions"

module Rich
  module Support
    module Test
      class Application < ::Thor::Group

        STASHED_EXT = "stashed"

        include Application::Utils
        include Application::Stashing
        include Application::Actions

        def initialize
          super [], {}, {}
          unless valid?
            log "Running a Rich::Support::Test::Application instance from an invalid path (needs to match '/rails-\\d/')".red
            exit
          end
        end

      private

        def valid?
          Rails.root.match(/rails-\d/)
        end

      end
    end
  end
end