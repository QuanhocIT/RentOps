class PaymentReconcilerService
  def self.reconcile(transaction_code:, amount:, content:, bank_code: "MB", tenant: nil)
    return { success: false, message: "Nội dung chuyển khoản rỗng" } if content.blank?

    # Extract bill code pattern e.g. BILL-202607-101 or BILL202607101
    matched = content.match(/BILL[-_]?(\d{6})[-_]?([A-Z0-9]+)/i)
    unless matched
      return { success: false, message: "Không tìm thấy mã hóa đơn hợp lệ trong nội dung: #{content}" }
    end

    raw_month = matched[1]
    room_str = matched[2]
    formatted_month = "#{raw_month[0..3]}-#{raw_month[4..5]}"

    # Locate bill
    query = MonthlyBill.kept
    query = query.where(tenant: tenant) if tenant
    bill = query.find_by(bill_code: content.strip) ||
           query.joins(:room).find_by(billing_month: formatted_month, rooms: { room_number: room_str })

    unless bill
      return { success: false, message: "Không tìm thấy hóa đơn khớp với nội dung '#{content}'" }
    end

    return { success: true, message: "Hóa đơn #{bill.bill_code} đã được thanh toán trước đó", bill: bill } if bill.paid?

    pay_amount = amount.to_f > 0 ? amount.to_f : bill.remaining_amount
    new_paid = bill.paid_amount.to_f + pay_amount
    new_status = new_paid >= bill.total_amount ? :paid : :partially_paid

    MonthlyBill.transaction do
      bill.update!(
        paid_amount: new_paid,
        status: new_status,
        paid_at: Time.current
      )

      PaymentTransaction.create!(
        tenant: bill.tenant,
        monthly_bill: bill,
        transaction_code: transaction_code.presence || "TX-AUTO-#{Time.current.to_i}-#{rand(100..999)}",
        amount: pay_amount,
        payment_method: "vietqr_auto",
        status: "completed",
        description: "Đối soát tự động từ ngân hàng #{bank_code}: #{content}",
        paid_at: Time.current
      )

      if defined?(Notification)
        Notification.create!(
          tenant: bill.tenant,
          recipient_name: bill.contract&.renter&.full_name || "Khách thuê",
          recipient_phone: bill.contract&.renter&.phone || "N/A",
          channel: "system",
          content: "✅ Xác nhận thanh toán tự động thành công cho hóa đơn #{bill.bill_code} số tiền #{pay_amount.round}đ.",
          status: "sent"
        )
      end
    end

    { success: true, message: "Đã tự động gạch nợ thành công #{pay_amount.round}đ cho hóa đơn #{bill.bill_code}", bill: bill }
  end
end
