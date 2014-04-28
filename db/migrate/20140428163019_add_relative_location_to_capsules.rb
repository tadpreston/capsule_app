class AddRelativeLocationToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :relative_location, :hstore
  end
end
