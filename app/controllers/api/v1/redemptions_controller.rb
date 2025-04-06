class Api::V1::RedemptionsController < Api::V1::BaseController
  # POST /api/v1/users/:user_id/redemptions
  # POST /api/v1/redemptions (with user_id in params)
  def create
    # Handle params when user_id may be in the URL params or directly in the request params
    user_id = params[:user_id] || params[:id]
    user = User.find(user_id)

    # Extract reward_id from various possible parameter formats
    # It could be directly in params or nested within redemption params
    reward_id = if params[:redemption] && params[:redemption][:reward_id]
                  params[:redemption][:reward_id]
                else
                  params[:reward_id]
                end

    # Ensure we have a reward_id
    unless reward_id
      render json: {
        error: 'Failed to redeem reward',
        reason: 'Missing reward_id parameter'
      }, status: :bad_request
      return
    end

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

  # GET /api/v1/users/:user_id/redemptions
  # GET /api/v1/redemptions?user_id=:user_id
  def index
    # Handle both nested route and direct access with query param
    user_id = if params[:user_id]
                params[:user_id]
              elsif params[:id]
                params[:id]
              else
                # For direct controller access in tests
                params.fetch(:user_id, nil)
              end

    # Ensure we have a user_id
    unless user_id
      render json: { error: 'User ID is required' }, status: :bad_request
      return
    end

    user = User.find(user_id)
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
