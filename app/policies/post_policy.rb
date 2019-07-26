# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    super
    @user = user
    @post = post
  end

  def destroy?
    @post.present? && @post.persisted? && owner?
  end

  private

  def owner?
    @user && @user == @post.user
  end
end
