class AddRecipientTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recipient_token, :string
    add_index :users, :recipient_token
  end
end
