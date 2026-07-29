class CreateRoomAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :room_assets do |t|
      t.references :room, foreign_key: true, null: true
      t.references :property, foreign_key: true, null: true
      t.string :name, null: false
      t.string :asset_code
      t.string :category # furniture, appliance, electronics, plumbing, general
      t.string :condition, default: "good" # new, good, worn, damaged
      t.integer :quantity, default: 1
      t.decimal :purchase_price, precision: 12, scale: 2, default: 0.0
      t.date :installed_at
      t.text :notes

      t.timestamps
    end
  end
end
