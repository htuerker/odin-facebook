class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]

  def create
    @like = current_user.likes.build(like_params)

    respond_to do |format|
      if @like.save
        format.html { redirect_to @like.post, success: "Liked post!"}
        format.js
      else
        format.html { redirect_back fallback_location: root_path , danger: "Something went wrong!"}
        format.js
      end
    end
  end

  def destroy
    authorize @like, :destroy?
    @like.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:post_id)
  end
end
