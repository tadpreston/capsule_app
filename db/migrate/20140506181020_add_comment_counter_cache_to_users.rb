class AddCommentCounterCacheToUsers < ActiveRecord::Migration
  def up
    add_column :users, :comments_count, :integer, default: 0

    User.all.each { |user| User.update_counters user.id, comments_count: user.comments.count }
  end

  def down
    remove_column :users, :comments_count
  end
end
