require_relative "../config/environment"

puts "Populating rich 6+ months sample seed data for RentOps SaaS Platform..."

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

# 2. Users & Tenants
super_admin = ActsAsTenant.without_tenant do
  User.find_or_create_by!(email: "superadmin@rentops.vn") do |u|
    u.full_name = "Super Admin Hệ Thống"
    u.role = :super_admin
    u.password = "Password123!"
    u.tenant = nil
  end
end

tenant = ActsAsTenant.without_tenant do
  Tenant.first_or_create!(subdomain: "demo") do |t|
    t.name = "Chuỗi Căn Hộ Dịch Vụ RentOps Demo"
    t.phone = "0901234567"
    t.status = "active"
    t.bank_code = "MB"
    t.bank_account = "0901234567"
    t.bank_account_name = "RENTOPS DEMO"
    t.plan = plan_pro
  end
end

ActsAsTenant.with_tenant(tenant) do
  owner = User.find_or_create_by!(email: "admin@rentops.vn") do |u|
    u.full_name = "Chủ Trọ Nguyễn Văn A"
    u.tenant = tenant
    u.role = :owner
    u.password = "Password123!"
    u.phone = "0901234567"
    u.vehicle_plate = "29A-88888"
    u.emergency_contact = "0909999888 (Vợ A)"
  end

  # 3. Renters Seed (22 Renters)
  renters_seed = [
    { email: "renter102@rentops.vn", full_name: "Trần Thị Minh B", phone: "0988777666", id_card_number: "001198001234", hometown: "Nam Định", vehicle_plate: "18B1-99234", emergency_contact: "0988000111 (Mẹ B)" },
    { email: "nam.le@rentops.vn", full_name: "Lê Hoàng Nam", phone: "0912345678", id_card_number: "034095009876", hometown: "Hải Phòng", vehicle_plate: "15B2-45678", emergency_contact: "0912000222 (Bố Nam)" },
    { email: "huong.pham@rentops.vn", full_name: "Phạm Thị Hương", phone: "0977112233", id_card_number: "025091004321", hometown: "Thái Bình", vehicle_plate: "17M1-12389", emergency_contact: "0977000333 (Anh Hương)" },
    { email: "tuan.anh@rentops.vn", full_name: "Nguyễn Tuấn Anh", phone: "0966554433", id_card_number: "001099005566", hometown: "Hà Nội", vehicle_plate: "29E1-66778", emergency_contact: "0966000444 (Mẹ Tuấn)" },
    { email: "thu.ha@rentops.vn", full_name: "Đỗ Thu Hà", phone: "0933445566", id_card_number: "036197008899", hometown: "Thanh Hóa", vehicle_plate: "36B3-33445", emergency_contact: "0933000555 (Chị Hà)" },
    { email: "hoang.long@rentops.vn", full_name: "Vũ Hoàng Long", phone: "0944112233", id_card_number: "001095001122", hometown: "Bắc Ninh", vehicle_plate: "99A1-12345", emergency_contact: "0944000666 (Bố Long)" },
    { email: "mai.anh@rentops.vn", full_name: "Nguyễn Mai Anh", phone: "0922334455", id_card_number: "031198003344", hometown: "Hải Dương", vehicle_plate: "34C1-88990", emergency_contact: "0922000777 (Mẹ Mai)" },
    { email: "quang.khai@rentops.vn", full_name: "Trần Quang Khải", phone: "0955667788", id_card_number: "038096005566", hometown: "Nghệ An", vehicle_plate: "37D1-55667", emergency_contact: "0955000888 (Anh Khải)" },
    { email: "yen.nhi@rentops.vn", full_name: "Lê Yến Nhi", phone: "0977889900", id_card_number: "079199007788", hometown: "TP.HCM", vehicle_plate: "59F1-22334", emergency_contact: "0977000999 (Mẹ Nhi)" },
    { email: "minh.duc@rentops.vn", full_name: "Hoàng Minh Đức", phone: "0988990011", id_card_number: "075094008899", hometown: "Đồng Nai", vehicle_plate: "60B1-66778", emergency_contact: "0988000123 (Bố Đức)" },
    { email: "huyen.trang@rentops.vn", full_name: "Đặng Huyền Trang", phone: "0911223344", id_card_number: "001197004455", hometown: "Vĩnh Phúc", vehicle_plate: "88H1-11223", emergency_contact: "0911000234 (Chị Trang)" },
    { email: "bao.nam@rentops.vn", full_name: "Bùi Bảo Nam", phone: "0933221100", id_card_number: "035096001122", hometown: "Hà Nam", vehicle_plate: "90A1-33445", emergency_contact: "0933000345 (Bố Nam)" },
    { email: "thanh.thao@rentops.vn", full_name: "Phan Thanh Thảo", phone: "0966778899", id_card_number: "040198006677", hometown: "Quảng Ninh", vehicle_plate: "14K1-55667", emergency_contact: "0966000456 (Mẹ Thảo)" },
    { email: "viet.dung@rentops.vn", full_name: "Ngô Việt Dũng", phone: "0944556677", id_card_number: "001093002233", hometown: "Hà Nội", vehicle_plate: "29F1-88990", emergency_contact: "0944000567 (Vợ Dũng)" },
    { email: "ngoc.anh@rentops.vn", full_name: "Trịnh Ngọc Anh", phone: "0922110099", id_card_number: "037199008899", hometown: "Ninh Bình", vehicle_plate: "35B1-44556", emergency_contact: "0922000678 (Bố Ngọc)" },
    { email: "anh.tuan@rentops.vn", full_name: "Dương Anh Tuấn", phone: "0988664422", id_card_number: "068095007788", hometown: "Lâm Đồng", vehicle_plate: "49M1-22334", emergency_contact: "0988000789 (Anh Tuấn)" },
    { email: "kim.ngan@rentops.vn", full_name: "Cao Kim Ngân", phone: "0911335577", id_card_number: "080198001122", hometown: "Long An", vehicle_plate: "62G1-77889", emergency_contact: "0911000890 (Mẹ Ngân)" },
    { email: "duc.thinh@rentops.vn", full_name: "Đinh Đức Thịnh", phone: "0933557799", id_card_number: "077097003344", hometown: "Bà Rịa", vehicle_plate: "72C1-11223", emergency_contact: "0933000901 (Bố Thịnh)" },
    { email: "phuong.thao@rentops.vn", full_name: "Võ Phương Thảo", phone: "0966442200", id_card_number: "086199005566", hometown: "Bình Dương", vehicle_plate: "61D1-33445", emergency_contact: "0966000012 (Chị Thảo)" },
    { email: "hoang.kiet@rentops.vn", full_name: "Lương Hoàng Kiệt", phone: "0944220088", id_card_number: "083096007788", hometown: "Bến Tre", vehicle_plate: "71B1-55667", emergency_contact: "0944000123 (Anh Kiệt)" },
    { email: "truc.quynh@rentops.vn", full_name: "Lý Trúc Quỳnh", phone: "0922008866", id_card_number: "087198009900", hometown: "Đồng Tháp", vehicle_plate: "66C1-88990", emergency_contact: "0922000234 (Mẹ Quỳnh)" },
    { email: "dinh.khang@rentops.vn", full_name: "Hồ Đình Khang", phone: "0955443322", id_card_number: "091094002233", hometown: "Kiên Giang", vehicle_plate: "68A1-44556", emergency_contact: "0955000345 (Bố Khang)" }
  ]

  created_renters = renters_seed.map do |rdata|
    User.find_or_create_by!(email: rdata[:email]) do |u|
      u.full_name = rdata[:full_name]
      u.phone = rdata[:phone]
      u.id_card_number = rdata[:id_card_number]
      u.hometown = rdata[:hometown]
      u.vehicle_plate = rdata[:vehicle_plate]
      u.emergency_contact = rdata[:emergency_contact]
      u.id_card_issue_date = Date.new(2021, 5, 15)
      u.tenant = tenant
      u.role = :renter
      u.password = "Password123!"
    end
  end

  # 4. Properties (8 Properties with diverse property_type)
  props_seed = [
    { name: "Tòa A - Nam Từ Liêm", address: "Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội", property_type: "phong_tro", description: "Dãy nhà trọ sinh viên & người đi làm khép kín" },
    { name: "Tòa B - Cầu Giấy", address: "Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội", property_type: "chung_cu_mini", description: "Tòa chung cư mini 7 tầng có thang máy" },
    { name: "Tòa C - Bình Thạnh", address: "Số 120 Điện Biên Phủ, P. 17, Bình Thạnh, TP.HCM", property_type: "can_ho_cao_cap", description: "Khu căn hộ dịch vụ cao cấp full nội thất" },
    { name: "Tòa D - Thanh Xuân", address: "Số 45 Nguyễn Trãi, Thanh Xuân, Hà Nội", property_type: "nha_nguyen_can", description: "Nhà nguyên căn 4 tầng cho gia đình/nhóm ở" },
    { name: "Tòa E - Đống Đa", address: "Số 102 Chùa Bộc, Đống Đa, Hà Nội", property_type: "chung_cu_mini", description: "Chung cư mini cao cấp gần đại học" },
    { name: "Tòa F - Quận 1", address: "Số 250 Nguyễn Trãi, P. Phạm Ngũ Lão, Q.1, TP.HCM", property_type: "can_ho_cao_cap", description: "Căn hộ trung tâm Q1 full dịch vụ" },
    { name: "Tòa G - Quận 7", address: "Số 80 Nguyễn Thị Thập, P. Tân Hưng, Q.7, TP.HCM", property_type: "chung_cu_mini", description: "Chung cư mini gần Sunrise City" },
    { name: "Tòa H - Thủ Đức", address: "Số 15 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức", property_type: "phong_tro", description: "Khu nhà trọ an ninh cao" }
  ]

  created_props = props_seed.map do |pdata|
    Property.find_or_create_by!(tenant: tenant, name: pdata[:name]) do |p|
      p.address = pdata[:address]
      p.property_type = pdata[:property_type]
      p.description = pdata[:description]
    end
  end

  # 5. Services & Amenities
  services_seed = [
    { name: "Điện sinh hoạt", unit_price: 3800, unit_name: "kWh" },
    { name: "Nước sạch", unit_price: 30000, unit_name: "m3" },
    { name: "Internet 200Mbps", unit_price: 100000, unit_name: "tháng" },
    { name: "Vệ sinh & Rác thải", unit_price: 50000, unit_name: "tháng" },
    { name: "Gửi xe máy", unit_price: 100000, unit_name: "tháng/xe" },
    { name: "Phí Quản lý & Thang máy", unit_price: 80000, unit_name: "tháng" }
  ]

  services_seed.each do |s|
    Service.find_or_create_by!(tenant: tenant, name: s[:name]) do |rec|
      rec.unit_price = s[:unit_price]
      rec.unit_name = s[:unit_name]
    end
  end

  amenities_seed = [
    { name: "Điều hòa Inverter", icon: "❄️" },
    { name: "Tủ lạnh 180L", icon: "🧊" },
    { name: "Bình nóng lạnh", icon: "🚿" },
    { name: "Giường gỗ & Nệm cao su", icon: "🛏️" },
    { name: "Tủ quần áo 3 cánh", icon: "🚪" },
    { name: "Máy giặt dùng chung", icon: "🧺" },
    { name: "Ban công thoáng mát", icon: "🌅" },
    { name: "Khóa cửa vân tay", icon: "🔐" }
  ]

  amenities_seed.each do |a|
    Amenity.find_or_create_by!(tenant: tenant, name: a[:name]) do |rec|
      rec.icon = a[:icon]
    end
  end

  # 6. Rooms Seed (32 Rooms with detailed layouts)
  rooms_seed = [
    # Tòa A - Phòng trọ
    { property: created_props[0], room_number: "101", floor: 1, area: 25, price: 3500000, status: :vacant, room_type: "phong_don", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: true, furnished: "co_ban", balcony: true },
    { property: created_props[0], room_number: "102", floor: 1, area: 28, price: 3800000, status: :occupied, room_type: "studio", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[0], room_number: "103", floor: 1, area: 25, price: 3500000, status: :reserved, room_type: "phong_don", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: true, furnished: "co_ban", balcony: false },
    { property: created_props[0], room_number: "201", floor: 2, area: 30, price: 4200000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[0], room_number: "202", floor: 2, area: 32, price: 4500000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[0], room_number: "203", floor: 2, area: 30, price: 4200000, status: :maintenance, room_type: "phong_don", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: true, furnished: "co_ban", balcony: true },
    # Tòa B - Chung cư mini
    { property: created_props[1], room_number: "301", floor: 3, area: 35, price: 5000000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[1], room_number: "302", floor: 3, area: 48, price: 6200000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[1], room_number: "303", floor: 3, area: 35, price: 5000000, status: :vacant, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "co_ban", balcony: true },
    { property: created_props[1], room_number: "401", floor: 4, area: 52, price: 6800000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    # Tòa C - Căn hộ cao cấp
    { property: created_props[2], room_number: "C-101", floor: 1, area: 55, price: 8500000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[2], room_number: "C-102", floor: 1, area: 58, price: 8800000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[2], room_number: "C-201", floor: 2, area: 75, price: 12000000, status: :occupied, room_type: "can_ho_3pn", bedrooms: 3, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[2], room_number: "C-202", floor: 2, area: 55, price: 8500000, status: :vacant, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    # Tòa D - Nhà nguyên căn
    { property: created_props[3], room_number: "D-101 (Nguyên Căn)", floor: 1, area: 120, price: 18500000, status: :occupied, room_type: "nha_nguyen_can", bedrooms: 3, living_rooms: 1, bathrooms: 3, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[3], room_number: "D-102", floor: 1, area: 30, price: 4100000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "co_ban", balcony: true },
    { property: created_props[3], room_number: "D-201", floor: 2, area: 32, price: 4400000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[3], room_number: "D-202", floor: 2, area: 28, price: 3900000, status: :reserved, room_type: "phong_don", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: true, furnished: "co_ban", balcony: false },
    # Tòa E
    { property: created_props[4], room_number: "E-101", floor: 1, area: 35, price: 4800000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[4], room_number: "E-102", floor: 1, area: 35, price: 4800000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "co_ban", balcony: true },
    { property: created_props[4], room_number: "E-201", floor: 2, area: 50, price: 6500000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[4], room_number: "E-202", floor: 2, area: 50, price: 6500000, status: :vacant, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    # Tòa F
    { property: created_props[5], room_number: "F-101", floor: 1, area: 55, price: 9500000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[5], room_number: "F-102", floor: 1, area: 68, price: 11500000, status: :occupied, room_type: "can_ho_3pn", bedrooms: 3, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[5], room_number: "F-201", floor: 2, area: 55, price: 9500000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 2, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    # Tòa G
    { property: created_props[6], room_number: "G-101", floor: 1, area: 35, price: 5500000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[6], room_number: "G-102", floor: 1, area: 35, price: 5500000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[6], room_number: "G-201", floor: 2, area: 48, price: 6800000, status: :occupied, room_type: "can_ho_2pn", bedrooms: 2, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    # Tòa H
    { property: created_props[7], room_number: "H-101", floor: 1, area: 30, price: 4200000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "co_ban", balcony: true },
    { property: created_props[7], room_number: "H-102", floor: 1, area: 32, price: 4500000, status: :occupied, room_type: "can_ho_1pn", bedrooms: 1, living_rooms: 1, bathrooms: 1, kitchens: 1, mezzanine: false, furnished: "full_noi_that", balcony: true },
    { property: created_props[7], room_number: "H-201", floor: 2, area: 30, price: 4200000, status: :vacant, room_type: "phong_don", bedrooms: 1, living_rooms: 0, bathrooms: 1, kitchens: 1, mezzanine: true, furnished: "co_ban", balcony: true }
  ]

  created_rooms = {}
  rooms_seed.each do |attrs|
    r = Room.find_or_initialize_by(tenant: tenant, room_number: attrs[:room_number])
    r.property_name = attrs[:property].name
    r.property_id = attrs[:property].id
    r.floor = attrs[:floor]
    r.area = attrs[:area]
    r.price = attrs[:price]
    r.status = attrs[:status]
    r.room_type = attrs[:room_type] || "phong_don"
    r.bedrooms_count = attrs[:bedrooms] || 1
    r.living_rooms_count = attrs[:living_rooms] || 0
    r.bathrooms_count = attrs[:bathrooms] || 1
    r.kitchens_count = attrs[:kitchens] || 1
    r.is_mezzanine = attrs[:mezzanine] || false
    r.furnished_status = attrs[:furnished] || "co_ban"
    r.has_balcony = attrs[:balcony] || false
    r.save!
    created_rooms[attrs[:room_number]] = r
  end

  # 7. Room Assets
  asset_templates = [
    { name: "Điều hòa Daikin 12000 BTU", category: "Appliance", price: 9500000 },
    { name: "Tủ lạnh Panasonic 188L", category: "Appliance", price: 6200000 },
    { name: "Giường gỗ xoan đào 1.8m", category: "Furniture", price: 4500000 },
    { name: "Bình nóng lạnh Ariston 20L", category: "Appliance", price: 3100000 },
    { name: "Tủ quần áo 3 cánh MDF", category: "Furniture", price: 3800000 },
    { name: "Smart TV LG 43 inch", category: "Electronics", price: 8200000 },
    { name: "Khóa cửa điện tử Samsung", category: "Electronics", price: 5400000 }
  ]

  created_rooms.values.first(12).each_with_index do |rm, idx|
    ast = asset_templates[idx % asset_templates.size]
    RoomAsset.find_or_create_by!(room_id: rm.id, name: "#{ast[:name]} - P.#{rm.room_number}") do |a|
      a.property_id = rm.property_id
      a.asset_code = "AST-#{rm.room_number}-#{idx + 1}"
      a.category = ast[:category]
      a.condition = ["good", "good", "worn"].sample
      a.quantity = 1
      a.purchase_price = ast[:price]
      a.installed_at = Date.current - (3 + idx).months
    end
  end

  # 8. Contracts & Co-Tenants
  occupied_rooms = created_rooms.values.select { |r| r.status == "occupied" }
  created_contracts = []

  occupied_rooms.each_with_index do |rm, idx|
    renter = created_renters[idx % created_renters.size]
    start_m = (idx % 5) + 1
    code = "CTR-2026-#{rm.room_number}"

    c = Contract.find_or_create_by!(tenant: tenant, contract_code: code) do |rec|
      rec.room = rm
      rec.renter = renter
      rec.start_date = Date.current.beginning_of_month - start_m.months
      rec.end_date = rec.start_date + 12.months
      rec.monthly_rent = rm.price
      rec.deposit_amount = rm.price
      rec.status = :active
      rec.signed_at = rec.start_date
    end

    created_contracts << c

    # Co-tenant for half of rooms
    if idx.even?
      CoTenant.find_or_create_by!(contract: c, full_name: "Người ở cùng của #{renter.full_name}") do |co|
        co.phone = "0999888#{format('%03d', idx)}"
        co.id_card_number = "001199#{format('%06d', idx + 100)}"
        co.vehicle_plate = "29B1-#{format('%05d', idx + 1234)}"
        co.emergency_contact = "0911222333"
        co.temporary_residence_status = ["registered", "pending"].sample
        co.is_primary_renter = false
      end
    end
  end

  # 9. Contract Template
  ContractTemplate.find_or_create_by!(name: "Mẫu Hợp Đồng Thuê Nhà Trọ Standard 2026") do |t|
    t.content = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n\nHỢP ĐỒNG CHO THUÊ PHÒNG TRỌ\n\nBên A (Chủ nhà): {{landlord_name}} - SĐT: {{landlord_phone}}\nBên B (Khách thuê): {{tenant_name}} - CCCD: {{tenant_id_card}}\n\nHai bên thống nhất cho thuê phòng {{room_number}} tại {{property_address}} với giá {{monthly_rent}} VNĐ/tháng."
    t.is_default = true
    t.description = "Mẫu chuẩn pháp lý với đầy đủ điều khoản cọc, thanh toán và hủy hợp đồng."
  end

  # 10. Utility Readings & Monthly Bills over 6 Months
  months = (0..5).map { |i| (Date.current - i.months).strftime("%Y-%m") }.reverse

  months.each_with_index do |m_str, m_idx|
    occupied_rooms.first(15).each_with_index do |room, r_idx|
      elec_base = 1200 + (m_idx * 140) + (r_idx * 15)
      water_base = 40 + (m_idx * 8) + r_idx

      is_abnormal = (r_idx == 0 && m_idx == 4) # Spike in 1st room on month 4

      elec_usage = is_abnormal ? 380 : (110 + (r_idx * 7) % 50)
      water_usage = is_abnormal ? 28 : (6 + (r_idx * 2) % 6)

      ur = UtilityReading.find_or_initialize_by(tenant: tenant, room: room, billing_month: m_str)
      ur.electric_old = elec_base
      ur.electric_new = elec_base + elec_usage
      ur.water_old = water_base
      ur.water_new = water_base + water_usage
      ur.is_abnormal = is_abnormal
      ur.note = is_abnormal ? "CẢNH BÁO: Tiêu thụ điện/nước tăng vọt nghi vấn rò rỉ!" : "Chốt chỉ số hàng tháng"
      ur.save!

      # Bill creation
      contract = room.contracts.active.first
      next unless contract

      b_code = "BILL-#{m_str.delete('-')}-#{room.room_number}"
      bill = MonthlyBill.find_or_initialize_by(tenant: tenant, bill_code: b_code)
      bill.room = room
      bill.contract = contract
      bill.billing_month = m_str
      bill.room_fee = room.price
      bill.utility_fee = (elec_usage * 3800) + (water_usage * 30000)
      bill.service_fee = 150000
      bill.discount_amount = (m_idx == 1 && r_idx == 2) ? 200000 : 0
      bill.penalty_amount = (m_idx == 0 && r_idx == 0) ? 100000 : 0
      bill.due_date = Date.parse("#{m_str}-25")

      if m_idx < 5
        bill.status = :paid
        bill.paid_at = Time.parse("#{m_str}-20 10:30:00")
        bill.paid_amount = bill.room_fee + bill.utility_fee + bill.service_fee + bill.penalty_amount - bill.discount_amount
      else
        # Current month status mix
        if r_idx % 3 == 0
          bill.status = :paid
          bill.paid_at = Time.current - 2.days
          bill.paid_amount = bill.room_fee + bill.utility_fee + bill.service_fee
        elsif r_idx % 3 == 1
          bill.status = :issued
          bill.paid_amount = 0
        else
          bill.status = :overdue
          bill.paid_amount = 0
        end
      end

      bill.bank_code = tenant.bank_code
      bill.bank_account = tenant.bank_account
      bill.bank_account_name = tenant.bank_account_name
      bill.save!

      # Items
      bill.bill_items.destroy_all
      bill.bill_items.create!(item_type: "rent", description: "Tiền thuê phòng #{room.room_number}", amount: room.price, quantity: 1, unit_price: room.price)
      bill.bill_items.create!(item_type: "electric", description: "Điện (#{elec_usage} kWh)", amount: elec_usage * 3800, quantity: elec_usage, unit_price: 3800)
      bill.bill_items.create!(item_type: "water", description: "Nước (#{water_usage} m3)", amount: water_usage * 30000, quantity: water_usage, unit_price: 30000)
      bill.bill_items.create!(item_type: "service", description: "Wifi & Dịch vụ tòa nhà", amount: 150000, quantity: 1, unit_price: 150000)

      if bill.paid?
        PaymentTransaction.find_or_create_by!(transaction_code: "TX-#{bill.bill_code}") do |p|
          p.monthly_bill = bill
          p.tenant = tenant
          p.amount = bill.total_amount
          p.payment_method = "vietqr"
          p.status = "completed"
          p.bank_name = "MB Bank"
          p.account_number = tenant.bank_account
          p.description = bill.bill_code
          p.paid_at = bill.paid_at
        end
      end
    end
  end

  # 11. Maintenance Requests
  [
    { title: "Sửa vòi hoa sen bị gãy", room: occupied_rooms[0], renter: created_renters[0], priority: :medium, status: :resolved, cost: 200000, cost_bearer: "owner", handyman: "Thợ Tuấn", handyman_phone: "0912111222", resolved_ago: 5.days },
    { title: "Bảo trì vệ sinh điều hòa phòng", room: occupied_rooms[1], renter: created_renters[1], priority: :low, status: :resolved, cost: 250000, cost_bearer: "renter", handyman: "Điện Lạnh Hà Nội", handyman_phone: "0988333444", resolved_ago: 10.days },
    { title: "Sửa khoá cửa vân tay bị hết pin", room: occupied_rooms[2], renter: created_renters[2], priority: :high, status: :in_progress, cost: 150000, cost_bearer: "owner", handyman: "Thợ Sơn", handyman_phone: "0904555666", resolved_ago: nil },
    { title: "Thay bóng đèn tuýp LED ban công", room: occupied_rooms[3], renter: created_renters[3], priority: :low, status: :pending, cost: 80000, cost_bearer: "renter", handyman: nil, handyman_phone: nil, resolved_ago: nil },
    { title: "Kiểm tra rò rỉ nước nhà vệ sinh", room: occupied_rooms[4], renter: created_renters[4], priority: :high, status: :resolved, cost: 350000, cost_bearer: "owner", handyman: "Sửa nước 247", handyman_phone: "0911999888", resolved_ago: 2.days }
  ].each do |mr|
    m = MaintenanceRequest.find_or_initialize_by(tenant: tenant, title: mr[:title])
    m.room = mr[:room]
    m.renter = mr[:renter]
    m.priority = mr[:priority]
    m.status = mr[:status]
    m.cost = mr[:cost]
    m.cost_bearer = mr[:cost_bearer]
    m.handyman_name = mr[:handyman]
    m.handyman_phone = mr[:handyman_phone]
    m.resolved_at = mr[:resolved_ago] ? (Time.current - mr[:resolved_ago]) : nil
    m.save!
  end

  # 12. Operating Expenses
  [
    { title: "Thanh toán Tiền Điện Nước Tổng Tòa A", property: created_props[0], category: "tiền điện nước tổng", amount: 4500000, date_ago: 15.days, note: "Hóa đơn EVN tổng tháng trước" },
    { title: "Gói Cáp Quang Internet Viettel 200Mbps Tòa B", property: created_props[1], category: "internet", amount: 650000, date_ago: 20.days, note: "Gói cước 6 tháng" },
    { title: "Thuê Công ty Vệ sinh Tổng thể Tòa A & B", property: created_props[0], category: "vệ sinh", amount: 1200000, date_ago: 8.days, note: "Vệ sinh hành lang & dọn rác" },
    { title: "Sửa máy bơm áp lực tầng mái Tòa A", property: created_props[0], category: "sửa chữa", amount: 850000, date_ago: 3.days, note: "Thay phao điện & tụ khởi động" },
    { title: "Bảo trì thang máy định kỳ Tòa C", property: created_props[2], category: "bảo trì tòa nhà", amount: 1500000, date_ago: 12.days, note: "Kiểm định an toàn thang máy Schindler" },
    { title: "Mua bảo hiểm cháy nổ Tòa D", property: created_props[3], category: "bảo hiểm", amount: 3200000, date_ago: 45.days, note: "Bảo hiểm hỏa hoạn nhà tư nhân 1 năm" }
  ].each do |ex|
    e = OperatingExpense.find_or_initialize_by(tenant: tenant, title: ex[:title])
    e.property = ex[:property]
    e.category = ex[:category]
    e.amount = ex[:amount]
    e.expense_date = Date.current - ex[:date_ago]
    e.note = ex[:note]
    e.save!
  end

  # 13. Notifications & Audit Logs
  AuditLog.log_action(
    tenant: tenant,
    user: owner,
    action: "SEED_DATA_SUCCESS",
    record: tenant,
    payload: { message: "Đã khởi tạo bộ dữ liệu mẫu 6+ tháng RentOps thành công!" }
  )

  Notification.find_or_create_by!(tenant: tenant, recipient_name: "Trần Thị Minh B") do |n|
    n.recipient_phone = "0988777666"
    n.channel = "zns"
    n.content = "RentOps Thông báo: Hóa đơn phòng 102 tháng này là 4.760.000đ. Vui lòng quét mã VietQR để thanh toán."
    n.status = :sent
    n.sent_at = Time.current - 1.day
  end
end

puts "RentOps 6+ months sample seed data populated successfully!"
load Rails.root.join("db/seed_renter_account.rb") if File.exist?(Rails.root.join("db/seed_renter_account.rb"))
