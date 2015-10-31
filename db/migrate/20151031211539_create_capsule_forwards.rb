class CreateCapsuleForwards < ActiveRecord::Migration
  def change
    create_table :capsule_forwards do |t|
      t.references :capsule, index: true
      t.references :forward, index: true

      t.timestamps
    end
  end
end
