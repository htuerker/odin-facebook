class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(friendship_params)
    if @friendship.save
      flash[:success] = "You are now friends"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      redirect_to current_user
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      flash[:success] = "You removed the user from friends"
      redirect_to current_user
    else
      flash[:error] = "Some error occured"
      redirect_to current_user
    end
  end

  private
  def friendship_params
    params.require(:friendship).permit(:user1, :user2)
  end
end
