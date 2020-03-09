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

ActiveRecord::Schema.define(version: 2020_03_09_143148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basket_items", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "basket_id", null: false
    t.integer "amount", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["basket_id"], name: "index_basket_items_on_basket_id"
    t.index ["item_id"], name: "index_basket_items_on_item_id"
  end

  create_table "baskets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "price", default: 0.0
    t.float "emissions", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "retailer"
    t.index ["user_id"], name: "index_baskets_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "emission"
    t.string "quantity"
    t.string "retailer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "generic_name"
    t.integer "generic_quantity"
    t.string "generic_unit"
    t.string "category"
    t.string "sub_category"
    t.boolean "seasonal", default: false
    t.string "image"
    t.string "unit"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.integer "total_emissions", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wish_list_items", force: :cascade do |t|
    t.integer "amount"
    t.bigint "user_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_wish_list_items_on_item_id"
    t.index ["user_id"], name: "index_wish_list_items_on_user_id"
  end

  add_foreign_key "basket_items", "baskets"
  add_foreign_key "basket_items", "items"
  add_foreign_key "baskets", "users"
  add_foreign_key "wish_list_items", "items"
  add_foreign_key "wish_list_items", "users"
end
