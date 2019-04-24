class FriendshipsController < ApplicationController

  def destroy
    debugger
    @friendships = Friendship.where("user1_id = ? AND user2_id = ?", current_user.id, params[:user].id)
      .or(Friendship.where("user1_id = ? AND user2_id = ?", params[:user].id, current_user.id))
  end
end
