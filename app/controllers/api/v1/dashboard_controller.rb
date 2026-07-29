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
            }
          },
          message: "Lấy thông tin dashboard tổng quan thành công"
        )
      end
    end
  end
end
