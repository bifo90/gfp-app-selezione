require "test_helper"

class Admin::ConsumptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
    @consumption = consumptions(:one)
  end

  test "should get index" do
    get admin_consumptions_url
    assert_response :success
  end

  test "should filter consumptions by type" do
    get admin_consumptions_url, params: { consumption_type: "electricity" }
    assert_response :success
  end

  test "should filter consumptions by start_date" do
    get admin_consumptions_url, params: { start_date: 1.week.ago.to_date }
    assert_response :success
  end

  test "should filter consumptions by end_date" do
    get admin_consumptions_url, params: { end_date: Date.today }
    assert_response :success
  end

  test "should order consumptions" do
    get admin_consumptions_url, params: { ordering: "date desc" }
    assert_response :success
  end

  test "should get new" do
    get new_admin_consumption_url
    assert_response :success
  end

  test "should create consumption with valid params" do
    assert_difference("Consumption.count", 1) do
      post admin_consumptions_url, params: {
        consumption: {
          consumption_type: "electricity",
          value: 15.5,
          date: Date.today
        }
      }
    end

    assert_redirected_to admin_consumptions_url
    assert_equal "Consumo creato con successo.", flash[:notice][:title]
  end

  test "should not create consumption with invalid params" do
    assert_no_difference("Consumption.count") do
      post admin_consumptions_url, params: {
        consumption: {
          consumption_type: "invalid",
          value: -1,
          date: Date.today
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_consumption_url(@consumption)
    assert_response :success
  end

  test "should update consumption with valid params" do
    patch admin_consumption_url(@consumption), params: {
      consumption: {
        value: 25.0
      }
    }

    assert_redirected_to admin_consumptions_url
    assert_equal "Consumo aggiornato con successo.", flash[:notice][:title]
    @consumption.reload
    assert_equal 25.0, @consumption.value
  end

  test "should not update consumption with invalid params" do
    patch admin_consumption_url(@consumption), params: {
      consumption: {
        value: -10
      }
    }

    assert_response :unprocessable_entity
  end

  test "should destroy consumption" do
    assert_difference("Consumption.count", -1) do
      delete admin_consumption_url(@consumption)
    end

    assert_redirected_to admin_consumptions_url
    assert_equal "Consumo eliminato con successo.", flash[:notice][:title]
  end

  test "should redirect to login if not authenticated" do
    delete session_url
    
    get admin_consumptions_url
    assert_redirected_to new_session_url
  end
end
