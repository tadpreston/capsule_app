class AddFieldsToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :thumbnail, :string
    add_column :capsules, :start_date, :datetime
  end
end
