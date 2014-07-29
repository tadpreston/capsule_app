class AddUserHashToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :creator, :hstore
  end
end
