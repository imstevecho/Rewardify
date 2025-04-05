require 'rails_helper'

RSpec.describe Api::V1::RewardsController, type: :controller do
  describe 'GET #index' do
    before do
      create_list(:reward, 3, available: true)
      create_list(:reward, 2, available: false)
      get :index
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns only available rewards' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(3)
      parsed_response.each do |reward|
        expect(reward['available']).to be true
      end
    end

    it 'returns reward details in JSON format' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first).to include(
        'id', 'name', 'description', 'points_required', 'available'
      )
    end
  end

  describe 'GET #show' do
    let(:reward) { create(:reward) }

    context 'when reward exists' do
      before { get :show, params: { id: reward.id } }

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'returns the reward details in JSON format' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(reward.id)
        expect(parsed_response['name']).to eq(reward.name)
        expect(parsed_response['description']).to eq(reward.description)
        expect(parsed_response['points_required']).to eq(reward.points_required)
        expect(parsed_response['available']).to eq(reward.available)
      end
    end

    context 'when reward does not exist' do
      before { get :show, params: { id: 9999 } }

      it 'returns a 404 status code' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('error')
        expect(parsed_response['error']).to eq('Resource not found')
      end
    end
  end
end
