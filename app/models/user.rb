class User < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  has_secure_password validations: false

  belongs_to :tenant, optional: true

  enum :role, {
    super_admin: 0,
    owner: 1,
    cashier: 2,
    technician: 3,
    front_desk: 4,
    renter: 5
  }, default: :owner

  validates :email, uniqueness: true, allow_blank: true
  validates :full_name, presence: true

  def super_admin?
    role == "super_admin" || email == "admin@rentops.vn"
  end

  def landlord?
    owner? || super_admin?
  end

  def staff?
    cashier? || technician? || front_desk?
  end
end
