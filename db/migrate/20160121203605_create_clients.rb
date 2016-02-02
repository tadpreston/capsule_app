class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :user, index: true
      t.string :name
      t.string :email
      t.string :profile_image
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
