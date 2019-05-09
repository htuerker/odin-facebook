require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @post = posts(:one)
  end

  #########
  # index #
  #########
  test 'should get index' do
    sign_in @user
    get posts_path
    assert_template 'posts/index'
  end

  test "should redirect index if not logged in" do
    get "/posts"
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'devise/sessions/new'
  end

  #########
  #  new  #
  #########

  ##########
  # create #
  ##########
  test 'should redirect create if not logged in' do
    post posts_path, params: { content: @post.content }
    assert_redirected_to new_user_session_path
  end

  test 'should create post when given parameter is valid' do
    sign_in @user
    assert_difference 'Post.count' do
      post posts_path, params: {
        post: { content: @post.content } }
    end
    assert_redirected_to root_path
    follow_redirect!
  end

  ###########
  # destroy #
  ###########
  test 'should redirect destroy when not logged in' do
    delete post_path(@post)
    assert_redirected_to new_user_session_path
  end


  test 'should delete post when current user is authorized to delete' do
    sign_in @user
    assert_difference 'Post.count', -1 do
      delete post_path(@user.posts.first)
    end
    assert_redirected_to root_path
  end

  test 'should throw unauthorized error destroy when current user is not authorized to delete' do
    sign_in @user
    other_user = users(:two)
    assert_no_difference 'Post.count', -1 do
      assert_raises Pundit::NotAuthorizedError do
        delete post_path(other_user.posts.first)
      end
    end
  end

  ###########
  #   XHR   #
  ###########

  test 'should create post with ajax ' do
    sign_in @user
    assert_difference -> { @user.posts.count } do
      post posts_path, xhr: true, params: { post: { content: @post.content } }
    end
  end
end
