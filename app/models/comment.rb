# frozen_string_literal: true

class Comment < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { maximum: 150 }

  after_create -> { Notifications::CreateService.call(self) }

  def notifier_ids
    post.comments.pluck(:user_id).reject { |id| id == user.id }.uniq
  end
end
