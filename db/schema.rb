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

ActiveRecord::Schema.define(version: 2019_10_29_072505) do

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

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.integer "quantity", default: 0, null: false
    t.string "image_url", default: "https://i.imgur.com/eYl9RO4.png", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", null: false
    t.float "cost"
    t.index ["category"], name: "index_products_on_category"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "purchased_products", force: :cascade do |t|
    t.uuid "transaction_id"
    t.uuid "product_id"
    t.integer "quantity", default: 1, null: false
    t.index ["product_id"], name: "index_purchased_products_on_product_id"
    t.index ["transaction_id"], name: "index_purchased_products_on_transaction_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.integer "genre", default: 0, null: false
    t.integer "state"
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "transfer_details", force: :cascade do |t|
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
    t.string "messenger_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "owner_id"
end
