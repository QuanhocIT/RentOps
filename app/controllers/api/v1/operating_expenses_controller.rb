module Api
  module V1
    class OperatingExpensesController < BaseController
      def index
        expenses = OperatingExpense.kept.where(tenant_id: current_tenant_record&.id)

        expenses = expenses.where(property_id: params[:property_id]) if params[:property_id].present?
        expenses = expenses.where(category: params[:category]) if params[:category].present?
        expenses = expenses.where("expense_date >= ?", params[:start_date]) if params[:start_date].present?
        expenses = expenses.where("expense_date <= ?", params[:end_date]) if params[:end_date].present?

        expenses = expenses.order(expense_date: :desc)

        expenses_list = expenses.map do |exp|
          exp.as_json.merge(property_name: exp.property&.name)
        end

        total_amount = expenses.sum(:amount)
        by_category = expenses.group(:category).sum(:amount)

        render_json_success(
          data: expenses_list,
          message: "Lấy danh sách chi phí vận hành thành công",
          meta: {
            total_items: expenses_list.size,
            total_amount: total_amount,
            by_category: by_category
          }
        )
      end

      def create
        expense = OperatingExpense.new(expense_params.merge(tenant: current_tenant_record))

        if expense.save
          render_json_success(data: expense.as_json, message: "Ghi nhận chi phí thành công", status: :created)
        else
          render_json_error(message: "Không thể lưu chi phí", errors: expense.errors.full_messages)
        end
      end

      def destroy
        expense = OperatingExpense.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        expense.discard

        render_json_success(message: "Xóa chi phí thành công")
      end

      private

      def expense_params
        params.require(:operating_expense).permit(:property_id, :title, :category, :amount, :expense_date, :note)
      end
    end
  end
end
