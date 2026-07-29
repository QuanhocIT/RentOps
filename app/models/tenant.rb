class Tenant < ApplicationRecord
  include Discard::Model

  has_many :users, dependent: :nullify
  has_many :properties, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :monthly_bills, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
end
