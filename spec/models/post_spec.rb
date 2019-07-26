require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'content' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(180) }
    end
  end

  describe 'scopes' do
    describe 'default scope' do
      let (:posts) { create_list(:post, 10) }
      it 'should ordered descendant by created_at' do
        expect(posts.first.created_at < posts.second.created_at).to be true
      end
    end
  end
end
