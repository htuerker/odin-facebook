require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:receiver) }
  end

  describe 'validations' do
    describe '#not_self' do
      let(:user) { create(:user) }
      subject { build(:friend_request, sender: user, receiver: user) }

      it 'should not allow when sender and receiver are the same user' do
        expect(subject.valid?).to be false
        expect(subject.errors[:not_self]).to include('sender and receiver pair can\'t be the same')
      end
    end

    describe '#not_friends' do
      let (:user) { create(:user) }
      let (:friend) { create(:user) }
      subject { build(:friend_request, sender: user, receiver: friend) }

      before do
        user.direct_friends << friend
      end

      it 'should not allow when sender and receiver are already friends' do
        expect(subject.valid?). to be false
        expect(subject.errors[:not_friends]).to include('sender and receiver pair can\'t be already friends')
      end
    end
  end
end
