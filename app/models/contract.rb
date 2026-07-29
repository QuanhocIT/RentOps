class Contract < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :renter, class_name: "User", optional: true
  has_many :monthly_bills, dependent: :nullify
  has_many :co_tenants, dependent: :destroy
  has_many :payment_schedules, dependent: :destroy

  enum :status, { draft: 0, active: 1, ended: 2, cancelled: 3 }

  validates :contract_code, presence: true, uniqueness: true
  validates :start_date, presence: true

  def signed?
    tenant_signature.present?
  end

  def unpaid_bills
    monthly_bills.kept.where.not(status: :paid)
  end

  def total_unpaid_amount
    unpaid_bills.sum(:remaining_amount)
  end
end
