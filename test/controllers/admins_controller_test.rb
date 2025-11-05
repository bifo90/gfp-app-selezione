require "test_helper"

class AdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should redirect to dashboard on admin root" do
    get admin_dashboard_admin_url
    assert_response :success
  end
end
