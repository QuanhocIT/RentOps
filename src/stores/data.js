import { defineStore } from 'pinia'

const STORAGE_KEY = 'rentops_data_v2'

const initialProperties = [
  {
    id: 1,
    name: 'Tòa nhà Minh House - Quận 1',
    address: '124 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP.HCM',
    city: 'Hồ Chí Minh',
    totalRooms: 12,
    electricRate: 3500,
    waterRate: 18000,
    managerName: 'Nguyễn Văn Minh',
    managerPhone: '0908123456',
    image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
    description: 'Chung cư dịch vụ cao cấp, đầy đủ tiện nghi, an ninh 24/7.'
  },
  {
    id: 2,
    name: 'Dãy trọ Lê Văn Sỹ - Quận 3',
    address: '450 Lê Văn Sỹ, Phường 14, Quận 3, TP.HCM',
    city: 'Hồ Chí Minh',
    totalRooms: 10,
    electricRate: 3500,
    waterRate: 18000,
    managerName: 'Trần Thị Mai',
    managerPhone: '0912987654',
    image: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
    description: 'Khu trọ sinh viên và người đi làm, thoáng mát, yên tĩnh, giờ giấc tự do.'
  },
  {
    id: 3,
    name: 'RentOps Tower - Bình Thạnh',
    address: '88 Điện Biên Phủ, Phường 15, Quận Bình Thạnh, TP.HCM',
    city: 'Hồ Chí Minh',
    totalRooms: 15,
    electricRate: 3200,
    waterRate: 20000,
    managerName: 'Lê Hoàng Nam',
    managerPhone: '0988776655',
    image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    description: 'Căn hộ Studio hiện đại với cửa từ thông minh, thang máy tốc độ cao.'
  }
]

const initialRooms = [
  {
    id: 101,
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomNumber: 'P101',
    floor: 1,
    area: 28,
    price: 5500000,
    deposit: 5500000,
    status: 'rented',
    renterId: 1,
    renterName: 'Nguyễn Thị Thu Hà',
    amenities: ['Máy lạnh', 'Tủ lạnh', 'Máy giặt', 'Khóa van tay', 'Ban công'],
    images: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'],
    description: 'Phòng Studio ban công thoáng mát, view đẹp.',
    electricMeter: 1450,
    waterMeter: 128
  },
  {
    id: 102,
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomNumber: 'P102',
    floor: 1,
    area: 32,
    price: 6200000,
    deposit: 6200000,
    status: 'rented',
    renterId: 2,
    renterName: 'Lê Văn Hoàng',
    amenities: ['Máy lạnh', 'Tủ lạnh', 'Máy giặt', 'Sofa', 'Gác xép'],
    images: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80'],
    description: 'Phòng rộng có gác lửng cao 2m, bếp riêng.',
    electricMeter: 2180,
    waterMeter: 205
  },
  {
    id: 103,
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomNumber: 'P103',
    floor: 1,
    area: 25,
    price: 4800000,
    deposit: 4800000,
    status: 'vacant',
    renterId: null,
    renterName: '',
    amenities: ['Máy lạnh', 'Tủ lạnh', 'Bếp âm'],
    images: ['https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=800&q=80'],
    description: 'Phòng trống giao ngay, mới sơn sửa thơm tho.',
    electricMeter: 890,
    waterMeter: 94
  },
  {
    id: 104,
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomNumber: 'P201',
    floor: 2,
    area: 30,
    price: 5800000,
    deposit: 5800000,
    status: 'maintenance',
    renterId: null,
    renterName: '',
    amenities: ['Máy lạnh', 'Tủ lạnh', 'Máy nước nóng'],
    images: ['https://images.unsplash.com/photo-1560185127-6ed189bf02f4?auto=format&fit=crop&w=800&q=80'],
    description: 'Đang bảo trì nâng cấp máy điều hòa và sơn lại tường.',
    electricMeter: 1120,
    waterMeter: 110
  },
  {
    id: 201,
    propertyId: 2,
    propertyName: 'Dãy trọ Lê Văn Sỹ - Quận 3',
    roomNumber: 'R01',
    floor: 1,
    area: 22,
    price: 3800000,
    deposit: 3800000,
    status: 'rented',
    renterId: 3,
    renterName: 'Phạm Minh Tuấn',
    amenities: ['Máy lạnh', 'Wifi', 'Kệ bếp'],
    images: ['https://images.unsplash.com/photo-1536376072261-38c75010e6c9?auto=format&fit=crop&w=800&q=80'],
    description: 'Phòng trọ trệt, cửa sổ lớn, WC khép kín.',
    electricMeter: 3410,
    waterMeter: 312
  },
  {
    id: 202,
    propertyId: 2,
    propertyName: 'Dãy trọ Lê Văn Sỹ - Quận 3',
    roomNumber: 'R02',
    floor: 1,
    area: 22,
    price: 3800000,
    deposit: 3800000,
    status: 'vacant',
    renterId: null,
    renterName: '',
    amenities: ['Máy lạnh', 'Wifi'],
    images: ['https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=800&q=80'],
    description: 'Phòng trọ yên tĩnh, giờ tự do.',
    electricMeter: 1540,
    waterMeter: 160
  },
  {
    id: 301,
    propertyId: 3,
    propertyName: 'RentOps Tower - Bình Thạnh',
    roomNumber: 'T502',
    floor: 5,
    area: 35,
    price: 7500000,
    deposit: 15000000,
    status: 'rented',
    renterId: 4,
    renterName: 'Vũ Thị Hương',
    amenities: ['Máy lạnh', 'Tủ lạnh', 'Máy giặt', 'Sofa', 'Cửa khóa từ', 'Ban công'],
    images: ['https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80'],
    description: 'Căn hộ luxury view toàn cảnh Landmark 81.',
    electricMeter: 4520,
    waterMeter: 410
  }
]

