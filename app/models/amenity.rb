class Amenity < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant

  validates :name, presence: true
end
