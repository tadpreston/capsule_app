class CreateCapsules < ActiveRecord::Migration
  def change
    create_table :capsules do |t|
      t.references :user, index: true
      t.string :title
      t.string :hash_tags
      t.hstore :location
      t.string :status
      t.string :payload_type
      t.string :promotional_state
      t.string :passcode
      t.string :visibility

      t.timestamps
    end
  end
end
