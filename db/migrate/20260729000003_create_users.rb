class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.bigint :tenant_id
      t.string :email, null: false
      t.string :full_name, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :tenant_id
    add_index :users, :discarded_at
    add_foreign_key :users, :tenants
  end
end
