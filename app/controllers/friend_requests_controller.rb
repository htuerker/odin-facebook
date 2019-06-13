# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: :destroy

  def index
    @sent_requests = current_user.sent_friend_requests
    @received_requests = current_user.received_friend_requests
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(friend_request_params)
    if @friend_request.save
      flash[:success] = 'Succesfuly liked a post!'
    else
      flash[:danger] = 'Something went wrong!'
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    # TO-DO implement nil policy
    authorize @friend_request, :destroy?
    @friend_request.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end

