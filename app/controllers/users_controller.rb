# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show friends]

  def index
    @users = current_user.friendable_users
    @sent_friend_requests = current_user.sent_friend_requests
    @received_friend_requests = current_user.received_friend_requests
  end

  def show
    @posts = @user.posts.paginate(page: params[:posts_page], per_page: 10)
    respond_to do |format|
      format.html { render @user == current_user ? 'me' : 'show' }
      format.js
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
