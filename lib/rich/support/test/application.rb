require "thor/group"
require "rich/support/test/application/utils"
require "rich/support/test/application/actions"

module Rich
  module Support
    module Test
      class Application < ::Thor::Group

        include Application::Actions

        STASHED_EXT = "stashed"

        def initialize(validate_path = true)
          super [], {}, {}
          if validate_path && !root_path.match(/rails-\d/)
            log "Running a #{self.class.name} instance from an invalid path: '#{root_path}' needs to match ".red + "/rails-\\d/".yellow
            exit
          end
        end

        class << self
          def source_root
            @source_root ||= self.new.templates_path
          end

          def setup(&block)
            self.new.setup &block
          end
        end

      end
    end
  end
end