# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: %i[update destroy]

  def index
    @sent_requests = current_user.friend_requests_sent.pending
    @received_requests = current_user.friend_requests_received.pending
  end

  def create
    @friend_request = FriendRequest.find_or_initialize_by(sender_id: current_user.id,
                                                          receiver_id: params[:friend_request][:receiver_id])
    @friend_request.status = FriendRequest.statuses[:pending]
    respond_to do |format|
      if @friend_request.save
        format.html do
          redirect_back fallback_location: root_path,
                        success: 'Friend request sent succesfuly'
        end
        format.js
      else
        format.html do
          redirect_back fallback_location: root_path,
                        danger: 'Something went wrong'
        end
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if FriendRequestService.update(@friend_request, friend_request_params, current_user)
        format.html do
          redirect_back fallback_location: root_path,
                        success: 'Successfuly updated!'
        end
        format.js
      else
        format.html do
          redirect_back fallback_location: root_path,
                        danger: 'Something went wrong!'
        end
        format.js
      end
    end
  end

  def destroy
    authorize @friend_request, :destroy?
    @friend_request.destroy
    respond_to do |format|
      format.html do
        redirect_back fallback_location: root_path,
                      success: 'Friend request successfuly canceled'
      end
      format.js
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id, :status)
  end

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
