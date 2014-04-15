class AddNewFieldsToCapsule < ActiveRecord::Migration
  def up
    execute "DROP INDEX capsules_location"
    add_column :capsules, :latitude, :numeric
    add_column :capsules, :longitude, :numeric
    add_index :capsules, :latitude
    add_index :capsules, :longitude
  end

  def down
    remove_index :capsules, :longitude
    remove_index :capsules, :latitude
    remove_column :capsules, :longitude
    remove_column :capsules, :latitude
    execute "CREATE INDEX capsules_location ON capsules USING GIN(location)"
  end
end
