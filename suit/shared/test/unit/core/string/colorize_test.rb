require File.expand_path("../../../../test_helper.rb", __FILE__)

module Core
  module String
    class ColorizeTest < ActiveSupport::TestCase

      context "A String" do
        should "respond to colorize methods" do
          assert "".respond_to?(:red)
          assert "".respond_to?(:green)
          assert "".respond_to?(:yellow)
        end

        should "return the expected when calling a colorize method" do
          assert_equal "\e[1m\e[31mtesting\e[0m", "testing".red
          assert_equal "\e[1m\e[32mtesting\e[0m", "testing".green
          assert_equal "\e[1m\e[33mtesting\e[0m", "testing".yellow
        end

        context "with a lot of colorization" do
          should "be able to be colorized" do
            string = <<-STRING
{{green:Create your Firefox 'capybara' profile if you haven't done it yet}}
Run the following in your console to start the profile manager and create a profile called 'capybara':
{{yellow:[Mac]   $ /Applications/Firefox.app/Contents/MacOS/firefox-bin -profilemanager}}
{{yellow:[Linux] $ cd <appdir> && ./firefox -profilemanager}}
{{green:Done establishing current GemSuit in your environment! ^^}}
STRING
            result = <<-RESULT
\e[1m\e[32mCreate your Firefox 'capybara' profile if you haven't done it yet\e[0m
Run the following in your console to start the profile manager and create a profile called 'capybara':
\e[1m\e[33m[Mac]   $ /Applications/Firefox.app/Contents/MacOS/firefox-bin -profilemanager\e[0m
\e[1m\e[33m[Linux] $ cd <appdir> && ./firefox -profilemanager\e[0m
\e[1m\e[32mDone establishing current GemSuit in your environment! ^^\e[0m
RESULT
            assert_equal result, string.colorize
          end
        end
      end

    end
  end
end