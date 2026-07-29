class AddSignatureAndDepositFields < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :tenant_signature, :text unless column_exists?(:contracts, :tenant_signature)
    add_column :contracts, :landlord_signature, :text unless column_exists?(:contracts, :landlord_signature)
    add_column :contracts, :signed_at, :datetime unless column_exists?(:contracts, :signed_at)
    add_column :contracts, :deposit_status, :string, default: "held" unless column_exists?(:contracts, :deposit_status) # held, refunded, forfeited, partially_refunded
    add_column :contracts, :deposit_refunded_amount, :decimal, precision: 12, scale: 2, default: 0.0 unless column_exists?(:contracts, :deposit_refunded_amount)
    
    add_column :monthly_bills, :qr_code_url, :string unless column_exists?(:monthly_bills, :qr_code_url)
    add_column :monthly_bills, :payment_reference, :string unless column_exists?(:monthly_bills, :payment_reference)
  end
end
