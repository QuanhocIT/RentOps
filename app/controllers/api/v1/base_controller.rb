module Api
  module V1
    class BaseController < ActionController::API
      set_current_tenant_through_filter
      before_action :authenticate_request!
      before_action :set_tenant_from_user

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

      protected

      def render_json_success(data: nil, message: "Thành công", meta: {}, status: :ok)
        render json: {
          success: true,
          message: message,
          data: data,
          meta: meta
        }, status: status
      end

      def render_json_error(message: "Đã có lỗi xảy ra", errors: [], meta: {}, status: :unprocessable_entity)
        render json: {
          success: false,
          message: message,
          data: errors.presence || nil,
          meta: meta
        }, status: status
      end

      private

      def authenticate_request!
        header = request.headers["Authorization"].to_s
        token = header.split(" ").last
        @current_user = decode_mock_user(token) if token.present?

        return if @current_user

        render_json_error(message: "Không có quyền truy cập. Token không hợp lệ.", status: :unauthorized)
      end

      def set_tenant_from_user
        return if @current_user&.respond_to?(:super_admin?) && @current_user.super_admin?
        return unless @current_user&.tenant

        set_current_tenant(@current_user.tenant)
      end

      def decode_mock_user(token)
        return nil if token.blank?

        tenant = Tenant.first_or_create!(subdomain: "demo") do |t|
          t.name = "Demo Tenant"
          t.phone = "0901234567"
        end

        User.first_or_create!(email: "admin@rentops.vn") do |u|
          u.full_name = "Quản trị viên RentOps"
          u.tenant = tenant
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
