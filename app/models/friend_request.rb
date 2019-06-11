# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  validate :not_self
  validate :not_friends

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  private

  def not_self
    if sender == receiver
      errors.add(:not_self, 'sender and receiver pair can\'t be the same')
    end
  end

  def not_friends
    if Friendship.find_between(sender, receiver)
      errors.add(:not_friends, 'sender and receiver pair can\'t be already friends')
    end
  end
end
