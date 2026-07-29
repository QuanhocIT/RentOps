class CreatePlansAndUpdateRenters < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :max_rooms, default: 10, null: false
      t.decimal :monthly_price, precision: 12, scale: 2, default: 0.0, null: false
      t.text :description
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :plans, :discarded_at

    add_column :tenants, :plan_id, :bigint
    add_index :tenants, :plan_id
    add_foreign_key :tenants, :plans

    add_column :users, :phone, :string
    add_column :users, :id_card_number, :string # encrypted CCCD
    add_column :users, :hometown, :string
    add_column :users, :role, :integer, default: 1, null: false # 0: super_admin, 1: owner, 2: staff, 3: renter
  end
end
