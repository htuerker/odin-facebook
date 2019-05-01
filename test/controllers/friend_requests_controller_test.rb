require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  #TO-DO setup fixtures to use one friend_request
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  ##########
  # create #
  ##########
  test 'should redirect create when not logged in' do
    post friend_requests_path, params: { friend_request: { receiver_id: 1 } }
    assert_redirected_to new_user_session_path
  end

  test 'should create if it\'s valid with pending status' do
    sign_in @user
    assert_not @user == @other_user
    assert_not @user.friends.include?(@other_user)
    assert_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id
        } }
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
          receiver_id: @user.id
        } }
    end
    assert_not assigns(:friend_request).errors[:sender_receiver].nil?
    assert_redirected_to root_path
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
        } }
    end
  end

  test 'should update status to pending when there\'s declined request' do
    sign_in @user
    @user.friend_requests_sent.create!(receiver: @other_user, status: -1)
    assert_not @user.friend_requests_sent.pending.any?
    assert @user.friend_requests_sent.any?
    assert_not @other_user.friend_requests_received.pending.any?
    assert @other_user.friend_requests_received.any?
    assert_no_difference -> { @user.friend_requests_sent.count } do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id
        } }
    end
  end

  ##################
  # accept decline #
  ##################
  test 'should redirect accept when not logged in' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    post friend_request_accept_path(friend_request)
    assert_redirected_to new_user_session_path
  end

  test 'should not accept when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    post friend_request_accept_path(friend_request)
    assert_redirected_to root_path
    assert flash.any?
  end

  test 'should redirect decline when not logged in' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    post friend_request_decline_path(friend_request)
    assert_redirected_to new_user_session_path
  end

  test 'should not decline when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    post friend_request_decline_path(friend_request)
    assert_redirected_to root_path
    assert flash.any?
  end

  ###########
  # destroy #
  ###########

  test 'should redirect destroy when not logged in' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    assert_no_difference 'FriendRequest.count' do
      delete friend_request_path(friend_request)
    end
    assert_redirected_to new_user_session_path
    assert flash.any?
  end

  test 'should destroy with authorized user' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    assert_difference 'FriendRequest.count', -1 do
      delete friend_request_path(friend_request)
    end
    assert_redirected_to root_path
    assert flash.any?
  end

  test 'should not destroy when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    sign_in @other_user
    assert_no_difference 'FriendRequest.count' do
      delete friend_request_path(friend_request)
    end
    assert_redirected_to root_path
    assert flash.any?
  end

end
