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

ActiveRecord::Schema[8.0].define(version: 2026_07_29_000013) do
  create_table "amenities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.string "icon", default: "?️"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_amenities_on_tenant_id"
  end

  create_table "audit_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "user_id"
    t.string "action", null: false
    t.string "record_type", null: false
    t.bigint "record_id"
    t.text "payload"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.index ["tenant_id", "created_at"], name: "index_audit_logs_on_tenant_id_and_created_at"
  end

  create_table "contracts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "room_id", null: false
    t.bigint "renter_id"
    t.string "contract_code", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.decimal "monthly_rent", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "deposit_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_code"], name: "index_contracts_on_contract_code", unique: true
    t.index ["discarded_at"], name: "index_contracts_on_discarded_at"
    t.index ["renter_id"], name: "index_contracts_on_renter_id"
    t.index ["room_id"], name: "index_contracts_on_room_id"
    t.index ["tenant_id"], name: "index_contracts_on_tenant_id"
  end

  create_table "maintenance_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "room_id", null: false
    t.bigint "renter_id"
    t.string "title", null: false
    t.text "description"
    t.integer "priority", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.decimal "cost", precision: 12, scale: 2, default: "0.0"
    t.datetime "resolved_at"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_maintenance_requests_on_discarded_at"
    t.index ["room_id"], name: "fk_rails_ef1e4af497"
    t.index ["tenant_id", "status"], name: "index_maintenance_requests_on_tenant_id_and_status"
  end

  create_table "monthly_bills", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "room_id", null: false
    t.bigint "contract_id"
    t.string "bill_code", null: false
    t.string "billing_month", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.date "due_date"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "room_fee", precision: 12, scale: 2, default: "0.0"
    t.decimal "utility_fee", precision: 12, scale: 2, default: "0.0"
    t.decimal "service_fee", precision: 12, scale: 2, default: "0.0"
    t.datetime "paid_at"
    t.string "bank_code", default: "MB"
    t.string "bank_account", default: "0901234567"
    t.string "bank_account_name", default: "RENTOPS DEMO"
    t.index ["bill_code"], name: "index_monthly_bills_on_bill_code", unique: true
    t.index ["billing_month"], name: "index_monthly_bills_on_billing_month"
    t.index ["contract_id"], name: "index_monthly_bills_on_contract_id"
    t.index ["discarded_at"], name: "index_monthly_bills_on_discarded_at"
    t.index ["room_id"], name: "index_monthly_bills_on_room_id"
    t.index ["tenant_id"], name: "index_monthly_bills_on_tenant_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "recipient_name", null: false
    t.string "recipient_phone"
    t.string "channel", default: "zns", null: false
    t.text "content", null: false
    t.integer "status", default: 1, null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "created_at"], name: "index_notifications_on_tenant_id_and_created_at"
  end

  create_table "operating_expenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "property_id"
    t.string "title", null: false
    t.string "category", default: "sửa chữa", null: false
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.date "expense_date", null: false
    t.text "note"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_operating_expenses_on_discarded_at"
    t.index ["property_id"], name: "fk_rails_29e7b9c1c1"
    t.index ["tenant_id", "expense_date"], name: "index_operating_expenses_on_tenant_id_and_expense_date"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "max_rooms", default: 10, null: false
    t.decimal "monthly_price", precision: 12, scale: 2, default: "0.0", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_plans_on_discarded_at"
  end

  create_table "properties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.string "address"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_properties_on_discarded_at"
    t.index ["tenant_id"], name: "index_properties_on_tenant_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "property_name", null: false
    t.string "room_number", null: false
    t.decimal "price", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_id"
    t.integer "floor", default: 1
    t.decimal "area", precision: 8, scale: 2, default: "20.0"
    t.index ["discarded_at"], name: "index_rooms_on_discarded_at"
    t.index ["property_id"], name: "index_rooms_on_property_id"
    t.index ["tenant_id", "status"], name: "index_rooms_on_tenant_id_and_status"
    t.index ["tenant_id"], name: "index_rooms_on_tenant_id"
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.string "unit_name", default: "tháng", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_services_on_discarded_at"
    t.index ["tenant_id"], name: "index_services_on_tenant_id"
  end

  create_table "tenants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.string "phone"
    t.string "status", default: "active", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_code", default: "MB"
    t.string "bank_account", default: "0901234567"
    t.string "bank_account_name", default: "RENTOPS DEMO"
    t.bigint "plan_id"
    t.index ["discarded_at"], name: "index_tenants_on_discarded_at"
    t.index ["plan_id"], name: "index_tenants_on_plan_id"
    t.index ["subdomain"], name: "index_tenants_on_subdomain", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "email", null: false
    t.string "full_name", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "id_card_number"
    t.string "hometown"
    t.integer "role", default: 1, null: false
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "utility_readings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "room_id", null: false
    t.string "billing_month", null: false
    t.integer "electric_old", default: 0, null: false
    t.integer "electric_new", default: 0, null: false
    t.integer "water_old", default: 0, null: false
    t.integer "water_new", default: 0, null: false
    t.string "image_url"
    t.text "note"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_utility_readings_on_discarded_at"
    t.index ["room_id"], name: "fk_rails_1aa99be56e"
    t.index ["tenant_id", "room_id", "billing_month"], name: "idx_utility_readings_tenant_room_month"
  end

  add_foreign_key "amenities", "tenants"
  add_foreign_key "audit_logs", "tenants"
  add_foreign_key "contracts", "rooms"
  add_foreign_key "contracts", "tenants"
  add_foreign_key "contracts", "users", column: "renter_id"
  add_foreign_key "maintenance_requests", "rooms"
  add_foreign_key "maintenance_requests", "tenants"
  add_foreign_key "monthly_bills", "contracts"
  add_foreign_key "monthly_bills", "rooms"
  add_foreign_key "monthly_bills", "tenants"
  add_foreign_key "notifications", "tenants"
  add_foreign_key "operating_expenses", "properties"
  add_foreign_key "operating_expenses", "tenants"
  add_foreign_key "properties", "tenants"
  add_foreign_key "services", "tenants"
  add_foreign_key "tenants", "plans"
  add_foreign_key "users", "tenants"
  add_foreign_key "utility_readings", "rooms"
  add_foreign_key "utility_readings", "tenants"
end
