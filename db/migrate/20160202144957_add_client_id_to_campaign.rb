class AddClientIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :client_id, :integer
    add_column :campaigns, :client_message, :string
    add_column :campaigns, :user_message, :string
    add_column :campaigns, :image_from_client, :string
    add_column :campaigns, :image_from_user, :string
    add_column :campaigns, :image_keep, :string
    add_column :campaigns, :image_forward, :string
    add_column :campaigns, :image_expired, :string

    add_index :campaigns, :client_id
  end
end
