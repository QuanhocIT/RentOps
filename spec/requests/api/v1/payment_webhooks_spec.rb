require 'rails_helper'

RSpec.describe "Api::V1::PaymentWebhooks", type: :request do
  describe "POST /api/v1/webhooks/sepay" do
    let!(:tenant) { Tenant.first || Tenant.create!(name: "Test Tenant", subdomain: "test", phone: "0900000000") }
    let!(:property) { Property.first || Property.create!(tenant: tenant, name: "Tòa A", address: "123 Đường ABC") }
    let!(:room) { Room.first || Room.create!(tenant: tenant, property: property, room_number: "101", price: 3500000, status: :occupied) }
    let!(:bill) do
      MonthlyBill.create!(
        tenant: tenant,
        room: room,
        bill_code: "BILL-202607-101",
        billing_month: "2026-07",
        room_fee: 3500000,
        total_amount: 3500000,
        paid_amount: 0,
        due_date: Date.current,
        status: :issued
      )
    end

    it "automatically reconciles bill when valid webhook is received" do
      post "/api/v1/payment_webhooks/sepay", params: {
        content: "Thanh toan BILL-202607-101",
        transferAmount: 3500000,
        referenceCode: "SEPAY-TEST-999"
      }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["data"]["bill_code"]).to eq("BILL-202607-101")
      expect(json["data"]["new_status"]).to eq("paid")

      bill.reload
      expect(bill.status).to eq("paid")
      expect(bill.paid_amount).to eq(3500000)
    end
  end
end
