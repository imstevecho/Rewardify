class Api::V1::UsersController < Api::V1::BaseController
  # GET /api/v1/users/:id/points
  def points
    user = User.find(params[:id])
    render json: { points: user.points }
  end

  # GET /api/v1/users/:id/balance
  def balance
    user = User.find(params[:id])
    render json: UserSerializer.render_balance(user)
  end
end
