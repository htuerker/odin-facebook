class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]
  before_action :require_authorized_user, only: [:destroy]

  def create
    @like = current_user.likes.build(like_params)
    flash[:danger] = "Some error occured" unless @like.save
    redirect_back fallback_location: root_path
  end

  def destroy
    flash[:danger] = "Some error occured" unless @like.destroy
    redirect_back fallback_location: root_path
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:post_id)
  end

  def require_authorized_user
    unless @like.user == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end
end
