class Api::V1::RedemptionsController < Api::V1::BaseController
  # POST /api/v1/users/:user_id/redemptions
  def create
    user = User.find(params[:user_id])
    reward = Reward.find(params[:reward_id])

    # Add logging to debug the issue
    Rails.logger.info("Attempting to redeem reward: #{reward.name}, Available: #{reward.available}")

    if !reward.available
      render json: { error: 'Reward is not available for redemption' }, status: :unprocessable_entity
      return
    end

    if user.redeem_reward(reward)
      render json: {
        message: 'Reward successfully redeemed',
        remaining_points: user.points
      }, status: :created
    else
      render json: {
        error: 'Failed to redeem reward',
        reason: 'Insufficient points or reward unavailable'
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:user_id/redemptions
  def index
    user = User.find(params[:user_id])
    redemptions = user.redemptions.ordered_by_recent.includes(:reward)

    render json: redemptions.map { |redemption| redemption_to_json(redemption) }
  end

  # GET /api/v1/users/:user_id/points
  def points_balance
    user = User.find(params[:user_id])
    render json: { points: user.points }
  end

  # GET /api/v1/rewards
  def available_rewards
    rewards = Reward.where(available: true)
    render json: rewards.map { |reward| reward_to_json(reward) }
  end

  private

  def redemption_to_json(redemption)
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

  def reward_to_json(reward)
    {
      id: reward.id,
      name: reward.name,
      description: reward.description,
      points_required: reward.points_required,
      available: reward.available
    }
  end
end
