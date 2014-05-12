class CreateLocationWatches < ActiveRecord::Migration
  def change
    create_table :location_watches do |t|
      t.references :user, index: true
      t.decimal :longitude
      t.decimal :latitude
      t.decimal :radius

      t.timestamps
    end

    add_index :location_watches, :longitude
    add_index :location_watches, :latitude
    add_index :location_watches, [:latitude, :longitude]
    add_index :location_watches, [:longitude, :latitude]
  end
end
