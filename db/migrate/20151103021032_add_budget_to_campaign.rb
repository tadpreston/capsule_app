class AddBudgetToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :budget, :decimal
    add_column :campaigns, :base_url, :string
  end
end
