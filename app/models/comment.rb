# frozen_string_literal: true

class Comment < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { maximum: 150 }

  after_create -> { Notifications::CreateService.call(self) }
end
