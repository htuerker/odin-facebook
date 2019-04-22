require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

  test 'should valid?' do
    assert @post.valid?
  end

  test 'should have valid content' do
    # presence
    @post.content = ''
    assert_not @post.valid?
    # length
    @post.content = 'a' * 181
    assert_not @post.valid?
  end

  test 'should destroy associated comments when destroyed' do
    assert_difference 'Comment.count', -(@post.comments.count) do
      @post.destroy
    end
  end

  test 'should destroy associated likes when destroyed' do
    assert_difference 'Like.count', -(@post.likes.count) do
      @post.destroy
    end
  end
end
