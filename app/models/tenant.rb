class Tenant < ApplicationRecord
  include Discard::Model

  has_many :users, dependent: :nullify
  has_many :rooms, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
end
