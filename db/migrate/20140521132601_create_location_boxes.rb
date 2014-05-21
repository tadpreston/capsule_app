class CreateLocationBoxes < ActiveRecord::Migration
  def change
    create_table :location_boxes do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :lat_median
      t.decimal :long_median
      t.hstore :capsule_store, default: { ids: [] }

      t.timestamps
    end

    add_index :location_boxes, :latitude
    add_index :location_boxes, :longitude
  end
end
