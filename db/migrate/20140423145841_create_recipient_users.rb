class CreateRecipientUsers < ActiveRecord::Migration
  def change
    create_table :recipient_users do |t|
      t.references :user, index: true
      t.references :capsule, index: true

      t.timestamps
    end
  end
end
