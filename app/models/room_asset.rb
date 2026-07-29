class RoomAsset < ApplicationRecord
  belongs_to :room, optional: true
  belongs_to :property, optional: true

  validates :name, presence: true

  scope :by_property, ->(property_id) { where(property_id: property_id) if property_id.present? }
  scope :by_room, ->(room_id) { where(room_id: room_id) if room_id.present? }
end
