class AddIndexesForArrayColumnsToCapsules < ActiveRecord::Migration
  def change
    add_index :capsules, :watchers, using: 'gin'
    add_index :capsules, :readers, using: 'gin'
  end
end
