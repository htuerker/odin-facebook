# frozen_string_literal: true

require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'profile page as owner' do
    sign_in @user
    get user_path(@user.id)
    assert_template 'users/me'
    # User info
    assert_match "#{@user.first_name.capitalize} #{@user.last_name.capitalize}", response.body
    assert_select 'img[class=?]', 'gravatar rounded-circle'
    assert_select 'a[href=?]', me_edit_path
    # New post form
    assert_select 'form[id=?]', 'new_post'
    # User's own posts
    assert_select 'div[class=?]', 'card-body', count: @user.posts.count

    @user.posts.paginate(page: 1, per_page: 10).each do |user_post|
      # TO-DO
      # fix fixture issue, there's one invalid post with filled by nil values
      next unless user_post.id

      assert_select 'span[id=?]', "post-#{user_post.id}-comments-counter", value: user_post.comments.count
      assert_select 'span[id=?]', "post-#{user_post.id}-likes-counter", value: user_post.likes.count
      assert_select 'div[id=?]', "post-#{user_post.id}-like-form", count: 1
      if user_post.comments.any?
        assert_select 'a[id=?]', "post-#{user_post.id}-comments-pagination-link", count: 1
      end
    end
  end

  test 'profile as visitor' do
    sign_in @user
    get user_path(@other_user.id)
    assert_template 'users/show'
    # User info
    assert_match "#{@other_user.first_name.capitalize} #{@other_user.last_name.capitalize}", response.body
    assert_select 'img[class=?]', 'gravatar rounded-circle'
    assert_select 'a[href=?]', me_edit_path, count: 0

    assert_select 'form[id=?]', 'new_post', count: 0
    assert_select 'div[class=?]', 'card-body', count: @other_user.posts.count

    @other_user.posts.paginate(page: 1, per_page: 10).each do |user_post|
      assert_select 'span[id=?]', "post-#{user_post.id}-comments-counter", value: user_post.comments.count
      assert_select 'span[id=?]', "post-#{user_post.id}-likes-counter", value: user_post.comments.count
      assert_select 'div[id=?]', "post-#{user_post.id}-like-form", count: 1
      assert_select 'a[id=?]', "post-#{user_post.id}-comments-pagination-link", count: 1
      # comment form under each post
      assert_select 'form[id=?]', "post-#{user_post.id}-comment-form", count: 1
    end
  end
end
