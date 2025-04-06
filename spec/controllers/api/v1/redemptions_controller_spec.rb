require 'rails_helper'

RSpec.describe Api::V1::RedemptionsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward) }

    before do
      create_list(:redemption, 3, user: user, reward: reward)
      # Create redemptions for another user that shouldn't be returned
      other_user = create(:user)
      create_list(:redemption, 2, user: other_user, reward: reward)
      get :index, params: { user_id: user.id }
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns only the specified user\'s redemptions' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(3)
    end

    it 'returns redemption details in JSON format' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first).to include('id', 'reward', 'redeemed_at')
      expect(parsed_response.first['reward']).to include(
        'id', 'name', 'description', 'points_required'
      )
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, points: 500) }
    let(:reward) { create(:reward, points_required: 200, available: true) }

    context 'with valid parameters and sufficient points' do
      before do
        post :create, params: { user_id: user.id, reward_id: reward.id }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new redemption' do
        expect(user.redemptions.count).to eq(1)
      end

      it 'deducts points from the user' do
        user.reload
        expect(user.points).to eq(300) # 500 - 200
      end

      it 'returns a success message and remaining points' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'message' => 'Reward successfully redeemed',
          'remaining_points' => 300
        )
      end
    end

    context 'with insufficient points' do
      let(:expensive_reward) { create(:reward, points_required: 600, available: true) }

      before do
        post :create, params: { user_id: user.id, reward_id: expensive_reward.id }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a redemption' do
        expect(user.redemptions.count).to eq(0)
      end

      it 'returns an error message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'error' => 'Failed to redeem reward'
        )
      end
    end

    context 'with an unavailable reward' do
      let(:unavailable_reward) { create(:reward, points_required: 200, available: false) }

      before do
        post :create, params: { user_id: user.id, reward_id: unavailable_reward.id }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include('error' => 'Failed to redeem reward')
        expect(parsed_response['reason']).to match(/not available/)
      end
    end

    context 'with invalid user or reward' do
      it 'returns not found for invalid user' do
        post :create, params: { user_id: 9999, reward_id: reward.id }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns not found for invalid reward' do
        post :create, params: { user_id: user.id, reward_id: 9999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
