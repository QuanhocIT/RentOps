module Api
  module V1
    class NotificationsController < BaseController
      def index
        notifications = Notification.where(tenant_id: current_tenant_record&.id).order(created_at: :desc)

        render_json_success(
          data: notifications.as_json,
          message: "Lấy lịch sử thông báo thành công",
          meta: { total_items: notifications.count }
        )
      end

      def send_reminder
        bill_id = params[:bill_id]
        bill = MonthlyBill.kept.where(tenant_id: current_tenant_record&.id).find_by(id: bill_id)

        unless bill
          render_json_error(message: "Không tìm thấy hóa đơn", status: :not_found)
          return
        end

        renter = bill.contract&.renter
        phone = renter&.phone || current_tenant_record&.phone || "0988777666"
        name = renter&.full_name || "Khách thuê"
        amt = ActionController::Base.helpers.number_to_currency(bill.total_amount, unit: "đ", precision: 0, format: "%n %u")

        content = "RentOps Nhắc Nợ: Kính gửi #{name}, hóa đơn #{bill.bill_code} phòng #{bill.room&.room_number} tháng #{bill.billing_month} số tiền #{amt} chưa được thanh toán. Vui lòng chuyển khoản tới TK MB: #{current_tenant_record.bank_account}."

        noti = Notification.create!(
          tenant: current_tenant_record,
          recipient_name: name,
          recipient_phone: phone,
          channel: params[:channel].presence || "zns",
          content: content,
          status: :sent,
          sent_at: Time.current
        )

        AuditLog.log_action(
          tenant: current_tenant_record,
          user: current_user,
          action: "SEND_DEBT_REMINDER",
          record: bill,
          payload: { recipient: name, phone: phone, bill_code: bill.bill_code }
        )

        render_json_success(
          data: noti.as_json,
          message: "Đã gửi tin nhắn nhắc nợ ZNS/SMS thành công tới #{name} (#{phone})"
        )
      end
    end
  end
end
