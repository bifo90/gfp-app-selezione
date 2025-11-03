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

  def self.get_stats_data_for_page
    data = []
    c_grouped = Consumption.all.group_by(&:consumption_type)
    c_grouped.each do |type, records|
      data << {
        title: consumption_type_label(type),
        data: records.map { |r| [ r.date.strftime("%Y-%m-%d"), r.value ] }
      }
    end
    data
  end

  def self.get_options_for_select
    CONSUMPTION_TYPES.map { |type| [ consumption_type_label(type), type ] }
  end
end
