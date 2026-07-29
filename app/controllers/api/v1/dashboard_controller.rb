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

        # 6-month financial trends
        current_date = Date.current
        financial_trends = (0..5).map do |i|
          m_date = current_date - (5 - i).months
          m_str = m_date.strftime("%Y-%m")
          m_bills = bills.where(billing_month: m_str)
          m_paid = m_bills.where(status: :paid).sum(:total_amount)
          m_expenses = expenses.where("DATE_FORMAT(expense_date, '%Y-%m') = ?", m_str).sum(:amount)
          {
            month: m_str,
            month_name: "Thg #{m_date.month}/#{m_date.year}",
            paid_billed: m_paid,
            expenses: m_expenses,
            net_profit: m_paid - m_expenses
          }
        end

        # Expiring contracts (next 30 days)
        expiring_contracts = contracts.where("end_date IS NOT NULL AND end_date <= ?", Date.current + 30.days).order(end_date: :asc).limit(5).map do |c|
          days_left = c.end_date ? (c.end_date - Date.current).to_i : 0
          {
            id: c.id,
            contract_code: c.contract_code,
            room_number: c.room&.room_number,
            property_name: c.room&.property_name,
            renter_name: c.renter&.full_name,
            end_date: c.end_date,
            days_remaining: [days_left, 0].max
          }
        end

        # Maintenance statistics
        m_requests = MaintenanceRequest.kept.where(tenant_id: tenant_id)
        pending_maintenance_count = m_requests.where(status: [:pending, :in_progress]).count

        render_json_success(
          data: {
            counters: {
              total_rooms: total_rooms,
              vacant_rooms: vacant_rooms,
              occupied_rooms: occupied_rooms,
              reserved_rooms: reserved_rooms,
              maintenance_rooms: maintenance_rooms,
              occupancy_rate: occupancy_rate,
              pending_maintenance_count: pending_maintenance_count,
              expiring_contracts_count: expiring_contracts.size
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
            expense_categories: expense_categories,
            financial_trends: financial_trends,
            expiring_contracts: expiring_contracts
          },
          message: "Lấy thông tin dashboard tổng quan thành công"
        )
      end
    end
  end
end
