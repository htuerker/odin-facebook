# frozen_string_literal: true

class Comment < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 150 }

  belongs_to :post
  belongs_to :user
end
