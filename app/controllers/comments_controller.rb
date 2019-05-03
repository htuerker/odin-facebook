class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_authorized_user, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, success: "Comment succesfully created!"}
        format.json { render json: @comment, status: :created, location: @comment }
        format.js
      else
        format.html { redirect_to @comment.post, danger: "Something went wrong!" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.post }
      format.json { render }
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

  def require_authorized_user
    unless @comment.user == current_user
      flash[:danger] = "You're not authorized"
      redirect_back(fallback_location: root_path)
    end
  end
end
