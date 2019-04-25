require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: "New Comment Content" } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should create when parameter is valid' do
    sign_in @user
    assert_difference -> { @user.comments.count } do
      post comments_path, params: { comment: { content: "New Comment Content" } }
    end
  end
end
