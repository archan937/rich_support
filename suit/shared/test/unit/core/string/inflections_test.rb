require File.expand_path("../../../../test_helper.rb", __FILE__)

module Core
  module String
    class InflectionsTest < ActiveSupport::TestCase

      test "upcase_first" do
        assert_equal      "",      "".upcase_first
        assert_equal "Value", "value".upcase_first
        assert_equal "VALUE", "vALUE".upcase_first
        assert_equal "Value", "Value".upcase_first
      end

      test "cp_case" do
        assert_equal                  "VALUE",                  "value".cp_case("KEY")
        assert_equal                  "value",                  "VALUE".cp_case("key")
        assert_equal                  "VAlUe",                  "vAlUe".cp_case("Key")
        assert_equal "Welkom bij CodeHero.es", "welkom bij CodeHero.es".cp_case("Welcome at CodeHero.es")
      end

      test "upcase_first!" do
        assert_equal    nil,     "".upcase_first!
        assert_equal    nil, "Paul".upcase_first!
        assert_equal "Paul", "paul".upcase_first!
      end

      test "cp_case!" do
        assert_equal    nil,     "".cp_case!("")
        assert_equal    nil, "Paul".cp_case!("Engel")
        assert_equal    nil, "PAUL".cp_case!("ENGEL")
        assert_equal "Paul", "paul".cp_case!("Engel")
        assert_equal "PAUL", "paul".cp_case!("ENGEL")
      end

      test "singularize!" do
        assert_equal    nil, "test" .singularize!
        assert_equal    nil, "TeSt" .singularize!
        assert_equal "test", "tests".singularize!
        assert_equal "TeSt", "TeSts".singularize!
      end

      test "pluralize!" do
        assert_equal     nil, "tests".pluralize!
        assert_equal     nil, "TeSts".pluralize!
        assert_equal "tests", "test" .pluralize!
        assert_equal "TeSts", "TeSt" .pluralize!
      end

      test "singular?" do
        assert "baby"    .singular?
        assert "person"  .singular?
        assert "question".singular?
        assert "status " .singular?
      end

      test "plural?" do
        assert "babies"   .plural?
        assert "people"   .plural? unless Rails::VERSION::MAJOR < 3 # This fails in Rails < 3
        assert "questions".plural?
        assert "statuses" .plural?
      end

    end
  end
end