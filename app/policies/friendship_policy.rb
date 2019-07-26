class FriendshipPolicy < ApplicationPolicy
  attr_reader :user, :friendship

  def initialize(user, friendship)
    @user = user
    @friendship = friendship
  end

  def destroy?
    @friendship.present? && has_access?
  end

  private

  def has_access?
    @user && (@user == @friendship.user || @user == @friendship.friend)
  end
end
