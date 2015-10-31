class AddForwardedFlagToCapsule < ActiveRecord::Migration
  def change
    add_column :capsules, :forwarded, :boolean
  end
end
