require "thor/group"
require "rich/support/test/application/utils"
require "rich/support/test/application/actions"

module Rich
  module Support
    module Test
      class Application < ::Thor::Group

        STASHED_EXT = "stashed"

        include Application::Utils
        include Application::Actions

        def self.source_root
          @source_root ||= self.new.templates_path
        end

        def initialize(validate_path = true)
          super [], {}, {}
          if validate_path && !root_path.match(/rails-\d/)
            log "Running a #{self.class.name} instance from an invalid path: '#{root_path}' needs to match ".red + "/rails-\\d/".yellow
            exit
          end
        end

      end
    end
  end
end