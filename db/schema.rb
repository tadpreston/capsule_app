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

ActiveRecord::Schema.define(version: 20140514201331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "assets", force: true do |t|
    t.integer  "capsule_id"
    t.string   "media_type"
    t.string   "resource"
    t.hstore   "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["capsule_id"], name: "index_assets_on_capsule_id", using: :btree

  create_table "capsule_reads", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capsule_reads", ["capsule_id"], name: "index_capsule_reads_on_capsule_id", using: :btree
  add_index "capsule_reads", ["user_id"], name: "index_capsule_reads_on_user_id", using: :btree

  create_table "capsule_watches", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capsule_watches", ["capsule_id"], name: "index_capsule_watches_on_capsule_id", using: :btree
  add_index "capsule_watches", ["user_id"], name: "index_capsule_watches_on_user_id", using: :btree

  create_table "capsules", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "hash_tags"
    t.hstore   "location"
    t.string   "status"
    t.string   "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lock_question"
    t.string   "lock_answer"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.integer  "payload_type"
    t.integer  "promotional_state"
    t.hstore   "relative_location"
    t.boolean  "incognito"
    t.integer  "in_reply_to"
    t.integer  "comments_count",    default: 0
    t.hstore   "likes_store"
    t.boolean  "is_portable"
  end

  add_index "capsules", ["in_reply_to"], name: "index_capsules_on_in_reply_to", using: :btree
  add_index "capsules", ["latitude", "longitude"], name: "index_capsules_on_latitude_and_longitude", using: :btree
  add_index "capsules", ["latitude"], name: "index_capsules_on_latitude", using: :btree
  add_index "capsules", ["longitude"], name: "index_capsules_on_longitude", using: :btree
  add_index "capsules", ["user_id"], name: "index_capsules_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["capsule_id"], name: "index_comments_on_capsule_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contact_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_users", ["contact_id"], name: "index_contact_users_on_contact_id", using: :btree
  add_index "contact_users", ["user_id"], name: "index_contact_users_on_user_id", using: :btree

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

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["capsule_id"], name: "index_favorites_on_capsule_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "hashtags", force: true do |t|
    t.string   "tag"
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtags", ["longitude", "latitude"], name: "index_hashtags_on_longitude_and_latitude", using: :btree
  add_index "hashtags", ["tag"], name: "index_hashtags_on_tag", using: :btree

  create_table "location_watches", force: true do |t|
    t.integer  "user_id"
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.decimal  "radius"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_watches", ["latitude", "longitude"], name: "index_location_watches_on_latitude_and_longitude", using: :btree
  add_index "location_watches", ["latitude"], name: "index_location_watches_on_latitude", using: :btree
  add_index "location_watches", ["longitude", "latitude"], name: "index_location_watches_on_longitude_and_latitude", using: :btree
  add_index "location_watches", ["longitude"], name: "index_location_watches_on_longitude", using: :btree
  add_index "location_watches", ["user_id"], name: "index_location_watches_on_user_id", using: :btree

  create_table "recipient_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipient_users", ["capsule_id"], name: "index_recipient_users_on_capsule_id", using: :btree
  add_index "recipient_users", ["user_id"], name: "index_recipient_users_on_user_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: true do |t|
    t.uuid     "public_id",            default: "uuid_generate_v4()"
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
    t.string   "profile_image"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "tutorial_progress",    default: 0
    t.string   "recipient_token"
    t.integer  "comments_count",       default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["public_id"], name: "index_users_on_public_id", unique: true, using: :btree
  add_index "users", ["recipient_token"], name: "index_users_on_recipient_token", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
