class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.string :phone
      t.string :status, default: "active", null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :tenants, :subdomain, unique: true
    add_index :tenants, :discarded_at
  end
end
