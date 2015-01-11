class AddWatchedCapsulesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :watching, :integer, array: true, default: []

    Capsule.unscoped.all.each do |capsule|
      unless capsule.watchers.empty?
        users = User.find(capsule.watchers)
        users.each do |user|
          say "Capsule - ID #{capsule.id}"
          say "-- User ID - #{user.id}"
          user.update_columns(watching: user.watching + [capsule.id])
        end
      end
    end
  end

  def down
    remove_column :users, :watching
  end
end
