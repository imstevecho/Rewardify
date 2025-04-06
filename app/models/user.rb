class User < ApplicationRecord
  has_many :redemptions, dependent: :destroy
  has_many :rewards, through: :redemptions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }

  # Helper shorthand for checking if user has enough points
  # Use like: user.has_points_for?(reward)
  def has_points_for?(reward)
    points >= reward.points_required
  end

  # Alias to keep code more readable in conditionals
  alias_method :can_afford?, :has_points_for?

  # For backward compatibility with existing tests
  alias_method :can_redeem?, :has_points_for?

  # Service-based approach for redemptions
  def redeem_reward(reward)
    # Just delegate to the service object - keeps the model clean
    RewardRedemptionService.new(self, reward).redeem
  end

  # Gets user's top 5 most expensive redemptions
  # Useful for dashboard displays, etc.
  def top_redemptions(limit = 5)
    redemptions
      .joins(:reward)
      .order('rewards.points_required DESC')
      .limit(limit)
  end

  # Used by the rewards browsing page to filter out things
  # the user can't afford to reduce UI noise
  def affordable_rewards
    Reward.available.where('points_required <= ?', points)
  end
end
