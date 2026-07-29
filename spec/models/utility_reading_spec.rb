require 'rails_helper'

RSpec.describe UtilityReading, type: :model do
  let(:tenant) { Tenant.create!(name: "Test Tenant", subdomain: "test-#{Time.current.to_i}") }
  let(:room) { Room.create!(tenant: tenant, property_name: "Tòa A", room_number: "P101", price: 3000000) }

  it "calculates normal usage correctly" do
    reading = UtilityReading.new(
      tenant: tenant,
      room: room,
      billing_month: "2026-07",
      electric_old: 100,
      electric_new: 150,
      water_old: 10,
      water_new: 15
    )
    expect(reading.electric_usage).to eq(50)
    expect(reading.water_usage).to eq(5)
    expect(reading.valid?).to be true
  end

  it "validates that new reading cannot be less than old reading unless meter_reset is set" do
    reading = UtilityReading.new(
      tenant: tenant,
      room: room,
      billing_month: "2026-07",
      electric_old: 200,
      electric_new: 150,
      meter_reset: false
    )
    expect(reading.valid?).to be false
    expect(reading.errors[:electric_new]).to be_present

    reading.meter_reset = true
    expect(reading.electric_usage).to eq(150)
    expect(reading.valid?).to be true
  end
end
