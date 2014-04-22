class AddSearchIndexToCapsules < ActiveRecord::Migration
  def up
    execute "CREATE INDEX capsules_hash_tags ON capsules USING gin(to_tsvector('english', hash_tags))"
  end

  def down
    execute "DROP INDEX capsules_hash_tags"
  end
end
