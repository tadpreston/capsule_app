class AddTutorialProgressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_progress, :integer, default: 0
  end
end
