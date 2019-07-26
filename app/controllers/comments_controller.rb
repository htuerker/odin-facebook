# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def index
    if @post = Post.find_by(id: params[:post_id])
      @comments = @post.comments.paginate(page: params[:comments_page], per_page: 3)
    end

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Comment successfuly created!'
    else
      flash[:danger] = 'Something went wrong!'
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    authorize @comment, :destroy?
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
