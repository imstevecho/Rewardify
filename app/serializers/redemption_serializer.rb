class RedemptionSerializer
  def self.render(redemption, options = {})
    # Basic redemption info
    result = {
      id: redemption.id,
      redeemed_at: redemption.redeemed_at&.iso8601 || redemption.created_at.iso8601
    }

    # Include the reward details - eager loaded for efficiency where possible
    reward = redemption.reward
    result[:reward] = {
      id: reward.id,
      name: reward.name,
      description: reward.description,
      cost: reward.points_required, # Use cost for API consistency
      points_required: reward.points_required # Include for backward compatibility
    }

    # Include a formatted date for display purposes
    if options[:include_formatted_dates]
      result[:formatted_date] = format_date(redemption.redeemed_at || redemption.created_at)
    end

    # For debugging or admin views
    if options[:include_admin_details]
      result[:transaction_id] = "RDM-#{redemption.id}-#{redemption.created_at.to_i}"
    end

    result
  end

  def self.render_collection(redemptions, options = {})
    redemptions.map { |redemption| render(redemption, options) }
  end

  def self.render_created(redemption, remaining_points)
    {
      message: 'Reward successfully redeemed',
      redemption: render(redemption),
      remaining_points: remaining_points
    }
  end

  # Helper method for formatting dates in a human-readable way
  def self.format_date(date)
    # Return something like "April 5, 2023" or "Today at 2:15pm" for recent dates
    if date.to_date == Date.today
      "Today at #{date.strftime('%-I:%M%P')}"
    elsif date.to_date == Date.yesterday
      "Yesterday at #{date.strftime('%-I:%M%P')}"
    else
      date.strftime('%B %-d, %Y')
    end
  end
end
