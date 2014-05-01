class AddPairTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pair_token, :string
    add_index :users, :pair_token
  end
end
