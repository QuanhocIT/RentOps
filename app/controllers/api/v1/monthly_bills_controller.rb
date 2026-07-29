module Api
  module V1
    class MonthlyBillsController < BaseController
      def index
        bills = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id)
        bills = bills.where(billing_month: params[:billing_month]) if params[:billing_month].present?
        bills = bills.where(status: params[:status]) if params[:status].present?

        records, meta = paginate(bills.includes(:room, :contract).order(billing_month: :desc, created_at: :desc))

        bills_list = records.map do |b|
          b.as_json.merge(
            room_number: b.room&.room_number,
            property_name: b.room&.property_name,
            vietqr_url: b.vietqr_url,
            paid_amount: b.paid_amount,
            remaining_amount: b.remaining_amount
          )
        end

        render_json_success(
          data: bills_list,
          message: "Lấy danh sách hóa đơn thành công",
          meta: meta
        )
      end

      def create
        bill = MonthlyBill.new(bill_params.merge(tenant: current_tenant_record))
        bill.bank_code ||= current_tenant_record&.bank_code || "MB"
        bill.bank_account ||= current_tenant_record&.bank_account || "0901234567"
        bill.bank_account_name ||= current_tenant_record&.bank_account_name || "RENTOPS DEMO"

        if bill.save
          render_json_success(
            data: bill.as_json.merge(vietqr_url: bill.vietqr_url),
            message: "Tạo hóa đơn thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể tạo hóa đơn", errors: bill.errors.full_messages)
        end
      rescue ActiveRecord::RecordNotUnique
        render_json_error(message: "Hóa đơn cho phòng này trong tháng đã tồn tại!")
      end

      def generate
        room = Room.find_by(id: params.dig(:monthly_bill, :room_id))
        contract = room&.contracts&.find_by(status: :active)

        billing_month = params.dig(:monthly_bill, :billing_month).presence || Date.current.strftime("%Y-%m")
        room_fee = params.dig(:monthly_bill, :room_fee).presence&.to_f || contract&.monthly_rent&.to_f || room&.price&.to_f || 0

        # Tiered pricing engine calculation
        reading = UtilityReading.find_by(tenant_id: current_tenant_record&.id, room_id: room&.id, billing_month: billing_month)
        elec_usage = reading&.electric_usage || 0
        water_usage = reading&.water_usage || 0

        elec_fee = calculate_tiered_electric_fee(elec_usage)
        water_fee = water_usage * 15000

        utility_fee = params.dig(:monthly_bill, :utility_fee).presence&.to_f || (elec_fee + water_fee)
        service_fee = params.dig(:monthly_bill, :service_fee).presence&.to_f || 150000

        total_amount = room_fee + utility_fee + service_fee
        bill_code = "BILL-#{billing_month.delete('-')}-#{room&.room_number || rand(100..999)}"

        MonthlyBill.transaction do
          existing = MonthlyBill.kept.find_by(tenant_id: current_tenant_record&.id, room_id: room&.id, billing_month: billing_month)
          if existing
            return render_json_error(message: "Phòng #{room&.room_number} đã có hóa đơn tháng #{billing_month}")
          end

          bill = MonthlyBill.create!(
            tenant: current_tenant_record,
            room: room,
            contract: contract,
            bill_code: bill_code,
            billing_month: billing_month,
            room_fee: room_fee,
            utility_fee: utility_fee,
            service_fee: service_fee,
            total_amount: total_amount,
            paid_amount: 0.0,
            remaining_amount: total_amount,
            due_date: params.dig(:monthly_bill, :due_date).presence || Date.current.end_of_month,
            status: :issued,
            bank_code: current_tenant_record&.bank_code.presence || "MB",
            bank_account: current_tenant_record&.bank_account.presence || "0901234567",
            bank_account_name: current_tenant_record&.bank_account_name.presence || "RENTOPS DEMO"
          )

          create_itemized_breakdown(bill, room_fee, elec_fee, water_fee, service_fee, elec_usage, water_usage)

          render_json_success(
            data: bill.as_json.merge(vietqr_url: bill.vietqr_url),
            message: "Sinh hóa đơn thành công cho phòng #{room&.room_number}",
            status: :created
          )
        end
      rescue ActiveRecord::RecordNotUnique
        render_json_error(message: "Hóa đơn cho phòng này trong tháng đã tồn tại (Race condition detected)")
      end

      def vietqr
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        render_json_success(
          data: {
            bill_code: bill.bill_code,
            total_amount: bill.total_amount,
            paid_amount: bill.paid_amount,
            remaining_amount: bill.remaining_amount,
            bank_code: bill.bank_code,
            bank_account: bill.bank_account,
            bank_account_name: bill.bank_account_name,
            vietqr_url: bill.vietqr_url
          },
          message: "Lấy thông tin VietQR thành công"
        )
      end

      def batch_generate
        billing_month = params[:billing_month].presence || Date.current.strftime("%Y-%m")
        property_id = params[:property_id]

        active_contracts = Contract.kept.where(tenant_id: current_tenant_record&.id, status: :active).includes(:room)
        if property_id.present?
          active_contracts = active_contracts.joins(:room).where(rooms: { property_id: property_id })
        end

        generated_count = 0
        skipped_count = 0

        active_contracts.each do |contract|
          room = contract.room
          next unless room

          MonthlyBill.transaction do
            existing = MonthlyBill.kept.find_by(tenant_id: current_tenant_record&.id, room_id: room.id, billing_month: billing_month)
            if existing
              skipped_count += 1
              next
            end

            room_fee = contract.monthly_rent > 0 ? contract.monthly_rent : room.price
            reading = UtilityReading.kept.find_by(tenant_id: current_tenant_record&.id, room_id: room.id, billing_month: billing_month)

            elec_usage = reading&.electric_usage || 0
            water_usage = reading&.water_usage || 0
            elec_fee = calculate_tiered_electric_fee(elec_usage)
            water_fee = water_usage * 15000

            utility_fee = elec_fee + water_fee
            service_fee = params[:service_fee].presence ? params[:service_fee].to_f : 150000
            total_amount = room_fee.to_f + utility_fee.to_f + service_fee.to_f
            bill_code = "BILL-#{billing_month.delete('-')}-#{room.room_number}"

            bill = MonthlyBill.create!(
              tenant: current_tenant_record,
              room: room,
              contract: contract,
              bill_code: bill_code,
              billing_month: billing_month,
              room_fee: room_fee,
              utility_fee: utility_fee,
              service_fee: service_fee,
              total_amount: total_amount,
              paid_amount: 0.0,
              remaining_amount: total_amount,
              due_date: Date.current.end_of_month,
              status: :issued,
              bank_code: current_tenant_record&.bank_code.presence || "MB",
              bank_account: current_tenant_record&.bank_account.presence || "0901234567",
              bank_account_name: current_tenant_record&.bank_account_name.presence || "RENTOPS DEMO"
            )

            create_itemized_breakdown(bill, room_fee, elec_fee, water_fee, service_fee, elec_usage, water_usage)
            generated_count += 1
          end
        rescue ActiveRecord::RecordNotUnique
          skipped_count += 1
        end

        render_json_success(
          data: { generated_count: generated_count, skipped_count: skipped_count },
          message: "Đã sinh thành công #{generated_count} hóa đơn cho tháng #{billing_month} (Bỏ qua #{skipped_count} phòng đã có hóa đơn)"
        )
      end

      def mark_as_paid
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        payment_method = params[:payment_method].presence || "cash"
        note = params[:note].presence || "Xác nhận thanh toán thủ công"
        pay_amount = params[:amount].presence ? params[:amount].to_f : bill.remaining_amount

        new_paid = bill.paid_amount.to_f + pay_amount
        new_status = new_paid >= bill.total_amount ? :paid : :partially_paid

        bill.update!(
          paid_amount: new_paid,
          status: new_status,
          paid_at: Time.current
        )

        PaymentTransaction.create!(
          tenant: current_tenant_record,
          monthly_bill: bill,
          transaction_code: "TX-MANUAL-#{Time.current.to_i}-#{rand(100..999)}",
          amount: pay_amount,
          payment_method: payment_method,
          status: "completed",
          description: note,
          paid_at: Time.current
        )

        AuditLog.log_action(
          tenant: current_tenant_record,
          user: current_user,
          action: "MARK_BILL_PAID",
          record: bill,
          payload: { bill_code: bill.bill_code, amount: pay_amount, status: new_status }
        )

        render_json_success(
          data: bill.as_json.merge(vietqr_url: bill.vietqr_url),
          message: "Đã xác nhận thanh toán #{pay_amount.round}đ cho hóa đơn #{bill.bill_code}"
        )
      end

      def destroy
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        bill.discard

        render_json_success(message: "Xóa mềm hóa đơn thành công")
      end

      private

      def calculate_tiered_electric_fee(kwh)
        return 0 if kwh <= 0
        # Tiered rates: 0-50 kWh: 1800, 51-100 kWh: 2100, 101-200 kWh: 2600, >200 kWh: 3500
        fee = 0
        if kwh <= 50
          fee = kwh * 1800
        elsif kwh <= 100
          fee = (50 * 1800) + ((kwh - 50) * 2100)
        elsif kwh <= 200
          fee = (50 * 1800) + (50 * 2100) + ((kwh - 100) * 2600)
        else
          fee = (50 * 1800) + (50 * 2100) + (100 * 2600) + ((kwh - 200) * 3500)
        end
        fee
      end

      def create_itemized_breakdown(bill, room_fee, elec_fee, water_fee, service_fee, elec_usage, water_usage)
        BillItem.create!(monthly_bill: bill, item_type: :rent, description: "Tiền thuê phòng tháng #{bill.billing_month}", amount: room_fee, quantity: 1, unit_price: room_fee) if room_fee > 0
        BillItem.create!(monthly_bill: bill, item_type: :electric, description: "Tiền điện (#{elec_usage} kWh)", amount: elec_fee, quantity: elec_usage, unit_price: (elec_usage > 0 ? elec_fee / elec_usage : 3500)) if elec_fee > 0
        BillItem.create!(monthly_bill: bill, item_type: :water, description: "Tiền nước (#{water_usage} m3)", amount: water_fee, quantity: water_usage, unit_price: 15000) if water_fee > 0
        BillItem.create!(monthly_bill: bill, item_type: :service, description: "Phí dịch vụ chung (Rác, Wifi, Vệ sinh)", amount: service_fee, quantity: 1, unit_price: service_fee) if service_fee > 0
      end

      def bill_params
        params.require(:monthly_bill).permit(
          :bill_code, :room_id, :contract_id, :billing_month, :status,
          :room_fee, :utility_fee, :service_fee, :total_amount, :due_date,
          :bank_code, :bank_account, :bank_account_name
        )
      end
    end
  end
end
