require "test_helper"

class Admin::DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get admin_dashboard_admin_url
    assert_response :success
  end

  test "should assign user" do
    get admin_dashboard_admin_url
    assert_not_nil assigns(:user)
    assert_equal @user.id, assigns(:user).id
  end

  test "should assign consumptions stats" do
    get admin_dashboard_admin_url
    assert_not_nil assigns(:consumptions)
    assert_kind_of Hash, assigns(:consumptions)
  end

  test "should assign user_summary" do
    get admin_dashboard_admin_url
    assert_not_nil assigns(:user_summary)
    assert_kind_of Hash, assigns(:user_summary)
  end

  test "should redirect to login if not authenticated" do
    delete session_url

    get admin_dashboard_admin_url
    assert_redirected_to new_session_url
  end
end
