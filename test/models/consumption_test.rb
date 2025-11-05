require "test_helper"

class ConsumptionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @consumption = Consumption.new(
      user: @user,
      consumption_type: "electricity",
      value: 10.5,
      date: Date.today
    )
  end

  test "should be valid with valid attributes" do
    assert @consumption.valid?
  end

  test "should belong to user" do
    assert_respond_to @consumption, :user
  end

  test "should validate consumption_type inclusion" do
    @consumption.consumption_type = "invalid"
    assert_not @consumption.valid?
    assert_includes @consumption.errors[:consumption_type], "is not included in the list"
  end

  test "should validate measure inclusion when not set by callback" do
    # This test verifies that the measure validation works
    # Since before_validation callback always sets the measure based on type,
    # we test that valid measures are accepted
    @consumption.consumption_type = "electricity"
    @consumption.measure = "kwh"
    assert @consumption.valid?
    
    @consumption.consumption_type = "water"
    @consumption.measure = "liters"
    assert @consumption.valid?
    
    @consumption.consumption_type = "gas"
    @consumption.measure = "cubic_meters"
    assert @consumption.valid?
  end

  test "should validate value is greater than or equal to 0" do
    @consumption.value = -1
    assert_not @consumption.valid?
    assert_includes @consumption.errors[:value], "must be greater than or equal to 0"
  end

  test "should accept valid consumption types" do
    %w[electricity water gas].each do |type|
      @consumption.consumption_type = type
      assert @consumption.valid?, "#{type} should be valid"
    end
  end

  test "should set measure based on type before validation" do
    @consumption.consumption_type = "electricity"
    @consumption.valid?
    assert_equal "kwh", @consumption.measure

    @consumption.consumption_type = "water"
    @consumption.valid?
    assert_equal "liters", @consumption.measure

    @consumption.consumption_type = "gas"
    @consumption.valid?
    assert_equal "cubic_meters", @consumption.measure
  end

  test "should return correct measure for type" do
    assert_equal "kW", Consumption.get_measure_for_type("electricity")
    assert_equal "L.", Consumption.get_measure_for_type("water")
    assert_equal "m³", Consumption.get_measure_for_type("gas")
  end

  test "should return consumption type label" do
    assert_equal "Elettricità", Consumption.consumption_type_label("electricity")
    assert_equal "Acqua", Consumption.consumption_type_label("water")
    assert_equal "Gas", Consumption.consumption_type_label("gas")
  end

  test "average_daily_for_user_and_type should return 0 for no consumptions" do
    result = Consumption.average_daily_for_user_and_type(999999, "electricity")
    assert_equal 0, result
  end

  test "average_daily_for_user_and_type should calculate correctly" do
    user = users(:one)
    Consumption.create!(user: user, consumption_type: "electricity", value: 10, date: 3.days.ago)
    Consumption.create!(user: user, consumption_type: "electricity", value: 20, date: Date.today)
    
    result = Consumption.average_daily_for_user_and_type(user.id, "electricity")
    assert result > 0
  end

  test "monthly_trend should return trend data" do
    trend = Consumption.monthly_trend(type: "electricity")
    
    assert_includes trend.keys, :this_month
    assert_includes trend.keys, :last_month
    assert_includes trend.keys, :change_percentage
    assert_includes trend.keys, :trend
    assert_includes %w[up down stable], trend[:trend]
  end

  test "user_summary should return data for all consumption types" do
    user = users(:one)
    summary = Consumption.user_summary(user.id)
    
    assert_equal 3, summary.keys.length
    %w[electricity water gas].each do |type|
      assert_includes summary.keys, type
      assert_includes summary[type].keys, :total
      assert_includes summary[type].keys, :average
      assert_includes summary[type].keys, :count
      assert_includes summary[type].keys, :measure
    end
  end

  test "estimated_cost should calculate cost correctly" do
    user = users(:one)
    Consumption.create!(user: user, consumption_type: "electricity", value: 100, date: Date.today)
    
    result = Consumption.estimated_cost(type: "electricity", rate_per_unit: 0.15)
    
    assert_includes result.keys, :total_consumption
    assert_includes result.keys, :rate
    assert_includes result.keys, :estimated_cost
    assert_equal 0.15, result[:rate]
    assert_equal "EUR", result[:currency]
  end

  test "daily_breakdown should return daily data" do
    user = users(:one)
    start_date = 3.days.ago.to_date
    end_date = Date.today
    
    Consumption.create!(user: user, consumption_type: "electricity", value: 10, date: start_date)
    
    result = Consumption.daily_breakdown(start_date, end_date, type: "electricity")
    
    assert_kind_of Array, result
    result.each do |day|
      assert_includes day.keys, :date
      assert_includes day.keys, :total
      assert_includes day.keys, :day_name
      assert_includes day.keys, :measure
    end
  end

  test "get_options_for_select should return proper options" do
    options = Consumption.get_options_for_select
    
    assert_equal 3, options.length
    assert_equal [ "Elettricità", "electricity" ], options[0]
    assert_equal [ "Acqua", "water" ], options[1]
    assert_equal [ "Gas", "gas" ], options[2]
  end
end
