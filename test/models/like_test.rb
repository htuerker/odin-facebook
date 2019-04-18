require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @like = likes(:one)
  end

  test 'should valid?' do
    assert @like.valid?
  end

  test 'should have user_id' do
    @like.user_id = ''
    assert_not @like.valid?
  end

  test 'should have post_id' do
    @like.post_id = ''
    assert_not @like.valid?
  end
end
