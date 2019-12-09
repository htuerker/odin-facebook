require 'rails_helper'

RSpec.describe Comment, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    describe 'content' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(150) }
    end
  end

  describe 'scopes' do
    describe 'default scope' do
      let (:comments) { create_list(:comment, 10) }
      it 'should ordered descendant by created_at' do
        expect(comments.first.created_at < comments.second.created_at).to be true
      end
    end
  end

  describe 'after_create notifications' do
    let(:user) { create(:user) }
    let(:others) { create_list(:user, 2) }
    let(:post) { create(:post, user: user) }
    it 'should create notification' do
      expect(user.received_notifications).to be_empty
      create(:comment, user: others.first, post: post)
      expect(user.received_notifications).not_to be_empty
    end
  end
end
