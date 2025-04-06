class Api::V1::RewardsController < Api::V1::BaseController
  # GET /api/v1/rewards
  def index
    rewards = Reward.available
    render json: RewardSerializer.render_collection(rewards)
  end

  # GET /api/v1/rewards/:id
  def show
    reward = Reward.find(params[:id])
    render json: RewardSerializer.render(reward)
  end

  private

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
