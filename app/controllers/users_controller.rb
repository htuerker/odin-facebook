class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:me, :edit, :friends]

  def index
    friends               = current_user.friends.ids
    sent_request_to       = current_user.friend_requests_sent.pending.pluck(:receiver_id)
    received_request_from = current_user.friend_requests_received.pending.pluck(:sender_id)
    @users = User.all
      .where.not("id IN (?)", friends + [current_user.id] + sent_request_to + received_request_from)
  end

  def me
  end


  def show
    render 'me' if @user == current_user
  end

  def friends
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end
end
