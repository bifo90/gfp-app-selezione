require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should show home page content" do
    get root_url
    assert_select "html"
  end

  test "should be accessible without authentication" do
    get root_url
    assert_response :success
    assert_nil session[:user_id]
  end
end
