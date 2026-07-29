module Api
  module V1
    class TenantSettingsController < BaseController
      def show
        tenant = current_tenant_record

        render_json_success(
          data: {
            id: tenant.id,
            name: tenant.name,
            subdomain: tenant.subdomain,
            phone: tenant.phone,
            bank_code: tenant.bank_code,
            bank_account: tenant.bank_account,
            bank_account_name: tenant.bank_account_name,
            max_rooms: tenant.max_rooms_allowed,
            plan_name: tenant.plan&.name || "Gói Tiêu Chuẩn"
          },
          message: "Lấy thông tin cấu hình tenant thành công"
        )
      end

      def update
        tenant = current_tenant_record

        if tenant.update(tenant_params)
          AuditLog.log_action(
            tenant: tenant,
            user: current_user,
            action: "UPDATE_TENANT_SETTINGS",
            record: tenant,
            payload: { bank_code: tenant.bank_code, bank_account: tenant.bank_account }
          )

          render_json_success(
            data: {
              id: tenant.id,
              name: tenant.name,
              subdomain: tenant.subdomain,
              phone: tenant.phone,
              bank_code: tenant.bank_code,
              bank_account: tenant.bank_account,
              bank_account_name: tenant.bank_account_name
            },
            message: "Cập nhật cấu hình hệ thống thành công"
          )
        else
          render_json_error(message: "Không thể cập nhật cấu hình", errors: tenant.errors.full_messages)
        end
      end

      private

      def tenant_params
        params.require(:tenant).permit(:name, :phone, :subdomain, :bank_code, :bank_account, :bank_account_name)
      end
    end
  end
end
