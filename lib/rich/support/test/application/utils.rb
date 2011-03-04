module Rich
  module Support
    module Test
      class Application < ::Thor::Group
        module Utils

          def self.included(base)
            base.extend ClassMethods
            base.send :include, InstanceMethods
          end

          module ClassMethods
            attr_accessor :_file_

            def inherited(klass)
              klass._file_ = caller.first[/^[^:]+/]
            end
          end

          module InstanceMethods
            def root_path
              defined?(Rails) ? Rails.root : self.class._file_
            end

            def shared_path
              File.expand_path("../../../shared", root_path)
            end

            def source_root
              File.expand_path "templates", shared_path
            end

            def rails_version
              root_path.match(/\/rails-(\d)\//)[1].to_i
            end

            def mysql_password
              file = File.expand_path("mysql", shared_path)
              "#{File.new(file).read}".strip if File.exists? file
            end

            def expand_path(path)
              path.match(root_path) ?
                path :
                File.expand_path(path, root_path)
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