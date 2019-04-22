require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers

  test "should redirect if not logged in" do
    get "/posts"
    unless user_signed_in?
      assert_redirect_to new_user_session_path      
    end
  end
end
