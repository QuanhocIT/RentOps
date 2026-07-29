require_relative "../config/environment"

# SaaS Plans
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

tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
  record.name = "Tòa Nhà Demo RentOps"
  record.phone = "0901234567"
  record.status = "active"
  record.bank_code = "MB"
  record.bank_account = "0901234567"
  record.bank_account_name = "RENTOPS DEMO"
  record.plan = plan_standard
end

owner = User.find_or_create_by!(email: "admin@rentops.vn") do |record|
  record.full_name = "Chủ Trọ Nguyễn Văn A"
  record.tenant = tenant
  record.role = :owner
end

renter1 = User.find_or_create_by!(email: "renter102@rentops.vn") do |u|
  u.full_name = "Trần Thị Minh B"
  u.phone = "0988777666"
  u.id_card_number = "001198001234"
  u.hometown = "Nam Định"
  u.tenant = tenant
  u.role = :renter
end

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

c102 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-202607-102") do |rec|
  rec.room = r102
  rec.renter = renter1
  rec.start_date = Date.current.beginning_of_month - 3.months
  rec.end_date = Date.current.beginning_of_month + 9.months
  rec.monthly_rent = r102.price
  rec.deposit_amount = r102.price
  rec.status = :active
end

c201 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-202607-201") do |rec|
  rec.room = r201
  rec.renter = owner
  rec.start_date = Date.current.beginning_of_month - 1.month
  rec.end_date = Date.current.beginning_of_month + 11.months
  rec.monthly_rent = r201.price
  rec.deposit_amount = r201.price
  rec.status = :active
end

# Maintenance Requests
MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Sửa vòi nước nhà vệ sinh bị rò rỉ") do |m|
  m.room = r102
  m.renter = renter1
  m.description = "Vòi sen tắm bị rỉ nước liên tục"
  m.priority = :medium
  m.status = :resolved
  m.cost = 150000
  m.resolved_at = Time.current - 2.days
end

# Audit Logs
AuditLog.log_action(
  tenant: tenant,
  user: owner,
  action: "CREATE_CONTRACT",
  record: c102,
  payload: { contract_code: c102.contract_code, monthly_rent: c102.monthly_rent }
)

# Notifications
Notification.find_or_create_by!(tenant: tenant, recipient_name: "Trần Thị Minh B") do |n|
  n.recipient_phone = "0988777666"
  n.channel = "zns"
  n.content = "RentOps Nhắc Nợ: Hóa đơn BILL-202607-102 phòng 102 tiền phòng 4.760.000đ chưa được thanh toán."
  n.status = :sent
  n.sent_at = Time.current - 1.day
end

# Utility Readings
current_month = Date.current.strftime("%Y-%m")
UtilityReading.find_or_create_by!(tenant: tenant, room: r102, billing_month: current_month) do |u|
  u.electric_old = 1200
  u.electric_new = 1350
  u.water_old = 40
  u.water_new = 48
  u.note = "Nhập chỉ số tháng 7"
end

UtilityReading.find_or_create_by!(tenant: tenant, room: r201, billing_month: current_month) do |u|
  u.electric_old = 850
  u.electric_new = 980
  u.water_old = 25
  u.water_new = 32
  u.note = "Nhập chỉ số tháng 7"
end

# Monthly Bills
MonthlyBill.find_or_create_by!(tenant: tenant, bill_code: "BILL-202607-102") do |b|
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

# Operating Expenses
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

puts "RentOps seed data populated successfully."
