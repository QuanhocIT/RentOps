class MaintenanceRequest < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :room
  belongs_to :renter, class_name: "User", optional: true

  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }
  enum :status, { pending: 0, in_progress: 1, resolved: 2, cancelled: 3 }
  enum :cost_bearer, { owner: "owner", renter: "renter" }, prefix: true

  validates :title, presence: true
end
