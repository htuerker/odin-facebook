class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 180 }
  validates :user_id, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
end
