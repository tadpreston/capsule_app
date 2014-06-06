class ChangeIndexesForHashtag < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION pg_trgm;"
    execute "CREATE EXTENSION fuzzystrmatch"

    execute "CREATE INDEX hashtags_tag ON hashtags USING GIN(to_tsvector('english',tag))"
    remove_index :hashtags, [:longitude, :latitude]
    remove_index :hashtags, :tag
    add_index :hashtags, :longitude
    add_index :hashtags, :latitude
  end

  def down
    remove_index :hashtags, :latitude
    remove_index :hashtags, :longitude
    add_index :hashtags, :tag
    add_index :hashtags, [:longitude, :latitude]
    execute "DROP INDEX hashtags_tag"

    execute "DROP EXTENSION fuzzystrmatch"
    execute "DROP EXTENSION pg_trgm;"
  end
end
