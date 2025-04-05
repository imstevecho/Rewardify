class User < ApplicationRecord
  has_many :redemptions, dependent: :destroy
  has_many :rewards, through: :redemptions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }

  def can_redeem?(reward)
    points >= reward.points_required
  end

  def redeem_reward(reward)
    # Check if user has enough points
    if self.points < reward.points_required
      Rails.logger.info("Redemption failed: User has #{self.points} points, but #{reward.points_required} are required")
      return false
    end

    # Check if reward is available
    unless reward.available
      Rails.logger.info("Redemption failed: Reward is not available")
      return false
    end

    # Proceed with redemption
    ActiveRecord::Base.transaction do
      self.redemptions.create!(reward: reward, redeemed_at: Time.current)
      self.update!(points: self.points - reward.points_required)
    end

    true
  rescue => e
    Rails.logger.error("Redemption error: #{e.message}")
    false
  end
end
