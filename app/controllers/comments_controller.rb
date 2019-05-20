class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def comments_by_post
    respond_to do |format|
      if @post = Post.find_by(id: params[:post_id])
        @comments = @post.comments.paginate(page: params[:comments_page], per_page: 3)
        format.html { redirect_to @post }
        format.js
      else
        format.html { redirect_back fallback_location: root_path, danger: "Something went wrong!" }
        format.js
      end
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post,
                      success: "Comment succesfully created!" }
        format.js
      else
        format.html { redirect_back fallback_location: root_path,
                      danger: "Something went wrong!" }
        format.js
      end
    end
  end

  def destroy
    unless CommentPolicy.new(current_user, @comment).destroy?
      raise Pundit::NotAuthorizedError
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.post }
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
