module Api
  module V1
    class RoomsController < BaseController
      def index
        rooms = Room.kept.select(:id, :tenant_id, :property_name, :room_number, :price, :status, :created_at)

        rooms = rooms.where(status: Room.statuses[params[:status]]) if params[:status].present? && Room.statuses.key?(params[:status])

        room_list = rooms.order(:room_number)

        render_json_success(
          data: room_list.as_json,
          message: "Lấy danh sách phòng trọ thành công",
          meta: {
            total_items: room_list.count,
            summary: {
              vacant: room_list.where(status: Room.statuses[:vacant]).count,
              occupied: room_list.where(status: Room.statuses[:occupied]).count,
              reserved: room_list.where(status: Room.statuses[:reserved]).count
            }
          }
        )
      end

      def create
        room = Room.new(room_params)

        if room.save
          render_json_success(data: room.as_json, message: "Tạo phòng mới thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo phòng", errors: room.errors.full_messages)
        end
      end

      def update
        room = Room.kept.find(params[:id])

        if room.update(room_params)
          render_json_success(data: room.as_json, message: "Cập nhật thông tin phòng thành công")
        else
          render_json_error(message: "Cập nhật thất bại", errors: room.errors.full_messages)
        end
      end

      def destroy
        room = Room.kept.find(params[:id])
        room.discard

        render_json_success(message: "Xóa mềm phòng trọ thành công")
      end

      private

      def room_params
        params.require(:room).permit(:property_name, :room_number, :price, :status)
      end
    end
  end
end
