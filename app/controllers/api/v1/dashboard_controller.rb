module Api
  module V1
    class DashboardController < BaseController
      def summary
        tenant_id = current_tenant_record&.id
        rooms = Room.kept.where(tenant_id: tenant_id)
        contracts = Contract.kept.where(tenant_id: tenant_id, status: :active)
        bills = MonthlyBill.kept.where(tenant_id: tenant_id)
        expenses = OperatingExpense.kept.where(tenant_id: tenant_id)

        total_rooms = rooms.count
        vacant_rooms = rooms.where(status: :vacant).count
        occupied_rooms = rooms.where(status: :occupied).count
        reserved_rooms = rooms.where(status: :reserved).count
        maintenance_rooms = rooms.where(status: :maintenance).count

        occupancy_rate = total_rooms.positive? ? ((occupied_rooms.to_f / total_rooms) * 100).round(1) : 0.0

        monthly_revenue_estimate = contracts.sum(:monthly_rent)
        total_billed = bills.sum(:total_amount)
        paid_billed = bills.where(status: :paid).sum(:total_amount)
        pending_billed = bills.where(status: [:issued, :partially_paid, :overdue]).sum(:total_amount)
        total_expenses = expenses.sum(:amount)

        net_profit_estimate = paid_billed - total_expenses

        # Property performance breakdown
        properties = Property.kept.where(tenant_id: tenant_id)
        by_property = properties.map do |prop|
          p_rooms = rooms.where(property_id: prop.id)
          p_total = p_rooms.count
          p_occupied = p_rooms.where(status: :occupied).count
          p_rate = p_total.positive? ? ((p_occupied.to_f / p_total) * 100).round(1) : 0.0
          p_contracts = contracts.joins(:room).where(rooms: { property_id: prop.id })
          p_revenue = p_contracts.sum(:monthly_rent)
          p_bills = bills.joins(:room).where(rooms: { property_id: prop.id })
          p_paid = p_bills.where(status: :paid).sum(:total_amount)
          p_expenses = expenses.where(property_id: prop.id).sum(:amount)

          {
            id: prop.id,
            name: prop.name,
            total_rooms: p_total,
            occupied_rooms: p_occupied,
            occupancy_rate: p_rate,
            revenue_estimate: p_revenue,
            paid_billed: p_paid,
            expenses: p_expenses,
            net_profit: p_paid - p_expenses
          }
        end

        # Expense categories breakdown
        expense_by_cat = expenses.group(:category).sum(:amount)
        expense_categories = expense_by_cat.map do |cat, amt|
          pct = total_expenses.positive? ? ((amt.to_f / total_expenses) * 100).round(1) : 0.0
          { category: cat.presence || "Khác", amount: amt, percentage: pct }
        end

        render_json_success(
          data: {
            counters: {
              total_rooms: total_rooms,
              vacant_rooms: vacant_rooms,
              occupied_rooms: occupied_rooms,
              reserved_rooms: reserved_rooms,
              maintenance_rooms: maintenance_rooms,
              occupancy_rate: occupancy_rate
            },
            financials: {
              monthly_revenue_estimate: monthly_revenue_estimate,
              total_billed: total_billed,
              paid_billed: paid_billed,
              pending_billed: pending_billed,
              total_expenses: total_expenses,
              net_profit_estimate: net_profit_estimate
            },
            by_property: by_property,
            expense_categories: expense_categories
          },
          message: "Lấy thông tin dashboard tổng quan thành công"
        )
      end
    end
  end
end
