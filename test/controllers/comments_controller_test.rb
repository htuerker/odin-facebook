require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
    @post = @user.posts.create(content: "Post Content")
  end

  ###########
  #  create #
  ###########
  test 'should redirect create when not logged in' do
    assert_no_difference 'Comment.count' do
      post comments_path, params: {
        comment: {
          content: "New Comment Content",
          post_id: @post.id } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should create when parameter is valid' do
    sign_in @user
    assert_difference -> { @user.comments.count } do
      post comments_path, params: {
        comment: {
          content: "New Comment Content",
          post_id: @post.id } }
    end
  end

  test 'should not create when parameter is invalid' do
    sign_in @user
    assert_no_difference -> { @user.comments.count } do
      post comments_path, params: {
        comment: {
          content: "",
          post_id: ""} }
    end
    assert assigns(:comment).errors[:post].any?
    assert assigns(:comment).errors[:content].any?
  end


  ###########
  # destroy #
  ###########
  test 'should redirect destroy when not logged in' do
    delete comment_path(1)
    assert_redirected_to new_user_session_path
  end

  test 'should destroy comment when user is authorized' do
    sign_in @user
    post comments_path, params: { comment: { content: "Comment", post_id: @post.id } }
    @comment = assigns(:comment)
    assert_difference -> { @user.comments.count }, -1 do
      delete comment_path(@comment)
    end
  end

  test 'should not destroy when user is not authorized' do
    @comment = @user.comments.create(post: @post, content: "Comment")
    assert @comment.present?
    sign_in @other_user
    assert_no_difference 'Comment.count' do
      assert_raises Pundit::NotAuthorizedError do
        delete comment_path(@comment)
      end
    end
  end


  ###########
  #   XHR   #
  ###########

  test 'should create comment with ajax ' do
    sign_in @user
    assert_difference -> { @user.comments.count } do
      post comments_path, xhr: true, params: { comment: { content: "comment", post_id: @post.id } }
    end
  end

  test 'should destroy comment with ajax' do
    sign_in @user
    last_comment = @user.comments.create!(content: "comment", post: @post)
    assert_difference -> { @user.comments.count }, -1 do
      delete comment_path(last_comment), xhr: true
    end
  end

end
