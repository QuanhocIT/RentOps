class Service < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant

  validates :name, presence: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
end
