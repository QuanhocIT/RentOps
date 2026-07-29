class PaymentSchedule < ApplicationRecord
  belongs_to :contract

  validates :due_date, presence: true
  validates :expected_amount, numericality: { greater_than_or_equal_to: 0 }

  enum :status, {
    pending: "pending",
    paid: "paid",
    overdue: "overdue"
  }, default: "pending"
end