const initialRenters = [
  {
    id: 1,
    fullName: 'Nguyễn Thị Thu Hà',
    phone: '0938112233',
    email: 'thuha.nguyen@gmail.com',
    identityCard: '079198001234',
    roomId: 101,
    roomNumber: 'P101',
    propertyId: 1,
    deposit: 5500000,
    joinDate: '2025-01-15',
    status: 'active',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
    coTenants: [
      { name: 'Nguyễn Văn An', phone: '0938112299', relationship: 'Em trai' }
    ]
  },
  {
    id: 2,
    fullName: 'Lê Văn Hoàng',
    phone: '0903887766',
    email: 'hoang.le@gmail.com',
    identityCard: '079195004321',
    roomId: 102,
    roomNumber: 'P102',
    propertyId: 1,
    deposit: 6200000,
    joinDate: '2024-11-01',
    status: 'active',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
    coTenants: []
  },
  {
    id: 3,
    fullName: 'Phạm Minh Tuấn',
    phone: '0918223344',
    email: 'tuan.pham@gmail.com',
    identityCard: '079192008888',
    roomId: 201,
    roomNumber: 'R01',
    propertyId: 2,
    deposit: 3800000,
    joinDate: '2025-02-01',
    status: 'active',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
    coTenants: []
  },
  {
    id: 4,
    fullName: 'Vũ Thị Hương',
    phone: '0977665544',
    email: 'huong.vu@gmail.com',
    identityCard: '079199009999',
    roomId: 301,
    roomNumber: 'T502',
    propertyId: 3,
    deposit: 15000000,
    joinDate: '2024-06-15',
    status: 'active',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
    coTenants: [
      { name: 'Trần Bảo Ngọc', phone: '0977665511', relationship: 'Bạn cùng phòng' }
    ]
  }
]

const initialContracts = [
  {
    id: 1,
    contractNumber: 'HD-2025-101',
    roomId: 101,
    roomNumber: 'P101',
    renterId: 1,
    renterName: 'Nguyễn Thị Thu Hà',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    startDate: '2025-01-15',
    endDate: '2026-01-15',
    price: 5500000,
    deposit: 5500000,
    billingCycle: '1 tháng',
    status: 'active',
    signedDate: '2025-01-15',
    eSigned: true,
    terms: 'Bên thuê thanh toán đúng ngày 05 hàng tháng. Giữ gìn vệ sinh chung, không làm ồn sau 22h.'
  },
  {
    id: 2,
    contractNumber: 'HD-2024-102',
    roomId: 102,
    roomNumber: 'P102',
    renterId: 2,
    renterName: 'Lê Văn Hoàng',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    startDate: '2024-11-01',
    endDate: '2025-11-01',
    price: 6200000,
    deposit: 6200000,
    billingCycle: '1 tháng',
    status: 'active',
    signedDate: '2024-11-01',
    eSigned: true,
    terms: 'Thanh toán tiền nhà đầu mỗi kỳ. Không sử dụng chất cấm.'
  },
  {
    id: 3,
    contractNumber: 'HD-2025-201',
    roomId: 201,
    roomNumber: 'R01',
    renterId: 3,
    renterName: 'Phạm Minh Tuấn',
    propertyId: 2,
    propertyName: 'Dãy trọ Lê Văn Sỹ - Quận 3',
    startDate: '2025-02-01',
    endDate: '2025-08-01',
    price: 3800000,
    deposit: 3800000,
    billingCycle: '1 tháng',
    status: 'active',
    signedDate: '2025-02-01',
    eSigned: false,
    terms: 'Hợp đồng 6 tháng.'
  }
]

const initialUtilityReadings = [
  {
    id: 1,
    month: '07/2026',
    year: 2026,
    roomId: 101,
    roomNumber: 'P101',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    prevElectric: 1350,
    currElectric: 1450,
    electricUsage: 100,
    electricCost: 380000,
    prevWater: 120,
    currWater: 128,
    waterUsage: 8,
    waterCost: 144000,
    recordedDate: '2026-07-28',
    recordedBy: 'Nguyễn Văn Minh',
    billed: true
  },
  {
    id: 2,
    month: '07/2026',
    year: 2026,
    roomId: 102,
    roomNumber: 'P102',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    prevElectric: 2050,
    currElectric: 2180,
    electricUsage: 130,
    electricCost: 494000,
    prevWater: 195,
    currWater: 205,
    waterUsage: 10,
    waterCost: 180000,
    recordedDate: '2026-07-28',
    recordedBy: 'Nguyễn Văn Minh',
    billed: false
  }
]

const initialServices = [
  { id: 1, name: 'Điện', unit: 'kWh', price: 3800, billingType: 'per_unit', description: 'Đồng hồ công tơ riêng từng phòng', icon: 'zap', status: 'active' },
  { id: 2, name: 'Nước sinh hoạt', unit: 'm³', price: 18000, billingType: 'per_unit', description: 'Đồng hồ đo khối riêng', icon: 'droplet', status: 'active' },
  { id: 3, name: 'Internet / Wifi High-Speed', unit: 'Phòng', price: 100000, billingType: 'fixed_monthly', description: 'Gói doanh nghiệp 500Mbps', icon: 'wifi', status: 'active' },
  { id: 4, name: 'Vệ sinh & Thu gom rác', unit: 'Phòng', price: 50000, billingType: 'fixed_monthly', description: 'Vệ sinh hành lang 3 lần/tuần', icon: 'trash-2', status: 'active' },
  { id: 5, name: 'Giữ xe máy', unit: 'Chiếc', price: 120000, billingType: 'fixed_monthly', description: 'Bảo vệ camera 24/7', icon: 'shield', status: 'active' }
]

