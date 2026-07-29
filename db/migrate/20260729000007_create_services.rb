class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.bigint :tenant_id, null: false
      t.string :name, null: false
      t.decimal :unit_price, precision: 12, scale: 2, default: 0.0, null: false
      t.string :unit_name, default: "tháng", null: false # e.g. kWh, m3, tháng, người
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :services, :tenant_id
    add_index :services, :discarded_at
    add_foreign_key :services, :tenants
  end
end
