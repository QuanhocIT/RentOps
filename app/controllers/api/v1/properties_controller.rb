module Api
  module V1
    class PropertiesController < BaseController
      def index
        properties = Property.kept.select(:id, :tenant_id, :name, :address, :created_at).order(:name)

        render_json_success(
          data: properties.as_json,
          message: "Lấy danh sách khu trọ thành công",
          meta: { total_items: properties.count }
        )
      end

      def create
        property = Property.new(property_params)

        if property.save
          render_json_success(data: property.as_json, message: "Tạo khu trọ thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo khu trọ", errors: property.errors.full_messages)
        end
      end

      private

      def property_params
        params.require(:property).permit(:name, :address)
      end
    end
  end
end
