class CreateCapsuleWatches < ActiveRecord::Migration
  def change
    create_table :capsule_watches do |t|
      t.references :user, index: true
      t.references :capsule, index: true

      t.timestamps
    end
  end
end
