// RentOps Standard Constants & Enums

export const ROOM_STATUS = {
  RENTED: 'rented',
  VACANT: 'vacant',
  MAINTENANCE: 'maintenance',
  RESERVED: 'reserved'
}

export const ROOM_STATUS_LABELS = {
  [ROOM_STATUS.RENTED]: 'Đang thuê 🔴',
  [ROOM_STATUS.VACANT]: 'Trống 🟢',
  [ROOM_STATUS.MAINTENANCE]: 'Bảo trì 🔧',
  [ROOM_STATUS.RESERVED]: 'Đã cọc 🟡'
}

export const BILL_STATUS = {
  PAID: 'paid',
  UNPAID: 'unpaid',
  OVERDUE: 'overdue',
  CANCELLED: 'cancelled'
}

export const DEFAULT_RATES = {
  ELECTRIC_RATE: 3500, // VNĐ/kWh
  WATER_RATE: 18000,   // VNĐ/m3
  SERVICE_FEE: 150000  // VNĐ/tháng
}

export const CONTRACT_EXPIRY_WARNING_DAYS = 30
