class User < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant, optional: true

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
end
