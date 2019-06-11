# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  after_initialize { self.status = FriendRequest.statuses[:pending] if self.new_record? }

  enum status: { pending: 'pending',
                 accepted: 'accepted',
                 declined: 'declined',
                 cancelled: 'cancelled'
  }

  validates :status, presence: true
  validate :not_self
  validate :not_friends

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  private

  def not_self
    if sender == receiver
      errors.add(:not_self, 'sender and receiver pair should be different')
    end
  end

  def not_friends
    if Friendship.find_between(sender, receiver)
      errors.add(:not_friends, 'sender and receiver users are already friend')
    end
  end
end
