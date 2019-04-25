class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created"
      redirect_to @comment.post
    else
      flash[:error] = "Some error occured"
      redirect_to root_path
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = "Comment removed"
      redirect_to root_path
    else
      flash[:error] = "Some error occured"
      redirect_to root_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
