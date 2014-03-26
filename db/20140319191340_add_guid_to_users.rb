class AddGuidToUsers < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION "uuid-ossp"'

    execute "ALTER TABLE users ADD COLUMN public_id uuid NOT NULL DEFAULT uuid_generate_v4()"
    add_index :users, :public_id, name: "index_objects_on_public_id", unique: true
  end

  def down
    remove_index :users, name: :index_objects_on_public_id
    execute "ALTER TABLE users DROP COLUMN public_id"
    execute 'DROP EXTENSION "uuid-ossp"'
  end
end
