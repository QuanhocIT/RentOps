class GenerateMonthlyBillsJob
  include Sidekiq::Job

  def perform
    billing_month = Date.current.strftime("%Y-%m")

    Tenant.kept.find_each do |tenant|
      ActsAsTenant.with_tenant(tenant) do
        Contract.kept.where(status: :active).find_each do |contract|
          next if MonthlyBill.kept.exists?(contract: contract, billing_month: billing_month)

          room = contract.room
          room_fee = contract.monthly_rent || room&.price || 0
          reading = UtilityReading.kept.find_by(room: room, billing_month: billing_month)

          utility_fee = 0
          if reading
            utility_fee += reading.electric_usage * 3800
            utility_fee += reading.water_usage * 30000
          end

          service_fee = 150000
          total_amount = room_fee + utility_fee + service_fee
          bill_code = "BILL-#{billing_month.delete('-')}-#{room&.room_number || rand(100..999)}"

          MonthlyBill.create!(
            tenant: tenant,
            room: room,
            contract: contract,
            bill_code: bill_code,
            billing_month: billing_month,
            room_fee: room_fee,
            utility_fee: utility_fee,
            service_fee: service_fee,
            total_amount: total_amount,
            due_date: Date.current.end_of_month,
            status: :issued,
            bank_code: tenant.bank_code,
            bank_account: tenant.bank_account,
            bank_account_name: tenant.bank_account_name
          )
        end
      end
    end
  end
end
