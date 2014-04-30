class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :watched, :boolean, default: false
    add_column :users, :incognito, :boolean, default: false
  end
end
