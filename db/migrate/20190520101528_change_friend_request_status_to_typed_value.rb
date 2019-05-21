# frozen_string_literal: true

class ChangeFriendRequestStatusToTypedValue < ActiveRecord::Migration[5.2]
  def up
    remove_column :friend_requests, :status
    execute <<-SQL
      CREATE TYPE friend_request_status AS ENUM ('pending', 'accepted', 'declined', 'cancelled');
    SQL
    add_column :friend_requests, :status, :friend_request_status
  end

  def down
    remove_column :friend_requests, :status
    execute <<-SQL
      DROP TYPE friend_request_status;
    SQL
    add_column :friend_requests, :status, :integer
  end
end
