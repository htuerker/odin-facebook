require 'rails_helper'

RSpec.describe Like, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    describe 'record uniqueness' do
      subject { create(:like) }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:post_id) }
    end
  end

  describe 'after_create notifications' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:post) { create(:post, user: user) }
    it 'should create notification' do
      expect(user.received_notifications).to be_empty
      create(:like, user: other, post: post)
      expect(user.received_notifications).not_to be_empty
    end
  end
end
