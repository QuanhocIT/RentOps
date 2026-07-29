class Notification < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant

  enum :status, { pending: 0, sent: 1, failed: 2 }

  validates :recipient_name, presence: true
  validates :content, presence: true
end
