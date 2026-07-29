class CheckOverdueBillsJob
  include Sidekiq::Job

  def perform
    today = Date.current
    MonthlyBill.kept.where(status: [:issued, :partially_paid]).where("due_date < ?", today).find_each do |bill|
      bill.update!(status: :overdue)
    end
  end
end
