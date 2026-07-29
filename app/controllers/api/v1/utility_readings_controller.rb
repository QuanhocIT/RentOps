module Api
  module V1
    class UtilityReadingsController < BaseController
      def index
        readings = UtilityReading.kept.where(tenant_id: current_tenant_record&.id)
        readings = readings.where(billing_month: params[:billing_month]) if params[:billing_month].present?
        readings = readings.where(room_id: params[:room_id]) if params[:room_id].present?

        if params[:property_id].present?
          readings = readings.joins(:room).where(rooms: { property_id: params[:property_id] })
        end

        records, meta = paginate(readings.includes(:room).order(created_at: :desc))

        readings_list = records.map do |r|
          elec_use = r.electric_usage
          water_use = r.water_usage
          is_high_elec = elec_use > 250
          is_high_water = water_use > 25

          r.as_json.merge(
            room_number: r.room&.room_number,
            property_name: r.room&.property_name,
            property_id: r.room&.property_id,
            electric_usage: elec_use,
            water_usage: water_use,
            is_high_electric: is_high_elec,
            is_high_water: is_high_water,
            is_high_usage: is_high_elec || is_high_water,
            meter_reset: r.meter_reset?
          )
        end

        render_json_success(
          data: readings_list,
          message: "Lấy danh sách chỉ số điện nước thành công",
          meta: meta
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
              water_usage: reading.water_usage,
              meter_reset: reading.meter_reset?
            ),
            message: "Lưu chỉ số điện nước thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể lưu chỉ số", errors: reading.errors.full_messages)
        end
      end

      def batch_create
        readings_params = params[:readings] || []
        created_count = 0

        UtilityReading.transaction do
          readings_params.each do |item|
            next if item[:room_id].blank? || item[:billing_month].blank?

            r = UtilityReading.find_or_initialize_by(
              tenant: current_tenant_record,
              room_id: item[:room_id],
              billing_month: item[:billing_month]
            )
            r.assign_attributes(
              electric_old: item[:electric_old].to_i,
              electric_new: item[:electric_new].to_i,
              water_old: item[:water_old].to_i,
              water_new: item[:water_new].to_i,
              note: item[:note],
              meter_reset: item[:meter_reset] || false
            )
            if r.save
              created_count += 1
            end
          end
        end

        render_json_success(message: "Đã lưu thành công #{created_count} chỉ số điện nước!")
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
          :water_old, :water_new, :note, :image_url, :meter_reset
        )
      end
    end
  end
end
