class AddPropertyTypeAndRoomLayoutToTables < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :property_type, :string, default: "phong_tro", null: false
    add_column :properties, :description, :text

    add_column :rooms, :room_type, :string, default: "phong_don", null: false
    add_column :rooms, :bedrooms_count, :integer, default: 1, null: false
    add_column :rooms, :living_rooms_count, :integer, default: 0, null: false
    add_column :rooms, :bathrooms_count, :integer, default: 1, null: false
    add_column :rooms, :has_balcony, :boolean, default: false, null: false

    add_index :properties, :property_type
    add_index :rooms, :room_type
  end
end
