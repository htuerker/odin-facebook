class RenameColumnNamesToFriendships < ActiveRecord::Migration[5.2]
  def up
    rename_column :friendships, :user1_id, :user_id
    rename_column :friendships, :user2_id, :friend_id
  end

  def down
    rename_column :friendships,   :user_id, :user1_id
    rename_column :friendships, :friend_id, :user2_id
  end
end
