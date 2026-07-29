class OperatingExpense < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :property, optional: true

  validates :title, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :expense_date, presence: true
end
