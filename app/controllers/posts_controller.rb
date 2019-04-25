class PostsController < ApplicationController
  before_action :set_post, only: [:destroy]
  before_action :require_authorized_user, only: [:destroy]

  def index
    @posts = current_user.feed
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Successfuly created a post"
      redirect_back fallback_location: root_path
    else
      flash[:error] = "Invalid parameters"
      render "new"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Successfuly deleted a post"
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def require_authorized_user
    unless @post.user == current_user
      flash[:danger] = "You are not authorized to delete this post"
      redirect_to posts_path
    end
  end
end
