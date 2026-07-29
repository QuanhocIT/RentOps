tenant = Tenant.first_or_create!(subdomain: "demo") do |record|
  record.name = "Tòa Nhà Demo RentOps"
  record.phone = "0901234567"
  record.status = "active"
end

owner = User.first_or_create!(email: "admin@rentops.vn") do |record|
  record.full_name = "Quản trị viên RentOps"
  record.tenant = tenant
end

property = Property.first_or_create!(tenant: tenant, name: "Tòa Nhà A - Nam Từ Liêm") do |record|
  record.address = "Hà Nội"
end

rooms = [
  { room_number: "101", price: 3500000, status: :vacant },
  { room_number: "102", price: 3800000, status: :occupied },
  { room_number: "103", price: 3500000, status: :reserved },
  { room_number: "201", price: 4200000, status: :occupied }
]

rooms.each do |attrs|
  Room.first_or_create!(
    tenant: tenant,
    property_name: property.name,
    room_number: attrs[:room_number]
  ) do |record|
    record.price = attrs[:price]
    record.status = attrs[:status]
  end
end

contract = Contract.first_or_create!(tenant: tenant, contract_code: "CTR-20260729-001") do |record|
  record.room = Room.find_by(room_number: "102", tenant: tenant)
  record.renter = owner
  record.start_date = Date.current.beginning_of_month
  record.monthly_rent = 3800000
  record.deposit_amount = 5000000
  record.status = :active
end

MonthlyBill.first_or_create!(tenant: tenant, bill_code: "BILL-202607-001") do |record|
  record.room = contract.room
  record.contract = contract
  record.billing_month = Date.current.strftime("%Y-%m")
  record.total_amount = 3800000
  record.due_date = Date.current.end_of_month
  record.status = :issued
end

puts "Seeded RentOps demo data successfully."
