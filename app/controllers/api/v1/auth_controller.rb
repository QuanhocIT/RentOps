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

      def register
        email = params[:email].presence || "user_#{Time.current.to_i}@rentops.vn"
        full_name = params[:full_name].presence || "Khách Hàng Mới"
        phone = params[:phone].presence || "0901234567"
        role = params[:role] || "landlord"
        tenant_name = params[:tenant_name].presence || "Tòa Nhà của #{full_name}"

        tenant = Tenant.create!(
          name: tenant_name,
          subdomain: "tenant-#{Time.current.to_i}",
          phone: phone
        )

        user = User.create!(
          email: email,
          full_name: full_name,
          phone: phone,
          tenant: tenant
        )

        render json: {
          success: true,
          message: "Đăng ký tài khoản thành công!",
          data: {
            token: mock_jwt_token(user),
            user: user_payload(user),
            tenant: tenant_payload(tenant)
          }
        }
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end

      def public_rooms
        rooms = Room.kept.includes(:property).map do |r|
          {
            id: r.id,
            room_number: r.room_number,
            property_name: r.property_name || r.property&.name || "Căn Hộ RentOps",
            price: r.price,
            status: r.status,
            floor: r.floor || 1,
            area: r.area || 25.0,
            amenities: ["Điều hòa", "Tủ lạnh", "Wifi tốc độ cao", "Ban công", "Bình nóng lạnh", "Giường nệm"].sample(4)
          }
        end

        render json: {
          success: true,
          data: rooms
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
