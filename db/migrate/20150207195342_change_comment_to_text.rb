class ChangeCommentToText < ActiveRecord::Migration
  def change
    change_column :capsules, :comment, :text
  end
end
