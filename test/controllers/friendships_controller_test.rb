require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'should redirect destroy when not logged in' do
    delete friendship_path(1)
    assert_redirected_to new_user_session_path
  end

  test 'should destroy present friendship' do
    sign_in @user
    @user.establish_friendship(@other_user)
    assert @user.friends.include?(@other_user)
    assert @other_user.friends.include?(@user)
    assert_difference 'Friendship.count', -2 do
      delete friendship_path(@other_user.id)
    end
    assert_not @user.friends.include?(@other_user)
    assert_not @other_user.friends.include?(@user)
  end
end
