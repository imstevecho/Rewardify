namespace :rewards do
  desc "Reset user points to 500 while preserving redemption history"
  task reset: :environment do
    # Find the user (assuming user ID 1 for this example)
    user = User.find_by(id: 1)

    if user
      # Store original points for logging
      original_points = user.points

      # Reset points to 500
      user.update!(points: 500)

      # Count redemptions for reporting
      redemption_count = user.redemptions.count

      puts "✅ Reset complete!"
      puts "User: #{user.email}"
      puts "Points changed: #{original_points} → 500"
      puts "Redemption history preserved (#{redemption_count} records)"
    else
      puts "❌ User not found!"
    end
  end

  desc "Reset entire system to initial state (500 points, no redemptions)"
  task reset_all: :environment do
    # Find the user
    user = User.find_by(id: 1)

    if user
      # Begin transaction to ensure all operations succeed or fail together
      ActiveRecord::Base.transaction do
        # Store original values for logging
        original_points = user.points
        redemption_count = user.redemptions.count

        # Delete all redemptions for this user
        user.redemptions.destroy_all

        # Reset points to 500
        user.update!(points: 500)

        puts "✅ Full reset complete!"
        puts "User: #{user.email}"
        puts "Points changed: #{original_points} → 500"
        puts "Redemptions deleted: #{redemption_count}"
      end
    else
      puts "❌ User not found!"
    end
  end
end
