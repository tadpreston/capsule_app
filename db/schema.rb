# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140311184545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "remote_ip"
    t.string   "user_agent"
    t.string   "auth_token"
    t.datetime "auth_expires_at"
    t.datetime "last_sign_in_at"
    t.hstore   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["auth_token"], name: "index_devices_on_auth_token", unique: true, using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.uuid     "public_id",       default: "uuid_generate_v4()"
    t.string   "email"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "password_digest"
    t.string   "location"
    t.string   "provider"
    t.string   "uid"
    t.datetime "authorized_at"
    t.hstore   "settings"
    t.string   "locale"
    t.string   "time_zone"
    t.hstore   "oauth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["public_id"], name: "index_users_on_public_id", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
