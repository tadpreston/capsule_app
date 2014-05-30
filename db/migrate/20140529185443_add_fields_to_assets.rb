class AddFieldsToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :job_id, :string
    add_column :assets, :storage_path, :string
    add_column :assets, :process_response, :hstore
    add_column :assets, :complete, :boolean, default: false

    add_index :assets, :job_id
  end
end
