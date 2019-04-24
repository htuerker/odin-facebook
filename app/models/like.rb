class Like < ApplicationRecord
  validates :user, presence: true
  validates :post, presence: true

  validates :user_id, uniqueness: { scope: :post_id }

  belongs_to :user
  belongs_to :post
end
