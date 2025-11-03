json.array! @consumptions do |consumption|
  json.extract! consumption, :id, :user_id, :consumption_type, :amount, :date, :created_at, :updated_at
end
