class CreateRelevances < ActiveRecord::Migration
  def change
    create_table :relevances do |t|
      t.references :user, index: true
      t.references :capsule, index: true

      t.timestamps
    end
  end
end
