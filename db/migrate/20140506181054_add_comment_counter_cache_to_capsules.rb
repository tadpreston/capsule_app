class AddCommentCounterCacheToCapsules < ActiveRecord::Migration
  def up
    add_column :capsules, :comments_count, :integer, default: 0

    Capsule.unscoped.all.each { |capsule| Capsule.unscoped.update_counters capsule.id, comments_count: capsule.comments.count }
  end

  def down
    remove_column :capsules, :comments_count, :integer
  end
end
