require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:points_required).is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:redemptions).dependent(:restrict_with_error) }
    it { should have_many(:users).through(:redemptions) }
  end

  describe 'scopes' do
    describe '.available' do
      it 'returns only available rewards' do
        available_reward = create(:reward, available: true)
        unavailable_reward = create(:reward, available: false)

        expect(Reward.available).to include(available_reward)
        expect(Reward.available).not_to include(unavailable_reward)
      end
    end
  end
end
