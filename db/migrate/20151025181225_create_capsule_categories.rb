class CreateCapsuleCategories < ActiveRecord::Migration
  def change
    create_table :capsule_categories do |t|
      t.references :capsule, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
