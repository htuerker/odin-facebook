require 'rails_helper'

RSpec.feature 'User visits notifications page', :type => :feature do
  let(:current_user) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it 'should show friend requests if there\'s any', js: true do
    current_user.sent_friend_requests.create(receiver: user1)
    current_user.received_friend_requests.create(sender: user2)

    login_as current_user
    visit friend_requests_path

    current_user.sent_friend_requests.each do |friend_request|
      expect(page).to have_selector "#friend_request-#{friend_request.receiver.id}-links"
      within "#friend_request-#{friend_request.receiver.id}-links" do
        expect(page).to have_link href: friend_request_path(friend_request)
        find("a[href=\"#{friend_request_path(friend_request)}\"]").click
        expect(page).to have_no_link href: friend_request_path(friend_request)
        expect(page).to have_selector "form[action=\"#{friend_requests_path}\"]"
      end
    end

    current_user.received_friend_requests.each do |friend_request|
      expect(page).to have_selector "#friend_request-#{friend_request.sender.id}-links"
      within "#friend_request-#{friend_request.sender.id}-links" do
        expect(page).to have_link href: friend_request_path(friend_request)
        expect(page).to have_selector "form[action=\"#{friendships_path}\"]"
      end
      click_button 'Accept'
      expect(page).to have_no_selector "#friend_request-#{friend_request.sender.id}-links"
    end
  end
end
