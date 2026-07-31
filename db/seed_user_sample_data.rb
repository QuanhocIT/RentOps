# Script to seed sample renter data for all renter accounts in database

tenant = Tenant.first_or_create!(subdomain: "demo") do |t|
  t.name = "Tòa Nhà Demo RentOps"
  t.phone = "0901234567"
  t.bank_code = "MB"
  t.bank_account = "0908123456"
  t.bank_account_name = "RENTOPS DEMO"
end

property = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà RentOps A - Nam Từ Liêm") do |p|
  p.address = "Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội"
end

renters = User.where(role: :renter)

renters.each_with_index do |renter, index|
  room_num = (102 + index).to_s

  room = Room.find_or_initialize_by(tenant: tenant, room_number: room_num)
  room.update!(
    property_name: property.name,
    property_id: property.id,
    floor: 1 + (index / 4),
    price: 3800000 + (index * 200000),
    status: :occupied,
    area: 28.0 + index
  )

  contract = Contract.find_or_initialize_by(tenant: tenant, contract_code: "CTR-2026-#{room_num}")
  contract.update!(
    room: room,
    renter: renter,
    start_date: Date.new(2026, 1, 1),
    end_date: Date.new(2026, 12, 31),
    monthly_rent: room.price,
    deposit_amount: room.price,
    status: :active,
    signed_at: Time.zone.parse("2026-01-01 09:00:00")
  )

  CoTenant.find_or_create_by!(contract: contract, full_name: "Lê Thị Mai") do |c|
    c.phone = "0912345678"
    c.id_card_number = "001198777666"
    c.temporary_residence_status = "registered"
  end

  RoomAsset.find_or_create_by!(room_id: room.id, asset_code: "DH-#{room_num}") do |a|
    a.property = property
    a.name = "Điều hòa Daikin Inverter 12000 BTU"
    a.category = "appliance"
    a.condition = "good"
    a.quantity = 1
    a.purchase_price = 9500000
    a.installed_at = Date.new(2026, 1, 15)
  end

  RoomAsset.find_or_create_by!(room_id: room.id, asset_code: "TL-#{room_num}") do |a|
    a.property = property
    a.name = "Tủ lạnh Panasonic 180L NoFrost"
    a.category = "appliance"
    a.condition = "good"
    a.quantity = 1
    a.purchase_price = 6800000
    a.installed_at = Date.new(2026, 1, 15)
  end

  UtilityReading.find_or_create_by!(tenant: tenant, room: room, billing_month: "2026-07") do |u|
    u.electric_old = 1200 + (index * 50)
    u.electric_new = 1350 + (index * 50)
    u.water_old = 40 + (index * 5)
    u.water_new = 48 + (index * 5)
    u.note = "Chỉ số điện nước tháng 7/2026"
  end

  # Monthly Bill July 2026 (Issued)
  bill_jul = MonthlyBill.find_or_initialize_by(tenant: tenant, bill_code: "BILL-202607-#{room_num}")
  bill_jul.room = room
  bill_jul.contract = contract
  bill_jul.billing_month = "2026-07"
  bill_jul.room_fee = room.price
  bill_jul.utility_fee = 650000
  bill_jul.service_fee = 150000
  bill_jul.total_amount = room.price + 800000
  bill_jul.remaining_amount = room.price + 800000
  bill_jul.due_date = Date.new(2026, 7, 31)
  bill_jul.status = :issued
  bill_jul.bank_code = "MB"
  bill_jul.bank_account = "0908123456"
  bill_jul.bank_account_name = "RENTOPS DEMO"
  bill_jul.save!

  # Monthly Bill June 2026 (Paid)
  bill_jun = MonthlyBill.find_or_initialize_by(tenant: tenant, bill_code: "BILL-202606-#{room_num}")
  bill_jun.room = room
  bill_jun.contract = contract
  bill_jun.billing_month = "2026-06"
  bill_jun.room_fee = room.price
  bill_jun.utility_fee = 600000
  bill_jun.service_fee = 150000
  bill_jun.total_amount = room.price + 750000
  bill_jun.paid_amount = room.price + 750000
  bill_jun.remaining_amount = 0
  bill_jun.due_date = Date.new(2026, 6, 30)
  bill_jun.paid_at = Time.zone.parse("2026-06-05 10:30:00")
  bill_jun.status = :paid
  bill_jun.bank_code = "MB"
  bill_jun.bank_account = "0908123456"
  bill_jun.bank_account_name = "RENTOPS DEMO"
  bill_jun.save!

  MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Sửa vòi nước rửa mặt bị rò rỉ") do |m|
    m.room = room
    m.renter = renter
    m.description = "Vòi nước chậu rửa mặt phòng vệ sinh bị rỉ nước liên tục gây thất thoát nước"
    m.priority = :medium
    m.status = :resolved
    m.cost = 150000
    m.cost_bearer = :owner
    m.resolved_at = Time.zone.parse("2026-07-20 14:00:00")
  end

  MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Kiểm tra bảo dưỡng định kỳ máy điều hòa") do |m|
    m.room = room
    m.renter = renter
    m.description = "Yêu cầu vệ sinh lưới lọc và nạp gas bổ sung cho máy điều hòa Daikin"
    m.priority = :low
    m.status = :in_progress
    m.cost = 200000
    m.cost_bearer = :owner
  end

  Notification.find_or_create_by!(tenant: tenant, content: "Hóa đơn tiền nhà tháng 07/2026 của phòng #{room_num} đã được phát hành. Vui lòng thanh toán trước ngày 31/07/2026.") do |n|
    n.recipient_name = renter.full_name
    n.recipient_phone = renter.phone
    n.channel = "in_app"
    n.status = :sent
    n.created_at = Time.zone.parse("2026-07-01 08:00:00")
  end

  puts "SUCCESS: Seeded sample data for renter #{renter.email} (#{renter.full_name}) on Room #{room_num}"
end
