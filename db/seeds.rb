require_relative "../config/environment"

puts "Populating rich sample seed data for RentOps SaaS Platform..."

# 1. SaaS Plans
plan_pro = Plan.find_or_create_by!(name: "Gói Pro Enterprise") do |p|
  p.max_rooms = 500
  p.monthly_price = 799000
  p.description = "Dành cho chuỗi tòa nhà / căn hộ dịch vụ lớn"
end

plan_standard = Plan.find_or_create_by!(name: "Gói Standard") do |p|
  p.max_rooms = 50
  p.monthly_price = 299000
  p.description = "Dành cho nhà trọ quy mô vừa (tối đa 50 phòng)"
end

Plan.find_or_create_by!(name: "Gói Free") do |p|
  p.max_rooms = 10
  p.monthly_price = 0
  p.description = "Dành cho chủ trọ nhỏ (tối đa 10 phòng)"
end

# 2. Tenants & Owner Users
tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
  record.name = "Tòa Nhà Demo RentOps"
  record.phone = "0901234567"
  record.status = "active"
  record.bank_code = "MB"
  record.bank_account = "0901234567"
  record.bank_account_name = "RENTOPS DEMO"
  record.plan = plan_pro
end

owner = User.find_or_create_by!(email: "admin@rentops.vn") do |record|
  record.full_name = "Chủ Trọ Nguyễn Văn A"
  record.tenant = tenant
  record.role = :owner
end

# Renters
renter1 = User.find_or_create_by!(email: "renter102@rentops.vn") do |u|
  u.full_name = "Trần Thị Minh B"
  u.phone = "0988777666"
  u.id_card_number = "001198001234"
  u.hometown = "Nam Định"
  u.tenant = tenant
  u.role = :renter
end

renter2 = User.find_or_create_by!(email: "nam.le@rentops.vn") do |u|
  u.full_name = "Lê Hoàng Nam"
  u.phone = "0912345678"
  u.id_card_number = "034095009876"
  u.hometown = "Hải Phòng"
  u.tenant = tenant
  u.role = :renter
end

renter3 = User.find_or_create_by!(email: "huong.pham@rentops.vn") do |u|
  u.full_name = "Phạm Thị Hương"
  u.phone = "0977112233"
  u.id_card_number = "025091004321"
  u.hometown = "Thái Bình"
  u.tenant = tenant
  u.role = :renter
end

# 3. Properties & Rooms
prop1 = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà A - Nam Từ Liêm") do |record|
  record.address = "Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội"
end

prop2 = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà B - Cầu Giấy") do |record|
  record.address = "Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội"
end

services = [
  { name: "Điện sinh hoạt", unit_price: 3800, unit_name: "kWh" },
  { name: "Nước sạch", unit_price: 30000, unit_name: "m3" },
  { name: "Internet tốc độ cao", unit_price: 100000, unit_name: "tháng" },
  { name: "Vệ sinh & rác thải", unit_price: 50000, unit_name: "tháng" }
]

services.each do |s|
  Service.find_or_create_by!(tenant: tenant, name: s[:name]) do |rec|
    rec.unit_price = s[:unit_price]
    rec.unit_name = s[:unit_name]
  end
end

amenities_data = [
  { name: "Điều hòa 9000 BTU", icon: "❄️" },
  { name: "Tủ lạnh Inverter", icon: "🧊" },
  { name: "Bình nóng lạnh", icon: "🚿" },
  { name: "Giường gỗ & Nệm cao su", icon: "🛏️" },
  { name: "Tủ quần áo 3 cánh", icon: "🚪" },
  { name: "Máy giặt dùng chung", icon: "🧺" }
]

amenities_data.each do |a|
  Amenity.find_or_create_by!(tenant: tenant, name: a[:name]) do |rec|
    rec.icon = a[:icon]
  end
end

rooms_data = [
  { property: prop1, property_name: prop1.name, room_number: "101", floor: 1, price: 3500000, status: :vacant },
  { property: prop1, property_name: prop1.name, room_number: "102", floor: 1, price: 3800000, status: :occupied },
  { property: prop1, property_name: prop1.name, room_number: "103", floor: 1, price: 3500000, status: :reserved },
  { property: prop1, property_name: prop1.name, room_number: "201", floor: 2, price: 4200000, status: :occupied },
  { property: prop1, property_name: prop1.name, room_number: "202", floor: 2, price: 4500000, status: :occupied },
  { property: prop2, property_name: prop2.name, room_number: "301", floor: 3, price: 5000000, status: :vacant },
  { property: prop2, property_name: prop2.name, room_number: "302", floor: 3, price: 5200000, status: :occupied }
]

