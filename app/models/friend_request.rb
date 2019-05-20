class FriendRequest < ApplicationRecord
  enum status: { pending: 'pending', accepted: 'accepted', declined: 'declined',
                 cancelled: 'cancelled' }

  validates :sender, presence: true
  validates :receiver, presence: true
  validates :status, presence: true
  # Refactor this method names, i.e different? friend?
  validate :sender_and_receiver_should_be_different
  validate :sender_and_receiver_should_not_be_friends

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  private

  def sender_and_receiver_should_be_different
    if sender == receiver
      self.errors.add(:sender_receiver, "sender and receiver pair should be different")
    end
  end

  def sender_and_receiver_should_not_be_friends
    if sender.friends.include?(receiver)
      self.errors.add(:sender_receiver, "sender and receiver users are already friend")
    end
  end
end
