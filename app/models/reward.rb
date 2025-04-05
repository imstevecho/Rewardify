class Reward < ApplicationRecord
  has_many :redemptions, dependent: :restrict_with_error
  has_many :users, through: :redemptions

  validates :name, presence: true
  validates :description, presence: true
  validates :points_required, numericality: { greater_than: 0 }

  scope :available, -> { where(available: true) }
end
