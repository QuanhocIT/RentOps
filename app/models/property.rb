class Property < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  has_many :rooms, dependent: :destroy

  PROPERTY_TYPES = {
    "phong_tro" => "Phòng trọ / Dãy trọ",
    "chung_cu_mini" => "Chung cư mini (Nhiều tầng)",
    "can_ho_cao_cap" => "Căn hộ cao cấp / Penthouse",
    "nha_nguyen_can" => "Nhà nguyên căn / Nhà phố",
    "biet_thu" => "Biệt thự / Villa",
    "shophouse" => "Shophouse / Mặt bằng kinh doanh",
    "homestay" => "Căn hộ Dịch vụ / Homestay"
  }.freeze

  validates :name, presence: true
  validates :address, presence: true, allow_blank: true

  def property_type_label
    PROPERTY_TYPES[property_type] || "Tòa nhà / Bất động sản"
  end

  def property_type_icon
    case property_type
    when "chung_cu_mini" then "🏢"
    when "can_ho_cao_cap" then "🏢✨"
    when "nha_nguyen_can" then "🏡"
    when "biet_thu" then "🏰"
    when "shophouse" then "🏪"
    when "homestay" then "🏩"
    else "🏠"
    end
  end
end
