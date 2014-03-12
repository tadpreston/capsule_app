class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user, index: true
      t.string :remote_ip
      t.string :user_agent
      t.string :auth_token
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :devices, :auth_token
  end
end
