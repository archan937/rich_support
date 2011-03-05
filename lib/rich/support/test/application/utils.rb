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
              defined?(Rails) ? Rails.root : File.expand_path("../..", self.class._file_)
            end

            def shared_path
              File.expand_path("../../shared", root_path)
            end

            def templates_path
              File.expand_path("../../templates", root_path)
            end

            def expand_path(path)
              Pathname.new(path).absolute? ?
                path :
                File.expand_path(path, root_path)
            end

            def original(file)
              expand_path file.gsub(/\.#{STASHED_EXT}$/, "")
            end

            def stashed(file)
              expand_path file.match(/\.#{STASHED_EXT}$/) ? file : "#{file}.#{STASHED_EXT}"
            end

            def rails_version
              root_path.match(/\/rails-(\d)\//)[1].to_i
            end

            def mysql_password
              file = File.expand_path("mysql", shared_path)
              "#{File.new(file).read}".strip if File.exists? file
            end
          end

        end
      end
    end
  end
end