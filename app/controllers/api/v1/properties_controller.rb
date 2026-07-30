module Api
  module V1
    class PropertiesController < BaseController
      def index
        properties = Property.kept.where(tenant_id: current_tenant_record&.id)
        properties = properties.where(property_type: params[:property_type]) if params[:property_type].present?
        properties = properties.order(:name)

        data = properties.map do |p|
          p.as_json.merge(
            property_type_label: p.property_type_label,
            property_type_icon: p.property_type_icon,
            total_rooms: p.rooms.kept.count,
            occupied_rooms: p.rooms.kept.where(status: :occupied).count,
            vacant_rooms: p.rooms.kept.where(status: :vacant).count
          )
        end

        render_json_success(
          data: data,
          message: "Lấy danh sách tòa nhà/khu trọ thành công",
          meta: { total_items: properties.count }
        )
      end

      def create
        property = Property.new(property_params.merge(tenant: current_tenant_record))

        if property.save
          render_json_success(
            data: property.as_json.merge(
              property_type_label: property.property_type_label,
              property_type_icon: property.property_type_icon
            ),
            message: "Tạo tòa nhà thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể tạo tòa nhà", errors: property.errors.full_messages)
        end
      end

      def destroy
        property = Property.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        property.discard

        render_json_success(message: "Xóa mềm tòa nhà thành công")
      end

      private

      def property_params
        params.require(:property).permit(:name, :address, :property_type, :description)
      end
    end
  end
end
