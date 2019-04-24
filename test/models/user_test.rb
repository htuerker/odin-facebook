require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  ###############
  # validations #
  ###############

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

  ###############
  #   cascade   #
  ###############

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

  test 'should destroy associated friend_requests when user destroyed which assigned as sender or receiver' do
    assert_difference 'FriendRequest.count', -(@user.friend_requests_sent.count + @user.friend_requests_received.count) do
      @user.destroy
    end
  end

  test 'should destroy associated friendships records when user destroyed which assigned as user1 or user2' do
    assert_difference 'Friendship.count', -(@user.friendships.count + @user.friendships_2.count) do
      @user.destroy
    end
  end

  ################
  #    posts     #
  ################

  test 'should create posts' do
    assert_difference -> { @user.posts.count } do
      @user.posts.create(content: "Lorem Text")
    end
  end

  test 'should destroy posts' do
    assert_difference -> { @user.posts.count }, -1 do
      @user.posts.delete(@user.posts.last)
    end
  end

  ##################
  # friend request #
  ##################

  test 'should create friend_ship request' do
    assert_difference 'FriendRequest.count' do
      @user.friend_requests_sent.create(receiver: @other_user)
    end
    assert @other_user.friend_requests_received.find_by(sender: @user).present?
  end

  test 'should establish friendship relation with some user' do
    assert_difference 'Friendship.count', 2 do
      @user.establish_friendship(@other_user)
    end
    assert @user.friends.include?(@other_user)
    assert @other_user.friends.include?(@user)
  end

  test 'should handle uniqueness exception when users are already friends' do
    @user.establish_friendship(@other_user)
    assert_no_difference 'Friendship.count' do
      @user.establish_friendship(@other_user)
    end
    assert @user.errors[:friends].any?
    assert @other_user.errors[:friends].any?
  end

  ###############
  # friendship  #
  ###############

  test 'should destroy friendship relation with one of his friends' do
    @user.establish_friendship(@other_user)
    assert_difference 'Friendship.count', -2 do
      @user.destroy_friendship(@other_user)
    end
    assert_not @user.friends.include?(@other_user)
    assert_not @other_user.friends.include?(@user)
  end

  test 'should destroy nothing if there\'s no friendship relation' do
    assert_not @user.friends.include?(@other_user)
    assert_not @other_user.friends.include?(@user)
    assert_no_difference 'Friendship.count' do
      @user.destroy_friendship(@other_user)
    end
  end

end
