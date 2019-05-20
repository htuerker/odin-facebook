require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'should be valid' do
    # presence
    @request = @user.friend_requests_sent.build(receiver: @other_user)
    assert_not @request.valid?
    assert @request.errors[:status].any?
    # inclusion
    assert_raise ArgumentError do
      @request.status = "hello"
    end
    assert_not @request.valid?
    assert @request.errors[:status].any?
    @request.status = FriendRequest.statuses[:pending]
    assert @request.valid?
    @request.status = FriendRequest.statuses[:accepted]
    assert @request.valid?
    @request.status = FriendRequest.statuses[:declined]
    assert @request.valid?
    @request.status = FriendRequest.statuses[:cancelled]
    assert @request.valid?
  end
end
