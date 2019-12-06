class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :actor, class_name: 'User'
  belongs_to :notifier, class_name: 'User'

  default_scope -> { order(created_at: :desc) }
end
