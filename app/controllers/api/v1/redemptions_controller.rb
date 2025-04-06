class Api::V1::RedemptionsController < Api::V1::BaseController
  before_action :find_user, only: [:create, :index]
  before_action :find_reward, only: [:create, :redeem]
  before_action :check_user_id_present, only: [:redeem]

  # POST /api/v1/users/:user_id/redemptions
  # POST /api/v1/redemptions (with user_id in params)
  def create
    handle_redemption
  end

  # GET /api/v1/users/:user_id/redemptions
  # GET /api/v1/redemptions?user_id=:user_id
  def index
    # Always eager-load associations we know we'll need
    redemptions = @user.redemptions.ordered_by_recent.includes(:reward)
    render json: RedemptionSerializer.render_collection(redemptions)
  end

  # POST /api/v1/rewards/:id/redeem
  # For the "/rewards/:id/redeem" endpoint
  def redeem
    @user = User.find(params[:user_id])
    handle_redemption
  end

  private

  def check_user_id_present
    # Special handling for the redeem endpoint since it works differently
    unless params[:user_id].present?
      render json: { error: 'User ID is required' }, status: :bad_request
      return false
    end
  end

  def find_user
    # Multiple places the user ID could come from. Check them in order.
    user_id = params[:user_id] || params[:id]

    # Bail if we don't have a user ID
    unless user_id
      render json: { error: 'User ID is required' }, status: :bad_request
      return false
    end

    @user = User.find(user_id)
  end

  def find_reward
    # We may get a reward_id or we may be using the :id from the URL
    # Also check for a nested structure from the frontend
    reward_id = params[:reward_id] ||
               (params[:redemption] && params[:redemption][:reward_id]) ||
               (params[:id] if action_name == 'redeem')

    # Bail if we don't have a reward ID
    unless reward_id
      render_error('Reward ID is required', :bad_request)
      return false
    end

    @reward = Reward.find(reward_id)
  end

  def handle_redemption
    # Let the service object do the work
    service = RewardRedemptionService.new(@user, @reward)

    if service.redeem
      # Find the redemption record for the response
      redemption = @user.redemptions.where(reward: @reward).order(created_at: :desc).first

      render json: {
        message: 'Reward successfully redeemed',
        remaining_points: @user.points
      }, status: :created
    else
      render json: {
        error: 'Failed to redeem reward',
        reason: service.error_message
      }, status: :unprocessable_entity
    end
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
