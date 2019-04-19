require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @like = likes(:one)
  end

  test 'should valid?' do
    assert @like.valid?
  end
end
