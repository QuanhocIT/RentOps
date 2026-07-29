module Api
  module V1
    class SuperAdminController < BaseController
      def index
        tenants = Tenant.all.includes(:plan)
        plans = Plan.all

        render_json_success(
          data: {
            tenants: tenants.as_json(include: :plan),
            plans: plans.as_json,
            total_tenants: tenants.size,
            active_tenants: tenants.where(status: "active").size,
            mrr_estimate: tenants.sum { |t| t.plan&.monthly_price || 0 }
          },
          message: "Lấy dữ liệu Super Admin thành công"
        )
      end

      def update_tenant_plan
        tenant = Tenant.find(params[:tenant_id])
        plan = Plan.find(params[:plan_id])

        tenant.update!(plan: plan)
        render_json_success(data: tenant.as_json(include: :plan), message: "Đã cập nhật gói cước cho Tenant #{tenant.name}")
      end
    end
  end
end
