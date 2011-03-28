require File.expand_path("../../../../test_helper.rb", __FILE__)

module Actionpack
  module ActionController
    class RoutingTest < ::ActionController::TestCase

      test "root_path" do
        assert_routing     "/", :controller => "application", :action => "index"
        assert_named_route "/", :root
      end

    end
  end
end