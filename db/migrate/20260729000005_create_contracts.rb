class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.bigint :tenant_id, null: false
      t.bigint :room_id, null: false
      t.bigint :renter_id
      t.string :contract_code, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.decimal :monthly_rent, precision: 12, scale: 2, default: 0, null: false
      t.decimal :deposit_amount, precision: 12, scale: 2, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :contracts, :tenant_id
    add_index :contracts, :room_id
    add_index :contracts, :renter_id
    add_index :contracts, :contract_code, unique: true
    add_index :contracts, :discarded_at
    add_foreign_key :contracts, :tenants
    add_foreign_key :contracts, :rooms
    add_foreign_key :contracts, :users, column: :renter_id
  end
end
