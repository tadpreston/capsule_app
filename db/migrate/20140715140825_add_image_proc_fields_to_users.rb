class AddImageProcFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_id, :string
    add_column :users, :complete, :boolean, default: false
    add_index :users, :job_id
  end
end
