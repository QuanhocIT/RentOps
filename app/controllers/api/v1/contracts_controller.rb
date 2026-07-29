module Api
  module V1
    class ContractsController < BaseController
      def index
        contracts = Contract.kept.select(:id, :tenant_id, :room_id, :renter_id, :contract_code, :status, :start_date, :end_date, :created_at).order(created_at: :desc)

        render_json_success(
          data: contracts.as_json,
          message: "Lấy danh sách hợp đồng thành công",
          meta: { total_items: contracts.count }
        )
      end

      def create
        contract = Contract.new(contract_params)

        if contract.save
          room = contract.room
          room.update(status: :occupied) if room&.respond_to?(:status=)
          render_json_success(data: contract.as_json, message: "Tạo hợp đồng thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo hợp đồng", errors: contract.errors.full_messages)
        end
      end

      def checkout
        contract = Contract.kept.find(params[:id])
        contract.update(status: :ended, end_date: Date.current)

        if contract.room&.respond_to?(:status=)
          contract.room.update(status: :vacant)
        end

        render_json_success(data: contract.as_json, message: "Thanh lý hợp đồng thành công")
      end

      private

      def contract_params
        params.require(:contract).permit(:contract_code, :room_id, :renter_id, :start_date, :end_date, :status, :monthly_rent, :deposit_amount)
      end
    end
  end
end
