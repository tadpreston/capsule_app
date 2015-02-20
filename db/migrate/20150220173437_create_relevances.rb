class CreateRelevances < ActiveRecord::Migration
  def change
    create_table :relevances do |t|
      t.references :user, index: true
      t.references :capsule, index: true
      t.datetime   :relevant_date

      t.timestamps
    end

    add_index :relevances, :relevant_date
  end
end
