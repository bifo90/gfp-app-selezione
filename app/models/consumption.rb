class Consumption < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :user

  CONSUMPTION_TYPES = %w[electricity water gas].freeze
  MEASURES = %w[kwh liters cubic_meters].freeze
  validates :consumption_type, inclusion: { in: CONSUMPTION_TYPES }
  validates :measure, inclusion: { in: MEASURES }
  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def total_by_type(type)
    where(consumption_type: type).sum(:value)
  end

  def self.model_to_stats
    stats = {}
    CONSUMPTION_TYPES.each do |type|
      stats[type] = calculate_stats_for_type(type)
    end
    stats
  end

  def self.calculate_stats_for_type(type)
    records = where(consumption_type: type)
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
end
