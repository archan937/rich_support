require "fileutils"

module Rich
  module Support
    module Test
      class Application < ::Thor::Group
        module Actions

          def self.included(base)
            base.send :include, Thor::Actions
            base.send :include, InstanceMethods
          end

          module InstanceMethods

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

            def restore_all(force = nil)
              if @prepared
                unless force
                  log "Cannot (non-forced) restore files after having prepared the test application" unless force.nil?
                  return
                end
              end

              delete  "db/migrate/*.rb"
              restore "app/models/*.rb.#{STASHED_EXT}"
              restore "test/fixtures/*.yml.#{STASHED_EXT}"
              restore "**/*.#{STASHED_EXT}"
            end

            def stash_all
              delete "db/migrate/*.rb"
              stash  "Gemfile"
              stash  "Gemfile.lock"
              stash  "app/models/*.rb"
              stash  "config/database.yml"
              stash  "config/routes.rb"
              stash  "test/fixtures/*.yml"
            end

            def restore(string)
              Dir[expand_path(string)].each do |file|
                if File.exists? stashed(file)
                  delete original(file)
                  log :restoring, stashed(file)
                  File.rename stashed(file), original(file)
                end
              end
            end

            def stash(string)
              Dir[expand_path(string)].each do |file|
                unless File.exists? stashing(file)
                  next unless template?(file)
                  log :stashing, original(file)
                  File.rename original(file), original(file)
                  write file
                end
              end
            end

            def write(file)
              path = expand_path file
              template template_for(path), path
            end

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
              `cd #{root_path} && #{command}`
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