module Api
  module V1
    class UtilityReadingsController < BaseController
      def index
        readings = UtilityReading.kept.where(tenant_id: current_tenant_record&.id)
        readings = readings.where(billing_month: params[:billing_month]) if params[:billing_month].present?
        readings = readings.where(room_id: params[:room_id]) if params[:room_id].present?

        readings_list = readings.includes(:room).order(created_at: :desc).map do |r|
          r.as_json.merge(
            room_number: r.room&.room_number,
            property_name: r.room&.property_name,
            electric_usage: r.electric_usage,
            water_usage: r.water_usage
          )
        end

        render_json_success(
          data: readings_list,
          message: "Lấy danh sách chỉ số điện nước thành công",
          meta: { total_items: readings_list.size }
        )
      end

      def create
        reading = UtilityReading.find_or_initialize_by(
          tenant: current_tenant_record,
          room_id: reading_params[:room_id],
          billing_month: reading_params[:billing_month]
        )

        reading.assign_attributes(reading_params)

        if reading.save
          render_json_success(
            data: reading.as_json.merge(
              electric_usage: reading.electric_usage,
              water_usage: reading.water_usage
            ),
            message: "Lưu chỉ số điện nước thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể lưu chỉ số", errors: reading.errors.full_messages)
        end
      end

      def destroy
        reading = UtilityReading.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        reading.discard

        render_json_success(message: "Xóa chỉ số thành công")
      end

      private

      def reading_params
        params.require(:utility_reading).permit(
          :room_id, :billing_month, :electric_old, :electric_new,
          :water_old, :water_new, :note, :image_url
        )
      end
    end
  end
end
