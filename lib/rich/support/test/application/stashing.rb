module Rich
  module Support
    module Test
      class Application < ::Thor::Group
        module Stashing

          def self.included(base)
            base.extend ClassMethods
            base.send :include, Thor::Actions
          end

          module ClassMethods

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

          end

        end
      end
    end
  end
end