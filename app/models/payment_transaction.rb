class PaymentTransaction < ApplicationRecord
  belongs_to :monthly_bill, optional: true
  belongs_to :tenant, optional: true

  validates :transaction_code, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :completed, -> { where(status: "completed") }
  scope :recent, -> { order(created_at: :desc) }
end
