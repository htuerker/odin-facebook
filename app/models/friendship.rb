# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validate :not_self
  validate :not_friends
  validates :user_id, uniqueness: { scope: :friend_id }

  def self.find_between(user1, user2)
    Friendship.find_by(user: user1, friend: user2) || Friendship.find_by(user: user2, friend: user1)
  end

  private

  def not_self
    if user == friend
      self.errors[:not_self] << "user and friend pair can't be the same"
    end
  end

  def not_friends
    if Friendship.find_between(user, friend)
      self.errors[:not_friends] << "user and friend pair can't be already friends"
    end
  end
end
