class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests_sent.build(friend_request_params)
    if @friend_request.save
      flash[:success] = "Friend request sent"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      # TO-DO change redirection, not redirect current_user, redirect it to back
      redirect_to current_user
    end
  end

  def update
    @friend_request = FriendRequest.find(params[:id])
    if @friend_request.save
      flash[:success] = "Friend request updated"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      redirect_to current_user
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    if @friend_request.save
      flash[:success] = "Friend request removed"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      redirect_to current_user
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id, :status)
  end

end
