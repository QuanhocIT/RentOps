# Script to seed dedicated renter user account and linked sample data

tenant = Tenant.first_or_create!(subdomain: "demo") do |t|
  t.name = "Tòa Nhà Demo RentOps"
  t.phone = "0901234567"
  t.bank_code = "MB"
  t.bank_account = "0908123456"
  t.bank_account_name = "RENTOPS DEMO"
end

# 1. Create Main Renter Account (renter@rentops.vn)
main_renter = User.find_or_initialize_by(email: "renter@rentops.vn")
main_renter.update!(
  full_name: "Nguyễn Văn An (Cư Dân Demo)",
  phone: "0988888999",
  id_card_number: "001199005678",
  hometown: "Hà Nội",
  role: :renter,
  password: "Password123!",
  tenant: tenant
)

# 2. Also ensure renter102@rentops.vn is present and has renter role
renter102 = User.find_or_initialize_by(email: "renter102@rentops.vn")
renter102.update!(
  full_name: "Trần Thị Minh B",
  phone: "0988777666",
  id_card_number: "001198001234",
  hometown: "Nam Định",
  role: :renter,
  password: "Password123!",
  tenant: tenant
)

# 3. Create Property & Room 102
property = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà RentOps A - Nam Từ Liêm") do |p|
  p.address = "Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội"
end

room102 = Room.find_or_initialize_by(tenant: tenant, room_number: "102")
room102.update!(
  property_name: property.name,
  property_id: property.id,
  floor: 1,
  price: 3800000,
  status: :occupied,
  area: 28.0
)

# 4. Create Active Contract for main_renter
contract = Contract.find_or_initialize_by(tenant: tenant, contract_code: "CTR-2026-102")
contract.update!(
  room: room102,
  renter: main_renter,
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  monthly_rent: 3800000,
  deposit_amount: 3800000,
  status: :active,
  signed_at: Time.zone.parse("2026-01-01 09:00:00")
)

# 5. Create Co-Tenants
CoTenant.find_or_create_by!(contract: contract, full_name: "Lê Thị Mai") do |c|
  c.phone = "0912345678"
  c.id_card_number = "001198777666"
  c.temporary_residence_status = "registered"
end

# 6. Create Room Assets
RoomAsset.find_or_create_by!(room_id: room102.id, asset_code: "DH-102") do |a|
  a.property = property
  a.name = "Điều hòa Daikin Inverter 12000 BTU"
  a.category = "appliance"
  a.condition = "good"
  a.quantity = 1
  a.purchase_price = 9500000
  a.installed_at = Date.new(2026, 1, 15)
end

RoomAsset.find_or_create_by!(room_id: room102.id, asset_code: "TL-102") do |a|
  a.property = property
  a.name = "Tủ lạnh Panasonic 180L NoFrost"
  a.category = "appliance"
  a.condition = "good"
  a.quantity = 1
  a.purchase_price = 6800000
  a.installed_at = Date.new(2026, 1, 15)
end

RoomAsset.find_or_create_by!(room_id: room102.id, asset_code: "GG-102") do |a|
  a.property = property
  a.name = "Bộ giường gỗ sồi 1m8 x 2m + Nệm cao su"
  a.category = "furniture"
  a.condition = "good"
  a.quantity = 1
  a.purchase_price = 8500000
  a.installed_at = Date.new(2026, 1, 10)
end

# 7. Create Utility Readings
UtilityReading.find_or_create_by!(tenant: tenant, room: room102, billing_month: "2026-07") do |u|
  u.electric_old = 1200
  u.electric_new = 1350
  u.water_old = 40
  u.water_new = 48
  u.note = "Chỉ số điện nước tháng 7/2026"
end

UtilityReading.find_or_create_by!(tenant: tenant, room: room102, billing_month: "2026-06") do |u|
  u.electric_old = 1060
  u.electric_new = 1200
  u.water_old = 33
  u.water_new = 40
  u.note = "Chỉ số điện nước tháng 6/2026"
end

# 8. Create Monthly Bills
# Current Month Bill (Tháng 07/2026 - ISSUED / CHỜ THANH TOÁN)
bill_jul = MonthlyBill.find_or_initialize_by(tenant: tenant, bill_code: "BILL-202607-102")
bill_jul.room = room102
bill_jul.contract = contract
bill_jul.billing_month = "2026-07"
bill_jul.room_fee = 3800000
bill_jul.utility_fee = 650000
bill_jul.service_fee = 150000
bill_jul.total_amount = 4600000
bill_jul.remaining_amount = 4600000
bill_jul.due_date = Date.new(2026, 7, 31)
bill_jul.status = :issued
bill_jul.bank_code = "MB"
bill_jul.bank_account = "0908123456"
bill_jul.bank_account_name = "RENTOPS DEMO"
bill_jul.save!

# Previous Month Bill (Tháng 06/2026 - PAID / ĐÃ THANH TOÁN)
bill_jun = MonthlyBill.find_or_initialize_by(tenant: tenant, bill_code: "BILL-202606-102")
bill_jun.room = room102
bill_jun.contract = contract
bill_jun.billing_month = "2026-06"
bill_jun.room_fee = 3800000
bill_jun.utility_fee = 600000
bill_jun.service_fee = 150000
bill_jun.total_amount = 4550000
bill_jun.paid_amount = 4550000
bill_jun.remaining_amount = 0
bill_jun.due_date = Date.new(2026, 6, 30)
bill_jun.paid_at = Time.zone.parse("2026-06-05 10:30:00")
bill_jun.status = :paid
bill_jun.bank_code = "MB"
bill_jun.bank_account = "0908123456"
bill_jun.bank_account_name = "RENTOPS DEMO"
bill_jun.save!

# 9. Create Maintenance Requests
MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Sửa vòi nước rửa mặt bị rò rỉ") do |m|
  m.room = room102
  m.renter = main_renter
  m.description = "Vòi nước chậu rửa mặt phòng vệ sinh bị rỉ nước liên tục gây thất thoát nước"
  m.priority = :medium
  m.status = :resolved
  m.cost = 150000
  m.cost_bearer = :owner
  m.resolved_at = Time.zone.parse("2026-07-20 14:00:00")
end

MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Kiểm tra bảo dưỡng định kỳ máy điều hòa") do |m|
  m.room = room102
  m.renter = main_renter
  m.description = "Yêu cầu vệ sinh lưới lọc và nạp gas bổ sung cho máy điều hòa Daikin"
  m.priority = :low
  m.status = :in_progress
  m.cost = 200000
  m.cost_bearer = :owner
end

# 10. Create Notifications
Notification.find_or_create_by!(tenant: tenant, content: "Hóa đơn tiền nhà tháng 07/2026 của phòng 102 đã được phát hành với tổng số tiền 4,600,000 VNĐ. Vui lòng thanh toán trước ngày 31/07/2026.") do |n|
  n.recipient_name = main_renter.full_name
  n.recipient_phone = main_renter.phone
  n.channel = "in_app"
  n.status = :sent
  n.created_at = Time.zone.parse("2026-07-01 08:00:00")
end

Notification.find_or_create_by!(tenant: tenant, content: "Ban quản lý thông báo lịch súc rửa bể nước và bảo trì hệ thống nước sinh hoạt tòa nhà A vào ngày 05/08/2026 (từ 08:00 đến 11:30).") do |n|
  n.recipient_name = main_renter.full_name
  n.recipient_phone = main_renter.phone
  n.channel = "zns"
  n.status = :sent
  n.created_at = Time.zone.parse("2026-07-28 09:30:00")
end

puts "SUCCESS: Seeded renter account #{main_renter.email} successfully!"
