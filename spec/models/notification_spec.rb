require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:subject) }
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:recipient) }
  end

  context 'validations' do
    describe 'read_status' do
      it { is_expected.to validate_inclusion_of(:read_status).in_array([true, false]) }
    end
  end

  context 'scopes' do
    describe 'default scope' do
      let (:notifications) { create_list(:notification, 10) }
      it 'should ordered descendant by created_at' do
        expect(notifications.first.created_at < notifications.second.created_at).to be true
      end
    end
  end
end
