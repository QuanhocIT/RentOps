class AuditLog < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :user, optional: true

  validates :action, presence: true
  validates :record_type, presence: true

  def self.log_action(tenant:, user:, action:, record:, payload: {})
    create!(
      tenant: tenant,
      user: user,
      action: action,
      record_type: record.class.name,
      record_id: record&.id,
      payload: payload.to_json
    )
  end
end
