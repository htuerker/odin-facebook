require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @friend_request = friend_requests(:one)
  end

  test 'should valid' do
    assert @friend_request.valid?
  end

end
