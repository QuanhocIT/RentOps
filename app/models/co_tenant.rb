class CoTenant < ApplicationRecord
  belongs_to :contract
  belongs_to :user, optional: true

  validates :full_name, presence: true

  enum :temporary_residence_status, {
    pending: "pending",
    registered: "registered",
    expired: "expired"
  }, default: "pending"
end
