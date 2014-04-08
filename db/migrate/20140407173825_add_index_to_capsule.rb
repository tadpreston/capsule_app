class AddIndexToCapsule < ActiveRecord::Migration
  def up
    execute "CREATE INDEX capsules_location ON capsules USING GIN(location)"
    execute "CREATE INDEX capsules_title ON capsules USING GIN(to_tsvector('english',title))"
    execute "CREATE INDEX capsules_hash_tags ON capsules USING GIN(to_tsvector('english',hash_tags))"
  end

  def down
    execute "DROP INDEX capsules_location"
    execute "DROP INDEX capsules_title"
    execute "DROP INDEX capsules_has_tags"
  end
end
