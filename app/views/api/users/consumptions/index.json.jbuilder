json.array! @consumptions do |consumption|
  json.extract! consumption, :id, :consumption_type, :measure, :value, :date, :created_at, :updated_at
end
