require "jwt"

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

      def current_user
        @current_user
      end

      def current_tenant_record
        return current_tenant if defined?(current_tenant) && current_tenant.present?

        current_user&.tenant
      end

      def authorize_roles!(*roles)
        return if current_user&.super_admin?
        return if roles.map(&:to_s).include?(current_user&.role.to_s)

        render_json_error(message: "Bạn không có quyền thực hiện thao tác này.", status: :forbidden)
      end

      def paginate(scope, page: params[:page], per_page: params[:per_page])
        page_num = [(page.presence || 1).to_i, 1].max
        per_num = [(per_page.presence || 20).to_i, 1].max
        per_num = 100 if per_num > 100

        total_count = scope.count
        total_pages = (total_count.to_f / per_num).ceil
        records = scope.offset((page_num - 1) * per_num).limit(per_num)

        meta = {
          current_page: page_num,
          per_page: per_num,
          total_pages: total_pages,
          total_count: total_count
        }

        [records, meta]
      end

      def encode_jwt_token(user, exp = 24.hours.from_now)
        payload = {
          user_id: user.id,
          tenant_id: user.tenant_id,
          role: user.role,
          exp: exp.to_i
        }
        JWT.encode(payload, jwt_secret, "HS256")
      end

      private

      def authenticate_request!
        header = request.headers["Authorization"].to_s
        token = header.split(" ").last
        @current_user = decode_jwt_token(token) if token.present?

        return if @current_user

        render_json_error(message: "Không có quyền truy cập. Token không hợp lệ hoặc đã hết hạn.", status: :unauthorized)
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

      def set_tenant_from_user
        return if @current_user&.respond_to?(:super_admin?) && @current_user.super_admin?
        return unless @current_user&.tenant

        set_current_tenant(@current_user.tenant)
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
