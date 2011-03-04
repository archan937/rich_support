require "fileutils"

module Rich
  module Support
    module Test
      class Application < ::Thor::Group
        module Actions

          unless defined?(Rails)
            class Rails
              def self.root
                File.expand_path "../..", send(:__FILE__)
              end
            end
          end

          def self.included(base)
            base.extend ClassMethods
          end

          module ClassMethods
            def source_root
              File.expand_path "templates", shared_path
            end

            def shared_path
              File.expand_path("../../../shared", Rails.root)
            end

            # def prepare_database
            #   return if @db_prepared
            #   if @ran_generator
            #     stash   "db/schema.rb"
            #     execute "rake db:test:purge"
            #     execute "RAILS_ENV=test rake db:migrate"
            #   else
            #     execute "rake db:test:load"
            #   end
            #   @db_prepared = true
            # end

            def delete(string)
              Dir[expand_path(string)].each do |file|
                log :deleting, file
                File.delete file
              end

              dirname = expand_path File.dirname(string)

              return unless File.exists?(dirname)
              Dir.glob("#{dirname}/*", File::FNM_DOTMATCH) do |file|
                return unless %w(. ..).include? File.basename(file)
              end

              log :deleting, dirname
              Dir.delete dirname
            end

            def copy(source, destination)
              log :copying, "#{source} -> #{destination}"
              FileUtils.cp expand_path(source), expand_path(destination)
            end

            def execute(command)
              return if command.to_s.gsub(/\s/, "").size == 0
              log :executing, command
              `cd #{Rails.root} && #{command}`
            end

            def log(action, string = nil)
              return if @silent
              output = [string || action]
              output.unshift action.to_s.capitalize.ljust(10, " ") unless string.nil?
              puts output.join("  ")
            end

          end

        end
      end
    end
  end
end