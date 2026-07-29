class CreateUtilityReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :utility_readings do |t|
      t.bigint :tenant_id, null: false
      t.bigint :room_id, null: false
      t.string :billing_month, null: false # format YYYY-MM
      t.integer :electric_old, default: 0, null: false
      t.integer :electric_new, default: 0, null: false
      t.integer :water_old, default: 0, null: false
      t.integer :water_new, default: 0, null: false
      t.string :image_url
      t.text :note
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :utility_readings, [:tenant_id, :room_id, :billing_month], name: "idx_utility_readings_tenant_room_month"
    add_index :utility_readings, :discarded_at
    add_foreign_key :utility_readings, :tenants
    add_foreign_key :utility_readings, :rooms
  end
end
