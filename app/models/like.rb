# frozen_string_literal: true

class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :post_id }

  belongs_to :user
  belongs_to :post

  after_create -> { Notifications::CreateService.call(self) }
end
