class FriendshipsController < ApplicationController

  def destroy
    @friendships = Friendship.find_by(user1: params[:user_1])
      .or(Friendship.find_by(user_2: params[:user_1]))
    @friendships.each { |friendship| friendship.destory }
    flash[:success] = "Succesfully removed friendship"
    redirect_back(fallback_location: root_path)
  end

  private
  def friendship_params
    params.require(:friendship).permit(:user1, :user2)
  end
end
