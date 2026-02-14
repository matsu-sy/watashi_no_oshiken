require "test_helper"

class MypagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should update hometowns by mypage update" do
    patch mypage_url, params: {
      user: {
        name: @user.name,
        hometown_prefecture_codes: [ "13", "27" ]
      }
    }

    assert_response :redirect
    assert_equal [ 13, 27 ], @user.hometowns.order(:prefecture_code).pluck(:prefecture_code)
  end
end
