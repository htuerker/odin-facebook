require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(first_name: "User", last_name: "User", email: "one@mail.com", password: "password")
    @other_user = User.create!(first_name: "Other", last_name: "User", email: "other_user@mail.com", password: "password")
  end

  test 'profile page as owner' do
    sign_in @user
    get user_path(@user.id)
    assert_template 'users/show'
    # User info
    assert_match "#{@user.email}", response.body
    assert_match "#{@user.first_name.capitalize} #{@user.last_name.capitalize}", response.body
    assert_select "img[class=?]", "gravatar"
    assert_select "a[href=?]", me_edit_path
    # New post form
    assert_select "form[id=?]", "new_post"
    # User's sharings
    assert_select "div[class=?]", "card-body", count: @user.posts.count
  end
end
