# frozen_string_literal: true

class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true

  belongs_to :user, class_name: 'User'
  belongs_to :friend, class_name: 'User'
end
