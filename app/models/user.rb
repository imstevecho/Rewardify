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
    service = RewardRedemptionService.new(self, reward)
    service.redeem
  end
end
