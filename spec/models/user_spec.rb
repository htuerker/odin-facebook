require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:sent_friend_requests).dependent(:destroy) }
    it { is_expected.to have_many(:received_friend_requests).dependent(:destroy) }
    it { is_expected.to have_many(:direct_friendships).dependent(:destroy) }
    it { is_expected.to have_many(:inverse_friendships).dependent(:destroy) }
    it { is_expected.to have_many(:direct_friends) }
    it { is_expected.to have_many(:inverse_friends) }

    describe "#mutual friendship" do
      let(:current_user) { create(:user) }
      let(:other_user) { create(:user) }

      it "reflects like a bi-directional relation through direct and inverse friendships" do
        create(:friendship, user: current_user, friend: other_user)
        expect(current_user.direct_friends).to include(other_user)
        expect(other_user.inverse_friends).to include(current_user)
      end
    end
  end

  describe 'validations' do
    describe 'first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_length_of(:first_name).is_at_most(20) }
      it 'should be only alphabetically' do
        user = build(:user, first_name: '1firstname_1')
        expect(user.valid?).to be false
        expect(user.errors.messages[:first_name]).to eq ['must be alphabetically']
      end
    end

    describe 'last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(20) }
      it 'should be only alphabetically' do
        user = build(:user, last_name: '1last_name2')
        expect(user.valid?).to be false
        expect(user.errors.messages[:last_name]).to eq ['must be alphabetically']
      end
    end

  end
end
