class AddClientIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :client_id, :integer
    add_index :campaigns, :client_id
  end
end
