require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

  test 'should valid?' do
    assert @post.valid?
  end

  test 'should have valid user' do
    @post.user_id = ''
    assert_not @post.valid?
  end

  test 'should have valid content' do
    @post.content = ''
    assert_not @post.valid?
    @post.content = 'a' * 181
    assert_not @post.valid?
  end
end
