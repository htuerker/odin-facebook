require 'rails_helper'

RSpec.describe Friendship, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend) }
  end

  describe 'validations' do
    describe '#not_self' do
      let(:user) { create(:user) }
      subject { build(:friendship, user: user, friend: user) }

      it 'should not allow when sender and receiver are the same user' do
        expect(subject.valid?).to be false
        expect(subject.errors[:not_self]).to include('user and friend pair can\'t be the same')
      end
    end

    describe '#not_friends' do
      let (:user) { create(:user) }
      let (:friend) { create(:user) }
      subject { build(:friendship, user: user, friend: friend) }

      before do
        user.direct_friends << friend
      end

      it 'should not allow when sender and receiver are already friends' do
        expect(subject.valid?). to be false
        expect(subject.errors[:not_friends]).to include('user and friend pair can\'t be already friends')
      end
    end
  end

  describe 'class methods' do
    describe '#find_between' do
      let(:user) { create(:user) }
      let(:friend) { create(:user) }
      subject { create(:friendship, user: user, friend: friend) }

      it 'should return the friendship object, if there is' do
        expect(subject).to eql(Friendship.find_between(user, friend))
      end
    end
  end
end
