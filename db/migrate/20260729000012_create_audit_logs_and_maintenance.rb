class CreateAuditLogsAndMaintenance < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.bigint :tenant_id, null: false
      t.bigint :user_id
      t.string :action, null: false
      t.string :record_type, null: false
      t.bigint :record_id
      t.text :payload
      t.string :ip_address
      t.datetime :created_at, null: false
    end

    add_index :audit_logs, [:tenant_id, :created_at]
    add_foreign_key :audit_logs, :tenants

    create_table :maintenance_requests do |t|
      t.bigint :tenant_id, null: false
      t.bigint :room_id, null: false
      t.bigint :renter_id
      t.string :title, null: false
      t.text :description
      t.integer :priority, default: 1, null: false # 0: low, 1: medium, 2: high, 3: urgent
      t.integer :status, default: 0, null: false # 0: pending, 1: in_progress, 2: resolved, 3: cancelled
      t.decimal :cost, precision: 12, scale: 2, default: 0.0
      t.datetime :resolved_at
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :maintenance_requests, [:tenant_id, :status]
    add_index :maintenance_requests, :discarded_at
    add_foreign_key :maintenance_requests, :tenants
    add_foreign_key :maintenance_requests, :rooms

    create_table :amenities do |t|
      t.bigint :tenant_id, null: false
      t.string :name, null: false
      t.string :icon, default: "🛋️"
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :amenities, :tenant_id
    add_foreign_key :amenities, :tenants
  end
end
