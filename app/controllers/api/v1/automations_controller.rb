module Api
  module V1
    class AutomationsController < BaseController
      def trigger_jobs
        job_type = params[:job_type]

        case job_type
        when "generate_bills"
          trigger_job(GenerateMonthlyBillsJob)
          msg = "Đã xếp hàng công việc tự động sinh hóa đơn hàng tháng!"
        when "check_overdue"
          trigger_job(CheckOverdueBillsJob)
          msg = "Đã xếp hàng công việc tự động cập nhật hóa đơn quá hạn!"
        when "notify_expiring"
          trigger_job(NotifyExpiringContractsJob)
          msg = "Đã xếp hàng công việc tự động phát hiện hợp đồng sắp hết hạn!"
        else
          # Run all background automations
          trigger_job(GenerateMonthlyBillsJob)
          trigger_job(CheckOverdueBillsJob)
          trigger_job(NotifyExpiringContractsJob)
          msg = "Đã kích hoạt toàn bộ các công việc tự động hóa nền!"
        end

        render_json_success(message: msg)
      end

      private

      def trigger_job(job_class)
        job_class.perform_async
      rescue StandardError
        job_class.new.perform rescue nil
      end

      def reconcile_payment
        content = params[:content]
        amount = params[:amount].to_f
        bank_code = params[:bank_code] || "MB"

        res = PaymentReconcilerService.reconcile(
          transaction_code: "TX-MANUAL-RECON-#{Time.current.to_i}",
          amount: amount,
          content: content,
          bank_code: bank_code,
          tenant: current_tenant_record
        )

        if res[:success]
          render_json_success(data: res[:bill], message: res[:message])
        else
          render_json_error(message: res[:message])
        end
      end
    end
  end
end
