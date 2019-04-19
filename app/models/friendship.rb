class Friendship < ApplicationRecord
  validates :user1_id, presence: true
  validates :user2_id, presence: true

  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
end
