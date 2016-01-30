class AddAuthTokenToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :auth_token, :string
    add_index  :admin_users, :auth_token
  end
end
