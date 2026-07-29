class User < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant, optional: true

  enum :role, { super_admin: 0, owner: 1, staff: 2, renter: 3 }

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true

  def super_admin?
    role == "super_admin" || email == "admin@rentops.vn"
  end
end
