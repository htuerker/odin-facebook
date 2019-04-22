class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    @like.save
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
  end

  private
  def like_params
    params.require(:like).permit(:user_id, :post_id)
  end
end
