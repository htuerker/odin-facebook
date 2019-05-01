class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: [:accept, :decline, :destroy]
  before_action :require_authorized_receiver, only: [:accept, :decline]
  before_action :require_authorized_sender, only: [:destroy]

  def create
    @friend_request = FriendRequest.find_or_initialize_by(sender_id: current_user.id,
                                                           receiver_id: params[:friend_request][:receiver_id])
    @friend_request.status = 0
    if @friend_request.save
      flash[:success] = "Friend request sent"
    else
      flash[:danger] = "Some error occured"
    end
    redirect_back(fallback_location: root_path)
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

  def require_authorized_receiver
    unless @friend_request.receiver == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end

  def require_authorized_sender
    unless @friend_request.sender == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end

end
