# frozen_string_literal: true

require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  ##########
  # create #
  ##########
  test 'should redirect create when not logged in' do
    post friend_requests_path
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
        }
      }
    end
    assert_equal assigns(:friend_request).status, FriendRequest.statuses[:pending]
    assert @user.friend_requests_sent.find_by(receiver: @other_user).present?
    assert @other_user.friend_requests_received.find_by(sender: @user).present?
  end

  test 'should not send friendrequest to himself' do
    sign_in @user
    assert_no_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @user.id
        }
      }
    end
    assert_not assigns(:friend_request).errors[:sender_receiver].nil?
    assert_redirected_to root_path
  end

  test 'should not create friend request between two users are already friend' do
    sign_in @user
    assert_not @user.friends.include?(@other_user)
    @user.establish_friendship(@other_user)
    assert @user.friends.include?(@other_user)
    assert_no_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id
        }
      }
    end
  end

  test 'should update status to pending when there\'s declined request' do
    sign_in @user
    @user.friend_requests_sent.create!(receiver: @other_user, status: FriendRequest.statuses[:declined])
    assert_not @user.friend_requests_sent.pending.any?
    assert @user.friend_requests_sent.any?
    assert_not @other_user.friend_requests_received.pending.any?
    assert @other_user.friend_requests_received.any?
    assert_no_difference -> { @user.friend_requests_sent.count } do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: @other_user.id
        }
      }
    end
  end

  test 'should create a friend request with ajax' do
    sign_in @user
    assert_difference -> { @user.friend_requests_sent.count } do
      post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    end
  end

  ##################
  #     update     #
  ##################
  test 'should redirect update when not logged in' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    patch friend_request_path(friend_request), params: {
      friend_request: {
        status: FriendRequest.statuses[:accepted]
      }
    }
    assert_redirected_to new_user_session_path
  end

  test 'should throw error on update-accept when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    assert_raises Pundit::NotAuthorizedError do
      patch friend_request_path(friend_request), params: {
        friend_request: {
          status: FriendRequest.statuses[:accepted]
        }
      }
    end
  end

  test 'should redirect update-decline when not logged in' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    patch friend_request_path(friend_request), params: {
      friend_request: {
        status: FriendRequest.statuses[:declined]
      }
    }
    assert_redirected_to new_user_session_path
  end

  test 'should throw error on decline when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    assert_raises Pundit::NotAuthorizedError do
      patch friend_request_path(friend_request), params: {
        friend_request: {
          status: FriendRequest.statuses[:declined]
        }
      }
    end
  end

  test 'should accept with ajax' do
    sign_in @user
    assert_not @user.friends.include?(@other_user)
    friend_request = @other_user.friend_requests_sent
                                .create!(receiver: @user, status: FriendRequest.statuses[:pending])

    patch friend_request_path(friend_request), xhr: true, params: {
      friend_request: {
        status: FriendRequest.statuses[:accepted]
      }
    }
    friend_request.reload
    assert_equal friend_request.status, FriendRequest.statuses[:accepted]
    assert @user.friends.include?(@other_user)
  end

  test 'should decline with ajax' do
    sign_in @user
    friend_request = @other_user.friend_requests_sent.create!(receiver: @user,
                                                              status: FriendRequest.statuses[:pending])
    patch friend_request_path(friend_request), xhr: true, params: {
      friend_request: {
        status: FriendRequest.statuses[:declined]
      }
    }
    friend_request.reload
    assert_equal friend_request.status, FriendRequest.statuses[:declined]
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
  end

  test 'should not destroy when user not authorized' do
    sign_in @user
    post friend_requests_path, params: { friend_request: { receiver_id: @other_user.id } }
    friend_request = assigns(:friend_request)
    sign_out @user
    sign_in @other_user
    assert_no_difference 'FriendRequest.count' do
      assert_raises Pundit::NotAuthorizedError do
        delete friend_request_path(friend_request)
      end
    end
    assert_redirected_to root_path
  end

  test 'should destroy with ajax' do
    sign_in @user
    friend_request = @user.friend_requests_sent.create!(receiver: @other_user, status: FriendRequest.statuses[:pending])
    assert @other_user.friend_requests_received.include?(friend_request)
    assert_difference -> { @user.friend_requests_sent.count }, -1 do
      delete friend_request_path(friend_request), xhr: true
    end
  end
end
