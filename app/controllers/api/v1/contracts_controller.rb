module Api
  module V1
    class ContractsController < BaseController
      def index
        contracts = Contract.kept.where(tenant_id: current_tenant_record&.id)
        contracts = contracts.includes(:room, :renter).order(created_at: :desc)

        data = contracts.map do |c|
          c.as_json.merge(
            room_number: c.room&.room_number,
            property_name: c.room&.property_name,
            renter_name: c.renter&.full_name
          )
        end

        render_json_success(
          data: data,
          message: "Lấy danh sách hợp đồng thành công",
          meta: { total_items: data.size }
        )
      end

      def create
        contract = Contract.new(contract_params.merge(tenant: current_tenant_record))

        if contract.save
          room = contract.room
          room.update(status: :occupied) if room

          AuditLog.log_action(
            tenant: current_tenant_record,
            user: current_user,
            action: "CREATE_CONTRACT",
            record: contract,
            payload: { contract_code: contract.contract_code, room_number: room&.room_number }
          )

          render_json_success(data: contract.as_json, message: "Tạo hợp đồng thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo hợp đồng", errors: contract.errors.full_messages)
        end
      end

      def checkout
        contract = Contract.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        deduction_amount = params[:deduction_amount].to_f
        deduction_reason = params[:deduction_reason].presence || "Khấu trừ thanh lý"

        deposit = contract.deposit_amount.to_f
        refund_amount = [deposit - deduction_amount, 0].max

        contract.update!(status: :ended, end_date: Date.current)

        if contract.room
          contract.room.update!(status: :vacant)
        end

        AuditLog.log_action(
          tenant: current_tenant_record,
          user: current_user,
          action: "CHECKOUT_CONTRACT",
          record: contract,
          payload: {
            contract_code: contract.contract_code,
            deposit_amount: deposit,
            deduction_amount: deduction_amount,
            refund_amount: refund_amount,
            reason: deduction_reason
          }
        )

        render_json_success(
          data: contract.as_json.merge(
            deposit_amount: deposit,
            deduction_amount: deduction_amount,
            refund_amount: refund_amount,
            deduction_reason: deduction_reason
          ),
          message: "Thanh lý hợp đồng thành công"
        )
      end

      def renew
        contract = Contract.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        new_end_date = if params[:new_end_date].present?
                         Date.parse(params[:new_end_date])
                       elsif params[:months].present?
                         (contract.end_date || Date.current).to_date + params[:months].to_i.months
                       else
                         (contract.end_date || Date.current).to_date + 6.months
                       end

        updates = { end_date: new_end_date, status: :active }
        updates[:monthly_rent] = params[:new_monthly_rent].to_f if params[:new_monthly_rent].present?

        contract.update!(updates)

        AuditLog.log_action(
          tenant: current_tenant_record,
          user: current_user,
          action: "RENEW_CONTRACT",
          record: contract,
          payload: { contract_code: contract.contract_code, new_end_date: new_end_date }
        )

        render_json_success(
          data: contract.as_json,
          message: "Gia hạn hợp đồng thành công đến ngày #{new_end_date.strftime('%d/%m/%Y')}"
        )
      end

      def destroy
        contract = Contract.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        contract.discard

        render_json_success(message: "Xóa mềm hợp đồng thành công")
      end

      private

      def contract_params
        params.require(:contract).permit(:contract_code, :room_id, :renter_id, :start_date, :end_date, :status, :monthly_rent, :deposit_amount)
      end
    end
  end
end
