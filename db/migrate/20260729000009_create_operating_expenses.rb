class CreateOperatingExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :operating_expenses do |t|
      t.bigint :tenant_id, null: false
      t.bigint :property_id
      t.string :title, null: false
      t.string :category, default: "sửa chữa", null: false # e.g. sửa chữa, điện nước chung, bảo trì, internet, khác
      t.decimal :amount, precision: 12, scale: 2, default: 0.0, null: false
      t.date :expense_date, null: false
      t.text :note
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :operating_expenses, [:tenant_id, :expense_date]
    add_index :operating_expenses, :discarded_at
    add_foreign_key :operating_expenses, :tenants
    add_foreign_key :operating_expenses, :properties
  end
end