rooms_data.each do |attrs|
  r = Room.find_or_initialize_by(tenant: tenant, room_number: attrs[:room_number])
  r.property_name = attrs[:property_name]
  r.property_id = attrs[:property].id
  r.floor = attrs[:floor]
  r.price = attrs[:price]
  r.status = attrs[:status]
  r.save!
end

r102 = Room.find_by!(tenant: tenant, room_number: "102")
r201 = Room.find_by!(tenant: tenant, room_number: "201")
r202 = Room.find_by!(tenant: tenant, room_number: "202")

# 4. Room Assets
[
  { room: r102, property: prop1, name: "Điều hòa Daikin Inverter 12000 BTU", asset_code: "DH-102", category: "appliance", condition: "good", quantity: 1, purchase_price: 9500000 },
  { room: r102, property: prop1, name: "Tủ lạnh Panasonic 188L", asset_code: "TL-102", category: "appliance", condition: "good", quantity: 1, purchase_price: 6200000 },
  { room: r201, property: prop1, name: "Giường gỗ xoan đào 1.8m", asset_code: "G-201", category: "furniture", condition: "good", quantity: 1, purchase_price: 4500000 },
  { room: r201, property: prop1, name: "Bình nóng lạnh Ariston 20L", asset_code: "NL-201", category: "appliance", condition: "good", quantity: 1, purchase_price: 3100000 },
  { room: r202, property: prop1, name: "Tủ quần áo 3 cánh MDF", asset_code: "TQA-202", category: "furniture", condition: "worn", quantity: 1, purchase_price: 3800000 }
].each do |ast|
  a = RoomAsset.where(name: ast[:name]).first_or_initialize
  a.room_id = ast[:room].id
  a.property_id = ast[:property].id
  a.asset_code = ast[:asset_code]
  a.category = ast[:category]
  a.condition = ast[:condition]
  a.quantity = ast[:quantity]
  a.purchase_price = ast[:purchase_price]
  a.installed_at = Date.current - 6.months
  a.save!
end

# 5. Contracts
c102 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-202607-102") do |rec|
  rec.room = r102
  rec.renter = renter1
  rec.start_date = Date.current.beginning_of_month - 3.months
  rec.end_date = Date.current.beginning_of_month + 9.months
  rec.monthly_rent = r102.price
  rec.deposit_amount = r102.price
  rec.status = :active
  rec.signed_at = Time.current - 3.months
end

c201 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-202607-201") do |rec|
  rec.room = r201
  rec.renter = renter2
  rec.start_date = Date.current.beginning_of_month - 1.month
  rec.end_date = Date.current.beginning_of_month + 11.months
  rec.monthly_rent = r201.price
  rec.deposit_amount = r201.price
  rec.status = :active
  rec.signed_at = Time.current - 1.month
end

c202 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-202607-202") do |rec|
  rec.room = r202
  rec.renter = renter3
  rec.start_date = Date.current.beginning_of_month - 2.months
  rec.end_date = Date.current.beginning_of_month + 10.months
  rec.monthly_rent = r202.price
  rec.deposit_amount = r202.price
  rec.status = :active
  rec.signed_at = Time.current - 2.months
end

# 6. Contract Templates
ContractTemplate.find_or_create_by!(name: "Mẫu Hợp Đồng Thuê Nhà Trọ Chuẩn 2026") do |t|
  t.content = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n\nHỢP ĐỒNG CHO THUÊ PHÒNG TRỌ\n\nBên A (Bên cho thuê): {{landlord_name}} - SĐT: {{landlord_phone}}\nBên B (Bên thuê): {{tenant_name}} - CCCD: {{tenant_id_card}}\n\nHai bên thống nhất cho thuê phòng {{room_number}} tại {{property_address}} với giá {{monthly_rent}} VNĐ/tháng. Đặt cọc {{deposit_amount}} VNĐ."
  t.is_default = true
  t.description = "Mẫu hợp đồng đầy đủ điều khoản pháp lý về cọc, thanh toán và hủy hợp đồng."
end

# 7. Utility Readings
current_month = Date.current.strftime("%Y-%m")
prev_month = (Date.current - 1.month).strftime("%Y-%m")

