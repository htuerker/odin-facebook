# frozen_string_literal: true

class Friendship < ApplicationRecord
  validates :user1, presence: true
  validates :user2, presence: true

  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  def establish_friendship
    self.user1.friends.push(self.user2)
    self.user2.friends.push(self.user1)
  end

  def destroy_friendship
    self.user1.friends.delete(self.user2)
    self.user2.friends.delete(self.user1)
  end
end
