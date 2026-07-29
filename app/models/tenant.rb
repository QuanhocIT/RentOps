class Tenant < ApplicationRecord
  include Discard::Model

  belongs_to :plan, optional: true
  has_many :users, dependent: :nullify
  has_many :properties, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :monthly_bills, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :utility_readings, dependent: :destroy
  has_many :operating_expenses, dependent: :destroy
  has_many :audit_logs, dependent: :destroy
  has_many :maintenance_requests, dependent: :destroy
  has_many :amenities, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true

  def max_rooms_allowed
    plan&.max_rooms || 20
  end

  def can_add_more_rooms?
    rooms.kept.count < max_rooms_allowed
  end
end
