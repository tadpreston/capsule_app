class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :capsule, index: true
      t.text :message
      t.text :notification_type
      t.text :delivery_type
      t.boolean :notified

      t.timestamps
    end
  end
end
