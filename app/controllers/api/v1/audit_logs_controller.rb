module Api
  module V1
    class AuditLogsController < BaseController
      def index
        logs = AuditLog.where(tenant_id: current_tenant_record&.id).order(created_at: :desc).limit(100)

        logs_data = logs.map do |log|
          log.as_json.merge(
            user_name: log.user&.full_name || "Hệ thống tự động"
          )
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
