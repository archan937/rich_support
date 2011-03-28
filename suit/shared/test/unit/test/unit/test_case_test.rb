require File.expand_path("../../../../test_helper.rb", __FILE__)

module Test
  module Unit
    class TestCaseTest < ActiveSupport::TestCase

      context "An Test::Unit::TestCase instance" do
        should "be provided with pending methods" do
          if defined? Test
            klass = ::Test::Unit::TestCase
            # assert klass         .methods.include?("pending")
            # assert klass.instance_methods.include?("pending")
          end
        end
      end

    end
  end
end