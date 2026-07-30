module Api
  module V1
    class ContractsController < BaseController
      def index
        contracts = Contract.kept.where(tenant_id: current_tenant_record&.id)
        contracts = contracts.includes(:room, :renter, :co_tenants).order(created_at: :desc)

        if params[:status].present?
          if params[:status] == "expiring"
            contracts = contracts.where(status: :active).where("end_date IS NOT NULL AND end_date <= ?", Date.current + 30.days)
          else
            contracts = contracts.where(status: params[:status])
          end
        end

        active_count = Contract.kept.where(tenant_id: current_tenant_record&.id, status: :active).count
        total_deposit = Contract.kept.where(tenant_id: current_tenant_record&.id, status: :active).sum(:deposit_amount)

        records, meta = paginate(contracts)

        data = records.map do |c|
          days_remaining = c.end_date ? (c.end_date - Date.current).to_i : nil
          is_expiring_soon = c.active? && days_remaining && days_remaining <= 30 && days_remaining >= 0

          c.as_json.merge(
            room_number: c.room&.room_number,
            property_name: c.room&.property_name,
            renter_name: c.renter&.full_name,
            days_remaining: days_remaining,
            is_expiring_soon: is_expiring_soon,
            co_tenants_count: c.co_tenants.size,
            unpaid_bills_count: c.unpaid_bills.count,
            total_unpaid_amount: c.total_unpaid_amount
          )
        end

        render_json_success(
          data: data,
          message: "Lấy danh sách hợp đồng thành công",
          meta: meta.merge(active_count: active_count, total_deposit: total_deposit)
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

        unpaid_amount = contract.total_unpaid_amount.to_f
        manual_deduction = params[:deduction_amount].to_f
        deduction_reason = params[:deduction_reason].presence || "Khấu trừ nợ tiền phòng/hóa đơn & thanh lý"

        total_deduction = manual_deduction + unpaid_amount
        deposit = contract.deposit_amount.to_f
        refund_amount = [deposit - total_deduction, 0.0].max

        deposit_status = if refund_amount >= deposit
                           "refunded"
                         elsif refund_amount > 0
                           "partially_refunded"
                         else
                           "forfeited"
                         end

        Contract.transaction do
          contract.update!(
            status: :ended,
            end_date: Date.current,
            deposit_status: deposit_status,
            deposit_refunded_amount: refund_amount
          )

          if contract.room
            contract.room.update!(status: :vacant)
          end

          contract.co_tenants.update_all(temporary_residence_status: "expired")

          # Mark unpaid bills as paid via deposit deduction if requested
          if params[:settle_unpaid_with_deposit] && unpaid_amount > 0
            contract.unpaid_bills.each do |bill|
              bill.update!(status: :paid, paid_amount: bill.total_amount, paid_at: Time.current)
            end
          end

          AuditLog.log_action(
            tenant: current_tenant_record,
            user: current_user,
            action: "CHECKOUT_CONTRACT",
            record: contract,
            payload: {
              contract_code: contract.contract_code,
              deposit_amount: deposit,
              unpaid_amount: unpaid_amount,
              deduction_amount: total_deduction,
              refund_amount: refund_amount,
              deposit_status: deposit_status,
              reason: deduction_reason
            }
          )
        end

        render_json_success(
          data: contract.as_json.merge(
            deposit_amount: deposit,
            unpaid_amount: unpaid_amount,
            deduction_amount: total_deduction,
            refund_amount: refund_amount,
            deposit_status: deposit_status,
            deduction_reason: deduction_reason
          ),
          message: "Thanh lý hợp đồng thành công. Tiền cọc hoàn trả: #{refund_amount.round}đ"
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

      def co_tenants
        contract = Contract.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        if request.post?
          co_tenant = contract.co_tenants.create!(co_tenant_params)
          render_json_success(data: co_tenant, message: "Thêm người ở cùng thành công", status: :created)
        elsif request.delete?
          ct = contract.co_tenants.find_by(id: params[:co_tenant_id])
          if ct
            ct.destroy
            render_json_success(message: "Xóa thành viên ở cùng thành công")
          else
            render_json_error(message: "Không tìm thấy thông tin thành viên")
          end
        else
          render_json_success(data: contract.co_tenants, message: "Lấy danh sách người ở cùng thành công")
        end
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

      def co_tenant_params
        params.require(:co_tenant).permit(:full_name, :phone, :id_card_number, :id_card_front_url, :id_card_back_url, :is_primary_renter, :temporary_residence_status)
      end
    end
  end
end
