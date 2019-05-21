# frozen_string_literal: true

require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(first_name: 'Burhan', last_name: 'Tuerker',
                         email: 'burhan.tuerker@gmail.com',
                         password: 'password')
  end

  test 'login page' do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    # header links
    assert_select 'form[action=?]', user_session_path
  end

  test 'sign in with invalid credentials' do
    get new_user_session_path
    post user_session_path, params: {
      user: {
        email: '',
        password: 'passsowrd',
        remember_me: ''
      }
    }
    assert_equal flash[:alert], I18n.translate('devise.failure.invalid', authentication_keys: 'Email')
    assert_not assigns(:user).valid?
    assert assigns(:current_user).nil?
  end

  test 'sign in with valid credentials' do
    get new_user_session_path
    assert_nil session[:session_id]
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password',
        remember_me: ''
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_not_nil session[:session_id]
    assert_template 'posts/index'
    assert_equal flash[:notice], I18n.translate('devise.sessions.signed_in')
    assert_select 'a[href=?]', destroy_user_session_path
  end

  test 'sign in with remember me' do
    get new_user_session_path
    assert_nil cookies[:remember_user_token]
    assert_nil session[:session_id]
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password',
        remember_me: '1'
      }
    }
    assert_not_nil session[:session_id]
    assert cookies[:remember_user_token].present?
  end
end
