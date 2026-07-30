module Api
  module V1
    class RentersController < BaseController
      def index
        renters = User.kept.where(tenant_id: current_tenant_record&.id, role: :renter)
        renters = renters.order(:full_name)

        render_json_success(
          data: renters.as_json(only: [:id, :email, :full_name, :phone, :id_card_number, :hometown, :vehicle_plate, :emergency_contact, :id_card_issue_date, :created_at]),
          message: "Lấy danh sách khách thuê thành công",
          meta: { total_items: renters.count }
        )
      end

      def create
        renter = User.new(renter_params.merge(tenant: current_tenant_record, role: :renter))

        if renter.save
          render_json_success(data: renter.as_json, message: "Thêm khách thuê thành công", status: :created)
        else
          render_json_error(message: "Không thể thêm khách thuê", errors: renter.errors.full_messages)
        end
      end

      def update
        renter = User.kept.where(tenant_id: current_tenant_record&.id, role: :renter).find(params[:id])

        if renter.update(renter_params)
          render_json_success(data: renter.as_json, message: "Cập nhật thông tin khách thuê thành công")
        else
          render_json_error(message: "Cập nhật thất bại", errors: renter.errors.full_messages)
        end
      end

      def destroy
        renter = User.kept.where(tenant_id: current_tenant_record&.id, role: :renter).find(params[:id])
        renter.discard

        render_json_success(message: "Xóa khách thuê thành công")
      end

      private

      def renter_params
        params.require(:renter).permit(:full_name, :email, :phone, :id_card_number, :hometown, :vehicle_plate, :emergency_contact, :id_card_issue_date)
      end
    end
  end
end
