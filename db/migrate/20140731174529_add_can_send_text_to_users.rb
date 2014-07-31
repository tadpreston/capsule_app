class AddCanSendTextToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_send_text, :boolean
  end
end
