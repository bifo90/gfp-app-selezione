class Consumption < ApplicationRecord
  belongs_to :user

  CONSUMPTION_TYPES = %w[electricity water gas].freeze
  MEASURES = %w[kwh liters cubic_meters].freeze
  validates :consumption_type, inclusion: { in: CONSUMPTION_TYPES }
  validates :measure, inclusion: { in: MEASURES }
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_measure_based_on_type

  def total_by_type(type)
    where(consumption_type: type).sum(:value)
  end

  def self.model_to_stats
    stats = {}
    CONSUMPTION_TYPES.each do |type|
      stats[type] = calculate_stats_for_type(type, "date >= ?" => 1.month.ago)
    end
    stats
  end

  def self.calculate_stats_for_type(type, **options)
    records = where(consumption_type: type)
    if options.present?
      options.each do |key, value|
        records = records.where(key, value)
      end
    end
    {
      total: records.sum(:value).to_s + " " + get_measure_for_type(type),
      average: records.average(:value).to_s + "%",
      label: consumption_type_label(type)
    }
  end

  def self.get_measure_for_type(type)
    case type
    when "electricity"
      "kW"
    when "water"
      "L."
    when "gas"
      "m³"
    else
      ""
    end
  end

  def self.consumption_type_label(type)
    case type
    when "electricity"
      "Elettricità"
    when "water"
      "Acqua"
    when "gas"
      "Gas"
    else
      type.capitalize
    end
  end

  def set_measure_based_on_type
    case consumption_type
    when "electricity"
      self.measure = "kwh"
    when "water"
      self.measure = "liters"
    when "gas"
      self.measure = "cubic_meters"
    end
  end

  def self.get_stats_data_for_charts
    data = []
    c_grouped = Consumption.all.sort_by(&:date).group_by(&:consumption_type)
    c_grouped.each do |type, records|
      data << {
        title: consumption_type_label(type),
        data: records.map { |r| [ r.date.strftime("%d %b"), r.value ] }
      }
    end
    data
  end

  def self.get_options_for_select
    CONSUMPTION_TYPES.map { |type| [ consumption_type_label(type), type ] }
  end

  # Calculate total consumption for a specific period
  def self.total_for_period(start_date, end_date, type: nil)
    scope = where(date: start_date..end_date)
    scope = scope.where(consumption_type: type) if type.present?
    scope.sum(:value)
  end

  # Calculate average daily consumption for a user
  # Returns data formatted for charting: [{ name: type, data: [[date, value], ...] }, ...]
  def self.average_daily_for_user(user_id, type: nil)
    if type.present?
      consumptions = where(user_id: user_id, consumption_type: type)
                     .order(:date)
                     .pluck(:date, :value)
      return [{ name: type, data: consumptions.map { |date, value| [date.to_date.to_s, value] } }]
    end

    CONSUMPTION_TYPES.map do |consumption_type|
      consumptions = where(user_id: user_id, consumption_type: consumption_type)
                     .order(:date)
                     .pluck(:date, :value)

      {
        name: consumption_type,
        data: consumptions.map { |date, value| [date.to_date.to_s, value] }
      }
    end
  end

  def self.average_daily_for_user_and_type(user_id, type)
    consumptions = where(user_id: user_id, consumption_type: type)
    return 0 if consumptions.blank?

    min_date = consumptions.minimum(:date)&.to_date
    max_date = consumptions.maximum(:date)&.to_date
    return 0 unless min_date && max_date

    total_days = (max_date - min_date).to_i + 1
    return 0 if total_days <= 0

    (consumptions.sum(:value) / total_days.to_f).round(2)
  end

  # Get consumption trends (comparing this month vs last month)
  def self.monthly_trend(type: nil)
    this_month_total = with_type(where(date: Time.current.beginning_of_month..Time.current.end_of_month), type).sum(:value)
    last_month_total = with_type(where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month), type).sum(:value)

    change = percentage_change(last_month_total, this_month_total)

    {
      this_month: this_month_total,
      last_month: last_month_total,
      change_percentage: change,
      trend: trend_label(change)
    }
  end

  # Get consumption by day of week
  def self.by_day_of_week(type: nil)
    grouped = with_type(all, type)
              .group("strftime('%w', date)")
              .sum(:value)

    grouped.transform_keys { |day_index| Date::DAYNAMES[day_index.to_i] }
  end

  # Get peak consumption day
  def self.peak_consumption_day(type: nil)
    record = with_type(all, type)
             .select("date, SUM(value) AS total_value")
             .group(:date)
             .order("total_value DESC")
             .first
    return unless record

    {
      date: record.date,
      total: record.total_value,
      measure: type ? get_measure_for_type(type) : "mixed"
    }
  end

  # Calculate cost estimation (you can customize rates per type)
  def self.estimated_cost(type:, rate_per_unit:)
    total = with_type(all, type).sum(:value)

    {
      total_consumption: total,
      rate: rate_per_unit,
      estimated_cost: (total * rate_per_unit).round(2),
      currency: "EUR",
      measure: get_measure_for_type(type)
    }
  end

  # Get consumption summary for a user
  def self.user_summary(user_id)
    consumptions = where(user_id: user_id)

    CONSUMPTION_TYPES.each_with_object({}) do |consumption_type, summary|
      type_scope = consumptions.where(consumption_type: consumption_type)
      last_entry = type_scope.order(date: :desc).first

      summary[consumption_type] = {
        total: type_scope.sum(:value),
        average: type_scope.average(:value)&.round(2) || 0,
        count: type_scope.count,
        last_reading: last_entry&.value,
        last_date: last_entry&.date,
        measure: get_measure_for_type(consumption_type)
      }
    end
  end

  # Get daily consumption breakdown for a date range
  def self.daily_breakdown(start_date, end_date, type: nil)
    scope = with_type(where(date: start_date..end_date), type)

    scope.group(:date).sum(:value).sort_by { |date, _| date }.map do |date, total|
      {
        date: date,
        total: total,
        day_name: date.strftime("%A"),
        measure: type ? get_measure_for_type(type) : "mixed"
      }
    end
  end

  class << self
    private

    def with_type(scope, type)
      type.present? ? scope.where(consumption_type: type) : scope
    end

    def percentage_change(previous, current)
      previous = previous.to_f
      current = current.to_f
      return 0.0 if previous.zero? && current.zero?
      return 100.0 if previous.zero?

      (((current - previous) / previous) * 100).round(2)
    end

    def trend_label(change)
      return "up" if change.positive?
      return "down" if change.negative?

      "stable"
    end
  end
end
