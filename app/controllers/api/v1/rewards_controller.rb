class Api::V1::RewardsController < Api::V1::BaseController
  before_action :find_reward, only: [:show]
  before_action :find_user, only: [:affordable, :premium]

  # GET /api/v1/rewards
  def index
    rewards = Reward.available.ordered_by_cost

    # If a user ID is provided, include personalized data
    if params[:user_id].present?
      user = User.find_by(id: params[:user_id])
      options = user ? { current_user: user } : {}
      render json: RewardSerializer.render_collection(rewards, options)
    else
      render json: RewardSerializer.render_collection(rewards)
    end
  end

  # GET /api/v1/rewards/:id
  def show
    # Personalize when user_id is provided
    if params[:user_id].present?
      user = User.find_by(id: params[:user_id])
      options = user ? { current_user: user } : {}
      render json: RewardSerializer.render(@reward, options)
    else
      render json: RewardSerializer.render(@reward)
    end
  end

  # GET /api/v1/users/:user_id/rewards/affordable
  def affordable
    rewards = Reward.available.affordable_by(@user).ordered_by_cost
    render json: RewardSerializer.render_collection(rewards, { current_user: @user })
  end

  # GET /api/v1/rewards/premium
  def premium
    rewards = Reward.available.premium.ordered_by_cost
    options = @user ? { current_user: @user } : {}
    render json: RewardSerializer.render_collection(rewards, options)
  end

  private

  def find_reward
    @reward = Reward.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def find_user
    return unless params[:user_id].present?

    @user = User.find_by(id: params[:user_id])
    unless @user
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
