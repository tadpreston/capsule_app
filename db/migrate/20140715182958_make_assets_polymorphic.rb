class MakeAssetsPolymorphic < ActiveRecord::Migration
  def up
    add_column :assets, :assetable_id, :integer
    add_column :assets, :assetable_type, :string
    add_index :assets, [:assetable_id, :assetable_type]

    Asset.all.each { |asset| asset.update_columns(assetable_id: asset.capsule_id, assetable_type: 'Capsule') }

    remove_index :assets, :capsule_id
    remove_column :assets, :capsule_id
  end

  def down
    add_column :assets, :capsule_id, :integer
    add_index  :assets, :capsule_id

    Asset.all.each { |asset| asset.update_columns(capsule_id: asset.assetable_id) }

    remove_index :assets, [:assetable_id, :assetable_type]
    remove_column :assets, :assetable_type
    remove_column :assets, :assetable_id
  end
end
