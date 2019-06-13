class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:destroy]

  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends
  end

  def create
    @friendship = current_user.direct_friendships.build(friendship_params)
    if @friendship.save
      flash[:success] = 'You established a friendship!'
    else
      flash[:danger] = 'Something went wrong!'
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    authorize @friendship, :destroy?
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
