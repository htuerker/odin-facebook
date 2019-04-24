class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: [:accept, :decline, :destroy]
  before_action :authorize_receiver, only: [:accept, :decline]
  before_action :authorize_sender, only: [:destroy]

  # TO-DO remove status, create friend_request doesn't need status, for initially it should only 0(pending status)
  def create
    @friend_request = current_user.friend_requests_sent.build(friend_request_params)
    @friend_request.status = 0
    if @friend_request.save
      flash[:success] = "Friend request sent"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      # TO-DO change redirection, not redirect current_user, redirect it to back
      redirect_to current_user
    end
  end

  def accept
    if @friend_request.update(status: 1)
      @friend_request.sender.establish_friendship(@friend_request.receiver)
      flash[:succes] = "You have accepted a friendship request!"
      redirect_to me_friends_path
    else
      flash[:alert] = "There was some error occured on accepting a friend request!"
      redirect_to me_friends_path
    end
  end

  def decline
    if @friend_request.update(status: -1)
      flash[:succes] = "You have declined a friendship request!"
      redirect_to me_friends_path
    else
      flash[:alert] = "There was some error occured on declining a friend request!"
      redirect_to me_friends_path
    end
  end

  def destroy
    @friend_request.destroy
    flash[:succes] = "Successfuly deleted friend request"
    redirect_back(fallback_location: root_path)
  end


  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def authorize_receiver
    unless @friend_request.receiver == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end

  def authorize_sender
    unless @friend_request.sender == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end

end
