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
  test 'should get new' do
    sign_in @user
    get new_post_path
    assert_template "posts/new"
  end

  test 'should redirect new if not logged in' do
    get new_post_path
    assert_redirected_to new_user_session_path
  end

   ##########
   # create #
   ##########
  test 'should redirect create if not logged in' do
    post posts_path, params: { content: @post.content }
    assert_redirected_to new_user_session_path
  end

  test 'create should render new page with flash message when given parameter is not valid' do
    sign_in @user
    post posts_path, params: { post: { content: '' } }
    invalid_post = assigns(:post)
    assert_template 'posts/new'
    assert flash.any?
    assert invalid_post.errors.any?
    assert_not_nil invalid_post.errors[:content].nil?
    assert_not_nil invalid_post.errors[:user].nil?
  end

  test 'should create post when given parameter is valid' do
    sign_in @user
    assert_difference 'Post.count' do
      post posts_path, params: {
        post: { content: @post.content } },
        headers: { "HTTP_REFERER" => posts_url }
    end
    assert_redirected_to posts_path
    follow_redirect!
    assert flash.any?
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
    assert_redirected_to posts_path
    assert flash.any?
  end

  test 'should redirect destroy when current user is not authorized to delete' do
    sign_in @user
    other_user = users(:two)
    assert_no_difference 'Post.count', -1 do
      delete post_path(other_user.posts.first)
    end
    assert_redirected_to posts_path
    follow_redirect!
    assert flash.any?
  end

end
