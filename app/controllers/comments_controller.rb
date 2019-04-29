class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_authorized_user, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created"
    else
      flash[:danger] = @comment.errors.full_messages.to_s
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = "Comment removed"
    else
      flash[:danger] = "Some error occured"
    end
    redirect_back fallback_location: root_path
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def require_authorized_user
    unless @comment.user == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end
end
