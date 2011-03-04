STDOUT.sync = true

require "fileutils"

module DummyApp
  extend self

  def create_test_database
    @silent = true
    stash   "config/database.yml", :database
    execute "RAILS_ENV=test rake db:create"
  ensure
    restore "**/*.#{STASHED_EXT}"
  end

  def setup(&block)
    log "\n".ljust 145, "="
    log "Setting up test environment for Rails #{major_rails_version}\n"
    log "\n".rjust 145, "="

    restore_all
    stash_all
    # execute "bundle install"

    yield self if block_given?

    prepare_database
    @prepared = true

    log "\n".rjust 145, "="
    log "Environment for Rails #{major_rails_version} is ready for testing"
    log "=" .ljust 144, "="

    run
  end

  def prepare_database
    return if @db_prepared
    if @ran_generator
      # stash   "db/schema.rb", :schema
      execute "rake db:test:purge"
      execute "RAILS_ENV=test rake db:migrate"
    else
      execute "rake db:test:load"
    end
    @db_prepared = true
  end

  def restore_all(force = nil)
    if @prepared
      unless force
        log "Cannot (non-forced) restore files after having prepared the dummy app" unless force.nil?
        return
      end
    end

    delete  "db/migrate/*.rb"
    restore "app/models/*.rb.#{STASHED_EXT}"
    restore "test/fixtures/**/rails-*.yml.#{STASHED_EXT}"
    restore "test/integration/**/*.rb.#{STASHED_EXT}"
    restore "test/support/rich/**/*.rb.#{STASHED_EXT}"
    restore "**/*.#{STASHED_EXT}"
  end

  def stash_all
    delete "db/migrate/*.rb"
    # stash  "Gemfile", :gemfile
    # stash  "Gemfile.lock"
    stash  "app/models/*.rb"
    # stash  "config/database.yml", :database
    # stash  "config/routes.rb", :routes
    stash  "test/fixtures/**/rails-*.yml"
    stash  "test/support/rich/**/*.rb"

    # Dir[File.expand_path("../../integration/**/*.rb", __FILE__)].each do |file|
    #   stash file unless file.include?("_test.rb") || file.include?("#{@logic || "non_authenticated"}.rb")
    # end
  end

private

  STASHED_EXT = "stashed"

  def run
    ENV["RAILS_ENV"] = "test"

    require File.expand_path("../../../config/environment.rb", __FILE__)
    require "#{"rails/" if Rails::VERSION::MAJOR >= 3}test_help"

    Dir[File.expand_path("../**/*.rb", __FILE__)].each do |file|
      require file
    end

    puts "\nRunning Rails #{Rails::VERSION::STRING}\n\n"
  end

  def root_dir
    @root_dir ||= File.expand_path("../../../../dummy/", __FILE__)
  end

  def major_rails_version
    @major_rails_version ||= root_dir.match(/\/rails-(\d)\//)[1].to_i
  end

  def mysql_password
    file = File.expand_path("../../shared/mysql", root_dir)
    return unless File.exists? file
    "#{File.new(file).read}".strip
  end

  def expand_path(path)
    path.match(root_dir) ?
      path :
      File.expand_path(path, root_dir)
  end

  def target(file)
    file.gsub /\.#{STASHED_EXT}$/, ""
  end

  def stashed(file)
    file.match(/\.#{STASHED_EXT}$/) ?
      file :
      "#{file}.#{STASHED_EXT}"
  end

  def restore(string)
    Dir[expand_path(string)].each do |file|
      if File.exists?(stashed(file))
        delete target(file)
        log :restoring, stashed(file)
        File.rename stashed(file), target(file)
      end
    end
  end

  def stash(string, replacement = nil)
    Dir[expand_path(string)].each do |file|
      unless File.exists?(stashed(file))
        log :stashing, target(file)
        File.rename target(file), stashed(file)
        write(file, replacement)
      end
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

  def write(file, replacement)
    content = case replacement
              when :gemfile
                auth_gem = case @logic
                           when :devise
                             'gem "devise", "1.0.9"'
                           when :authlogic
                             'gem "authlogic"'
                           end if major_rails_version == 2
                <<-CONTENT.gsub(/^ {18}/, "")
                  source "http://rubygems.org"

                  gem "rails", "#{{2 => "2.3.11", 3 => "3.0.4"}[major_rails_version]}"
                  gem "mysql"
                  #{auth_gem}
                  gem "rich_cms", :path => File.expand_path("../../../..", __FILE__)

                  gem "shoulda"
                  gem "mocha"
                  gem "capybara"
                  gem "launchy"
                  gem "hpricot"
                CONTENT
              when :schema
                <<-CONTENT.gsub(/^ {18}/, "")
                  ActiveRecord::Schema.define(:version => 19820801180828) do
                  end
                CONTENT
              when :database
                <<-CONTENT.gsub(/^ {18}/, "")
                  development:
                    adapter: sqlite3
                    database: db/development.sqlite3
                    pool: 5
                    timeout: 5000
                  test:
                    adapter: mysql
                    database: rich_cms_test
                    username: root
                    password: #{mysql_password}
                    host: 127.0.0.1
                CONTENT
              when :routes
                case major_rails_version
                when 2
                  <<-CONTENT.gsub(/^ {20}/, "")
                    ActionController::Routing::Routes.draw do |map|
                      map.root :controller => "application"
                      map.connect ':controller/:action/:id'
                      map.connect ':controller/:action/:id.:format'
                    end
                  CONTENT
                when 3
                  <<-CONTENT.gsub(/^ {20}/, "")
                    Dummy::Application.routes.draw do
                      root :to => "application#index"
                    end
                  CONTENT
                end
              end

    if content
      log :writing, file
      File.open target(file), "w" do |file|
        file << content
      end
    end
  end

  def copy(source, destination)
    log :copying, "#{source} -> #{destination}"
    FileUtils.cp expand_path(source), expand_path(destination)
  end

  def execute(command)
    return if command.to_s.gsub(/\s/, "").size == 0
    log :executing, command
    `cd #{root_dir} && #{command}`
  end

  def log(action, string = nil)
    return if @silent
    output = [string || action]
    output.unshift action.to_s.capitalize.ljust(10, " ") unless string.nil?
    puts output.join("  ")
  end

end