class AddTokenToCapsules < ActiveRecord::Migration
  def change
    add_column :capsules, :access_token, :string
    add_column :capsules, :access_token_created_at, :datetime
  end
end