const initialBills = [
  {
    id: 1,
    code: 'INV-202607-101',
    month: '07/2026',
    year: 2026,
    roomId: 101,
    roomNumber: 'P101',
    renterId: 1,
    renterName: 'Nguyễn Thị Thu Hà',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomPrice: 5500000,
    electricUsage: 100,
    electricCost: 380000,
    waterUsage: 8,
    waterCost: 144000,
    serviceFee: 150000,
    discount: 0,
    totalAmount: 6174000,
    paidAmount: 6174000,
    status: 'paid',
    dueDate: '2026-08-05',
    paidDate: '2026-07-29',
    paymentMethod: 'VietQR / Chuyển khoản MBBank',
    notes: 'Thanh toán tiền nhà & dịch vụ tháng 7/2026'
  },
  {
    id: 2,
    code: 'INV-202607-102',
    month: '07/2026',
    year: 2026,
    roomId: 102,
    roomNumber: 'P102',
    renterId: 2,
    renterName: 'Lê Văn Hoàng',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomPrice: 6200000,
    electricUsage: 130,
    electricCost: 494000,
    waterUsage: 10,
    waterCost: 180000,
    serviceFee: 150000,
    discount: 0,
    totalAmount: 7024000,
    paidAmount: 0,
    status: 'unpaid',
    dueDate: '2026-08-05',
    paidDate: null,
    paymentMethod: '',
    notes: 'Tiền phòng & điện nước tháng 7/2026'
  },
  {
    id: 3,
    code: 'INV-202606-201',
    month: '06/2026',
    year: 2026,
    roomId: 201,
    roomNumber: 'R01',
    renterId: 3,
    renterName: 'Phạm Minh Tuấn',
    propertyId: 2,
    propertyName: 'Dãy trọ Lê Văn Sỹ - Quận 3',
    roomPrice: 3800000,
    electricUsage: 80,
    electricCost: 304000,
    waterUsage: 5,
    waterCost: 90000,
    serviceFee: 100000,
    discount: 0,
    totalAmount: 4294000,
    paidAmount: 0,
    status: 'overdue',
    dueDate: '2026-07-05',
    paidDate: null,
    paymentMethod: '',
    notes: 'Hóa đơn quá hạn thanh toán'
  }
]

const initialMaintenance = [
  {
    id: 1,
    title: 'Hỏng vòi nước bồn rửa chén',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomId: 101,
    roomNumber: 'P101',
    reporterName: 'Nguyễn Thị Thu Hà',
    reporterPhone: '0938112233',
    category: 'Nước',
    priority: 'Trung bình',
    status: 'Chờ xử lý',
    description: 'Vòi nước bị rò rỉ dưới bồn rửa gây đọng nước dưới sàn bếp.',
    createdDate: '2026-07-30 08:30',
    cost: 150000,
    assignedTo: 'Kỹ thuật Nam'
  },
  {
    id: 2,
    title: 'Máy lạnh không lạnh, chớp đèn đỏ',
    propertyId: 1,
    propertyName: 'Tòa nhà Minh House - Quận 1',
    roomId: 102,
    roomNumber: 'P102',
    reporterName: 'Lê Văn Hoàng',
    reporterPhone: '0903887766',
    category: 'Điều hòa',
    priority: 'Cao',
    status: 'Đang xử lý',
    description: 'Bật máy 16 độ nhưng chỉ ra hơi gió, bọt tuyết đóng dàn lạnh.',
    createdDate: '2026-07-29 14:15',
    cost: 350000,
    assignedTo: 'Thợ điện lạnh Tuấn'
  }
]

const initialExpenses = [
  { id: 1, title: 'Bảo trì thay block máy lạnh P102', category: 'Sửa chữa', amount: 350000, propertyId: 1, propertyName: 'Tòa nhà Minh House - Quận 1', date: '2026-07-29', receiptImage: '', paidTo: 'Thợ điện lạnh Tuấn', notes: 'Sửa chữa đột xuất' },
  { id: 2, title: 'Tiền internet cáp quang tổng tháng 7', category: 'Internet tổng', amount: 1200000, propertyId: 1, propertyName: 'Tòa nhà Minh House - Quận 1', date: '2026-07-25', receiptImage: '', paidTo: 'Viettel Telecom', notes: 'Hóa đơn định kỳ' },
  { id: 3, title: 'Vệ sinh hành lang & dọn rác khu nhà', category: 'Vệ sinh', amount: 800000, propertyId: 2, propertyName: 'Dãy trọ Lê Văn Sỹ - Quận 3', date: '2026-07-20', receiptImage: '', paidTo: 'Cô Lao Động Mai', notes: 'Chi phí vệ sinh định kỳ' }
]

const initialAmenities = [
  { id: 1, name: 'Máy lạnh / Điều hòa', icon: 'wind', category: 'Thiết bị', description: 'Inverter tiết kiệm điện 1.5 HP', roomsCount: 15 },
  { id: 2, name: 'Tủ lạnh', icon: 'box', category: 'Thiết bị', description: 'Dung tích 180L - 250L', roomsCount: 12 },
  { id: 3, name: 'Khóa vân tay thông minh', icon: 'key', category: 'Tiện ích tòa nhà', description: 'Cửa phòng mở bằng vân tay / mã số', roomsCount: 20 },
  { id: 4, name: 'Máy giặt chung / riêng', icon: 'disc', category: 'Thiết bị', description: 'Máy giặt cửa trên / cửa ngang 9kg', roomsCount: 10 },
  { id: 5, name: 'Ban công thoáng mát', icon: 'sun', category: 'Nội thất', description: 'View ánh sáng tự nhiên', roomsCount: 8 }
]