UtilityReading.find_or_create_by!(tenant: tenant, room: r102, billing_month: current_month) do |u|
  u.electric_old = 1200
  u.electric_new = 1350
  u.water_old = 40
  u.water_new = 48
  u.note = "Chỉ số điện nước tháng 7"
end

UtilityReading.find_or_create_by!(tenant: tenant, room: r201, billing_month: current_month) do |u|
  u.electric_old = 850
  u.electric_new = 980
  u.water_old = 25
  u.water_new = 32
  u.note = "Chỉ số điện nước tháng 7"
end

# 8. Monthly Bills & Payment Transactions
bill102 = MonthlyBill.find_or_create_by!(tenant: tenant, bill_code: "BILL-202607-102") do |b|
  b.room = r102
  b.contract = c102
  b.billing_month = current_month
  b.room_fee = 3800000
  b.utility_fee = (150 * 3800) + (8 * 30000)
  b.service_fee = 150000
  b.total_amount = b.room_fee + b.utility_fee + b.service_fee
  b.due_date = Date.current.end_of_month
  b.status = :issued
  b.bank_code = tenant.bank_code
  b.bank_account = tenant.bank_account
  b.bank_account_name = tenant.bank_account_name
end

bill201 = MonthlyBill.find_or_create_by!(tenant: tenant, bill_code: "BILL-202607-201") do |b|
  b.room = r201
  b.contract = c201
  b.billing_month = current_month
  b.room_fee = 4200000
  b.utility_fee = (130 * 3800) + (7 * 30000)
  b.service_fee = 150000
  b.total_amount = b.room_fee + b.utility_fee + b.service_fee
  b.due_date = Date.current.end_of_month
  b.status = :paid
  b.paid_at = Time.current - 1.day
  b.bank_code = tenant.bank_code
  b.bank_account = tenant.bank_account
  b.bank_account_name = tenant.bank_account_name
end

PaymentTransaction.find_or_create_by!(transaction_code: "FT26070019283") do |p|
  p.monthly_bill = bill201
  p.tenant = tenant
  p.amount = bill201.total_amount
  p.payment_method = "vietqr"
  p.status = "completed"
  p.bank_name = "MB Bank"
  p.account_number = "0901234567"
  p.description = "BILL-202607-201"
  p.paid_at = Time.current - 1.day
end

# 9. Maintenance Requests
MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Sửa vòi nước nhà vệ sinh bị rò rỉ") do |m|
  m.room = r102
  m.renter = renter1
  m.description = "Vòi sen tắm bị rỉ nước liên tục"
  m.priority = :medium
  m.status = :resolved
  m.cost = 150000
  m.resolved_at = Time.current - 2.days
end

MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Kiểm tra điều hòa chảy nước") do |m|
  m.room = r201
  m.renter = renter2
  m.description = "Điều hòa phòng 201 thổi hơi không mát và bị nhỏ giọt nước xuống sàn"
  m.priority = :high
  m.status = :in_progress
  m.cost = 250000
end

# 10. Operating Expenses
OperatingExpense.find_or_create_by!(tenant: tenant, title: "Sửa máy bơm nước tầng 1") do |e|
  e.property = prop1
  e.category = "sửa chữa"
  e.amount = 450000
  e.expense_date = Date.current - 5.days
  e.note = "Thay tụ điện máy bơm"
end

OperatingExpense.find_or_create_by!(tenant: tenant, title: "Thanh toán Wifi tổng tòa A") do |e|
  e.property = prop1
  e.category = "internet"
  e.amount = 600000
  e.expense_date = Date.current - 10.days
  e.note = "Gói Fiber 200Mbps"
end

# 11. Audit Logs & Notifications
AuditLog.log_action(
  tenant: tenant,
  user: owner,
  action: "CREATE_CONTRACT",
  record: c102,
  payload: { contract_code: c102.contract_code, monthly_rent: c102.monthly_rent }
)

Notification.find_or_create_by!(tenant: tenant, recipient_name: "Trần Thị Minh B") do |n|
  n.recipient_phone = "0988777666"
  n.channel = "zns"
  n.content = "RentOps Nhắc Nợ: Hóa đơn BILL-202607-102 phòng 102 tiền phòng 4.760.000đ chưa được thanh toán."
  n.status = :sent
  n.sent_at = Time.current - 1.day
end

puts "RentOps sample seed data populated successfully!"
