class Contract < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :renter, class_name: "User", optional: true

  enum :status, { draft: 0, active: 1, ended: 2, cancelled: 3 }

  validates :contract_code, presence: true, uniqueness: true
  validates :start_date, presence: true
end
