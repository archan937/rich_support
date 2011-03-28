require File.expand_path("../../../../test_helper.rb", __FILE__)

module Actionpack
  module ActionController
    class TestCaseTest < ActiveSupport::TestCase

      context "An ActionController::TestCase instance" do
        should "be provided with named route assertion methods" do
          methods = ::ActionController::TestCase.instance_methods
          assert methods.include?("assert_named_route")
          assert methods.include?("named_routes")
        end
      end

    end
  end
end