module Rich
  module Support
    module Core
      module String
        module Colorize

          COLORS = {:red => 31, :green => 32, :yellow => 33}

          def self.included(base)
            COLORS.each do |name, code|
              base.send :define_method, name do
                _colorize code
              end
            end

            base.send :include, InstanceMethods
          end

          module InstanceMethods
            def colorize
              self.gsub(/\{\{(#{COLORS.keys.join("|")}):(.+)\}\}/) do |match|
                $2.send $1
              end
            end
          end

        private

          def _colorize(color)
            "\e[1m\e[#{color}m#{self}\e[0m"
          end

        end
      end
    end
  end
end

class String
  include Rich::Support::Core::String::Colorize
end