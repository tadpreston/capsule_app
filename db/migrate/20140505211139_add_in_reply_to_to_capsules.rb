class AddInReplyToToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :in_reply_to, :integer
    add_index :capsules, :in_reply_to
  end
end
