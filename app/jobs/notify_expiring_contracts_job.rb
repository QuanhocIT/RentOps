class NotifyExpiringContractsJob
  include Sidekiq::Job

  def perform
    today = Date.current
    thirty_days_later = today + 30.days

    Contract.kept.where(status: :active).where("end_date IS NOT NULL AND end_date >= ? AND end_date <= ?", today, thirty_days_later).find_each do |contract|
      days_left = (contract.end_date - today).to_i

      if defined?(Notification)
        # Avoid duplicate notifications on same day
        existing = Notification.where(tenant: contract.tenant)
                               .where("content LIKE ?", "%#{contract.contract_code}%")
                               .where("created_at >= ?", today.beginning_of_day)
                               .exists?

        unless existing
          renter_name = contract.renter&.full_name || "Khách thuê"
          room_num = contract.room&.room_number || contract.room_id

          Notification.create!(
            tenant: contract.tenant,
            recipient_name: renter_name,
            recipient_phone: contract.renter&.phone || "N/A",
            channel: "zns",
            content: "Cảnh báo: Hợp đồng #{contract.contract_code} (Phòng #{room_num} - #{renter_name}) sẽ hết hạn sau #{days_left} ngày (Ngày #{contract.end_date.strftime('%d/%m/%Y')}). Vui lòng gia hạn sớm!",
            status: "sent"
          )
        end
      end
    end
  end
end
