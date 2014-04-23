class CreateContactUsers < ActiveRecord::Migration
  def change
    create_table :contact_users do |t|
      t.references :user, index: true
      t.integer :contact_id

      t.timestamps
    end
    add_index :contact_users, :contact_id
  end
end
