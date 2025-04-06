class Reward < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :points_required, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true

  # Scopes
  scope :affordable_by, ->(user) { where('points_required <= ?', user.points) }
  scope :ordered_by_cost, -> { order(points_required: :asc) }
  scope :premium, -> { where('points_required > 100') }
  scope :basic, -> { where('points_required <= 100') }
  scope :available, -> { where(available: true) }

  # Associations
  has_many :redemptions, dependent: :restrict_with_error
  has_many :users, through: :redemptions

  # Custom attributes
  def formatted_cost
    "#{points_required} points"
  end

  def affordable_for?(user)
    user.points >= points_required
  end

  # Alternate name for the same method for better readability in different contexts
  alias_method :can_be_redeemed_by?, :affordable_for?

  # Returns how many points the user needs to save to afford this reward
  def points_needed_by(user)
    return 0 if affordable_for?(user)
    points_required - user.points
  end

  # How many times this reward has been redeemed
  def redemption_count
    redemptions.count
  end

  # Is this a popular reward? (used in more than 5 redemptions)
  def popular?
    redemption_count > 5
  end

  # For debugging and easy inspection of rewards in the console
  def to_s
    "#{name} (#{formatted_cost})"
  end
end
