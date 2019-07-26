require 'rails_helper'

RSpec.feature 'User visits find friends page', :type => :feature do
  let(:current_user) { create(:user) }

  it 'should show friendable users with request link', js: true do
    create_list(:user, 5)
    login_as current_user
    visit users_path
    current_user.friendable_users.each do |user|
      expect(page).to have_selector "#friend_request-#{user.id}-links"
      within "#friend_request-#{user.id}-links" do
        click_button 'Add'
      end
      reload_page
      expect(page).to have_no_selector "#friend_request-#{user.id}-links"
    end
  end
end
