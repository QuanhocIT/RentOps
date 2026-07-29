module Api
  module V1
    class AuthController < ActionController::API
      def login
        # Sample auth endpoint returning JWT token & tenant info
        tenant = Tenant.first_or_create!(name: "Tòa Nhà Demo RentOps", subdomain: "demo")
        user = User.first_or_create!(email: params[:email] || "admin@rentops.vn", tenant: tenant) do |u|
          u.full_name = "Chủ Trọ Demo"
        end

        mock_jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.rentops_mock_token"

        render json: {
          success: true,
          message: "Đăng nhập thành công",
          data: {
            token: mock_jwt_token,
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
    end
  end
end
