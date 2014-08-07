class AddGinIndexOnCapsuleRelativeLocation < ActiveRecord::Migration
  def up
    execute "CREATE INDEX capsules_relative_location ON capsules USING GIN(relative_location)"
  end

  def down
    execute "DROP INDEX capsules_relative_location"
  end
end
