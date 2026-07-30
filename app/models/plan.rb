class Plan < ApplicationRecord
  include Discard::Model

  has_many :tenants, dependent: :nullify

  validates :name, presence: true
  validates :max_rooms, numericality: { greater_than: 0 }

  def max_properties_allowed
    max_properties || 5
  end
end
