# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user1, references: :users
      t.references :user2, references: :users

      t.timestamps
    end

    add_index :friendships, %i[user1_id user2_id], unique: true
  end
end
