class RemoveStatusFromFriendRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :friend_requests, :status
  end
end
