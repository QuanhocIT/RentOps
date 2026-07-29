class CreatePaymentTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_transactions do |t|
      t.references :monthly_bill, foreign_key: true, null: true
      t.references :tenant, foreign_key: true, null: true
      t.string :transaction_code, null: false
      t.decimal :amount, precision: 12, scale: 2, default: 0.0
      t.string :payment_method, default: "vietqr" # vietqr, bank_transfer, cash, momo
      t.string :status, default: "completed" # pending, completed, failed
      t.string :bank_name
      t.string :account_number
      t.text :description
      t.text :raw_payload
      t.datetime :paid_at

      t.timestamps
    end

    add_index :payment_transactions, :transaction_code, unique: true
  end
end
