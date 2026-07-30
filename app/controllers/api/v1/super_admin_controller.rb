module Api
  module V1
    class SuperAdminController < BaseController
      before_action :ensure_super_admin!

      def index
        tenants = Tenant.all.includes(:plan)
        plans = Plan.all

        total_rooms = Room.count
        total_contracts = Contract.where(status: :active).count
        total_renters = User.where(role: :renter).count

        render_json_success(
          data: {
            tenants: tenants.as_json(include: :plan),
            plans: plans.as_json,
            total_tenants: tenants.size,
            active_tenants: tenants.select { |t| t.status == "active" || t.status.blank? }.size,
            mrr_estimate: tenants.sum { |t| t.plan&.monthly_price || 0 },
            total_rooms: total_rooms,
            total_contracts: total_contracts,
            total_renters: total_renters
          },
          message: "Lấy dữ liệu Super Admin thành công"
        )
      end

      def create_tenant
        plan = Plan.find_by(id: params[:plan_id]) || Plan.first
        subdomain = params[:subdomain].presence || "tenant-#{Time.current.to_i}"

        tenant = Tenant.create!(
          name: params[:name],
          subdomain: subdomain,
          phone: params[:phone] || "0901234567",
          status: "active",
          plan: plan
        )

        owner = User.create!(
          email: params[:owner_email],
          full_name: params[:owner_name] || "Chủ Trọ #{tenant.name}",
          phone: params[:phone] || "0901234567",
          password: params[:owner_password] || "Password123!",
          tenant: tenant,
          role: :owner
        )

        if params[:seed_sample_data] != false
          TenantSampleSeeder.seed_for(tenant) rescue nil
        end

        render_json_success(
          data: { tenant: tenant.as_json(include: :plan), owner: owner.as_json },
          message: "Tạo Chủ Trọ mới #{tenant.name} thành công!"
        )
      end

      def update_tenant_plan
        tenant = Tenant.find(params[:tenant_id])
        plan = Plan.find(params[:plan_id])

        tenant.update!(plan: plan)
        render_json_success(data: tenant.as_json(include: :plan), message: "Đã cập nhật gói cước cho Tenant #{tenant.name}")
      end

      def toggle_tenant_status
        tenant = Tenant.find(params[:tenant_id])
        new_status = (tenant.status == "active" || tenant.status.blank?) ? "suspended" : "active"
        tenant.update!(status: new_status)

        render_json_success(data: tenant.as_json(include: :plan), message: "Đã đổi trạng thái Tenant sang #{new_status}")
      end

      def destroy_tenant
        tenant = Tenant.find(params[:tenant_id])
        tenant.destroy!
        render_json_success(message: "Đã xóa Tenant #{tenant.name} khỏi hệ thống.")
      end

      def create_plan
        plan = Plan.create!(
          name: params[:name],
          max_rooms: params[:max_rooms].to_i,
          monthly_price: params[:monthly_price].to_d,
          description: params[:description]
        )
        render_json_success(data: plan, message: "Tạo Gói Cước SaaS #{plan.name} thành công!")
      end

      def update_plan_details
        plan = Plan.find(params[:id])
        plan.update!(
          name: params[:name] || plan.name,
          max_rooms: (params[:max_rooms] || plan.max_rooms).to_i,
          monthly_price: (params[:monthly_price] || plan.monthly_price).to_d,
          description: params[:description] || plan.description
        )
        render_json_success(data: plan, message: "Đã cập nhật gói cước #{plan.name}")
      end

      def system_health
        render_json_success(
          data: {
            ruby_version: RUBY_VERSION,
            rails_version: Rails.version,
            rails_env: Rails.env,
            uptime_info: "Online • Normal",
            database_adapter: ActiveRecord::Base.connection.adapter_name,
            total_properties: Property.count,
            total_rooms: Room.count,
            total_contracts: Contract.count,
            total_bills: MonthlyBill.count,
            total_expenses: OperatingExpense.count,
            total_renters: User.where(role: :renter).count,
            total_users: User.count,
            total_tenants: Tenant.count,
            maintenance_mode: Rails.application.config.try(:maintenance_mode) || false
          },
          message: "Lấy thông số sức khỏe hệ thống thành công"
        )
      end

      def broadcast_notification
        title = params[:title].presence || "Thông Báo Từ Quản Trị Hệ Thống RentOps"
        content = params[:content].presence || "Hệ thống RentOps thông báo nâng cấp tính năng."
        channel = params[:channel].presence || "zns"

        created_count = 0
        Tenant.find_each do |tenant|
          Notification.create!(
            tenant: tenant,
            recipient_name: tenant.name,
            recipient_phone: tenant.phone || "0901234567",
            channel: channel,
            content: "[#{title}] #{content}",
            status: :sent,
            sent_at: Time.current
          )
          created_count += 1
        end

        render_json_success(message: "Đã phát thông báo thành công tới #{created_count} chủ trọ trên toàn hệ thống!")
      end

      def audit_logs
        logs = AuditLog.unscoped.order(created_at: :desc).limit(100).includes(:tenant, :user)

        logs_data = logs.map do |log|
          {
            id: log.id,
            action: log.action,
            record_type: log.record_type,
            record_id: log.record_id,
            tenant_name: log.tenant&.name || "Nền tảng RentOps",
            user_name: log.user&.full_name || "Hệ thống / Guest",
            user_email: log.user&.email,
            payload: log.payload,
            created_at: log.created_at
          }
        end

        render_json_success(data: logs_data, message: "Lấy nhật ký thao tác toàn hệ thống thành công")
      end

      def platform_settings
        settings = {
          support_hotline: "1900 8888 (24/7)",
          support_email: "support@rentops.vn",
          platform_name: "RentOps SaaS Platform",
          default_trial_days: 14,
          maintenance_mode: Rails.application.config.try(:maintenance_mode) || false,
          vietqr_gateway_active: true
        }
        render_json_success(data: settings, message: "Lấy cấu hình nền tảng thành công")
      end

      def update_platform_settings
        maintenance = params[:maintenance_mode].to_s == "true"
        Rails.application.config.maintenance_mode = maintenance rescue nil

        render_json_success(message: "Đã cập nhật cấu hình nền tảng thành công!")
      end

      private

      def ensure_super_admin!
        unless current_user&.super_admin?
          render_json_error(message: "Chỉ Super Admin mới có quyền truy cập.", status: :forbidden)
        end
      end
    end
  end
end
