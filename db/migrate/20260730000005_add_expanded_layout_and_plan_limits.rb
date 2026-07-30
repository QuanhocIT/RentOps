class AddExpandedLayoutAndPlanLimits < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :kitchens_count, :integer, default: 1, null: false unless column_exists?(:rooms, :kitchens_count)
    add_column :rooms, :is_mezzanine, :boolean, default: false, null: false unless column_exists?(:rooms, :is_mezzanine)
    add_column :rooms, :furnished_status, :string, default: "co_ban", null: false unless column_exists?(:rooms, :furnished_status)

    add_column :plans, :max_properties, :integer, default: 5, null: false unless column_exists?(:plans, :max_properties)
    add_column :plans, :allow_multi_bedroom, :boolean, default: true, null: false unless column_exists?(:plans, :allow_multi_bedroom)
  end
end
