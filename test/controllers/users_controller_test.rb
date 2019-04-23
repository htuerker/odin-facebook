require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end


  test 'should send friend request to another user' do
    sign_in @user
    user_not_sent_friend_request = users(:user_0)
    assert_difference 'FriendRequest.count' do
      post friend_requests_path, params: {
        friend_request: {
          receiver_id: user_not_sent_friend_request.id,
          status: 0
        } }
    end
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


end
