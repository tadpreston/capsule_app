class RemoveWatchedFromCapsules < ActiveRecord::Migration
  def change
    remove_column :capsules, :watched, :boolean
  end
end
