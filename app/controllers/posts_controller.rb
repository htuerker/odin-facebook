# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy]

  def index
    @posts = current_user.feed.paginate(page: params[:posts_page], per_page: 10)

    respond_to do |format|
      format.html { render 'index' }
      format.js
    end
  end

  def show; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Successfuly created a post!"
    else
      flash[:danger] = "Something went wrond!"
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    authorize @post, :destroy?
    @post.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :photo)
  end
end
