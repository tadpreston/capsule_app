class AddAnotherIndexToCapsues < ActiveRecord::Migration
  def change
    add_index :capsules, [:latitude, :longitude]
  end
end
