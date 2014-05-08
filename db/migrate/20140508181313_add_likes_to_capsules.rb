class AddLikesToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :likes, :hstore
  end
end