const initialAssets = [
  { id: 1, code: 'AST-ML-101', name: 'Máy lạnh Daikin 1.5HP Inverter', propertyId: 1, propertyName: 'Minh House', roomId: 101, roomNumber: 'P101', purchaseDate: '2024-05-10', value: 9500000, condition: 'Tốt', warrantyUntil: '2026-05-10' },
  { id: 2, code: 'AST-TL-102', name: 'Tủ lạnh Panasonic 188L', propertyId: 1, propertyName: 'Minh House', roomId: 102, roomNumber: 'P102', purchaseDate: '2024-06-15', value: 6800000, condition: 'Tốt', warrantyUntil: '2026-06-15' },
  { id: 3, code: 'AST-KT-001', name: 'Hệ thống Khóa cửa vân tay cổng chính', propertyId: 1, propertyName: 'Minh House', roomId: null, roomNumber: 'Cổng chính', purchaseDate: '2024-01-10', value: 12000000, condition: 'Mới', warrantyUntil: '2027-01-10' }
]

const initialNotifications = [
  { id: 1, title: 'Thanh toán mới', message: 'Khách thuê Nguyễn Thị Thu Hà đã thanh toán hóa đơn INV-202607-101 (6,174,000 đ)', type: 'success', createdDate: '2026-07-29 10:20', read: false, link: '/bills' },
  { id: 2, title: 'Báo cáo sự cố mới', message: 'Phòng P101 gửi yêu cầu sửa chữa vòi nước bồn rửa chén', type: 'warning', createdDate: '2026-07-30 08:30', read: false, link: '/maintenance' },
  { id: 3, title: 'Cảnh báo hóa đơn quá hạn', message: 'Hóa đơn INV-202606-201 của phòng R01 đã quá hạn 25 ngày', type: 'danger', createdDate: '2026-07-28 09:00', read: true, link: '/bills' }
]

const initialAuditLogs = [
  {
    id: 1,
    created_at: new Date().toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'MARK_BILL_PAID',
    record_type: 'MonthlyBill',
    record_id: 'INV-202607-101',
    details: 'Xác nhận gạch nợ thành công hóa đơn tiền nhà 6.174.000 ₫ cho phòng P101 qua VietQR MBBank',
    payload: { room: 'P101', renter: 'Nguyễn Thị Thu Hà', amount: 6174000, method: 'VietQR Auto' }
  },
  {
    id: 2,
    created_at: new Date(Date.now() - 3600000).toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'CREATE_CONTRACT',
    record_type: 'Contract',
    record_id: 'HD-2025-101',
    details: 'Lập hợp đồng thuê mới 12 tháng cho phòng P101, khách thuê Nguyễn Thị Thu Hà',
    payload: { room: 'P101', renter: 'Nguyễn Thị Thu Hà', price: 5500000, deposit: 5500000 }
  },
  {
    id: 3,
    created_at: new Date(Date.now() - 7200000).toISOString(),
    user_name: 'Hệ Thống Tự Động',
    action: 'SEND_BATCH_REMINDERS',
    record_type: 'Notification',
    record_id: 'ZNS-88',
    details: 'Tự động gửi 4 thông báo nhắc nợ hóa đơn tiền nhà kỳ 07/2026 qua Zalo ZNS',
    payload: { channel: 'ZNS Official', recipients_count: 4 }
  },
  {
    id: 4,
    created_at: new Date(Date.now() - 14400000).toISOString(),
    user_name: 'Trần Thị Mai (Quản lý)',
    action: 'RECORD_UTILITY',
    record_type: 'UtilityReading',
    record_id: 'UT-P102',
    details: 'Chốt chỉ số điện nước tháng 07/2026 phòng P102 (Điện: 2180 kWh, Nước: 205 m³)',
    payload: { room: 'P102', month: '07/2026', electric: 2180, water: 205 }
  },
  {
    id: 5,
    created_at: new Date(Date.now() - 28800000).toISOString(),
    user_name: 'Lê Văn Hoàng (Cư dân P102)',
    action: 'ADD_MAINTENANCE',
    record_type: 'Maintenance',
    record_id: 'MT-102',
    details: 'Báo sự cố kỹ thuật: Bật điều hòa phòng P102 không lạnh chỉ ra hơi gió',
    payload: { room: 'P102', title: 'Bảo trì máy lạnh', priority: 'Cao' }
  },
  {
    id: 6,
    created_at: new Date(Date.now() - 43200000).toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'ADD_EXPENSE',
    record_type: 'Expense',
    record_id: 'EXP-99',
    details: 'Ghi nhận chi phí vận hành: Bảo trì thay block máy lạnh P102 số tiền 350.000 ₫',
    payload: { title: 'Bảo trì thay block máy lạnh', amount: 350000, category: 'Sửa chữa' }
  }
]

const initialTrash = []

const initialSettings = {
  companyName: 'Hệ thống Quản lý Phòng trọ RentOps',
  phone: '0908123456',
  email: 'admin@rentops.vn',
  address: '124 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP.HCM',
  taxCode: '0318999888',
  bankName: 'MBBank',
  accountNumber: '0908123456',
  accountHost: 'NGUYEN VAN MINH',
  qrTemplate: 'compact2',
  defaultElectricRate: 3800,
  defaultWaterRate: 18000,
  defaultWifiRate: 100000,
  defaultGarbageRate: 50000,
  currency: 'VND',
  autoGenerateInvoiceDay: 28
}

function loadState() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      return JSON.parse(raw)
    }
  } catch (e) {
    console.error('Error loading RentOps store from localStorage', e)
  }
  return {
    properties: initialProperties,
    rooms: initialRooms,
    renters: initialRenters,
    contracts: initialContracts,
    utilityReadings: initialUtilityReadings,
    services: initialServices,
    bills: initialBills,
    maintenance: initialMaintenance,
    expenses: initialExpenses,
    amenities: initialAmenities,
    assets: initialAssets,
    notifications: initialNotifications,
    auditLogs: initialAuditLogs,
    trash: initialTrash,
    settings: initialSettings
  }
}

