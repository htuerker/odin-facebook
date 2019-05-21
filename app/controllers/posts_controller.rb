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
    respond_to do |format|
      if @post.save
        format.html do
          redirect_back fallback_location: root_path,
                        success: 'Successfuly created a post!'
        end
        format.js
      else
        format.html do
          redirect_back fallback_location: root_path,
                        danger: 'Something went wrong!'
        end
        format.js
      end
    end
  end

  def destroy
    authorize @post, :destroy?
    @post.destroy

    respond_to do |format|
      format.html do
        redirect_back fallback_location: root_path,
                      success: 'Successfuly removed a post!'
      end
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
