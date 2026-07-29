module Api
  module V1
    class MonthlyBillsController < BaseController
      def index
        bills = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id)
        bills = bills.includes(:room, :contract).order(billing_month: :desc, created_at: :desc)

        bills_list = bills.map do |b|
          b.as_json.merge(
            room_number: b.room&.room_number,
            property_name: b.room&.property_name,
            vietqr_url: b.vietqr_url
          )
        end

        render_json_success(
          data: bills_list,
          message: "Lấy danh sách hóa đơn thành công",
          meta: { total_items: bills_list.size }
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
      end

      def generate
        room = Room.find_by(id: params.dig(:monthly_bill, :room_id))
        contract = room&.contracts&.find_by(status: :active)

        room_fee = params.dig(:monthly_bill, :room_fee).presence || room&.price || 0
        utility_fee = params.dig(:monthly_bill, :utility_fee).presence || 0
        service_fee = params.dig(:monthly_bill, :service_fee).presence || 0
        total_amount = room_fee.to_f + utility_fee.to_f + service_fee.to_f

        billing_month = params.dig(:monthly_bill, :billing_month).presence || Date.current.strftime("%Y-%m")
        bill_code = "BILL-#{billing_month.delete('-')}-#{room&.room_number || rand(100..999)}"

        bill = MonthlyBill.new(
          tenant: current_tenant_record,
          room: room,
          contract: contract,
          bill_code: bill_code,
          billing_month: billing_month,
          room_fee: room_fee,
          utility_fee: utility_fee,
          service_fee: service_fee,
          total_amount: total_amount,
          due_date: params.dig(:monthly_bill, :due_date).presence || Date.current.end_of_month,
          status: :issued,
          bank_code: current_tenant_record&.bank_code || "MB",
          bank_account: current_tenant_record&.bank_account || "0901234567",
          bank_account_name: current_tenant_record&.bank_account_name || "RENTOPS DEMO"
        )

        if bill.save
          render_json_success(
            data: bill.as_json.merge(vietqr_url: bill.vietqr_url),
            message: "Sinh hóa đơn thành công",
            status: :created
          )
        else
          render_json_error(message: "Không thể sinh hóa đơn", errors: bill.errors.full_messages)
        end
      end

      def vietqr
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        render_json_success(
          data: {
            bill_code: bill.bill_code,
            total_amount: bill.total_amount,
            bank_code: bill.bank_code,
            bank_account: bill.bank_account,
            bank_account_name: bill.bank_account_name,
            vietqr_url: bill.vietqr_url
          },
          message: "Lấy thông tin VietQR thành công"
        )
      end

      def destroy
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        bill.discard

        render_json_success(message: "Xóa mềm hóa đơn thành công")
      end

      private

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
