class RewardRedemptionService
  attr_reader :user, :reward, :error_message

  def initialize(user, reward)
    @user = user
    @reward = reward
    @error_message = nil
  end

  def redeem
    # Bail early if any prereqs aren't met
    return false unless valid_entities?
    return false unless reward_available?
    return false unless enough_points?

    do_redemption
  end

  private

  def valid_entities?
    # This shouldn't happen in normal flow, but let's be safe
    if user.nil?
      set_error("User not found or invalid")
      return false
    end

    if reward.nil?
      set_error("Reward not found or invalid")
      return false
    end

    true
  end

  def reward_available?
    unless reward.available?
      set_error("This reward is not available")
      return false
    end

    true
  end

  def enough_points?
    # No magic numbers - always use the values from the objects themselves
    if user.points < reward.points_required
      set_error("Insufficient points (#{user.points}/#{reward.points_required})")
      return false
    end

    true
  end

  def do_redemption
    # Try/catch here since we're doing DB operations that could fail
    ActiveRecord::Base.transaction do
      create_redemption_record
      deduct_points

      # Log after success to help with troubleshooting
      Rails.logger.info("Reward redeemed: User ##{user.id} got '#{reward.name}' for #{reward.points_required} points")
      return true
    end
  rescue => e
    # Catch-all for unexpected errors (DB constraints, etc)
    set_error("Redemption failed: #{e.message}")
    return false
  end

  def create_redemption_record
    user.redemptions.create!(
      reward: reward,
      redeemed_at: Time.current
    )
  end

  def deduct_points
    # Don't bother with callbacks - explicit is better than implicit
    new_balance = user.points - reward.points_required
    user.update!(points: new_balance)
  end

  def set_error(msg)
    @error_message = msg
    Rails.logger.error("Redemption error: #{msg}")
    false
  end
end
