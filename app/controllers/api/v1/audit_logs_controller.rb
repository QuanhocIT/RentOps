module Api
  module V1
    class AuditLogsController < BaseController
      def index
        logs = AuditLog.where(tenant_id: current_tenant_record&.id)

        if params[:action_name].present?
          logs = logs.where(action: params[:action_name])
        end

        if params[:query].present?
          q = "%#{params[:query]}%"
          logs = logs.where("action LIKE ? OR record_type LIKE ? OR payload LIKE ?", q, q, q)
        end

        logs = logs.order(created_at: :desc).limit(200)

        logs_data = logs.map do |log|
          log.as_json.merge(
            user_name: log.user&.full_name || "Hệ thống tự động"
          )
        end

        if params[:export] == "true"
          require 'csv'
          csv_data = CSV.generate(headers: true) do |csv|
            csv << ["ID", "Thời gian", "Người thực hiện", "Hành động", "Đối tượng", "Mô tả chi tiết", "IP Address"]
            logs.each do |log|
              csv << [
                log.id,
                log.created_at.strftime("%d/%m/%Y %H:%M:%S"),
                log.user&.full_name || "Hệ thống",
                log.action,
                log.record_type,
                log.payload.to_json,
                log.ip_address
              ]
            end
          end
          send_data csv_data, filename: "audit_logs_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv", type: "text/csv"
          return
        end

        render_json_success(
          data: logs_data,
          message: "Lấy lịch sử nhật ký thao tác thành công",
          meta: { total_items: logs_data.size }
        )
      end
    end
  end
end
