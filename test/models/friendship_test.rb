require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  def setup
    @friendship = friendships(:one)
  end

  test 'should valid' do
    assert @friendship.valid?
  end
end

