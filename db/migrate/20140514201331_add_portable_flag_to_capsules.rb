class AddPortableFlagToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :is_portable, :boolean
  end
end
