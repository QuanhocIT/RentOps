class CreateMonthlyBills < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_bills do |t|
      t.bigint :tenant_id, null: false
      t.bigint :room_id, null: false
      t.bigint :contract_id
      t.string :bill_code, null: false
      t.string :billing_month, null: false
      t.integer :status, default: 0, null: false
      t.decimal :total_amount, precision: 12, scale: 2, default: 0, null: false
      t.date :due_date
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :monthly_bills, :tenant_id
    add_index :monthly_bills, :room_id
    add_index :monthly_bills, :contract_id
    add_index :monthly_bills, :bill_code, unique: true
    add_index :monthly_bills, :billing_month
    add_index :monthly_bills, :discarded_at
    add_foreign_key :monthly_bills, :tenants
    add_foreign_key :monthly_bills, :rooms
    add_foreign_key :monthly_bills, :contracts
  end
end
