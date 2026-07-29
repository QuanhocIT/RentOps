class AddFieldsToRoomsAndBills < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :property_id, :bigint
    add_column :rooms, :floor, :integer, default: 1
    add_column :rooms, :area, :decimal, precision: 8, scale: 2, default: 20.0
    add_index :rooms, :property_id

    add_column :monthly_bills, :room_fee, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :monthly_bills, :utility_fee, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :monthly_bills, :service_fee, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :monthly_bills, :paid_at, :datetime
    add_column :monthly_bills, :bank_code, :string, default: "MB"
    add_column :monthly_bills, :bank_account, :string, default: "0901234567"
    add_column :monthly_bills, :bank_account_name, :string, default: "RENTOPS DEMO"

    add_column :tenants, :bank_code, :string, default: "MB"
    add_column :tenants, :bank_account, :string, default: "0901234567"
    add_column :tenants, :bank_account_name, :string, default: "RENTOPS DEMO"
  end
end
