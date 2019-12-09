require 'rails_helper'

RSpec.feature 'User visits notifications page', :type => :feature do
  let(:current_user) { create(:user) }
  let(:user) { create(:user) }

  before do
    create(:notification, actor: user,
                          recipient: current_user,
                          subject: create(:comment))
    create(:notification, actor: user,
                          recipient: current_user,
                          subject: create(:like))
  end
  it 'should show notifications' do
    login_as current_user
    visit notifications_path
    current_user.received_notifications.each do |notification|
      expect(page).to have_selector("a[href='/posts/#{notification.subject.post.id}']")
    end
  end
end
