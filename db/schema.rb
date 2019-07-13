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

ActiveRecord::Schema.define(version: 2019_07_13_061414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "debit", default: 0.0, null: false, comment: "借"
    t.float "credit", default: 0.0, null: false, comment: "貸"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "owner_id"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.integer "quantity", default: 0, null: false
    t.string "image_url", default: "https://i.imgur.com/eYl9RO4.png", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "purchased_products", id: false, force: :cascade do |t|
    t.uuid "transaction_id"
    t.uuid "product_id"
    t.index ["product_id"], name: "index_purchased_products_on_product_id"
    t.index ["transaction_id"], name: "index_purchased_products_on_transaction_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.integer "genre", default: 0, null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "transfer_details", id: false, force: :cascade do |t|
    t.uuid "transaction_id"
    t.float "amount", null: false
    t.uuid "receiver_id"
    t.index ["receiver_id"], name: "index_transfer_details_on_receiver_id"
    t.index ["transaction_id"], name: "index_transfer_details_on_transaction_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.integer "gender", default: 0, null: false
    t.string "nick_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "messenger_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "products", "categories"
end
