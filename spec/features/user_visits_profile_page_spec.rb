require 'rails_helper'

RSpec.feature 'User visits home page', :type => :feature do
  let(:current_user) { create(:user) }
  let(:friend_user) { create(:user) }
  let(:non_friend_user) { create(:user) }

  before do
    login_as current_user
    create_list(:post, 5, user: current_user)
    create_list(:post, 5, user: friend_user)
    create_list(:post, 5, user: non_friend_user)
    current_user.direct_friendships.create(friend: friend_user)
  end

  scenario 'user visits own profile' do
    visit user_path(current_user)
    expect(page).to have_link href: me_edit_path
    expect(page).to have_link href: user_friendships_path(current_user)
    current_user.friends.each do |friend|
      expect(page).to have_link href: user_path(friend)
    end
    expect(page).to have_selector "form[action=\"#{posts_path}\"]"
    current_user.posts.each do |post|
      next if post.id.nil?
      expect(page).to have_selector("#post-#{post.id}")
    end
  end

  scenario 'user visits friend\'s profile' do
    visit user_path(friend_user)
    friendship = Friendship.find_between(current_user, friend_user)
    expect(page).to have_link href: friendship_path(friendship)
    expect(page).to have_link href: user_path(current_user)
  end

  scenario 'user visits non-friend\'s profile' do
    visit user_path(non_friend_user)
    expect(page).to have_selector "form[action=\"#{friend_requests_path}\"]"
  end
end
