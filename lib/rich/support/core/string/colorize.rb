module Rich
  module Support
    module Core
      module String
        module Colorize

          COLORS = {:red => 31, :green => 32, :yellow => 33}

          def self.included(base)
            COLORS.each do |name, code|
              base.send :define_method, name do
                colorize code
              end
            end
          end

        private

          def colorize(color)
            "\e[1m\e[#{color}m#{self}\e[0m"
          end

        end
      end
    end
  end
end