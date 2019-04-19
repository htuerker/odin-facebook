require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
  end

  test "should be valid?" do
    assert @user.valid?
  end

  test 'should have valid first_name' do
    # presence
    @user.first_name = ''
    assert_not @user.valid?
    # length
    @user.first_name = 'a' * 21
    assert_not @user.valid?
    # only letters
    @user.first_name = '1234'
    assert_not @user.valid?
  end

  test 'should have valid last_name' do
    # presence
    @user.last_name = ''
    assert_not @user.valid?
    # length
    @user.last_name = 'a' * 21
    assert_not @user.valid?
    # only letters
    @user.last_name = '1234'
    assert_not @user.valid?
  end

  test 'should destroy associated posts when user destroyed' do
    assert_difference 'Post.count', -(@user.posts.count) do
      @user.destroy
    end
  end

  test 'should destroy associated comments when user destroyed' do
    assert_difference 'Comment.count', -(@user.comments.count) do
      @user.destroy
    end
  end

  test 'should destroy associated likes when user destroyed' do
    assert_difference 'Like.count', -(@user.likes.count) do
      @user.destroy
    end
  end

  test 'should destroy associated friend_requests_sent when user destroyed' do
    assert_difference 'FriendRequest.count', -(@user.friend_requests_sent.count) do
      @user.destroy
    end
  end

  test 'should destroy associated friend_requests_received when user destroyed' do
    assert_difference 'FriendRequest.count', -(@user.friend_requests_received.count) do
      @user.destroy
    end
  end

  test 'should destroy associated friendships as marked by user_1' do
    assert_difference 'Friendship.count', -(@user.friendships.count) do
      @user.destroy
    end
  end

  test 'should destroy associated friendships as marked by user_2' do
    assert_difference 'Friendship.count', -(@user.friendships_2.count) do
      @user.destroy
    end
  end
end
