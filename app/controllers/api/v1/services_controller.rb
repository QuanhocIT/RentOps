module Api
  module V1
    class ServicesController < BaseController
      def index
        services = Service.kept.where(tenant_id: current_tenant_record&.id).order(:name)

        render_json_success(
          data: services.as_json,
          message: "Lấy danh sách dịch vụ thành công",
          meta: { total_items: services.count }
        )
      end

      def create
        service = Service.new(service_params.merge(tenant: current_tenant_record))

        if service.save
          render_json_success(data: service.as_json, message: "Tạo dịch vụ thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo dịch vụ", errors: service.errors.full_messages)
        end
      end

      def update
        service = Service.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        if service.update(service_params)
          render_json_success(data: service.as_json, message: "Cập nhật đơn giá dịch vụ thành công")
        else
          render_json_error(message: "Không thể cập nhật dịch vụ", errors: service.errors.full_messages)
        end
      end

      def destroy
        service = Service.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        service.discard

        render_json_success(message: "Xóa dịch vụ thành công")
      end

      private

      def service_params
        params.require(:service).permit(:name, :unit_price, :unit_name)
      end
    end
  end
end
