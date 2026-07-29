module Api
  module V1
    class PaymentTransactionsController < BaseController
      def index
        transactions = PaymentTransaction.recent
        render json: transactions
      end

      # Mock/Real Bank Webhook auto-matching
      def webhook
        # Payload from bank webhook: e.g., { transaction_code: "FT2607...", amount: 3500000, description: "RENTOPS HD2026-07-001" }
        tx_code = params[:transaction_code] || "TX#{Time.current.to_i}#{rand(100..999)}"
        amount = params[:amount].to_f
        description = params[:description] || params[:content] || ""

        # Find matching bill by bill_code inside description
        bill = MonthlyBill.find_by("bill_code IN (?) OR ? LIKE CONCAT('%', bill_code, '%')", [description.strip], description)

        if bill
          bill.update!(status: :paid, paid_at: Time.current)
          tx = PaymentTransaction.create!(
            monthly_bill: bill,
            tenant: bill.tenant,
            transaction_code: tx_code,
            amount: amount,
            payment_method: params[:payment_method] || "vietqr",
            status: "completed",
            bank_name: params[:bank_name] || "MB Bank",
            account_number: params[:account_number] || "0901234567",
            description: description,
            raw_payload: params.to_json,
            paid_at: Time.current
          )

          AuditLog.create!(
            tenant_id: bill.tenant_id,
            action: "payment_webhook_matched",
            record_type: "MonthlyBill",
            record_id: bill.id,
            payload: "Auto-reconciled bill #{bill.bill_code} via payment #{tx.transaction_code}"
          )

          render json: { success: true, message: "Hóa đơn #{bill.bill_code} đã được tự động gạch nợ thành công!", transaction: tx }
        else
          tx = PaymentTransaction.create!(
            transaction_code: tx_code,
            amount: amount,
            payment_method: "vietqr",
            status: "unmatched",
            description: description,
            raw_payload: params.to_json,
            paid_at: Time.current
          )
          render json: { success: false, message: "Không tìm thấy hóa đơn khớp với nội dung chuyển khoản", transaction: tx }, status: :unprocessable_entity
        end
      end
    end
  end
end
