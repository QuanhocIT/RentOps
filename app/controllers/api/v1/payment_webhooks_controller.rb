module Api
  module V1
    class PaymentWebhooksController < ActionController::API
      # Skip authentication for incoming external webhooks from SePay / Cassso / VietQR
      def sepay
        payload = params.to_unsafe_h
        content = payload["content"].to_s.presence || payload["description"].to_s
        amount = (payload["transferAmount"] || payload["amount"]).to_f
        transaction_code = payload["referenceCode"] || payload["id"] || "SEPAY-#{Time.current.to_i}"

        bill_code = extract_bill_code(content)
        process_auto_reconciliation(bill_code, amount, transaction_code, "SePay", payload)
      end

      def cassso
        payload = params.to_unsafe_h
        data = payload["data"] || [payload]
        processed_results = []

        data.each do |item|
          content = item["description"].to_s
          amount = item["amount"].to_f
          transaction_code = item["tid"] || "CASSSO-#{Time.current.to_i}"

          bill_code = extract_bill_code(content)
          res = process_auto_reconciliation(bill_code, amount, transaction_code, "Cassso", item)
          processed_results << res
        end

        render json: { success: true, message: "Processed Cassso webhook", data: processed_results }
      end

      private

      def extract_bill_code(content)
        # Matches BILL-YYYYMM-XXX or BILL-XXX
        match = content.match(/BILL-\d+-[A-Za-z0-9]+|BILL-[A-Za-z0-9]+/)
        match ? match[0] : nil
      end

      def process_auto_reconciliation(bill_code, amount, transaction_code, provider, raw_payload)
        return render json: { success: false, message: "No bill code match found in transaction content" }, status: :unprocessable_entity if bill_code.blank?

        bill = MonthlyBill.kept.find_by(bill_code: bill_code)
        return render json: { success: false, message: "Bill #{bill_code} not found" }, status: :not_found unless bill

        if bill.paid?
          return render json: { success: true, message: "Bill #{bill_code} is already fully paid" }
        end

        MonthlyBill.transaction do
          new_paid = bill.paid_amount.to_f + amount
          new_status = new_paid >= bill.total_amount ? :paid : :partially_paid

          bill.update!(
            paid_amount: new_paid,
            status: new_status,
            paid_at: Time.current
          )

          PaymentTransaction.create!(
            tenant: bill.tenant,
            monthly_bill: bill,
            transaction_code: transaction_code,
            amount: amount,
            payment_method: "#{provider.downcase}_webhook",
            status: "completed",
            description: "Thanh toán tự động gạch nợ qua Webhook #{provider} (Nội dung: #{bill_code})",
            raw_payload: raw_payload.to_json,
            paid_at: Time.current
          )

          # Auto Notification
          renter_name = bill.contract&.renter&.full_name || "Khách thuê phòng #{bill.room&.room_number}"
          renter_phone = bill.contract&.renter&.phone || bill.tenant&.phone

          Notification.create!(
            tenant: bill.tenant,
            recipient_name: renter_name,
            recipient_phone: renter_phone,
            channel: "zns",
            content: "Cảm ơn #{renter_name}! Hệ thống đã nhận thanh toán #{amount.round}đ cho hóa đơn #{bill.bill_code}. Trạng thái: #{new_status == :paid ? 'Đã thanh toán đủ' : 'Thanh toán 1 phần'}.",
            status: :sent,
            sent_at: Time.current
          )
        end

        render json: {
          success: true,
          message: "Tự động gạch nợ thành công cho hóa đơn #{bill_code}",
          data: {
            bill_code: bill.bill_code,
            amount_paid: amount,
            new_status: bill.status
          }
        }
      end
    end
  end
end
