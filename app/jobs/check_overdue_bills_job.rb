class CheckOverdueBillsJob
  include Sidekiq::Job

  def perform
    today = Date.current
    MonthlyBill.kept.where(status: [:issued, :partially_paid]).where("due_date < ?", today).find_each do |bill|
      bill.update!(status: :overdue)

      # Automatically generate notification if Notification model is available
      if defined?(Notification)
        Notification.create(
          tenant: bill.tenant,
          title: "Hóa đơn #{bill.bill_code} quá hạn thanh toán",
          content: "Hóa đơn phòng #{bill.room&.room_number} (kỳ #{bill.billing_month}) số tiền #{bill.total_amount}đ đã quá hạn thanh toán ngày #{bill.due_date&.strftime('%d/%m/%Y')}.",
          channel: "system",
          status: "sent"
        )
      end
    end
  end
end
