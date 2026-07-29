class ContractTemplate < ApplicationRecord
  validates :name, :content, presence: true

  scope :default_templates, -> { where(is_default: true) }
end
