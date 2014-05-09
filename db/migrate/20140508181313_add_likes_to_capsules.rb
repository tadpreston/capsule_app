class AddLikesToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :likes_store, :hstore
  end
end
