class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.bigint :tenant_id, null: false
      t.string :name, null: false
      t.string :address
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :properties, :tenant_id
    add_index :properties, :discarded_at
    add_foreign_key :properties, :tenants
  end
end
