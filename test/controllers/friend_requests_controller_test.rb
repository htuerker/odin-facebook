require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
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

end
