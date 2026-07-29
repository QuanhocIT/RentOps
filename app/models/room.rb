class Room < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant

  enum :status, { vacant: 0, occupied: 1, reserved: 2 }

  validates :room_number, presence: true
  validates :property_name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
