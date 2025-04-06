require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #points' do
    let(:user) { create(:user, points: 500) }

    context 'when user exists' do
      before { get :points, params: { id: user.id } }

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'returns the user points in JSON format' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('points')
        expect(parsed_response['points']).to eq(500)
      end
    end

    context 'when user does not exist' do
      before { get :points, params: { id: 9999 } }

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

  describe 'GET #balance' do
    let!(:user) { create(:user, points: 1000) }

    before do
      get :balance, params: { id: user.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the user points as JSON' do
      json_response = JSON.parse(response.body)
      expect(json_response['points']).to eq(1000)
    end
  end
end
