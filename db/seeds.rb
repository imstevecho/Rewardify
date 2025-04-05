# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a test user
user = User.find_or_create_by(email: 'user@example.com') do |u|
  u.name = 'Test User'
  u.points = 1000
end

# Create some sample rewards
rewards = [
  {
    name: 'Coffee Voucher',
    description: 'Free coffee at any participating cafe',
    points_required: 100,
    available: true
  },
  {
    name: 'Movie Ticket',
    description: 'Free movie ticket for any standard screening',
    points_required: 300,
    available: true
  },
  {
    name: 'Gift Card',
    description: '$50 gift card for your favorite store',
    points_required: 500,
    available: true
  },
  {
    name: 'Weekend Getaway',
    description: 'Two-night stay at a luxury hotel',
    points_required: 2000,
    available: true
  },
  {
    name: 'VIP Concert Tickets',
    description: 'Front row tickets to an exclusive concert',
    points_required: 1500,
    available: true
  }
]

rewards.each do |reward_data|
  Reward.find_or_create_by(name: reward_data[:name]) do |reward|
    reward.description = reward_data[:description]
    reward.points_required = reward_data[:points_required]
    reward.available = reward_data[:available]
  end
end

# Create some sample redemptions for the test user
if user.redemptions.empty?
  coffee_reward = Reward.find_by(name: 'Coffee Voucher')
  movie_reward = Reward.find_by(name: 'Movie Ticket')

  user.redemptions.create!(
    reward: coffee_reward,
    redeemed_at: 7.days.ago
  )

  user.redemptions.create!(
    reward: movie_reward,
    redeemed_at: 2.days.ago
  )

  # Update user's points after redemptions
  user.update!(points: 1000 - coffee_reward.points_required - movie_reward.points_required)
end

puts "Seed data created successfully!"
