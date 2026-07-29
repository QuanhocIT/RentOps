module Api
  module V1
    class AuthController < ActionController::API
      def login
        tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
          record.name = "Tòa Nhà Demo RentOps"
          record.phone = "0901234567"
        end

        user = User.first_or_create!(email: params[:email].presence || "admin@rentops.vn") do |record|
          record.full_name = "Chủ Trọ Demo"
          record.tenant = tenant
        end

        render json: {
          success: true,
          message: "Đăng nhập thành công",
          data: {
            token: mock_jwt_token(user),
            user: {
              id: user.id,
              email: user.email,
              full_name: user.full_name
            },
            tenant: {
              id: tenant.id,
              name: tenant.name,
              subdomain: tenant.subdomain
            }
          },
          meta: {}
        }
      end

      def me
        render json: {
          success: true,
          message: "Lấy thông tin người dùng thành công",
          data: current_user_payload,
          meta: {}
        }
      end

      private

      def current_user_payload
        user = User.first
        tenant = user&.tenant

        {
          user: user && {
            id: user.id,
            email: user.email,
            full_name: user.full_name
          },
          tenant: tenant && {
            id: tenant.id,
            name: tenant.name,
            subdomain: tenant.subdomain
          }
        }
      end

      def mock_jwt_token(user)
        "rentops_mock_#{user.id}_#{user.email.parameterize}"
      end
    end
  end
end
