class AddSocialUsernamesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :facebook_username, :string
    add_column :users, :twitter_username, :string
    add_index :users, :facebook_username
    add_index :users, :twitter_username

    User.all.each do |user|
      if user.provider == "facebook"
        user.update_attributes(facebook_username: user.username)
      elsif user.provider == "twitter"
        user.update_attributes(twitter_username: user.username)
      end
    end
  end

  def down
    remove_index :users, :facebook_username
    remove_index :users, :twitter_username
    remove_column :users, :facebook_username
    remove_column :users, :twitter_username
  end
end
