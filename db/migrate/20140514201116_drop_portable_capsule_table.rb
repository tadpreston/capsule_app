class DropPortableCapsuleTable < ActiveRecord::Migration
  def change
    drop_table :portable_capsules
  end
end
