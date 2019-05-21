class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:destroy]

  def index
    @user = User.find(params[:user_id]) || current_user
    @friends = @user.friends
  end

  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path,
                    success: "Succesfully deleted friendship" }
      format.js
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
en
