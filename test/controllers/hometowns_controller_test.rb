require "test_helper"

class HometownsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get hometowns_create_url
    assert_response :success
  end

  test "should get update" do
    get hometowns_update_url
    assert_response :success
  end

  test "should get destroy" do
    get hometowns_destroy_url
    assert_response :success
  end
end
