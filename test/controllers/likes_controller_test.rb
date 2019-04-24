require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @post = posts(:one)
    @other_user = users(:two)
  end

  test 'should redirect create when not logged in' do
    post likes_path, params: { like: { user_id: 1, post_id: 1 } }
    assert_redirected_to new_user_session_path
  end

  test 'should create like' do
    sign_in @user
    assert_difference -> { @user.likes.count } do
      post likes_path, params: { like: { user_id: @user.id, post_id: @post.id }}
    end
  end

  test 'should unique by user-post pair' do
    sign_in @user
    @user.likes.create(user_id: @user.id, post_id: @post.id)
    assert_no_difference -> { @user.likes.count } do
      post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    end
  end

  test 'should destroy by authorized user' do
    sign_in @user
    post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    assert_difference -> { @user.likes.count }, -1 do
      delete like_path(@user.likes.last)
    end
  end

  test 'should not destroy by unauthorized user' do
    sign_in @other_user
    post likes_path, params: { like: { user_id: @user.id, post_id: @post.id } }
    assert_no_difference -> { @user.likes.count } do
      delete like_path(@user.likes.last)
    end
  end
end
