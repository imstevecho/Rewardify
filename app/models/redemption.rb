class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :redeemed_at, presence: true
  validate :user_has_enough_points, on: :create

  scope :ordered_by_recent, -> { order(redeemed_at: :desc) }

  private

  def user_has_enough_points
    return unless user && reward

    if user.points < reward.points_required
      errors.add(:base, 'User does not have enough points to redeem this reward')
    end
  end
end
