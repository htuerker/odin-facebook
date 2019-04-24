class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    flash[:danger] = "Some error occured" unless @like.save
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find(params[:id])
    flash[:danger] = "Some error occured" unless @like.destroy
    redirect_back fallback_location: root_path
  end

  private
  def like_params
    params.require(:like).permit(:user_id, :post_id)
  end
end
