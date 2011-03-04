STDOUT.sync = true

require "rubygems"

module Suite
  module Setup
    extend self

    def run
      bundle_install
      rake_install
      # ask_mysql_password
      # create_test_database
      print_final_word
    end

  private

    def root_dir
      @root_dir ||= File.expand_path("../../..", __FILE__)
    end

    def bundle_install
      cmd = "cd #{root_dir} && bundle install"
      puts "Running 'bundle install' (this can take several minutes)".green
      puts cmd
      `#{cmd}`
    end

    def rake_install
      cmd = "cd #{root_dir} && rake install"
      puts "Running 'rake install' in order to be able to run the Rails 2 generators".green
      puts cmd
      `#{cmd}`
    end

    def ask_mysql_password
      puts "Setting up the MySQL test database".green
      puts "To be able to run integration tests (with Capybara in Firefox) we need to store your MySQL password in a git-ignored file (test/shared/mysql)"
      puts "Please provide the password of your MySQL root user: (press Enter when blank)"

      begin
        system "stty -echo"
        password = STDIN.gets.strip
      ensure
        system "stty echo"
      end

      file = File.expand_path("test/shared/mysql", root_dir)
      if password.length == 0
        File.delete file if File.exists? file
      else
        File.open(file, "w"){|f| f << password}
        puts "\n"
      end
    end

    def create_test_database
      puts "Creating the test database".green
      puts "cd #{root_dir}/test/rails-3/dummy && RAILS_ENV=test rake db:create"

      require File.expand_path("test/rails-3/dummy/test/support/dummy_app.rb", root_dir)
      DummyApp.create_test_database
    end

    def print_final_word
      puts "Create your Firefox 'capybara' profile if you haven't done it yet".green
      puts "Run the following in your console to start the profile manager and create the 'capybara' profile:"
      puts "[Mac]   $ /Applications/Firefox.app/Contents/MacOS/firefox-bin -profilemanager".yellow
      puts "[Linux] $ cd <appdir> && ./firefox -profilemanager".yellow
      puts "Done setting up the Rich-Support test suite! ^^".green
    end

  end
end