class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    enable_extension "uuid-ossp"

    create_table :users do |t|
      t.uuid      :public_id, default: "uuid_generate_v4()"
      t.string    :email
      t.string    :username
      t.string    :first_name
      t.string    :last_name
      t.string    :phone_number
      t.string    :password_digest
      t.string    :location
      t.string    :provider
      t.string    :uid
      t.datetime  :authorized_at
      t.hstore    :settings
      t.string    :locale
      t.string    :time_zone
      t.hstore    :oauth

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username
    add_index :users, :public_id, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
