class CreateCoTenantsAndUpgradeTables < ActiveRecord::Migration[8.0]
  def change
    # 1. User authentication and optional email
    add_column :users, :password_digest, :string unless column_exists?(:users, :password_digest)
    change_column_null :users, :email, true

    # 2. Race condition fix on monthly_bills
    add_index :monthly_bills, [:tenant_id, :room_id, :billing_month], unique: true, name: "idx_monthly_bills_unique_room_month" unless index_exists?(:monthly_bills, [:tenant_id, :room_id, :billing_month], name: "idx_monthly_bills_unique_room_month")

    # 3. Partial payments support
    add_column :monthly_bills, :paid_amount, :decimal, precision: 12, scale: 2, default: 0.0 unless column_exists?(:monthly_bills, :paid_amount)
    add_column :monthly_bills, :remaining_amount, :decimal, precision: 12, scale: 2, default: 0.0 unless column_exists?(:monthly_bills, :remaining_amount)

    # 4. Meter reset flag for utility readings
    add_column :utility_readings, :meter_reset, :boolean, default: false unless column_exists?(:utility_readings, :meter_reset)

    # 5. Create CoTenants table
    unless table_exists?(:co_tenants)
      create_table :co_tenants do |t|
        t.references :contract, null: false, foreign_key: true
        t.references :user, null: true, foreign_key: true
        t.string :full_name, null: false
        t.string :phone
        t.string :id_card_number
        t.string :id_card_front_url
        t.string :id_card_back_url
        t.boolean :is_primary_renter, default: false
        t.string :temporary_residence_status, default: "pending" # pending | registered | expired

        t.timestamps
      end
    end

    # 6. Create BillItems table
    unless table_exists?(:bill_items)
      create_table :bill_items do |t|
        t.references :monthly_bill, null: false, foreign_key: true
        t.string :item_type, null: false # rent | electric | water | service | penalty | discount
        t.string :description, null: false
        t.decimal :amount, precision: 12, scale: 2, default: 0.0, null: false
        t.decimal :quantity, precision: 8, scale: 2, default: 1.0
        t.decimal :unit_price, precision: 12, scale: 2, default: 0.0

        t.timestamps
      end
    end

    # 7. Create PaymentSchedules table
    unless table_exists?(:payment_schedules)
      create_table :payment_schedules do |t|
        t.references :contract, null: false, foreign_key: true
        t.date :due_date, null: false
        t.decimal :expected_amount, precision: 12, scale: 2, default: 0.0, null: false
        t.string :status, default: "pending", null: false # pending | paid | overdue

        t.timestamps
      end
    end
  end
end
