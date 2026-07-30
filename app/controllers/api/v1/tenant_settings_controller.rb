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
            plan_id: tenant.plan_id,
            plan_name: tenant.plan&.name || "Gói Cơ Bản",
            plan_description: tenant.plan&.description || "Quản lý tòa nhà & phòng trọ",
            monthly_price: tenant.plan&.monthly_price || 0,
            max_rooms: tenant.max_rooms_allowed,
            max_properties: tenant.max_properties_allowed,
            current_rooms_count: tenant.rooms.kept.count,
            current_properties_count: tenant.properties.kept.count
          },
          message: "Lấy thông tin cấu hình tenant thành công"
        )
      end

      def plans
        plans_list = Plan.kept.order(:monthly_price).map do |p|
          {
            id: p.id,
            name: p.name,
            max_rooms: p.max_rooms,
            max_properties: p.max_properties_allowed,
            monthly_price: p.monthly_price,
            description: p.description,
            is_current: current_tenant_record&.plan_id == p.id
          }
        end

        render_json_success(
          data: plans_list,
          message: "Lấy danh sách gói nâng cấp thành công"
        )
      end

      def upgrade_plan
        plan = Plan.kept.find_by(id: params[:plan_id])
        return render_json_error(message: "Không tìm thấy gói dịch vụ") unless plan

        tenant = current_tenant_record
        if tenant.update(plan: plan)
          AuditLog.log_action(
            tenant: tenant,
            user: current_user,
            action: "UPGRADE_TENANT_PLAN",
            record: tenant,
            payload: { old_plan_id: tenant.plan_id, new_plan_id: plan.id, new_plan_name: plan.name }
          )

          render_json_success(
            data: {
              plan_id: plan.id,
              plan_name: plan.name,
              max_rooms: plan.max_rooms,
              monthly_price: plan.monthly_price
            },
            message: "Chúc mừng! Bạn đã nâng cấp thành công lên #{plan.name}."
          )
        else
          render_json_error(message: "Không thể nâng cấp gói dịch vụ", errors: tenant.errors.full_messages)
        end
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

      def seed_sample_data
        tenant = current_tenant_record
        TenantSampleSeeder.seed_for(tenant)

        render_json_success(
          message: "Khởi tạo bộ dữ liệu mẫu thành công cho tòa nhà của bạn!"
        )
      end

      private

      def tenant_params
        params.require(:tenant).permit(:name, :phone, :subdomain, :bank_code, :bank_account, :bank_account_name)
      end
    end
  end
end
