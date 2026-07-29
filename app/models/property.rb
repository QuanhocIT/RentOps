class Property < ApplicationRecord
  include Discard::Model
  acts_as_tenant(:tenant)

  belongs_to :tenant
  has_many :rooms, dependent: :destroy

  validates :name, presence: true
end
