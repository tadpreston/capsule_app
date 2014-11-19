class AddPinCommentToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :pin_comment, :string
  end
end
