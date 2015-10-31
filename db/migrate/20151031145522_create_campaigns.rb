class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :capsule, index: true
      t.string :name
      t.text :description
      t.string :code

      t.timestamps
    end
  end
end
