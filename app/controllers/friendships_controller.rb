class FriendshipsController < ApplicationController
  def destroy
    current_user.destroy_friendship(User.find(params[:user_id]))
  end
end
