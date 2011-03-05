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

              if File.exists?(new_files = expand_path(".new_files"))
                File.readlines(new_files).each do |line|
                  delete line.strip
                end
                File.delete new_files
              end

              restore "app/models/**/*.#{STASHED_EXT}"
              restore "app/views/**/*.#{STASHED_EXT}"
              restore "db/**/*.#{STASHED_EXT}"
              restore "public/**/*.#{STASHED_EXT}"
              restore "test/**/*.#{STASHED_EXT}"
              restore "**/*.#{STASHED_EXT}"
              true
            end

            def write_all
              ["shared", "rails-#{rails_version}"].each do |dir|
                root = Pathname.new File.expand_path(dir, templates_path)
                Dir[File.expand_path("**/*", root.realpath)].each do |file|
                  next if File.directory? file
                  path = Pathname.new file
                  write path.relative_path_from(root).to_s
                end
              end
              true
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
              stash string
              generate string
            end

            def stash(string)
              Dir[expand_path(string)].each do |file|
                next if File.exists? stashed(file)
                log :stashing, original(file)
                File.rename original(file), stashed(file)
              end
            end

            def generate(string)
              new_files = []

              ["shared", "rails-#{rails_version}"].each do |dir|
                root = Pathname.new File.expand_path(dir, templates_path)
                Dir[File.expand_path(string, root.realpath)].each do |file|
                  next if File.directory? file
                  relative_path = Pathname.new(file).relative_path_from(root).to_s
                  new_files << relative_path unless File.exists? stashed(relative_path)
                  log :generating, relative_path
                  template file, expand_path(relative_path)
                end
              end

              unless new_files.empty?
                File.open(expand_path(".new_files"), "a") do |file|
                  file << new_files.collect{|x| "#{x}\n"}.join("")
                end
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