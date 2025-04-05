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
    return false unless can_redeem?(reward)

    ActiveRecord::Base.transaction do
      self.points -= reward.points_required
      redemptions.create!(reward: reward, redeemed_at: Time.current)
      save!
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
