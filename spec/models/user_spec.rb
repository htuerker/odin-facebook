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

      before do
        create(:friendship, user: current_user, friend: other_user)
      end

      it "reflects like a bi-directional relation through direct and inverse friendships" do
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
        expect(user.errors.messages[:first_name]).to eq ['must be valid name']
      end
    end

    describe 'last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(20) }
      it 'should be only alphabetically' do
        user = build(:user, last_name: '1last_name2')
        expect(user.valid?).to be false
        expect(user.errors.messages[:last_name]).to eq ['must be valid name']
      end
    end
  end

  describe '#friends' do
    let(:current_user) { create(:user) }
    let(:direct_friend) { create(:user) }
    let(:inverse_friend) { create(:user) }
    let(:not_friend) { create(:user) }

    it 'should return all direct and inverse friends' do
      current_user.direct_friends << direct_friend
      current_user.inverse_friends << inverse_friend
      expect(current_user.friends.length).to eql(2);
      expect(current_user.friends.include?(direct_friend)).to be true
      expect(current_user.friends.include?(inverse_friend)).to be true
      expect(current_user.friends.include?(not_friend)).to be false
    end
  end

  describe 'instance methods' do
    let(:current_user) { create(:user) }
    let(:friend_user) { create(:user) }
    let(:non_friend_user) { create(:user) }

    before do
      create(:friendship, user: current_user, friend: friend_user)
    end

    describe '#feed' do
      it 'should include own posts' do
        user_post = create(:post, user: current_user)
        expect(current_user.feed).to include(user_post)
      end

      it 'should include friends posts' do
        friend_post     = create(:post, user: friend_user)
        expect(current_user.feed).to include(friend_post)
      end

      it 'should not include non-friends posts' do
        non_friend_post = create(:post, user: non_friend_user)
        expect(current_user.feed).not_to include(non_friend_post)
      end
    end

    describe '#friendable_users' do
      it 'should not include current user' do
        expect(current_user.friendable_users).not_to include(current_user)
      end

      it 'should not include friends' do
        expect(current_user.friendable_users).not_to include(friend_user)
      end

      it 'should include non-friends' do
        expect(current_user.friendable_users).to include(non_friend_user)
      end
    end
  end
end
