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

ActiveRecord::Schema.define(version: 20160202144957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "admin_users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

  add_index "admin_users", ["auth_token"], name: "index_admin_users_on_auth_token", using: :btree

  create_table "assets", force: true do |t|
    t.string   "media_type"
    t.string   "resource"
    t.hstore   "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_id"
    t.string   "storage_path"
    t.hstore   "process_response"
    t.boolean  "complete",         default: false
    t.integer  "assetable_id"
    t.string   "assetable_type"
  end

  add_index "assets", ["assetable_id", "assetable_type"], name: "index_assets_on_assetable_id_and_assetable_type", using: :btree
  add_index "assets", ["job_id"], name: "index_assets_on_job_id", using: :btree

  create_table "blocks", force: true do |t|
    t.integer  "user_id"
    t.integer  "blocked_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocks", ["user_id"], name: "index_blocks_on_user_id", using: :btree

  create_table "campaign_transactions", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "capsule_id"
    t.integer  "user_id"
    t.string   "order_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_transactions", ["campaign_id"], name: "index_campaign_transactions_on_campaign_id", using: :btree
  add_index "campaign_transactions", ["capsule_id"], name: "index_campaign_transactions_on_capsule_id", using: :btree
  add_index "campaign_transactions", ["user_id"], name: "index_campaign_transactions_on_user_id", using: :btree

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "budget"
    t.string   "base_url"
    t.integer  "client_id"
    t.string   "client_message"
    t.string   "user_message"
    t.string   "image_from_client"
    t.string   "image_from_user"
    t.string   "image_keep"
    t.string   "image_forward"
    t.string   "image_expired"
  end

  add_index "campaigns", ["client_id"], name: "index_campaigns_on_client_id", using: :btree

  create_table "capsule_categories", force: true do |t|
    t.integer  "capsule_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capsule_categories", ["capsule_id"], name: "index_capsule_categories_on_capsule_id", using: :btree
  add_index "capsule_categories", ["category_id"], name: "index_capsule_categories_on_category_id", using: :btree

  create_table "capsule_forwards", force: true do |t|
    t.integer  "capsule_id"
    t.integer  "forward_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "capsule_forwards", ["capsule_id"], name: "index_capsule_forwards_on_capsule_id", using: :btree
  add_index "capsule_forwards", ["forward_id"], name: "index_capsule_forwards_on_forward_id", using: :btree
  add_index "capsule_forwards", ["user_id"], name: "index_capsule_forwards_on_user_id", using: :btree

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
    t.text     "comment"
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
    t.integer  "comments_count",          default: 0
    t.hstore   "likes_store"
    t.boolean  "is_portable"
    t.string   "thumbnail"
    t.datetime "start_date"
    t.integer  "watchers",                default: [], array: true
    t.integer  "read_array",              default: [], array: true
    t.integer  "tenant_id"
    t.hstore   "creator"
    t.integer  "likes",                   default: [], array: true
    t.string   "access_token"
    t.datetime "access_token_created_at"
    t.integer  "campaign_id"
    t.boolean  "forwarded"
  end

  add_index "capsules", ["campaign_id"], name: "index_capsules_on_campaign_id", using: :btree
  add_index "capsules", ["in_reply_to"], name: "index_capsules_on_in_reply_to", using: :btree
  add_index "capsules", ["latitude", "longitude"], name: "index_capsules_on_latitude_and_longitude", using: :btree
  add_index "capsules", ["latitude"], name: "index_capsules_on_latitude", using: :btree
  add_index "capsules", ["longitude"], name: "index_capsules_on_longitude", using: :btree
  add_index "capsules", ["read_array"], name: "index_capsules_on_read_array", using: :gin
  add_index "capsules", ["relative_location"], name: "capsules_relative_location", using: :gin
  add_index "capsules", ["tenant_id"], name: "index_capsules_on_tenant_id", using: :btree
  add_index "capsules", ["user_id"], name: "index_capsules_on_user_id", using: :btree
  add_index "capsules", ["watchers"], name: "index_capsules_on_watchers", using: :gin

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_templates", force: true do |t|
    t.integer  "category_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "profile_image"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.hstore   "likes_store"
    t.integer  "comments_count",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
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

  create_table "mandrill_results", force: true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.string   "message_id"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mandrill_results", ["user_id"], name: "index_mandrill_results_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.text     "message"
    t.text     "notification_type"
    t.text     "delivery_type"
    t.boolean  "notified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["capsule_id"], name: "index_notifications_on_capsule_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "objections", force: true do |t|
    t.integer  "objectionable_id"
    t.string   "objectionable_type"
    t.integer  "user_id"
    t.text     "comment"
    t.boolean  "dmca"
    t.boolean  "criminal"
    t.integer  "admin_user_id"
    t.datetime "handled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "obscene"
  end

  add_index "objections", ["admin_user_id"], name: "index_objections_on_admin_user_id", using: :btree
  add_index "objections", ["objectionable_id", "objectionable_type"], name: "index_objections_on_objectionable_id_and_objectionable_type", using: :btree
  add_index "objections", ["user_id"], name: "index_objections_on_user_id", using: :btree

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
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "relevances", force: true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.datetime "relevant_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relevances", ["capsule_id"], name: "index_relevances_on_capsule_id", using: :btree
  add_index "relevances", ["relevant_date"], name: "index_relevances_on_relevant_date", using: :btree
  add_index "relevances", ["user_id"], name: "index_relevances_on_user_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenant_keys", force: true do |t|
    t.integer  "tenant_id"
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tenant_keys", ["tenant_id"], name: "index_tenant_keys_on_tenant_id", using: :btree
  add_index "tenant_keys", ["token"], name: "index_tenant_keys_on_token", using: :btree

  create_table "tenants", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unlocks", force: true do |t|
    t.integer  "capsule_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unlocks", ["capsule_id"], name: "index_unlocks_on_capsule_id", using: :btree
  add_index "unlocks", ["user_id"], name: "index_unlocks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.uuid     "public_id",              default: "uuid_generate_v4()"
    t.string   "email"
    t.string   "username"
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
    t.integer  "tutorial_progress",      default: 0
    t.string   "recipient_token"
    t.integer  "comments_count",         default: 0
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.string   "motto"
    t.string   "background_image"
    t.string   "job_id"
    t.boolean  "complete",               default: false
    t.integer  "following",              default: [],                   array: true
    t.integer  "watching",               default: [],                   array: true
    t.boolean  "can_send_text"
    t.string   "device_token"
    t.string   "full_name"
    t.string   "mode"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "converted_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["facebook_username"], name: "index_users_on_facebook_username", using: :btree
  add_index "users", ["following"], name: "index_users_on_following", using: :gin
  add_index "users", ["job_id"], name: "index_users_on_job_id", using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["public_id"], name: "index_users_on_public_id", unique: true, using: :btree
  add_index "users", ["recipient_token"], name: "index_users_on_recipient_token", using: :btree
  add_index "users", ["twitter_username"], name: "index_users_on_twitter_username", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
