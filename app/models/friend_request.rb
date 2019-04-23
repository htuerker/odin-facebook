class FriendRequest < ApplicationRecord
  scope :pending, -> { where(status: 0) }

  validates :sender, presence: true
  validates :receiver, presence: true
  validate :sender_and_receiver_should_be_different

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  private

  def sender_and_receiver_should_be_different
    if sender == receiver
      self.errors.add(:sender_receiver, "sender and receiver pair should be different")
    end
  end
end
