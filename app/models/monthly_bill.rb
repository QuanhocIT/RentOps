class MonthlyBill < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :contract, optional: true

  enum :status, { draft: 0, issued: 1, partially_paid: 2, paid: 3, overdue: 4, cancelled: 5 }

  validates :bill_code, presence: true, uniqueness: true
  validates :billing_month, presence: true
end
