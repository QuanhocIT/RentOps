class UtilityReading < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room

  validates :billing_month, presence: true
  validates :electric_new, numericality: { greater_than_or_equal_to: 0 }
  validates :water_new, numericality: { greater_than_or_equal_to: 0 }

  validate :readings_must_be_increasing, unless: :meter_reset?

  def electric_usage
    return electric_new if meter_reset?
    [electric_new - electric_old, 0].max
  end

  def water_usage
    return water_new if meter_reset?
    [water_new - water_old, 0].max
  end

  private

  def readings_must_be_increasing
    if electric_new < electric_old
      errors.add(:electric_new, "chỉ số điện mới (#{electric_new}) không thể nhỏ hơn chỉ số cũ (#{electric_old}) trừ khi bật cờ thay đồng hồ (meter_reset)")
    end

    if water_new < water_old
      errors.add(:water_new, "chỉ số nước mới (#{water_new}) không thể nhỏ hơn chỉ số cũ (#{water_old}) trừ khi bật cờ thay đồng hồ (meter_reset)")
    end
  end
end
