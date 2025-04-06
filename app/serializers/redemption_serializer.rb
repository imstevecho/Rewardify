class RedemptionSerializer
  def self.render(redemption)
    {
      id: redemption.id,
      reward: {
        id: redemption.reward.id,
        name: redemption.reward.name,
        description: redemption.reward.description,
        points_required: redemption.reward.points_required
      },
      redeemed_at: redemption.redeemed_at.iso8601
    }
  end

  def self.render_collection(redemptions)
    redemptions.map { |redemption| render(redemption) }
  end

  def self.render_created(redemption, remaining_points)
    {
      message: 'Reward successfully redeemed',
      redemption: render(redemption),
      remaining_points: remaining_points
    }
  end
end
