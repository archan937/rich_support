module Rich
  module Support
    module Test
      class Application < ::Thor::Group
        module Utils

          def self.included(base)
            base.extend ClassMethods
          end

          module ClassMethods
            def rails_version
              Rails.root.match(/\/rails-(\d)\//)[1].to_i
            end

            def mysql_password
              file = File.expand_path("mysql", shared_path)
              "#{File.new(file).read}".strip if File.exists? file
            end

            def expand_path(path)
              path.match(Rails.root) ?
                path :
                File.expand_path(path, Rails.root)
            end

            def original(file)
              file.gsub /\.#{STASHED_EXT}$/, ""
            end

            def stashed(file)
              file.match(/\.#{STASHED_EXT}$/) ?
                file :
                "#{file}.#{STASHED_EXT}"
            end

            def template_for(file)
              Dir[File.join(self.class.source_root, "/**/#{string}")].each do |file|
                puts file
                puts file.gsub("#{self.class.source_root}/", "")
              end
            end

            def template?(file)
              !!template_for(file)
            end
          end

        end
      end
    end
  end
end