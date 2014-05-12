class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :tag
      t.decimal :longitude
      t.decimal :latitude

      t.timestamps
    end
    add_index :hashtags, :tag
    add_index :hashtags, [:longitude, :latitude]
  end
end
