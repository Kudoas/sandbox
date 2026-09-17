require "test_helper"

class JsonCompatibilityTest < ActiveSupport::TestCase
  test "Active Support can pass parser options to JSON" do
    assert_equal({ "name" => "Herb" }, ActiveSupport::JSON.decode('{"name":"Herb"}', symbolize_names: false))
  end
end
