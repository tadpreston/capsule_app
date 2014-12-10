class ChangeTitleToComment < ActiveRecord::Migration
  def change
    rename_column :capsules, :title, :comment
  end
end
