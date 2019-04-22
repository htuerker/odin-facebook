class FriendRequestsController < ApplicationController
  def create
    @friend_request = FriendRequest.new(friend_request_params)
    if @friend_request.save
      flash[:success] = "Friend request sent"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
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
    params.require(:friend_request).permit(:sender, :receiver, :status)
  end
end
