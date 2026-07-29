module Api
  module V1
    class WebhooksController < ActionController::API
      def vietqr
        # Webhook auto reconciliation for VietQR payment
        bill_code = params[:content] || params[:addInfo] || params[:description]
        amount = params[:amount].to_f

        if bill_code.present?
          bill = MonthlyBill.kept.find_by(bill_code: bill_code)
          if bill
            if amount >= bill.total_amount
              bill.update!(status: :paid, paid_at: Time.current)
            else
              bill.update!(status: :partially_paid)
            end

            render json: { error: 0, message: "Cập nhật thanh toán hóa đơn thành công" }, status: :ok
            return
          end
        end

        render json: { error: 0, message: "Webhook đã nhận nhưng không khớp bill_code" }, status: :ok
      end
    end
  end
end
