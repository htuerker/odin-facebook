# frozen_string_literal: true

class FriendRequestPolicy < ApplicationPolicy
  attr_reader :user, :friend_request

  def initialize(user, friend_request)
    @user = user
    @friend_request = friend_request
  end

  def destroy?
    @friend_request.present? && @friend_request.persisted? && (sender? || receiver?)
  end

  private

  def sender?
    @user && @user == @friend_request.sender
  end

  def receiver?
    @user && @user == @friend_request.receiver
  end

  def pending?
    @friend_request.status == FriendRequest.statuses[:pending]
  end
end
