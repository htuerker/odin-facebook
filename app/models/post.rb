class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 180 }
  belongs_to :user
end
