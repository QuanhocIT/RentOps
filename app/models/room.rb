class Room < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :property, optional: true
  has_many :contracts, dependent: :destroy
  has_many :monthly_bills, dependent: :destroy
  has_many :utility_readings, dependent: :destroy
  has_many :room_assets, dependent: :destroy

  enum :status, { vacant: 0, occupied: 1, reserved: 2, maintenance: 3 }

  validates :room_number, presence: true
  validates :property_name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_destroy :ensure_not_occupied_or_active_contract
  before_discard :ensure_not_occupied_or_active_contract

  private

  def ensure_not_occupied_or_active_contract
    if occupied? || contracts.kept.exists?(status: :active)
      errors.add(:base, "Không thể xóa phòng đang có khách ở (Occupied) hoặc đang có hợp đồng hoạt động (Active).")
      throw(:abort)
    end
  end
end
