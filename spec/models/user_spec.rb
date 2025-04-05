require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_numericality_of(:points).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should have_many(:redemptions).dependent(:destroy) }
    it { should have_many(:rewards).through(:redemptions) }
  end

  describe '#can_redeem?' do
    let(:user) { create(:user, points: 200) }

    context 'when user has enough points' do
      let(:reward) { create(:reward, points_required: 100) }

      it 'returns true' do
        expect(user.can_redeem?(reward)).to be true
      end
    end

    context 'when user does not have enough points' do
      let(:reward) { create(:reward, points_required: 300) }

      it 'returns false' do
        expect(user.can_redeem?(reward)).to be false
      end
    end
  end

  describe '#redeem_reward' do
    let(:user) { create(:user, points: 500) }
    let(:reward) { create(:reward, points_required: 200) }

    context 'when user has enough points' do
      it 'deducts points from user' do
        expect { user.redeem_reward(reward) }.to change { user.points }.by(-200)
      end

      it 'creates a redemption record' do
        expect { user.redeem_reward(reward) }.to change { user.redemptions.count }.by(1)
      end

      it 'returns true' do
        expect(user.redeem_reward(reward)).to be true
      end
    end

    context 'when user does not have enough points' do
      let(:expensive_reward) { create(:reward, points_required: 600) }

      it 'does not deduct points from user' do
        expect { user.redeem_reward(expensive_reward) }.not_to change { user.points }
      end

      it 'does not create a redemption record' do
        expect { user.redeem_reward(expensive_reward) }.not_to change { user.redemptions.count }
      end

      it 'returns false' do
        expect(user.redeem_reward(expensive_reward)).to be false
      end
    end
  end
end
