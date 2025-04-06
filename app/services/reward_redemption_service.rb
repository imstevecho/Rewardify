class RewardRedemptionService
  attr_reader :user, :reward, :error_message

  def initialize(user, reward)
    @user = user
    @reward = reward
    @error_message = nil
  end

  def redeem
    # Validate inputs
    return redemption_error('User not found') unless user
    return redemption_error('Reward not found') unless reward

    # Check if reward is available
    return redemption_error('Reward is not available for redemption') unless reward.available

    # Check if user has enough points
    unless user.points >= reward.points_required
      return redemption_error("Insufficient points (#{user.points}) to redeem reward (#{reward.points_required} required)")
    end

    # Proceed with redemption in a transaction
    ActiveRecord::Base.transaction do
      redemption = user.redemptions.create!(reward: reward, redeemed_at: Time.current)
      user.update!(points: user.points - reward.points_required)

      Rails.logger.info("Reward successfully redeemed: User #{user.id} redeemed #{reward.name} for #{reward.points_required} points")
      return true
    end
  rescue ActiveRecord::RecordInvalid => e
    redemption_error("Validation error: #{e.message}")
  rescue StandardError => e
    redemption_error("Unexpected error: #{e.message}")
  end

  private

  def redemption_error(message)
    Rails.logger.error("Redemption error: #{message}")
    @error_message = message
    false
  end
end
