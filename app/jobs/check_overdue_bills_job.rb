class CheckOverdueBillsJob
  include Sidekiq::Job

  def perform
    today = Date.current
    MonthlyBill.kept.where(status: [:issued, :partially_paid]).where("due_date < ?", today).find_each do |bill|
      bill.update!(status: :overdue)

      # Automatically generate notification if Notification model is available
      if defined?(Notification)
        renter_name = bill.contract&.renter&.full_name || "Khách thuê phòng #{bill.room&.room_number}"
        renter_phone = bill.contract&.renter&.phone || bill.tenant&.phone

        Notification.create(
          tenant: bill.tenant,
          recipient_name: renter_name,
          recipient_phone: renter_phone,
          content: "[Quá hạn thanh toán] Hóa đơn #{bill.bill_code} phòng #{bill.room&.room_number} (kỳ #{bill.billing_month}) số tiền #{bill.total_amount}đ đã quá hạn ngày #{bill.due_date&.strftime('%d/%m/%Y')}.",
          channel: "zns",
          status: :sent
        )
      end
    end
  end
end
