class AddIsSharedBathroomToRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :is_shared_bathroom, :boolean, default: false, null: false
  end
end