export const useDataStore = defineStore('data', {
  state: () => loadState(),

  getters: {
    // Rooms stats
    totalRoomsCount: (state) => state.rooms.length,
    rentedRoomsCount: (state) => state.rooms.filter(r => r.status === 'rented').length,
    vacantRoomsCount: (state) => state.rooms.filter(r => r.status === 'vacant').length,
    maintenanceRoomsCount: (state) => state.rooms.filter(r => r.status === 'maintenance').length,
    occupancyRate: (state) => {
      if (!state.rooms.length) return 0
      return Math.round((state.rooms.filter(r => r.status === 'rented').length / state.rooms.length) * 100)
    },

    // Financial stats
    totalMonthlyRevenue: (state) => {
      return state.bills
        .filter(b => b.status === 'paid')
        .reduce((sum, b) => sum + (b.totalAmount || 0), 0)
    },
    unpaidRevenue: (state) => {
      return state.bills
        .filter(b => b.status === 'unpaid' || b.status === 'overdue')
        .reduce((sum, b) => sum + (b.totalAmount || 0), 0)
    },
    totalExpensesAmount: (state) => {
      return state.expenses.reduce((sum, e) => sum + (e.amount || 0), 0)
    },
    netProfit: (state) => {
      const paidRev = state.bills.filter(b => b.status === 'paid').reduce((sum, b) => sum + b.totalAmount, 0)
      const exp = state.expenses.reduce((sum, e) => sum + e.amount, 0)
      return paidRev - exp
    },

    // Unread notifications
    unreadNotificationsCount: (state) => state.notifications.filter(n => !n.read).length,
    pendingMaintenanceCount: (state) => state.maintenance.filter(m => m.status === 'Chờ xử lý' || m.status === 'Đang xử lý').length,

    // Property helper
    getPropertyById: (state) => (id) => state.properties.find(p => p.id === Number(id)),
    getRoomById: (state) => (id) => state.rooms.find(r => r.id === Number(id)),
    getContractByRoomId: (state) => (roomId) => state.contracts.find(c => c.roomId === Number(roomId) && c.status === 'active'),
    getRoomMaintenanceCost: (state) => (roomId) => {
      return state.maintenance
        .filter(m => Number(m.roomId || m.room_id) === Number(roomId))
        .reduce((sum, m) => sum + (Number(m.cost) || 0), 0)
    },
    getRoomMaintenanceHistory: (state) => (roomId) => {
      return state.maintenance.filter(m => Number(m.roomId || m.room_id) === Number(roomId))
    }
  },

  actions: {
    checkExpiringContracts() {
      const now = new Date().getTime()
      this.contracts.forEach(c => {
        if (c.status === 'active' && c.endDate) {
          const endMs = new Date(c.endDate).getTime()
          const diffDays = Math.ceil((endMs - now) / (1000 * 60 * 60 * 24))
          if (diffDays > 0 && diffDays <= 30) {
            const notiTitle = `Hợp đồng phòng ${c.roomNumber} sắp hết hạn!`
            const exists = this.notifications.some(n => n.title === notiTitle)
            if (!exists) {
              this.addNotification(
                notiTitle,
                `Hợp đồng ${c.contractNumber} (${c.renterName}) sẽ hết hạn sau ${diffDays} ngày (${c.endDate}). Vui lòng liên hệ gia hạn hoặc chuẩn bị bàn giao.`,
                'warning',
                '/contracts'
              )
            }
          }
        }
      })
    },

    saveToStorage() {
      if (this._saveTimer) clearTimeout(this._saveTimer)
      this._saveTimer = setTimeout(() => {
        try {
          localStorage.setItem(STORAGE_KEY, JSON.stringify(this.$state))
        } catch (e) {
          console.error('Failed to save to localStorage', e)
        }
      }, 300)
    },

    addAuditLog(action, target, details) {
      const newLog = {
        id: Date.now(),
        user: 'Chủ Trọ Quản Lý',
        action,
        target,
        timestamp: new Date().toLocaleString('sv-SE').replace('T', ' ').substring(0, 16),
        details,
        ip: '14.232.11.88'
      }
      this.auditLogs.unshift(newLog)
      this.saveToStorage()
    },

    addNotification(title, message, type = 'info', link = '/notifications') {
      const newNoti = {
        id: Date.now(),
        title,
        message,
        type,
        createdDate: new Date().toLocaleString('sv-SE').replace('T', ' ').substring(0, 16),
        read: false,
        link
      }
      this.notifications.unshift(newNoti)
      this.saveToStorage()
    },

    // PROPERTIES
    addProperty(property) {
      const id = Date.now()
      const newProp = { id, ...property, totalRooms: 0 }
      this.properties.push(newProp)
      this.addAuditLog('Tạo bất động sản', newProp.name, `Thêm cơ sở mới tại ${newProp.address}`)
      this.saveToStorage()
      return newProp
    },
    updateProperty(id, updatedData) {
      const index = this.properties.findIndex(p => p.id === id)
      if (index !== -1) {
        this.properties[index] = { ...this.properties[index], ...updatedData }
        this.addAuditLog('Cập nhật bất động sản', this.properties[index].name, 'Cập nhật thông tin tòa nhà')
        this.saveToStorage()
      }
    },
    deleteProperty(id) {
      const item = this.properties.find(p => p.id === id)
      if (item) {
        this.trash.unshift({ id: Date.now(), originalType: 'property', itemData: item, deletedAt: new Date().toLocaleString() })
        this.properties = this.properties.filter(p => p.id !== id)
        this.addAuditLog('Xóa bất động sản', item.name, 'Chuyển tòa nhà vào thùng rác')
        this.saveToStorage()
      }
    },

    // ROOMS
    addRoom(roomData) {
      const id = Date.now()
      const property = this.properties.find(p => p.id === Number(roomData.propertyId))
      const newRoom = {
        id,
        ...roomData,
        propertyId: Number(roomData.propertyId),
        propertyName: property ? property.name : 'Chưa phân loại',
        status: roomData.status || 'vacant',
        renterId: null,
        renterName: '',
        electricMeter: roomData.electricMeter || 0,
        waterMeter: roomData.waterMeter || 0
      }
      this.rooms.push(newRoom)
      if (property) property.totalRooms = (property.totalRooms || 0) + 1
      this.addAuditLog('Tạo phòng mới', `${newRoom.roomNumber} (${newRoom.propertyName})`, `Thêm phòng diện tích ${newRoom.area}m2, giá ${newRoom.price.toLocaleString('vi-VN')} đ`)
      this.saveToStorage()
      return newRoom
    },
    updateRoom(id, roomData) {
      const index = this.rooms.findIndex(r => r.id === id)
      if (index !== -1) {
        const property = this.properties.find(p => p.id === Number(roomData.propertyId))
        this.rooms[index] = {
          ...this.rooms[index],
          ...roomData,
          propertyId: Number(roomData.propertyId),
          propertyName: property ? property.name : this.rooms[index].propertyName
        }
        this.addAuditLog('Cập nhật phòng', `${this.rooms[index].roomNumber}`, 'Cập nhật thông tin chi tiết phòng')
        this.saveToStorage()
      }
    },
    deleteRoom(id) {
      const room = this.rooms.find(r => r.id === id)
      if (room) {
        this.trash.unshift({ id: Date.now(), originalType: 'room', itemData: room, deletedAt: new Date().toLocaleString() })
        this.rooms = this.rooms.filter(r => r.id !== id)
        const property = this.properties.find(p => p.id === room.propertyId)
        if (property && property.totalRooms > 0) property.totalRooms -= 1
        this.addAuditLog('Xóa phòng', `${room.roomNumber}`, 'Đưa phòng vào thùng rác')
        this.saveToStorage()
      }
    },

    // RENTERS
    addRenter(renterData) {
      const id = Date.now()
      const room = this.rooms.find(r => r.id === Number(renterData.roomId))
      const newRenter = {
        id,
        ...renterData,
        roomId: Number(renterData.roomId),
        roomNumber: room ? room.roomNumber : 'N/A',
        propertyId: room ? room.propertyId : null,
        status: 'active',
        coTenants: renterData.coTenants || []
      }
      this.renters.push(newRenter)

      if (room) {
        room.status = 'rented'
        room.renterId = id
        room.renterName = newRenter.fullName
      }

      this.addAuditLog('Thêm khách thuê', newRenter.fullName, `Gán khách thuê cho phòng ${newRenter.roomNumber}`)
      this.addNotification('Khách thuê mới', `Đã thêm khách thuê ${newRenter.fullName} vào phòng ${newRenter.roomNumber}`, 'success')
      this.saveToStorage()
      return newRenter
    },
    updateRenter(id, updatedData) {
      const index = this.renters.findIndex(r => r.id === id)
      if (index !== -1) {
        this.renters[index] = { ...this.renters[index], ...updatedData }
        this.addAuditLog('Cập nhật thông tin khách', this.renters[index].fullName, 'Chỉnh sửa hồ sơ khách thuê')
        this.saveToStorage()
      }
    },
    deleteRenter(id) {
      const renter = this.renters.find(r => r.id === id)
      if (renter) {
        this.trash.unshift({ id: Date.now(), originalType: 'renter', itemData: renter, deletedAt: new Date().toLocaleString() })
        this.renters = this.renters.filter(r => r.id !== id)
        const room = this.rooms.find(r => r.id === renter.roomId)
        if (room && room.renterId === id) {
          room.status = 'vacant'
          room.renterId = null
          room.renterName = ''
        }
        this.addAuditLog('Xóa khách thuê', renter.fullName, 'Chuyển hồ sơ khách vào thùng rác')
        this.saveToStorage()
      }
    },

    // CONTRACTS
    addContract(contractData) {
      const id = Date.now()
      const room = this.rooms.find(r => r.id === Number(contractData.roomId))
      const renter = this.renters.find(rt => rt.id === Number(contractData.renterId))
      const newContract = {
        id,
        contractNumber: `HD-${new Date().getFullYear()}-${Math.floor(100 + Math.random() * 900)}`,
        ...contractData,
        roomId: Number(contractData.roomId),
        roomNumber: room ? room.roomNumber : 'N/A',
        renterId: Number(contractData.renterId),
        renterName: renter ? renter.fullName : 'N/A',
        propertyId: room ? room.propertyId : null,
        propertyName: room ? room.propertyName : 'N/A',
        status: 'active',
        eSigned: contractData.eSigned || false
      }
      this.contracts.push(newContract)

      if (room) {
        room.status = 'rented'
        room.renterId = newContract.renterId
        room.renterName = newContract.renterName
      }
      if (renter) {
        renter.roomId = newContract.roomId
        renter.roomNumber = newContract.roomNumber
        renter.deposit = newContract.deposit
      }

      this.addAuditLog('Tạo hợp đồng thuê', newContract.contractNumber, `Tạo hợp đồng cho phòng ${newContract.roomNumber} - ${newContract.renterName}`)
      this.addNotification('Hợp đồng mới', `Hợp đồng ${newContract.contractNumber} cho phòng ${newContract.roomNumber} đã được khởi tạo`, 'info')
      this.saveToStorage()
      return newContract
    },
    updateContract(id, updatedData) {
      const index = this.contracts.findIndex(c => c.id === id)
      if (index !== -1) {
        this.contracts[index] = { ...this.contracts[index], ...updatedData }
        this.addAuditLog('Cập nhật hợp đồng', this.contracts[index].contractNumber, 'Cập nhật thời hạn hoặc điều khoản')
        this.saveToStorage()
      }
    },
    terminateContract(id, reason = 'Kết thúc thời hạn', depositSettlement = null) {
      const contract = this.contracts.find(c => c.id === id)
      if (contract) {
        contract.status = 'terminated'
        if (depositSettlement) {
          contract.depositSettlement = depositSettlement
          if (depositSettlement.refundAmount > 0) {
            this.expenses.unshift({
              id: Date.now(),
              title: `Hoàn trả tiền cọc phòng ${contract.roomNumber} (${contract.renterName})`,
              category: 'Hoàn cọc',
              amount: Number(depositSettlement.refundAmount),
              propertyId: contract.propertyId,
              propertyName: contract.propertyName,
              date: new Date().toLocaleDateString('sv-SE'),
              receiptImage: '',
              paidTo: contract.renterName,
              notes: depositSettlement.deductionReason ? `Khấu trừ ${depositSettlement.deductionAmount}đ vì: ${depositSettlement.deductionReason}` : 'Hoàn cọc đủ'
            })
          }
        }
        const room = this.rooms.find(r => r.id === contract.roomId)
        if (room) {
          room.status = 'vacant'
          room.renterId = null
          room.renterName = ''
        }
        const renter = this.renters.find(rt => rt.id === contract.renterId)
        if (renter) {
          renter.status = 'inactive'
        }
        const logDetail = depositSettlement 
          ? `Thanh lý HD ${contract.roomNumber}. Hoàn cọc: ${depositSettlement.refundAmount?.toLocaleString()}đ, Khấu trừ: ${depositSettlement.deductionAmount?.toLocaleString()}đ (${depositSettlement.deductionReason || 'Không'})`
          : `Thanh lý hợp đồng phòng ${contract.roomNumber}. Lý do: ${reason}`
        this.addAuditLog('Thanh lý hợp đồng', contract.contractNumber, logDetail)
        this.saveToStorage()
      }
    },

    // UTILITY READINGS & INVOICES
    recordUtilityReading(data) {
      const room = this.rooms.find(r => r.id === Number(data.roomId))
      if (!room) return null

      const electricUsage = data.currElectric - data.prevElectric
      const waterUsage = data.currWater - data.prevWater
      const electricCost = electricUsage * (this.settings.defaultElectricRate || 3800)
      const waterCost = waterUsage * (this.settings.defaultWaterRate || 18000)

      const reading = {
        id: Date.now(),
        month: data.month,
        year: new Date().getFullYear(),
        roomId: room.id,
        roomNumber: room.roomNumber,
        propertyId: room.propertyId,
        propertyName: room.propertyName,
        prevElectric: data.prevElectric,
        currElectric: data.currElectric,
        electricUsage,
        electricCost,
        prevWater: data.prevWater,
        currWater: data.currWater,
        waterUsage,
        waterCost,
        recordedDate: new Date().toLocaleDateString('sv-SE'),
        recordedBy: 'Chủ Trọ Quản Lý',
        billed: false
      }

      this.utilityReadings.unshift(reading)
      room.electricMeter = data.currElectric
      room.waterMeter = data.currWater

      this.addAuditLog('Ghi chỉ số điện nước', `${room.roomNumber} - ${data.month}`, `Điện: ${electricUsage}kWh, Nước: ${waterUsage}m³`)
      this.saveToStorage()
      return reading
    },

    generateBillFromReading(readingId) {
      const reading = this.utilityReadings.find(u => u.id === readingId)
      if (!reading) return null

      const room = this.rooms.find(r => r.id === reading.roomId)
      const renter = this.renters.find(rt => rt.id === room?.renterId)

      const roomPrice = room ? room.price : 4000000
      const serviceFee = (this.settings.defaultWifiRate || 100000) + (this.settings.defaultGarbageRate || 50000)
      const totalAmount = roomPrice + reading.electricCost + reading.waterCost + serviceFee

      const newBill = {
        id: Date.now(),
        code: `INV-${new Date().getFullYear()}${(new Date().getMonth()+1).toString().padStart(2,'0')}-${reading.roomNumber}`,
        month: reading.month,
        year: reading.year,
        roomId: reading.roomId,
        roomNumber: reading.roomNumber,
        renterId: renter ? renter.id : null,
        renterName: renter ? renter.fullName : (room?.renterName || 'Khách thuê'),
        propertyId: reading.propertyId,
        propertyName: reading.propertyName,
        roomPrice,
        electricUsage: reading.electricUsage,
        electricCost: reading.electricCost,
        waterUsage: reading.waterUsage,
        waterCost: reading.waterCost,
        serviceFee,
        discount: 0,
        totalAmount,
        paidAmount: 0,
        status: 'unpaid',
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toLocaleDateString('sv-SE'),
        paidDate: null,
        paymentMethod: '',
        notes: `Hóa đơn tiền nhà & điện nước tháng ${reading.month}`
      }

      this.bills.unshift(newBill)
      reading.billed = true

      this.addAuditLog('Sinh hóa đơn', newBill.code, `Tạo hóa đơn ${totalAmount.toLocaleString('vi-VN')} đ cho phòng ${newBill.roomNumber}`)
      this.addNotification('Hóa đơn mới', `Hóa đơn ${newBill.code} phòng ${newBill.roomNumber} số tiền ${totalAmount.toLocaleString('vi-VN')} đ đã sẵn sàng`, 'warning', '/bills')
      this.saveToStorage()
      return newBill
    },

    payBill(billId, method = 'VietQR / Chuyển khoản') {
      const bill = this.bills.find(b => b.id === billId)
      if (bill) {
        bill.status = 'paid'
        bill.paidAmount = bill.totalAmount
        bill.paidDate = new Date().toLocaleDateString('sv-SE')
        bill.paymentMethod = method

        this.addAuditLog('Xác nhận thanh toán', bill.code, `Đã thu ${bill.totalAmount.toLocaleString('vi-VN')} đ từ phòng ${bill.roomNumber}`)
        this.addNotification('Thanh toán thành công', `Hóa đơn ${bill.code} của phòng ${bill.roomNumber} đã được thanh toán`, 'success', '/bills')
        this.saveToStorage()
      }
    },

    // MAINTENANCE
    addMaintenanceRequest(data) {
      const id = Date.now()
      const room = this.rooms.find(r => r.id === Number(data.roomId))
      const newReq = {
        id,
        title: data.title,
        propertyId: room ? room.propertyId : 1,
        propertyName: room ? room.propertyName : 'Tòa nhà Minh House - Quận 1',
        roomId: room ? room.id : null,
        roomNumber: room ? room.roomNumber : (data.roomNumber || 'Chung'),
        reporterName: data.reporterName || 'Khách thuê',
        reporterPhone: data.reporterPhone || '',
        category: data.category || 'Khác',
        priority: data.priority || 'Trung bình',
        status: 'Chờ xử lý',
        description: data.description || '',
        createdDate: new Date().toLocaleString('sv-SE').replace('T', ' ').substring(0, 16),
        cost: Number(data.cost || 0),
        assignedTo: 'Kỹ thuật viên'
      }
      this.maintenance.unshift(newReq)

      this.addAuditLog('Gửi yêu cầu sửa chữa', newReq.title, `Yêu cầu từ phòng ${newReq.roomNumber}`)
      this.addNotification('Yêu cầu sửa chữa mới', `Phòng ${newReq.roomNumber} gửi yêu cầu: ${newReq.title}`, 'warning', '/maintenance')
      this.saveToStorage()
      return newReq
    },

    updateMaintenanceStatus(id, status, cost = 0) {
      const item = this.maintenance.find(m => m.id === id)
      if (item) {
        item.status = status
        if (cost > 0) item.cost = cost

        if (status === 'Hoàn thành' && item.cost > 0) {
          this.expenses.unshift({
            id: Date.now(),
            title: `Chi phí sửa chữa: ${item.title} (${item.roomNumber})`,
            category: 'Sửa chữa',
            amount: item.cost,
            propertyId: item.propertyId,
            propertyName: item.propertyName,
            date: new Date().toLocaleDateString('sv-SE'),
            receiptImage: '',
            paidTo: item.assignedTo,
            notes: `Ghi nhận từ phiếu sửa chữa #${item.id}`
          })
        }

        this.addAuditLog('Cập nhật bảo trì', item.title, `Trạng thái: ${status}`)
        this.saveToStorage()
      }
    },

    // EXPENSES
    addExpense(expenseData) {
      const id = Date.now()
      const property = this.properties.find(p => p.id === Number(expenseData.propertyId))
      const newExp = {
        id,
        ...expenseData,
        propertyId: Number(expenseData.propertyId),
        propertyName: property ? property.name : 'Cơ sở chung',
        amount: Number(expenseData.amount)
      }
      this.expenses.unshift(newExp)
      this.addAuditLog('Thêm chi phí', newExp.title, `Số tiền ${newExp.amount.toLocaleString('vi-VN')} đ`)
      this.saveToStorage()
      return newExp
    },

    // NOTIFICATIONS
    markNotificationAsRead(id) {
      const noti = this.notifications.find(n => n.id === id)
      if (noti) {
        noti.read = true
        this.saveToStorage()
      }
    },
    markAllNotificationsAsRead() {
      this.notifications.forEach(n => n.read = true)
      this.saveToStorage()
    },

    // TRASH RESTORE / PERMANENT DELETE
    restoreTrashItem(trashId) {
      const trashIndex = this.trash.findIndex(t => t.id === trashId)
      if (trashIndex !== -1) {
        const item = this.trash[trashIndex]
        if (item.originalType === 'room') this.rooms.push(item.itemData)
        else if (item.originalType === 'renter') this.renters.push(item.itemData)
        else if (item.originalType === 'contract') this.contracts.push(item.itemData)
        else if (item.originalType === 'bill') this.bills.push(item.itemData)
        else if (item.originalType === 'property') this.properties.push(item.itemData)

        this.trash.splice(trashIndex, 1)
        this.addAuditLog('Khôi phục từ thùng rác', item.originalType, `Khôi phục mục #${item.id}`)
        this.saveToStorage()
      }
    },
    permanentlyDeleteTrashItem(trashId) {
      this.trash = this.trash.filter(t => t.id !== trashId)
      this.addAuditLog('Xóa vĩnh viễn', 'Thùng rác', `Đã xóa vĩnh viễn item #${trashId}`)
      this.saveToStorage()
    },
    emptyTrash() {
      this.trash = []
      this.addAuditLog('Dọn sạch thùng rác', 'Thùng rác', 'Dọn dẹp toàn bộ mục trong thùng rác')
      this.saveToStorage()
    },

    // AUDIT LOGS
    addAuditLog(action, recordType, recordId, details, payload = {}) {
      if (!this.auditLogs) this.auditLogs = []
      const newLog = {
        id: Date.now(),
        created_at: new Date().toISOString(),
        user_name: 'Nguyễn Văn Minh (Chủ nhà)',
        action: action || 'MARK_BILL_PAID',
        record_type: recordType || 'General',
        record_id: recordId || Date.now(),
        details: details || 'Đã thực hiện thao tác trên hệ thống.',
        payload: payload || {}
      }
      this.auditLogs.unshift(newLog)
    },

    // SETTINGS UPDATE
    updateSettings(newSettings) {
      this.settings = { ...this.settings, ...newSettings }
      this.addAuditLog('UPDATE_SETTINGS', 'Settings', 'Hệ thống', 'Cập nhật thông tin tài khoản VietQR và tự động hóa', newSettings)
      this.saveToStorage()
    }
  }
})
