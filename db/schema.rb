# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_25_230826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "celebrities", force: :cascade do |t|
    t.text "biography", default: "", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_celebrities_on_user_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "code_iso", default: "", null: false
    t.string "currency", default: "", null: false
    t.string "country_code", default: "", null: false
    t.string "international_prefix", default: "", null: false
    t.string "region", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_iso"], name: "index_countries_on_code_iso", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "fans", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_fans_on_user_id"
  end

  create_table "message_requests", force: :cascade do |t|
    t.text "brief", default: "", null: false
    t.string "to", default: "", null: false
    t.string "from", default: "", null: false
    t.string "phone_to", default: "", null: false
    t.string "recipient_type", default: "", null: false
    t.string "reference_code", default: "", null: false
    t.string "status", default: "pending", null: false
    t.bigint "celebrity_id"
    t.bigint "fan_id"
    t.index ["celebrity_id"], name: "index_message_requests_on_celebrity_id"
    t.index ["fan_id"], name: "index_message_requests_on_fan_id"
  end

  create_table "mr_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.json "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "message_request_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_request_id", "most_recent"], name: "index_mr_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["message_request_id", "sort_key"], name: "index_mr_transitions_parent_sort", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.string "cc_holder", default: "", null: false
    t.decimal "value", precision: 10, scale: 2, default: "0.0", null: false
    t.string "email_buyer", default: "", null: false
    t.string "response_code", default: "", null: false
    t.string "payment_method_name", default: "", null: false
    t.string "transaction_id", default: "", null: false
    t.string "currency", default: "", null: false
    t.datetime "transaction_date", null: false
    t.bigint "message_request_id", null: false
    t.jsonb "response", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_request_id"], name: "index_payments_on_message_request_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "username", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.text "photo_data"
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "celebrities", "users"
  add_foreign_key "fans", "users"
  add_foreign_key "message_requests", "celebrities"
  add_foreign_key "message_requests", "fans"
  add_foreign_key "mr_transitions", "message_requests"
  add_foreign_key "payments", "message_requests"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "countries"
end
