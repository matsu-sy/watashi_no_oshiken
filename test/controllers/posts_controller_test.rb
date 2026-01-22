require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one) # fixtures に users(:one) がある前提
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end
end
