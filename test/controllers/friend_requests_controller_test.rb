require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'should redirect create when not logged in' do
    post friend_requests_path, params: { friend_request: { receiver_id: 1, status: 0 } }
    assert_redirected_to new_user_session_path
  end

  test 'should create if it\'s valid with pending status' do
    sign_in @user
    assert_not @user == @other_user
    assert_not @user.friends.include?(@other_user)
    assert_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id,
          status: 0 } }
    end
    assert_equal assigns(:friend_request).status, 0
    assert @user.friend_requests_sent.find_by(receiver: @other_user).present?
    assert @other_user.friend_requests_received.find_by(sender: @user).present?

  end

  test 'should not send friendrequest to himself' do
    sign_in @user
    assert_no_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @user.id,
          status: 0
        } }
    end
    assert_not assigns(:friend_request).errors[:sender_and_receiver].nil?
    assert_redirected_to @user
    follow_redirect!
    #TO-DO check specifc flash messages like :danger - :alert when the view changed
    assert flash.any?
  end

  test 'should not create friend request between two users are already friend' do
    sign_in @user
    assert_not @user.friends.include?(@other_user)
    @user.establish_friendship(@other_user)
    assert @user.friends.include?(@other_user)
    assert_no_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id,
          status: 0 } }
    end
  end

  test 'should redirect accept when not logged in' do
    #TO-DO checking this needs present friend request for using id accept/:id
  end

  test 'should accept by current_user' do
    sign_in @user

  end

end
