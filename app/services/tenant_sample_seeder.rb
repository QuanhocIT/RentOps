class TenantSampleSeeder
  def self.seed_for(tenant)
    return unless tenant

    # 1. Services
    services_data = [
      { name: "Điện sinh hoạt", unit_price: 3800, unit_name: "kWh" },
      { name: "Nước sạch", unit_price: 30000, unit_name: "m3" },
      { name: "Internet tốc độ cao", unit_price: 100000, unit_name: "tháng" },
      { name: "Vệ sinh & rác thải", unit_price: 50000, unit_name: "tháng" },
      { name: "Gửi xe máy", unit_price: 100000, unit_name: "tháng" }
    ]

    services_data.each do |s|
      Service.find_or_create_by!(tenant: tenant, name: s[:name]) do |rec|
        rec.unit_price = s[:unit_price]
        rec.unit_name = s[:unit_name]
      end
    end

    # 2. Amenities
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

    # 3. Properties & Rooms
    prop1 = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà RentOps A - Nam Từ Liêm") do |r|
      r.address = "Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội"
    end

    prop2 = Property.find_or_create_by!(tenant: tenant, name: "Tòa Nhà RentOps B - Cầu Giấy") do |r|
      r.address = "Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội"
    end

    prop3 = Property.find_or_create_by!(tenant: tenant, name: "Căn Hộ Dịch Vụ RentOps C - Đống Đa") do |r|
      r.address = "Số 102 Chùa Lăng, Đống Đa, Hà Nội"
    end

    rooms_data = [
      { property: prop1, room_number: "101", floor: 1, price: 3500000, status: :vacant, area: 25.0 },
      { property: prop1, room_number: "102", floor: 1, price: 3800000, status: :occupied, area: 28.0 },
      { property: prop1, room_number: "103", floor: 1, price: 3500000, status: :vacant, area: 25.0 },
      { property: prop1, room_number: "201", floor: 2, price: 4200000, status: :occupied, area: 30.0 },
      { property: prop1, room_number: "202", floor: 2, price: 4500000, status: :occupied, area: 32.0 },
      { property: prop1, room_number: "203", floor: 2, price: 4000000, status: :vacant, area: 28.0 },
      { property: prop2, room_number: "301", floor: 3, price: 5000000, status: :vacant, area: 35.0 },
      { property: prop2, room_number: "302", floor: 3, price: 5200000, status: :occupied, area: 38.0 },
      { property: prop2, room_number: "303", floor: 3, price: 4800000, status: :vacant, area: 32.0 },
      { property: prop3, room_number: "401 (Studio)", floor: 4, price: 6500000, status: :vacant, area: 42.0 },
      { property: prop3, room_number: "402 (Studio)", floor: 4, price: 6800000, status: :occupied, area: 45.0 }
    ]

    created_rooms = {}
    rooms_data.each do |attrs|
      r = Room.find_or_initialize_by(tenant: tenant, room_number: attrs[:room_number])
      r.property_name = attrs[:property].name
      r.property_id = attrs[:property].id
      r.floor = attrs[:floor]
      r.price = attrs[:price]
      r.status = attrs[:status]
      r.area = attrs[:area]
      r.save!
      created_rooms[attrs[:room_number]] = r
    end

    # 4. Renters
    renter1 = User.find_or_create_by!(tenant: tenant, email: "renter102@#{tenant.subdomain}.vn") do |u|
      u.full_name = "Trần Thị Minh B"
      u.phone = "0988777666"
      u.id_card_number = "001198001234"
      u.hometown = "Nam Định"
      u.role = :renter
    end

    renter2 = User.find_or_create_by!(tenant: tenant, email: "nam.le@#{tenant.subdomain}.vn") do |u|
      u.full_name = "Lê Hoàng Nam"
      u.phone = "0912345678"
      u.id_card_number = "034095009876"
      u.hometown = "Hải Phòng"
      u.role = :renter
    end

    renter3 = User.find_or_create_by!(tenant: tenant, email: "huong.pham@#{tenant.subdomain}.vn") do |u|
      u.full_name = "Phạm Thị Hương"
      u.phone = "0977112233"
      u.id_card_number = "025091004321"
      u.hometown = "Thái Bình"
      u.role = :renter
    end

    # 5. Room Assets
    r102 = created_rooms["102"]
    r201 = created_rooms["201"]

    if r102
      RoomAsset.find_or_create_by!(room_id: r102.id, asset_code: "DH-102") do |a|
        a.property = prop1
        a.name = "Điều hòa Daikin Inverter 12000 BTU"
        a.category = "appliance"
        a.condition = "good"
        a.quantity = 1
        a.purchase_price = 9500000
        a.installed_at = Date.current - 6.months
      end
    end

    # 6. Contracts
    if r102
      c102 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-#{Date.current.strftime('%Y%m')}-102") do |c|
        c.room = r102
        c.renter = renter1
        c.start_date = Date.current.beginning_of_month - 3.months
        c.end_date = Date.current.beginning_of_month + 9.months
        c.monthly_rent = r102.price
        c.deposit_amount = r102.price
        c.status = :active
        c.signed_at = Time.current - 3.months
      end

      # Monthly Bill
      current_month = Date.current.strftime("%Y-%m")
      bill102 = MonthlyBill.find_or_create_by!(tenant: tenant, bill_code: "BILL-#{Date.current.strftime('%Y%m')}-102") do |b|
        b.room = r102
        b.contract = c102
        b.billing_month = current_month
        b.room_fee = r102.price
        b.utility_fee = 650000
        b.service_fee = 150000
        b.total_amount = b.room_fee + b.utility_fee + b.service_fee
        b.due_date = Date.current.end_of_month
        b.status = :issued
        b.bank_code = tenant.bank_code.presence || "MB"
        b.bank_account = tenant.bank_account.presence || "0901234567"
        b.bank_account_name = tenant.bank_account_name.presence || "RENTOPS DEMO"
      end

      # Utility Reading
      UtilityReading.find_or_create_by!(tenant: tenant, room: r102, billing_month: current_month) do |u|
        u.electric_old = 1200
        u.electric_new = 1350
        u.water_old = 40
        u.water_new = 48
        u.note = "Chỉ số điện nước tháng hiện tại"
      end
    end

    if r201
      c201 = Contract.find_or_create_by!(tenant: tenant, contract_code: "CTR-#{Date.current.strftime('%Y%m')}-201") do |c|
        c.room = r201
        c.renter = renter2
        c.start_date = Date.current.beginning_of_month - 1.month
        c.end_date = Date.current.beginning_of_month + 11.months
        c.monthly_rent = r201.price
        c.deposit_amount = r201.price
        c.status = :active
        c.signed_at = Time.current - 1.month
      end

      current_month = Date.current.strftime("%Y-%m")
      bill201 = MonthlyBill.find_or_create_by!(tenant: tenant, bill_code: "BILL-#{Date.current.strftime('%Y%m')}-201") do |b|
        b.room = r201
        b.contract = c201
        b.billing_month = current_month
        b.room_fee = r201.price
        b.utility_fee = 700000
        b.service_fee = 150000
        b.total_amount = b.room_fee + b.utility_fee + b.service_fee
        b.paid_amount = b.total_amount
        b.due_date = Date.current.end_of_month
        b.status = :paid
        b.paid_at = Time.current - 1.day
        b.bank_code = tenant.bank_code.presence || "MB"
        b.bank_account = tenant.bank_account.presence || "0901234567"
        b.bank_account_name = tenant.bank_account_name.presence || "RENTOPS DEMO"
      end
    end

    # 7. Contract Templates
    ContractTemplate.find_or_create_by!(name: "Mẫu Hợp Đồng Thuê Nhà Trọ Chuẩn 2026") do |t|
      t.content = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n\nHỢP ĐỒNG CHO THUÊ PHÒNG TRỌ\n\nBên A (Bên cho thuê): {{landlord_name}} - SĐT: {{landlord_phone}}\nBên B (Bên thuê): {{tenant_name}} - CCCD: {{tenant_id_card}}\n\nHai bên thống nhất cho thuê phòng {{room_number}} tại {{property_address}} với giá {{monthly_rent}} VNĐ/tháng. Đặt cọc {{deposit_amount}} VNĐ."
      t.is_default = true
      t.description = "Mẫu hợp đồng đầy đủ điều khoản pháp lý về cọc, thanh toán và hủy hợp đồng."
    end

    # 8. Maintenance Requests
    if r102
      MaintenanceRequest.find_or_create_by!(tenant: tenant, title: "Sửa vòi nước nhà vệ sinh bị rò rỉ") do |m|
        m.room = r102
        m.renter = renter1
        m.description = "Vòi sen tắm bị rỉ nước liên tục"
        m.priority = :medium
        m.status = :resolved
        m.cost = 150000
        m.resolved_at = Time.current - 2.days
      end
    end

    # 9. Operating Expenses
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
  end
end
