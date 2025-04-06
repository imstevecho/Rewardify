class RewardSerializer
  def self.render(reward)
    {
      id: reward.id,
      name: reward.name,
      description: reward.description,
      points_required: reward.points_required,
      available: reward.available
    }
  end

  def self.render_collection(rewards)
    rewards.map { |reward| render(reward) }
  end
end
