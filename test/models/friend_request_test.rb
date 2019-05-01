require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'stastus should be valid' do
    # presence
    @request = @user.friend_requests_sent.build(receiver: @other_user)
    assert_not @request.valid?
    assert @request.errors[:status].any?
    # inclusion
    @request.status = 5
    assert_not @request.valid?
    assert @request.errors[:status].any?
    @request.status = -1
    assert @request.valid?
    @request.status = 0
    assert @request.valid?
    @request.status = 1
    assert @request.valid?
  end
end
