require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.new(first_name: "Burhan", last_name: "Tuerker",
                     email: "burhan.tuerker@gmail.com",
                     password: "password")
  end

  test 'sign up page' do
    get new_user_registration_path
    assert_template 'devise/registrations/new'
    # Header links
    assert_select "a[href=?]", new_user_session_path, count: 1
    assert_select "form[action=?]", user_registration_path
    assert_select "a[href=?]", user_facebook_omniauth_authorize_path
  end

  test 'sign up with invalid object' do
    get new_user_registration_path
    assert_template 'devise/registrations/new'
    assert_not flash.any?
    post user_registration_path, params: {
      user: {
        first_name: "",
        last_name: "",
        email: "",
        password: "",
        password_confirmation: ""
      }
    }
    # each key has a label, btw there would be 2x errors fields
    assert_select "div[class=?]", "field_with_errors", count: assigns(:user).errors.keys.size * 2 + 4
    # refactor here, when I tried to read errors messages from response.body,
    # there was an issue with utf-8 encoding
    assert_select "small[class=?]", "text-danger", count: assigns(:user).errors.full_messages.size
  end

  test 'sign up with valid object' do
    get new_user_registration_path
    assert_template 'devise/registrations/new'
    assert_not flash.any?
    assert @user.valid?
    post user_registration_path, params: {
      user: {
        first_name: @user.first_name,
        last_name: @user.last_name,
        email: @user.email,
        password: @user.password,
        password_confirmation: @user.password
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'posts/index'
    assert_select "a[href=?]", destroy_user_session_path
    assert flash.any?
    assert_equal flash[:notice], I18n.translate('devise.registrations.signed_up')
  end
end
