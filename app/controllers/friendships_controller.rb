class FriendshipsController < ApplicationController
  def destroy
    if user = User.find_by(id: params[:user_id])
      flash[:success] = "Succesfuly destroyed friendship"
      current_user.destroy_friendship(user)
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_back(fallback_location: root_path)
  end
end
