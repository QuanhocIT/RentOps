module Api
  module V1
    class RoomsController < BaseController
      def index
        # Select specific required columns and leverage composite index [:tenant_id, :status]
        rooms = Room.kept
                    .select(:id, :tenant_id, :property_name, :room_number, :price, :status, :created_at)
                    .order(room_number: :asc)

        if params[:status].present?
          rooms = rooms.where(status: params[:status])
        end

        render_json_success(
          data: rooms,
          message: "Lấy danh sách phòng trọ thành công",
          meta: {
            total_items: rooms.size,
            summary: {
              vacant: rooms.select { |r| r.status == "vacant" }.size,
              occupied: rooms.select { |r| r.status == "occupied" }.size,
              reserved: rooms.select { |r| r.status == "reserved" }.size
            }
          }
        )
      end

      def create
        room = Room.new(room_params)
        if room.save
          render_json_success(data: room, message: "Tạo phòng mới thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo phòng", errors: room.errors.full_messages)
        end
      end

      def update
        room = Room.kept.find(params[:id])
        if room.update(room_params)
          render_json_success(data: room, message: "Cập nhật thông tin phòng thành công")
        else
          render_json_error(message: "Cập nhật thất bại", errors: room.errors.full_messages)
        end
      end

      def destroy
        room = Room.kept.find(params[:id])
        room.discard # Soft delete using Discard gem
        render_json_success(message: "Xóa mềm phòng trọ thành công")
      end

      private

      def room_params
        params.require(:room).permit(:property_name, :room_number, :price, :status)
      end
    end
  end
end
