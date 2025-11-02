# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = User.all

if users.empty?
  puts "No users found! Please create at least one user before seeding the database."
else
  users.each do |user|
    20.times do |i|
      c = Consumption.create!(
        user: user,
        value: rand(10..100),
        date: Date.today - i.days,
        measure: Consumption::MEASURES.sample,
        consumption_type: Consumption::CONSUMPTION_TYPES.sample
      )
      if c
        puts "Created consumption record for user #{user.email_address}: #{c.consumption_type} - #{c.value} #{c.measure} on #{c.date}"
      else
        puts "Failed to create consumption record for user #{user.email_address}"
      end
    end
  end
end
