module Api
  module V1
    class AmenitiesController < BaseController
      def index
        amenities = Amenity.kept.where(tenant_id: current_tenant_record&.id).order(:name)

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
