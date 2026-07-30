module Api
  module V1
    class MaintenanceRequestsController < BaseController
      def index
        requests = MaintenanceRequest.kept.where(tenant_id: current_tenant_record&.id).includes(:room, :renter).order(created_at: :desc)

        requests = requests.where(status: params[:status]) if params[:status].present?
        requests = requests.where(priority: params[:priority]) if params[:priority].present?
        if params[:property_id].present?
          requests = requests.joins(:room).where(rooms: { property_id: params[:property_id] })
        end

        total_cost = requests.sum(:cost)
        records, meta = paginate(requests)

        data = records.map do |req|
          req.as_json.merge(
            room_number: req.room&.room_number,
            property_name: req.room&.property_name,
            renter_name: req.renter&.full_name
          )
        end

        render_json_success(
          data: data,
          message: "Lấy danh sách sự cố sửa chữa thành công",
          meta: meta.merge(total_cost: total_cost)
        )
      end

      def create
        request_item = MaintenanceRequest.new(maintenance_params.merge(tenant: current_tenant_record))

        if request_item.save
          AuditLog.log_action(
            tenant: current_tenant_record,
            user: current_user,
            action: "CREATE_MAINTENANCE_REQUEST",
            record: request_item,
            payload: { title: request_item.title, room_id: request_item.room_id }
          )

          render_json_success(data: request_item.as_json, message: "Tạo yêu cầu sửa chữa thành công", status: :created)
        else
          render_json_error(message: "Không thể tạo yêu cầu", errors: request_item.errors.full_messages)
        end
      end

      def update
        request_item = MaintenanceRequest.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])

        if request_item.update(maintenance_params)
          request_item.update(resolved_at: Time.current) if request_item.resolved? && request_item.resolved_at.nil?

          # Automatically record cost as operating expense if cost > 0 and owner-paid
          if request_item.cost.to_f > 0 && request_item.resolved?
            if request_item.cost_bearer == "owner"
              OperatingExpense.find_or_create_by!(
                tenant: current_tenant_record,
                title: "Chi phí sửa chữa: #{request_item.title} (Phòng #{request_item.room&.room_number})"
              ) do |exp|
                exp.property = request_item.room&.property
                exp.category = "sửa chữa"
                exp.amount = request_item.cost
                exp.expense_date = Date.current
                exp.note = request_item.description
              end
            elsif request_item.cost_bearer == "renter"
              # Auto link to current or upcoming monthly bill for room
              current_month = Date.current.strftime("%Y-%m")
              active_bill = MonthlyBill.find_by(tenant: current_tenant_record, room_id: request_item.room_id, billing_month: current_month)
              if active_bill
                active_bill.bill_items.find_or_create_by!(
                  item_type: "maintenance",
                  description: "Phí sửa chữa: #{request_item.title}"
                ) do |bi|
                  bi.amount = request_item.cost
                  bi.quantity = 1
                  bi.unit_price = request_item.cost
                end
                active_bill.update!(service_fee: active_bill.service_fee + request_item.cost)
              end
            end
          end

          AuditLog.log_action(
            tenant: current_tenant_record,
            user: current_user,
            action: "UPDATE_MAINTENANCE_REQUEST",
            record: request_item,
            payload: { status: request_item.status, cost: request_item.cost, cost_bearer: request_item.cost_bearer }
          )

          render_json_success(data: request_item.as_json, message: "Cập nhật yêu cầu sửa chữa thành công")
        else
          render_json_error(message: "Cập nhật thất bại", errors: request_item.errors.full_messages)
        end
      end

      def destroy
        request_item = MaintenanceRequest.kept.where(tenant_id: current_tenant_record&.id).find(params[:id])
        request_item.discard

        render_json_success(message: "Xóa yêu cầu sửa chữa thành công")
      end

      private

      def maintenance_params
        params.require(:maintenance_request).permit(
          :room_id, :renter_id, :title, :description, :priority, :status, :cost,
          :cost_bearer, :handyman_name, :handyman_phone, :photo_before_url, :photo_after_url
        )
      end
    end
  end
end
