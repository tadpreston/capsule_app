class AddWatchersToCapsules < ActiveRecord::Migration
  def up
    add_column :capsules, :watchers, :integer, array: true, default: []

    CapsuleWatch.all.each do |watch|
      if capsule = watch.capsule
        say "Capsule ID - #{capsule.id}"
        capsule.update_attributes(watchers: capsule.watchers + [watch.user_id])
      end
    end
  end

  def down
    remove_column :capsules, :watchers
  end
end
