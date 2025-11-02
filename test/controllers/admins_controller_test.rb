require "test_helper"

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get consuptions" do
    get admins_consuptions_url
    assert_response :success
  end

  test "should get stats" do
    get admins_stats_url
    assert_response :success
  end
end
