module Api
  module V1
    class AmenitiesController < BaseController
      DEFAULT_AMENITIES = [
        { name: "Điều Hòa Inverter 2 Chiều", icon: "❄️" },
        { name: "Tủ Lạnh Side-by-Side 250L", icon: "🧊" },
        { name: "Giường Ngủ Gỗ Sồi (Nệm Cao Su)", icon: "🛏️" },
        { name: "Máy Giặt Riêng Cửa Trước", icon: "🧺" },
        { name: "Wifi Cáp Quang 200Mbps", icon: "📶" },
        { name: "Bếp Từ Đôi Âm + Hút Mùi", icon: "🍳" },
        { name: "Sofa & Bàn Trà Cao Cấp", icon: "🛋️" },
        { name: "Bình Nóng Lạnh Ariston 30L", icon: "🚿" },
        { name: "Tủ Quần Áo 3 Cánh Kịch Trần", icon: "🚪" },
        { name: "Ban Công View Phố Rộng", icon: "🌅" },
        { name: "Khóa Cửa Vân Tay Thông Minh", icon: "🔒" },
        { name: "Smart TV 50 inch 4K", icon: "🖥️" }
      ].freeze

      def index
        tenant = current_tenant_record
        if tenant && Amenity.kept.where(tenant_id: tenant.id).count == 0
          DEFAULT_AMENITIES.each do |item|
            Amenity.create!(name: item[:name], icon: item[:icon], tenant: tenant)
          end
        end

        amenities = Amenity.kept.where(tenant_id: tenant&.id).order(:id)

        render_json_success(
          data: amenities.as_json,
          message: "Lấy danh sách tiện ích thành công",
          meta: { total_items: amenities.count }
        )
      end

      def create
        amenity = Amenity.new(amenity_params.merge(tenant: current_tenant_record))

        if amenity.save
          render_json_success(data: amenity.as_json, message: "Tạo tiện ích thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo tiện ích", errors: amenity.errors.full_messages)
        end
      end

      def destroy
        amenity = Amenity.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        amenity.discard

        render_json_success(message: "Xóa tiện ích thành công")
      end

      private

      def amenity_params
        params.require(:amenity).permit(:name, :icon)
      end
    end
  end
end
