class Api::V1::RedemptionsController < Api::V1::BaseController
  # POST /api/v1/users/:user_id/redemptions
  # POST /api/v1/rewards/:id/redeem (with user_id in params)
  def create
    user = User.find(params[:user_id])
    reward = Reward.find(params[:reward_id])

    service = RewardRedemptionService.new(user, reward)
    if service.redeem
      # Find the most recent redemption for this user and reward
      redemption = user.redemptions.where(reward: reward).order(created_at: :desc).first
      render json: {
        message: 'Reward successfully redeemed',
        remaining_points: user.points
      }, status: :created
    else
      render json: {
        error: 'Failed to redeem reward',
        reason: service.error_message
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:user_id/redemptions
  def index
    user = User.find(params[:user_id])
    redemptions = user.redemptions.ordered_by_recent.includes(:reward)

    render json: RedemptionSerializer.render_collection(redemptions)
  end

  # Alternative route handler for /rewards/:id/redeem
  def redeem
    user_id = params[:user_id]
    reward_id = params[:id]

    unless user_id
      render json: { error: 'User ID is required' }, status: :bad_request
      return
    end

    user = User.find(user_id)
    reward = Reward.find(reward_id)

    service = RewardRedemptionService.new(user, reward)
    if service.redeem
      # Find the most recent redemption for this user and reward
      redemption = user.redemptions.where(reward: reward).order(created_at: :desc).first
      render json: {
        message: 'Reward successfully redeemed',
        remaining_points: user.points
      }, status: :created
    else
      render json: {
        error: 'Failed to redeem reward',
        reason: service.error_message
      }, status: :unprocessable_entity
    end
  end
end
