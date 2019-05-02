require 'test_helper'

class EditProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(first_name: "Burhan", last_name: "Tuerker",
                         email: "burhan.tuerker@gmail.com",
                         password: "password")
  end

  test 'edit profile page' do
    sign_in @user
    get me_edit_path
    assert_template 'devise/registrations/edit'
    # initially first_name last_name and email should be filled by current state,
    # password fields should be empty
    assert_select 'input[name=?]', "user[first_name]",            { value: @user.first_name, count: 1}
    assert_select 'input[name=?]', "user[last_name]",             { value: @user.last_name,  count: 1}
    assert_select 'input[name=?]', "user[email]",                 { value: @user.email,      count: 1}
    assert_select 'input[name=?]', "user[password]",              { value: "",               count: 1}
    assert_select 'input[name=?]', "user[password_confirmation]", { value: "",               count: 1}
    assert_select 'input[name=?]', "user[current_password]",      { value: "",               count: 1}
    # there would be 2 submit buttons, one for update, other one for cancel account
    assert_select 'input[type=?]', "submit", count: 2
    # there would be 2 form with same action user_registration
    # but one using put method, other one using delete
    assert_select 'form[action=?]', user_registration_path, count: 2
    assert_select 'input[value=?]', "put",    { name: "_method", count: 1 }
    assert_select 'input[value=?]', "delete", { name: "_method", count: 1 }
  end

  test 'after invalid submit' do
    sign_in @user
    get me_edit_path
    assert_template 'devise/registrations/edit'
    patch user_registration_path, params: {
      user: {
        first_name: "",
        last_name: "",
        email: "" ,
        password: "",
        password_confirmation: "",
        current_password: ""
      }
    }
    # only current password and email are required
    assert assigns(:user).errors.any?
    assert assigns(:user).errors[:email].any?
    assert assigns(:user).errors[:current_password].any?
    # fields with errors count would be double errors size, cause fields have labels as well
    assert_select "div[class=?]", "field_with_errors",  assigns(:user).errors.keys.size * 2
    assert_select "small[class=?]", "text-danger", count: assigns(:user).errors.full_messages.size
  end

  test 'after valid submit' do
    sign_in @user
    get me_edit_path
    assert_template 'devise/registrations/edit'
    patch user_registration_path, params: {
      user: {
        first_name: "updated",
        last_name: "updated",
        email: "updated@updated.com" ,
        password: "updated",
        password_confirmation: "updated",
        current_password: "password"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_equal flash[:notice], I18n.translate('devise.registrations.updated')
    @user.reload
    assert_equal @user.first_name, "updated"
    assert_equal @user.last_name,  "updated"
    assert_equal @user.email,      "updated@updated.com"
    sign_out @user

    # password changed
    get new_user_session_path
    assert_template "devise/sessions/new"
    assert_not flash.any?
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password"
      }
    }
    assert_equal flash[:alert], I18n.translate("devise.failure.invalid", authentication_keys: "Email")
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "updated"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_equal flash[:notice], I18n.translate("devise.sessions.signed_in")
  end
end
