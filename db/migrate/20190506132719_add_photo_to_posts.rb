# frozen_string_literal: true

class AddPhotoToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :photo, :string
  end
end
