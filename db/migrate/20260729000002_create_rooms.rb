class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.bigint :tenant_id, null: false
      t.string :property_name, null: false
      t.string :room_number, null: false
      t.decimal :price, precision: 12, scale: 2, default: 0.0, null: false
      t.integer :status, default: 0, null: false # 0: vacant (trống), 1: occupied (đang ở), 2: reserved (cọc)
      t.datetime :discarded_at

      t.timestamps
    end

    # Composite Index for Multi-Tenant Query Optimization
    add_index :rooms, [:tenant_id, :status]
    add_index :rooms, :tenant_id
    add_index :rooms, :discarded_at
  end
end
