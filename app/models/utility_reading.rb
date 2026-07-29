class UtilityReading < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room

  validates :billing_month, presence: true
  validates :electric_new, numericality: { greater_than_or_equal_to: 0 }
  validates :water_new, numericality: { greater_than_or_equal_to: 0 }

  def electric_usage
    [electric_new - electric_old, 0].max
  end

  def water_usage
    [water_new - water_old, 0].max
  end
end
