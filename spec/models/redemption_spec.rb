require 'rails_helper'

RSpec.describe Redemption, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:redeemed_at) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:reward) }
  end

  describe 'validate user_has_enough_points' do
    let(:user) { create(:user, points: 100) }

    context 'when user has enough points' do
      let(:reward) { create(:reward, points_required: 50) }

      it 'is valid' do
        redemption = build(:redemption, user: user, reward: reward)
        expect(redemption).to be_valid
      end
    end

    context 'when user does not have enough points' do
      let(:reward) { create(:reward, points_required: 150) }

      it 'is invalid' do
        redemption = build(:redemption, user: user, reward: reward)
        expect(redemption).not_to be_valid
        expect(redemption.errors[:base]).to include('User does not have enough points to redeem this reward')
      end
    end
  end

  describe 'scopes' do
    describe '.ordered_by_recent' do
      it 'orders redemptions by redeemed_at in descending order' do
        user = create(:user)
        reward = create(:reward)

        older_redemption = create(:redemption, user: user, reward: reward, redeemed_at: 2.days.ago)
        newer_redemption = create(:redemption, user: user, reward: reward, redeemed_at: 1.day.ago)
        newest_redemption = create(:redemption, user: user, reward: reward, redeemed_at: Time.current)

        expect(Redemption.ordered_by_recent.to_a).to eq([newest_redemption, newer_redemption, older_redemption])
      end
    end
  end
end
