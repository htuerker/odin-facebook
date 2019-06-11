# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validate :not_self
  validate :not_friends

  def self.find_between(user1, user2)
    Friendship.find_by(user: user1, friend: user2) || Friendship.find_by(user: user2, friend: user1)
  end

  private

  def not_self
    if user == friend
      self.errors[:not_self] << "cannot create friendship by yourself"
    end
  end

  def not_friends
    if Friendship.find_between(user, friend)
      self.errors[:not_friends] << "cannot create friendship while you're already friends"
    end
  end
end
