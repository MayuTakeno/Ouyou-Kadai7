require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cahts_show_url
    assert_response :success
  end
end
