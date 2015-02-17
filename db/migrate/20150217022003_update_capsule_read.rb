class UpdateCapsuleRead < ActiveRecord::Migration
  def change
    rename_column :capsules, :readers, :read_array
  end
end
