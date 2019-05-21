require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @other_user = users(:two)
    @request = FriendRequest.new(sender: @user, receiver: @other_user, status: FriendRequest.statuses[:pending])
  end

  test 'should be valid' do
    @request.status = nil
    assert_not @request.valid?
    assert @request.errors[:status].any?
    assert_raise ArgumentError do
      @request.status = "hello"
    end
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
