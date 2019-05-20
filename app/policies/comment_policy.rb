class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    super
    @user = user
    @comment = comment
  end

  def destroy?
    @comment.present? && @comment.persisted? && owner?
  end

  private

  def owner?
    @user && @user == @comment.user
  end
end
