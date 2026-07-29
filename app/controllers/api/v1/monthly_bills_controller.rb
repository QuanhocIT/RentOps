module Api
  module V1
    class MonthlyBillsController < BaseController
      def index
        bills = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id)
        bills = bills.select(:id, :tenant_id, :room_id, :contract_id, :bill_code, :billing_month, :status, :total_amount, :created_at).order(billing_month: :desc)

        render_json_success(
          data: bills.as_json,
          message: "Lấy danh sách hóa đơn thành công",
          meta: { total_items: bills.count }
        )
      end

      def create
        bill = MonthlyBill.new(bill_params.merge(tenant: current_tenant_record))

        if bill.save
          render_json_success(data: bill.as_json, message: "Tạo hóa đơn thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo hóa đơn", errors: bill.errors.full_messages)
        end
      end

      def generate
        bill = MonthlyBill.new(generate_bill_params.merge(tenant: current_tenant_record))

        if bill.save
          render_json_success(data: bill.as_json, message: "Sinh hóa đơn thành công", status: :created)
        else
          render_json_error(message: "Không thể sinh hóa đơn", errors: bill.errors.full_messages)
        end
      end

      def destroy
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        bill.discard

        render_json_success(message: "Xóa mềm hóa đơn thành công")
      end

      private

      def bill_params
        params.require(:monthly_bill).permit(:bill_code, :room_id, :contract_id, :billing_month, :status, :total_amount, :due_date)
      end

      def generate_bill_params
        params.require(:monthly_bill).permit(:room_id, :contract_id, :billing_month, :total_amount, :due_date).merge(
          bill_code: "BILL-#{Time.current.strftime('%Y%m%d%H%M%S')}"
        )
      end
    end
  end
end
