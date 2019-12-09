class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :subject, polymorphic: true
      t.references :actor, references: :user
      t.references :recipient, references: :user
      t.boolean :read_status, default: false

      t.timestamps
    end
  end
end
