require "test_helper"

class ConsumptionsHelpersTest < ActionView::TestCase
  include ConsumptionsHelpers

  setup do
    @user = users(:one)
    @consumption = Consumption.new(
      user: @user,
      consumption_type: "electricity",
      value: 10.5,
      date: Date.today
    )
  end

  test "format_consumption_date should format date correctly" do
    date = Date.new(2025, 11, 5)
    assert_equal "05/11/2025", format_consumption_date(date)
  end

  test "consumption_measure_label should return correct label for electricity" do
    @consumption.consumption_type = "electricity"
    assert_equal "kW", consumption_measure_label(@consumption)
  end

  test "consumption_measure_label should return correct label for water" do
    @consumption.consumption_type = "water"
    assert_equal "L.", consumption_measure_label(@consumption)
  end

  test "consumption_measure_label should return correct label for gas" do
    @consumption.consumption_type = "gas"
    assert_equal "m³", consumption_measure_label(@consumption)
  end

  test "consumption_select_options should return correct options" do
    options = consumption_select_options
    
    assert_equal 3, options.length
    assert_includes options, [ "Elettricità", "electricity" ]
    assert_includes options, [ "Acqua", "water" ]
    assert_includes options, [ "Gas", "gas" ]
  end
end
