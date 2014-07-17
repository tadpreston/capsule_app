class AddFollowersAndFollowingArraysToUsers < ActiveRecord::Migration
  def up
    add_column :users, :following, :integer, array: true, default: []
    add_index :users, :following, using: 'gin'

    Relationship.all.each do |relationship|
      if follower = relationship.follower
        follower.update_attributes(following: follower.following + [relationship.followed_id])
        say "Follower ID - #{follower.id}"
      end
    end
  end

  def down
    remove_index :users, :following
    remove_column :users, :following
  end
end
