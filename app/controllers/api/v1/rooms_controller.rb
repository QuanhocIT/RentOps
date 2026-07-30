module Api
  module V1
    class RoomsController < BaseController
      def index
        rooms = Room.kept.where(tenant_id: current_tenant_record&.id)

        rooms = rooms.where(status: Room.statuses[params[:status]]) if params[:status].present? && Room.statuses.key?(params[:status])
        rooms = rooms.where(property_id: params[:property_id]) if params[:property_id].present?
        rooms = rooms.where(room_type: params[:room_type]) if params[:room_type].present?

        room_list = rooms.order(:floor, :room_number)

        data = room_list.map do |r|
          r.as_json.merge(
            room_type_label: r.room_type_label,
            furnished_status_label: r.furnished_status_label,
            layout_summary: r.layout_summary,
            property_type: r.property&.property_type,
            property_type_label: r.property&.property_type_label,
            property_type_icon: r.property&.property_type_icon
          )
        end

        render_json_success(
          data: data,
          message: "Lấy danh sách phòng/căn hộ thành công",
          meta: {
            total_items: room_list.count,
            summary: {
              vacant: room_list.where(status: Room.statuses[:vacant]).count,
              occupied: room_list.where(status: Room.statuses[:occupied]).count,
              reserved: room_list.where(status: Room.statuses[:reserved]).count,
              maintenance: room_list.where(status: Room.statuses[:maintenance]).count
            }
          }
        )
      end

      def create
        p_params = room_params
        if p_params[:property_id].present?
          prop = Property.find_by(id: p_params[:property_id])
          p_params[:property_name] = prop.name if prop
        end

        room = Room.new(p_params.merge(tenant: current_tenant_record))

        if room.save
          render_json_success(
            data: room.as_json.merge(
              room_type_label: room.room_type_label,
              furnished_status_label: room.furnished_status_label,
              layout_summary: room.layout_summary,
              property_type: room.property&.property_type,
              property_type_label: room.property&.property_type_label,
              property_type_icon: room.property&.property_type_icon
            ),
            message: "Tạo phòng/căn hộ mới thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể tạo phòng/căn hộ", errors: room.errors.full_messages)
        end
      end

      def update
        room = Room.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        p_params = room_params
        if p_params[:property_id].present?
          prop = Property.find_by(id: p_params[:property_id])
          p_params[:property_name] = prop.name if prop
        end

        if room.update(p_params)
          render_json_success(
            data: room.as_json.merge(
              room_type_label: room.room_type_label,
              furnished_status_label: room.furnished_status_label,
              layout_summary: room.layout_summary,
              property_type: room.property&.property_type,
              property_type_label: room.property&.property_type_label,
              property_type_icon: room.property&.property_type_icon
            ),
            message: "Cập nhật thông tin căn hộ thành công"
          )
        else
          render_json_error(message: "Cập nhật thất bại", errors: room.errors.full_messages)
        end
      end

      def destroy
        room = Room.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        room.discard

        render_json_success(message: "Xóa mềm phòng trọ thành công")
      end

      private

      def room_params
        params.require(:room).permit(
          :property_id, :property_name, :room_number, :price, :status, :floor, :area,
          :room_type, :bedrooms_count, :living_rooms_count, :bathrooms_count, :kitchens_count,
          :has_balcony, :is_shared_bathroom, :is_mezzanine, :furnished_status
        )
      end
    end
  end
end
