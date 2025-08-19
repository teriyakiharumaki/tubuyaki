require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get static_top_url
    assert_response :success
  end
end
