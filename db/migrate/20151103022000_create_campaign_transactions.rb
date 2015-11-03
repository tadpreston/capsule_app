class CreateCampaignTransactions < ActiveRecord::Migration
  def change
    create_table :campaign_transactions do |t|
      t.references :campaign, index: true
      t.references :capsule, index: true
      t.references :user, index: true
      t.string :order_id
      t.decimal :amount

      t.timestamps
    end
  end
end
