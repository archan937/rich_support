require "pathname"
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

            def restore_all(force = nil)
              if @prepared
                unless force
                  log "Cannot (non-forced) restore files after having prepared the test application" unless force.nil?
                  return
                end
              end

              restore "app/models/**/*.rb.#{STASHED_EXT}"
              restore "public/**/*.rb.#{STASHED_EXT}"
              restore "test/**/*.yml.#{STASHED_EXT}"
              restore "**/*.#{STASHED_EXT}"
            end

            def write_all
              ["shared", "rails-#{rails_version}"].each do |dir|
                root = Pathname.new File.join(templates_path, dir)
                Dir[File.join(root.realpath, "/**/*")].each do |file|
                  next if File.directory? file
                  path = Pathname.new file
                  write path.relative_path_from(root).to_s
                end
              end
            end

            def restore(string)
              Dir[expand_path(string)].each do |file|
                next unless File.exists? stashed(file)
                delete original(file)
                log :restoring, stashed(file)
                File.rename stashed(file), original(file)
              end
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

            def write(string)
              Dir[expand_path(string)].each do |file|
                next if File.exists? stashed(file)
                stash original(file)
                generate file
              end
            end

            def stash(string)
              Dir[expand_path(string)].each do |file|
                log :stashing, original(file)
                File.rename original(file), stashed(file)
              end
            end

            def generate(file)
              relative_path = Pathname.new(file).relative_path_from(Pathname.new(root_path)).to_s

              ["shared", "rails-#{rails_version}"].each do |dir|
                template_path = File.join templates_path, dir, relative_path
                next unless File.exists?(template_path)
                log :generating, original(file)
                template template_path, relative_path
              end
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