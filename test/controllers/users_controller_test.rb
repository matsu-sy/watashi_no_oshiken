require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    user = users(:one)

    get user_url(user)
    assert_response :success
  end
end
