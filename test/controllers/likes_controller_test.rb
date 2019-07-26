# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @post = posts(:one)
    @other_user = users(:two)
  end

  ###########
  #  create #
  ###########
  test 'should redirect create when not logged in' do
    post likes_path, params: { like: { user_id: 1, post_id: 1 } }
    assert_redirected_to new_user_session_path
  end

  test 'should create like' do
    sign_in @user
    assert_difference -> { @user.likes.count } do
      post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    end
  end

  test 'should unique by user-post pair' do
    sign_in @user
    @user.likes.create(user_id: @user.id, post_id: @post.id)
    assert_no_difference -> { @user.likes.count } do
      post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    end
  end

  test 'should create with ajax' do
    sign_in @user
    assert_difference -> { @user.likes.count } do
      post likes_path, xhr: true, params: { like: { user_id: @user.id, post_id: @post.id } }
    end
  end

  ###########
  # destroy #
  ###########
  test 'should destroy by authorized user' do
    sign_in @user
    post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    assert_difference -> { @user.likes.count }, -1 do
      delete like_path(@user.likes.last)
    end
  end

  test 'should not destroy by unauthorized user' do
    sign_in @user
    post likes_path, params: { like: { post_id: @post.id } }
    sign_out @user
    sign_in @other_user
    assert_no_difference -> { @user.likes.count } do
      assert_raises Pundit::NotAuthorizedError do
        delete like_path(@user.likes.last)
      end
    end
  end

  test 'should destroy with ajax' do
    sign_in @user
    like = @user.likes.create!(post: @post)
    assert_difference -> { @user.likes.count }, -1 do
      delete like_path(like), xhr: true
    end
  end
end
