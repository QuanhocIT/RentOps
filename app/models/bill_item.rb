class BillItem < ApplicationRecord
  belongs_to :monthly_bill

  validates :item_type, presence: true
  validates :description, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  enum :item_type, {
    rent: "rent",
    electric: "electric",
    water: "water",
    service: "service",
    penalty: "penalty",
    discount: "discount",
    maintenance: "maintenance"
  }
end
