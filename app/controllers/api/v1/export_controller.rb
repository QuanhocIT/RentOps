require "csv"

module Api
  module V1
    class ExportController < BaseController
      def monthly_bills
        bills = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).includes(:room, :contract)
        bills = bills.where(billing_month: params[:billing_month]) if params[:billing_month].present?

        csv_data = CSV.generate(headers: true, col_sep: ",") do |csv|
          csv << ["Mã hóa đơn", "Tháng", "Phòng", "Tòa nhà", "Tiền phòng", "Tiền điện nước", "Phí dịch vụ", "Tổng tiền", "Đã trả", "Còn nợ", "Trạng thái", "Hạn thanh toán"]
          bills.each do |b|
            csv << [
              b.bill_code,
              b.billing_month,
              b.room&.room_number,
              b.room&.property_name,
              b.room_fee,
              b.utility_fee,
              b.service_fee,
              b.total_amount,
              b.paid_amount,
              b.remaining_amount,
              b.status,
              b.due_date
            ]
          end
        end

        send_data csv_data, filename: "Bao_Cao_Hoa_Don_#{params[:billing_month] || 'Tất_Cả'}.csv", type: "text/csv; charset=utf-8; header=present"
      end

      def operating_expenses
        expenses = OperatingExpense.kept.where(tenant_id: current_tenant_record&.id).includes(:property)
        csv_data = CSV.generate(headers: true, col_sep: ",") do |csv|
          csv << ["ID", "Tên chi phí", "Danh mục", "Số tiền", "Ngày ghi nhận", "Tòa nhà", "Ghi chú"]
          expenses.each do |e|
            csv << [
              e.id,
              e.title,
              e.category,
              e.amount,
              e.expense_date,
              e.property&.name || "Chung",
              e.note
            ]
          end
        end

        send_data csv_data, filename: "Bao_Cao_Chi_Phi_Vat_Hanh.csv", type: "text/csv; charset=utf-8; header=present"
      end

      def printable_bill
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        items = bill.bill_items

        render json: {
          success: true,
          data: {
            tenant_name: bill.tenant&.name,
            bill_code: bill.bill_code,
            billing_month: bill.billing_month,
            room_number: bill.room&.room_number,
            property_name: bill.room&.property_name,
            renter_name: bill.contract&.renter&.full_name || "Khách thuê",
            due_date: bill.due_date,
            total_amount: bill.total_amount,
            paid_amount: bill.paid_amount,
            remaining_amount: bill.remaining_amount,
            bank_code: bill.bank_code,
            bank_account: bill.bank_account,
            bank_account_name: bill.bank_account_name,
            vietqr_url: bill.vietqr_url,
            items: items
          }
        }
      end
    end
  end
end
