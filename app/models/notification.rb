class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :actor, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates_inclusion_of :read_status, in: [true, false]

  default_scope -> { order(created_at: :desc) }
  scope :without_friend_requests, -> { where.not(subject_type: 'FriendRequest') }
  scope :only_friend_requests, -> { where(subject_type: 'FriendRequest') }
  scope :not_seen, -> { where(read_status: false ) }
end
