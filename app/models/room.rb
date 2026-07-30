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

  ROOM_TYPES = {
    "phong_don" => "Phòng đơn khép kín",
    "studio" => "Căn hộ Studio",
    "can_ho_1pn" => "Căn hộ 1 Phòng Ngủ",
    "can_ho_2pn" => "Căn hộ 2 Phòng Ngủ + 1 PK",
    "can_ho_3pn" => "Căn hộ 3 Phòng Ngủ + 1 PK",
    "can_ho_4pn" => "Căn hộ 4+ Phòng Ngủ / Penthouse",
    "duplex" => "Căn hộ Duplex / Loft",
    "nha_nguyen_can" => "Nhà nguyên căn / Nhà phố",
    "shophouse" => "Mặt bằng thương mại / Shophouse"
  }.freeze

  FURNISHED_STATUSES = {
    "full_noi_that" => "Full nội thất cao cấp",
    "co_ban" => "Nội thất cơ bản",
    "nha_tho" => "Bàn giao thô"
  }.freeze

  validates :room_number, presence: true
  validates :property_name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_destroy :ensure_not_occupied_or_active_contract
  before_discard :ensure_not_occupied_or_active_contract

  def room_type_label
    ROOM_TYPES[room_type] || "Phòng trọ / Căn hộ"
  end

  def furnished_status_label
    FURNISHED_STATUSES[furnished_status] || "Nội thất cơ bản"
  end

  def layout_summary
    parts = []
    parts << "#{bedrooms_count} PN" if bedrooms_count.to_i > 0
    parts << "#{living_rooms_count} PK" if living_rooms_count.to_i > 0
    if is_shared_bathroom?
      parts << "WC dùng chung"
    elsif bathrooms_count.to_i > 0
      parts << "#{bathrooms_count} WC khép kín"
    end
    parts << "#{kitchens_count} Bếp" if responds_to?(:kitchens_count) && kitchens_count.to_i > 0
    parts << "#{area.to_f.round(0)}m²" if area.to_f > 0
    parts << "Gác lửng" if responds_to?(:is_mezzanine?) && is_mezzanine?
    parts << "Ban công" if has_balcony?
    parts << furnished_status_label if responds_to?(:furnished_status) && furnished_status.present?
    parts.join(" • ")
  end

  private

  def ensure_not_occupied_or_active_contract
    if occupied? || contracts.kept.exists?(status: :active)
      errors.add(:base, "Không thể xóa phòng đang có khách ở (Occupied) hoặc đang có hợp đồng hoạt động (Active).")
      throw(:abort)
    end
  end
end
