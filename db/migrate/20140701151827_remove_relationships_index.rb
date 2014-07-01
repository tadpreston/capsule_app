class RemoveRelationshipsIndex < ActiveRecord::Migration
  def change
    remove_index :relationships, ["follower_id", "followed_id"]
  end
end
