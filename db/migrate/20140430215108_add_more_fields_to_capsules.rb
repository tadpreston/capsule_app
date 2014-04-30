class AddMoreFieldsToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :watched, :boolean
    add_column :capsules, :incognito, :boolean
  end
end
