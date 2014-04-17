class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :capsule, index: true
      t.string :media_type
      t.string :resource
      t.hstore :metadata

      t.timestamps
    end
  end
end
