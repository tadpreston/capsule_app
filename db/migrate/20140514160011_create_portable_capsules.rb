class CreatePortableCapsules < ActiveRecord::Migration
  def change
    create_table :portable_capsules do |t|
      t.references :user, index: true
      t.references :capsule, index: true

      t.timestamps
    end
  end
end
