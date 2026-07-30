class MonthlyBill < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :contract, optional: true
  has_many :payment_transactions, dependent: :destroy
  has_many :bill_items, dependent: :destroy

  enum :status, { draft: 0, issued: 1, partially_paid: 2, paid: 3, overdue: 4, cancelled: 5 }

  validates :bill_code, presence: true, uniqueness: true
  validates :billing_month, presence: true

  before_save :calculate_amounts

  def calculate_amounts
    self.paid_amount ||= 0.0
    self.discount_amount ||= 0.0
    self.penalty_amount ||= 0.0
    computed_total = (room_fee.to_f + utility_fee.to_f + service_fee.to_f + penalty_amount.to_f - discount_amount.to_f)
    self.total_amount = [computed_total, 0.0].max
    self.remaining_amount = [total_amount - paid_amount, 0.0].max

    if paid_amount >= total_amount && total_amount > 0
      self.status = :paid
      self.paid_at ||= Time.current
    elsif paid_amount > 0 && paid_amount < total_amount
      self.status = :partially_paid
    end
  end

  def vietqr_url
    bank = bank_code.presence || tenant&.bank_code.presence || "MB"
    acc = bank_account.presence || tenant&.bank_account.presence || "0901234567"
    acc_name = bank_account_name.presence || tenant&.bank_account_name.presence || "RENTOPS DEMO"
    amt = (remaining_amount.positive? ? remaining_amount : total_amount).to_i
    info = bill_code

    "https://img.vietqr.io/image/#{bank}-#{acc}-compact2.png?amount=#{amt}&addInfo=#{info}&accountName=#{ERB::Util.url_encode(acc_name)}"
  end
end
