class Consumption < ApplicationRecord
  belongs_to :user

  TYPES = %w[electricity water gas].freeze
  MEASURES = %w[kwh liters cubic_meters].freeze
  validates :type, inclusion: { in: TYPES }
  validates :measure, inclusion: { in: MEASURES }
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
