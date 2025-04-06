class RewardSerializer
  def self.render(reward, options = {})
    result = {
      id: reward.id,
      name: reward.name,
      description: reward.description,
      cost: reward.points_required,  # Use 'cost' for API consistency
      points_required: reward.points_required, # Include for backward compatibility
      available: reward.available
    }

    # Include user-specific fields when a user is provided
    if options[:current_user]
      user = options[:current_user]
      affordable = reward.affordable_for?(user)

      result.merge!({
        affordable: affordable,
        points_needed: affordable ? 0 : reward.points_needed_by(user),
        message: affordable ? "You can redeem this reward!" :
                 "You need #{reward.points_needed_by(user)} more points"
      })
    end

    # Include stats when requested
    if options[:include_stats]
      count = reward.redemption_count
      result[:popularity] = case count
                            when 0..3 then "New"
                            when 4..10 then "Popular"
                            else "Hot"
                            end
    end

    result
  end

  def self.render_collection(rewards, options = {})
    rewards.map { |reward| render(reward, options) }
  end
end
