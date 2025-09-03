# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_03_123150) do
  create_table "account_deletions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "user_email"
    t.string "reason"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_settings", charset: "utf8mb3", force: :cascade do |t|
    t.integer "role"
    t.bigint "user_id", null: false
    t.json "permissions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admin_settings_on_user_id"
  end

  create_table "admin_settings_user_roles", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "role"
    t.json "permissions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", charset: "utf8mb3", force: :cascade do |t|
    t.string "subject"
    t.string "franchise_name"
    t.string "status", default: "Pending"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_conversations_on_created_by_id"
  end

  create_table "documents", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "file_type"
    t.string "file_key"
    t.string "file_url"
    t.string "uploaded_by"
    t.datetime "uploaded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "franchise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_favorites_on_franchise_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "franchise_details", charset: "utf8mb3", force: :cascade do |t|
    t.string "investment"
    t.string "breakeven"
    t.string "area"
    t.string "roi"
    t.string "locations"
    t.string "year"
    t.text "about"
    t.string "origin"
    t.text "support"
    t.text "available"
    t.text "requirements"
    t.text "who_we_look_for"
    t.json "training"
    t.bigint "franchise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_franchise_details_on_franchise_id"
  end

  create_table "franchise_reviews", charset: "utf8mb3", force: :cascade do |t|
    t.string "user_name"
    t.integer "rating"
    t.text "comment"
    t.date "date"
    t.string "status"
    t.bigint "franchise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_franchise_reviews_on_franchise_id"
  end

  create_table "franchises", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "location"
    t.string "owner"
    t.bigint "contact"
    t.text "description"
    t.string "email", default: "", null: false
    t.string "industry"
    t.decimal "investment_level", precision: 10
    t.string "city"
    t.integer "status", default: 1, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_franchises_on_user_id"
  end

  create_table "messages", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "subject"
    t.text "content", null: false
    t.boolean "is_contact_query", default: false
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "conversation_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "news", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "date"
    t.string "image"
    t.json "paragraphs"
    t.json "listItems"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.datetime "scheduled_at"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", charset: "utf8mb3", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "user_name"
    t.string "country"
    t.string "phone"
    t.string "email"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "staffs", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "franchise_id", null: false
    t.bigint "user_id", null: false
    t.json "permissions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_staffs_on_franchise_id"
    t.index ["user_id"], name: "index_staffs_on_user_id"
  end

  create_table "templates", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_otp"
    t.datetime "reset_password_otp_sent_at"
    t.integer "role", default: 2, null: false
    t.integer "franchise_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", charset: "utf8mb3", force: :cascade do |t|
    t.string "file_key"
    t.bigint "franchise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_videos_on_franchise_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_settings", "users"
  add_foreign_key "conversations", "users", column: "created_by_id"
  add_foreign_key "favorites", "franchises"
  add_foreign_key "favorites", "users"
  add_foreign_key "franchise_details", "franchises"
  add_foreign_key "franchise_reviews", "franchises"
  add_foreign_key "franchises", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "staffs", "franchises"
  add_foreign_key "staffs", "users"
  add_foreign_key "videos", "franchises"
end
