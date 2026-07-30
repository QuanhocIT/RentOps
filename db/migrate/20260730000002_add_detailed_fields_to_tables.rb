class AddDetailedFieldsToTables < ActiveRecord::Migration[8.0]
  def change
    # Renters / Users
    add_column :users, :vehicle_plate, :string
    add_column :users, :emergency_contact, :string
    add_column :users, :id_card_issue_date, :date

    # Co-Tenants
    add_column :co_tenants, :vehicle_plate, :string
    add_column :co_tenants, :emergency_contact, :string
    add_column :co_tenants, :id_card_issue_date, :date

    # Maintenance Requests
    add_column :maintenance_requests, :cost_bearer, :string, default: "owner"
    add_column :maintenance_requests, :handyman_name, :string
    add_column :maintenance_requests, :handyman_phone, :string
    add_column :maintenance_requests, :photo_before_url, :string
    add_column :maintenance_requests, :photo_after_url, :string

    # Utility Readings
    add_column :utility_readings, :is_abnormal, :boolean, default: false

    # Monthly Bills
    add_column :monthly_bills, :discount_amount, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :monthly_bills, :penalty_amount, :decimal, precision: 12, scale: 2, default: 0.0
  end
end
