class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.bigint :tenant_id, null: false
      t.string :recipient_name, null: false
      t.string :recipient_phone
      t.string :channel, default: "zns", null: false # e.g. zns, sms, email
      t.text :content, null: false
      t.integer :status, default: 1, null: false # 0: pending, 1: sent, 2: failed
      t.datetime :sent_at

      t.timestamps
    end

    add_index :notifications, [:tenant_id, :created_at]
    add_foreign_key :notifications, :tenants
  end
end
