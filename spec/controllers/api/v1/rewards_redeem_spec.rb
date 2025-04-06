require 'rails_helper'

RSpec.describe 'Rewards Redeem API', type: :request do
  describe 'POST /api/v1/rewards/:id/redeem' do
    let!(:user) { create(:user, points: 500) }
    let!(:reward) { create(:reward, points_required: 300, available: true) }
    let!(:unavailable_reward) { create(:reward, points_required: 100, available: false) }
    let!(:expensive_reward) { create(:reward, points_required: 800, available: true) }

    context 'when request is valid' do
      before do
        post "/api/v1/rewards/#{reward.id}/redeem", params: { user_id: user.id }
      end

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json['message']).to match(/successfully redeemed/)
      end

      it 'deducts the points from the user' do
        expect(json['remaining_points']).to eq(200)
        expect(user.reload.points).to eq(200)
      end

      it 'creates a redemption record' do
        expect(Redemption.where(user: user, reward: reward).count).to eq(1)
      end
    end

    context 'when reward is not available' do
      before do
        post "/api/v1/rewards/#{unavailable_reward.id}/redeem", params: { user_id: user.id }
      end

      it 'returns status code 422 (unprocessable entity)' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['error']).to match(/Failed to redeem reward/)
        expect(json['reason']).to match(/not available/)
      end

      it 'does not deduct points from user' do
        expect(user.reload.points).to eq(500)
      end
    end

    context 'when user has insufficient points' do
      before do
        post "/api/v1/rewards/#{expensive_reward.id}/redeem", params: { user_id: user.id }
      end

      it 'returns status code 422 (unprocessable entity)' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['error']).to match(/Failed to redeem reward/)
        expect(json['reason']).to match(/Insufficient points/)
      end

      it 'does not deduct points from user' do
        expect(user.reload.points).to eq(500)
      end
    end

    context 'when user_id is missing' do
      before do
        post "/api/v1/rewards/#{reward.id}/redeem"
      end

      it 'returns status code 400 (bad request)' do
        expect(response).to have_http_status(400)
      end

      it 'returns an error message' do
        expect(json['error']).to match(/User ID is required/)
      end
    end
  end

  # Helper method to parse JSON responses
  def json
    JSON.parse(response.body)
  end
end
