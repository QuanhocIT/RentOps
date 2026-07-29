module Api
  module V1
    class TrashController < BaseController
      def index
        discarded_rooms = Room.discarded.where(tenant_id: current_tenant_record&.id)
        discarded_contracts = Contract.discarded.where(tenant_id: current_tenant_record&.id)
        discarded_bills = MonthlyBill.discarded.where(tenant_id: current_tenant_record&.id)

        render_json_success(
          data: {
            rooms: discarded_rooms,
            contracts: discarded_contracts,
            bills: discarded_bills
          },
          message: "Lấy danh sách rác thành công"
        )
      end

      def restore
        type = params[:type]
        id = params[:id]

        record = case type
                 when 'room'
                   Room.discarded.find(id)
                 when 'contract'
                   Contract.discarded.find(id)
                 when 'bill'
                   MonthlyBill.discarded.find(id)
                 end

        if record&.undiscard
          render_json_success(message: "Đã khôi phục thành công!")
        else
          render_json_error(message: "Không thể khôi phục bản ghi")
        end
      end
    end
  end
end
