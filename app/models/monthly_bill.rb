class MonthlyBill < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :contract, optional: true

  enum :status, { draft: 0, issued: 1, partially_paid: 2, paid: 3, overdue: 4, cancelled: 5 }

  validates :bill_code, presence: true, uniqueness: true
  validates :billing_month, presence: true

  def vietqr_url
    bank = bank_code.presence || tenant&.bank_code.presence || "MB"
    acc = bank_account.presence || tenant&.bank_account.presence || "0901234567"
    acc_name = bank_account_name.presence || tenant&.bank_account_name.presence || "RENTOPS DEMO"
    amt = total_amount.to_i
    info = bill_code

    "https://img.vietqr.io/image/#{bank}-#{acc}-compact2.png?amount=#{amt}&addInfo=#{info}&accountName=#{ERB::Util.url_encode(acc_name)}"
  end
end
