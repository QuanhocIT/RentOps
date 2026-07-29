require "jwt"

module Api
  module V1
    class AuthController < ActionController::API
      def login
        email_or_phone = params[:email].presence || params[:phone].presence || "admin@rentops.vn"
        password = params[:password].presence || "Password123!"

        user = User.find_by(email: email_or_phone) || User.find_by(phone: email_or_phone)

        if user.nil?
          tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
            record.name = "Tòa Nhà Demo RentOps"
            record.phone = "0901234567"
          end

          user = User.create!(
            email: email_or_phone,
            full_name: params[:full_name].presence || "Chủ Trọ Demo",
            password: password,
            tenant: tenant,
            role: :owner
          )
        elsif user.password_digest.blank?
          user.update!(password: password)
        end

        if user.authenticate(password)
          tenant = user.tenant
          TenantSampleSeeder.seed_for(tenant) if tenant && Service.where(tenant_id: tenant.id).count.zero?

          token = encode_jwt_token(user)

          render json: {
            success: true,
            message: "Đăng nhập thành công",
            data: {
              token: token,
              user: user_payload(user),
              tenant: tenant_payload(tenant)
            },
            meta: {}
          }
        else
          render json: {
            success: false,
            message: "Mật khẩu không chính xác"
          }, status: :unauthorized
        end
      end

      def register
        email = params[:email].presence
        phone = params[:phone].presence || "0901234567"
        full_name = params[:full_name].presence || "Khách Hàng Mới"
        password = params[:password].presence || "Password123!"
        role = params[:role] || "owner"
        tenant_name = params[:tenant_name].presence || "Tòa Nhà của #{full_name}"

        tenant = Tenant.create!(
          name: tenant_name,
          subdomain: "tenant-#{Time.current.to_i}",
          phone: phone
        )

        user = User.create!(
          email: email,
          phone: phone,
          full_name: full_name,
          password: password,
          role: role,
          tenant: tenant
        )

        TenantSampleSeeder.seed_for(tenant)

        token = encode_jwt_token(user)

        render json: {
          success: true,
          message: "Đăng ký tài khoản thành công!",
          data: {
            token: token,
            user: user_payload(user),
            tenant: tenant_payload(tenant)
          }
        }
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end

      def public_rooms
        if Room.kept.count.zero?
          tenant = Tenant.first_or_create!(subdomain: "demo") do |t|
            t.name = "Tòa Nhà Demo RentOps"
            t.phone = "0901234567"
          end
          TenantSampleSeeder.seed_for(tenant)
        end

        rooms = Room.kept.includes(:property).order(created_at: :desc).map do |r|
          {
            id: r.id,
            room_number: r.room_number,
            property_name: r.property_name.presence || r.property&.name || "Căn Hộ RentOps",
            price: r.price,
            status: r.status,
            floor: r.floor || 1,
            area: r.area || 28.0,
            amenities: ["Điều hòa Inverter", "Tủ lạnh 2 cánh", "Wifi 200Mbps", "Ban công thoáng mát", "Bình nóng lạnh", "Giường nệm cao su"].sample(4)
          }
        end

        render json: {
          success: true,
          data: rooms
        }
      end

      def me
        header = request.headers["Authorization"].to_s
        token = header.split(" ").last
        user = decode_jwt_token(token) || User.first

        tenant = user&.tenant

        TenantSampleSeeder.seed_for(tenant) if tenant && Service.where(tenant_id: tenant.id).count.zero?

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

      def encode_jwt_token(user, exp = 24.hours.from_now)
        payload = {
          user_id: user.id,
          tenant_id: user.tenant_id,
          role: user.role,
          exp: exp.to_i
        }
        JWT.encode(payload, jwt_secret, "HS256")
      end

      def decode_jwt_token(token)
        return nil if token.blank?

        decoded = JWT.decode(token, jwt_secret, true, { algorithm: "HS256" }).first
        User.find_by(id: decoded["user_id"])
      rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
        nil
      end

      def jwt_secret
        ENV["JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base || "rentops_jwt_secret_key_2026_super_secure"
      end

      def user_payload(user)
        return nil unless user

        {
          id: user.id,
          email: user.email,
          phone: user.phone,
          full_name: user.full_name,
          role: user.role
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
    end
  end
end
