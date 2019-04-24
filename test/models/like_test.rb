require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @post = posts(:one)
    Like.create(user: @user, post: @post)
  end

  test 'should have valid user-post pair' do
    assert_no_difference 'Like.count' do
      @like = Like.create(user: @user, post: @post)
    end
  end
end
