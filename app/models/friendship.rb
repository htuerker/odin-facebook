class Friendship < ApplicationRecord
  validates :user1, presence: true
  validates :user2, presence: true

  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
end
