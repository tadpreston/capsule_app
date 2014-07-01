class AddMottoAndBackgroundImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :motto, :string
    add_column :users, :background_image, :string
  end
end
