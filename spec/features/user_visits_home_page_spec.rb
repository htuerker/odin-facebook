require 'rails_helper'

RSpec.feature 'User visits home page', :type => :feature do
  let(:current_user) { create(:user) }

  before do
    login_as current_user
    create_list(:post, 5, user: current_user)
    visit root_path
  end

  scenario 'Home page shows all the recent posts from user\'s feed' do
    visit root_path
    current_user.feed.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
  end

  describe 'top navigation bar' do
    it 'should show nav links' do
      expect(page).to have_link 'facebook', href: root_path
      expect(page).to have_link 'Home', href: root_path
      expect(page).to have_link "#{current_user.first_name} #{current_user.last_name}", href: user_path(current_user)
      expect(page).to have_link 'Find Friends', href: users_path
      expect(page).to have_link href: notifications_path
    end
  end

  context 'user intereacts with a post' do
    scenario 'User creates a new post' do
      fill_in 'post_content', with: 'Hello, World!'
      click_button 'Share'
      expect(page).to have_content('Hello, World!')
    end

    scenario 'user deletes a post' do
      post = current_user.feed.first
      within "#post-#{post.id}" do
        find('a[data-method="delete"]').click
      end
      expect(page).not_to have_selector("#post-#{post.id}")
    end

    scenario 'User comments on a post' do
      post = current_user.feed.first
      within "#post-#{post.id}" do
        fill_in 'comment_content', with: 'I\'m a comment! Really!'
        click_button 'Comment'
        expect(page).to have_content("Comments(#{post.comments.count})")
        expect(page).to have_content("I\'m a comment! Really!")
      end
    end

    scenario 'User delete his comment on a post' do
      post = current_user.feed.first
      create_list(:comment, 5, user: current_user, post: post)
      comment_to_delete = post.comments.first
      reload_page
      within "#post-#{post.id}" do
        click_link 'Load Comments'
        find("a[href=\"/comments/#{comment_to_delete.id}\"]").click
        reload_page
        click_link 'Load Comments'
        expect(page).to have_no_content(comment_to_delete.content)
      end
    end
  end
end
