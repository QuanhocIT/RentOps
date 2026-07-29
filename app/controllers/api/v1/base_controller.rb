module Api
  module V1
    class BaseController < ActionController::API
      set_current_tenant_through_filter
      before_action :authenticate_request!
      before_action :set_tenant_from_user

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

      protected

      # Standardized JSON success response helper
      def render_json_success(data: nil, message: "Thành công", meta: {}, status: :ok)
        render json: {
          success: true,
          message: message,
          data: data,
          meta: meta
        }, status: status
      end

      # Standardized JSON error response helper
      def render_json_error(message: "Đã có lỗi xảy ra", errors: [], meta: {}, status: :unprocessable_entity)
        render json: {
          success: false,
          message: message,
          data: errors.presence || nil,
          meta: meta
        }, status: status
      end

      private

      # Extract & verify JWT token from Authorization Header
      def authenticate_request!
        header = request.headers["Authorization"]
        token = header.split(" ").last if header.present?

        # Dummy/JWT auth payload decoding logic for Base skeleton
        if token.present?
          # In full Devise JWT setup, warden / jwt payload resolution identifies current_user
          @current_user ||= mock_or_decode_user(token)
        end

        unless @current_user
          render_json_error(message: "Không có quyền truy cập. Token không hợp lệ.", status: :unauthorized)
        end
      end

      # Set current tenant dynamically using acts_as_tenant filter
      def set_tenant_from_user
        return unless @current_user&.tenant

        set_current_tenant(@current_user.tenant)
      end

      def mock_or_decode_user(token)
        # Mocking user & tenant fallback for base controller bootstrap & testing
        Tenant.first_or_create!(name: "Demo Tenant", subdomain: "demo") do |t|
          t.phone = "0901234567"
        end.yield_self do |tenant|
          User.first_or_create!(email: "admin@rentops.vn", tenant: tenant) do |u|
            u.full_name = "Quản trị viên RentOps"
          end
        end
      end

      def render_not_found(exception)
        render_json_error(message: "Không tìm thấy dữ liệu yêu cầu: #{exception.message}", status: :not_found)
      end

      def render_unprocessable_entity(exception)
        render_json_error(message: "Dữ liệu không hợp lệ", errors: exception.record.errors.full_messages, status: :unprocessable_entity)
      end
    end
  end
end
