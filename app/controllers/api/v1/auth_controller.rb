module Api
  module V1
    class AuthController < ActionController::API
      def login
        tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
          record.name = "Tòa Nhà Demo RentOps"
          record.phone = "0901234567"
        end

        user = User.first_or_create!(email: params[:email].presence || "admin@rentops.vn") do |record|
          record.full_name = params[:full_name].presence || "Chủ Trọ Demo"
          record.tenant = tenant
        end

        render json: {
          success: true,
          message: "Đăng nhập thành công",
          data: {
            token: mock_jwt_token(user),
            user: user_payload(user),
            tenant: tenant_payload(tenant)
          },
          meta: {}
        }
      end

      def me
        user = User.first
        tenant = user&.tenant

        render json: {
          success: true,
          message: "Lấy thông tin người dùng thành công",
          data: {
            user: user_payload(user),
            tenant: tenant_payload(tenant)
          },
          meta: {}
        }
      end

      private

      def user_payload(user)
        return nil unless user

        {
          id: user.id,
          email: user.email,
          full_name: user.full_name
        }
      end

      def tenant_payload(tenant)
        return nil unless tenant

        {
          id: tenant.id,
          name: tenant.name,
          subdomain: tenant.subdomain
        }
      end

      def mock_jwt_token(user)
        "rentops_mock_#{user.id}_#{user.email.parameterize}"
      end
    end
  end
end
