# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
  end

  test 'should valid?' do
    assert @comment.valid?
  end

  test 'should have valid content' do
    @comment.content = ''
    assert_not @comment.valid?
    @comment.content = 'a' * 151
    assert_not @comment.valid?
  end
end
