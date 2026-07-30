module Api
  module V1
    class AiAdvisorController < BaseController
      def insights
        tenant_id = current_tenant_record&.id

        rooms = Room.kept.where(tenant_id: tenant_id).map do |r|
          {
            id: r.id,
            room_number: r.room_number,
            status: r.status,
            price: r.price.to_f,
            property_name: r.property_name
          }
        end

        bills = MonthlyBill.kept.where(tenant_id: tenant_id).map do |b|
          {
            id: b.id,
            bill_code: b.bill_code,
            status: b.status,
            total_amount: b.total_amount.to_f,
            due_date: b.due_date,
            billing_month: b.billing_month
          }
        end

        expenses = OperatingExpense.kept.where(tenant_id: tenant_id).map do |e|
          {
            id: e.id,
            title: e.title,
            category: e.category,
            amount: e.amount.to_f,
            expense_date: e.expense_date
          }
        end

        readings = UtilityReading.kept.where(tenant_id: tenant_id).map do |ur|
          {
            id: ur.id,
            room_number: ur.room&.room_number,
            billing_month: ur.billing_month,
            electric_usage: ur.electric_usage,
            water_usage: ur.water_usage,
            is_abnormal: ur.is_abnormal?
          }
        end

        maintenance = MaintenanceRequest.kept.where(tenant_id: tenant_id).map do |mr|
          {
            id: mr.id,
            title: mr.title,
            status: mr.status,
            cost: mr.cost.to_f,
            cost_bearer: mr.cost_bearer
          }
        end

        payload = {
          rooms: rooms,
          bills: bills,
          expenses: expenses,
          utility_readings: readings,
          maintenance_requests: maintenance
        }

        python_script = Rails.root.join("python", "rentops_advisor.py").to_s

        require "open3"
        stdout_str, stderr_str, status = Open3.capture3("python", python_script, stdin_data: payload.to_json)

        if status.success?
          begin
            advisor_data = JSON.parse(stdout_str)
            render_json_success(data: advisor_data, message: "Phân tích và gợi ý AI từ Python thành công")
          rescue JSON::ParserError => e
            render_json_error(message: "Không thể đọc dữ liệu phản hồi từ Python", errors: [e.message, stdout_str])
          end
        else
          render_json_error(message: "Lỗi thực thi mô-đun Python AI Advisor", errors: [stderr_str])
        end
      end
    end
  end
end
