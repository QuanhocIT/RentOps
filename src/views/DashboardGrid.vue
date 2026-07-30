<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <h1 class="text-3xl font-black text-slate-900">Tổng quan</h1>
          <p class="mt-1 text-sm text-slate-500">Cập nhật tình hình kinh doanh của bạn hôm nay</p>
        </div>
        <div class="flex items-center gap-3">
          <div class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">
            01/06/2024 - 31/06/2024
          </div>
          <button class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-slate-500 shadow-sm">📅</button>
        </div>
      </div>

      <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <div v-for="card in statCards" :key="card.label" class="rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="flex items-center justify-between">
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl" :class="card.bg">{{ card.icon }}</div>
            <div class="text-xs font-semibold text-emerald-600">↑ {{ card.delta }}</div>
          </div>
          <div class="mt-4 text-sm font-semibold text-slate-500">{{ card.label }}</div>
          <div class="mt-1 text-3xl font-black text-slate-900">{{ card.value }}</div>
          <div class="mt-2 text-xs text-emerald-600">↑ so với tháng trước</div>
        </div>
      </div>

      <div class="grid gap-6 xl:grid-cols-3">
        <section class="xl:col-span-2 rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="mb-5 flex items-center justify-between">
            <div>
              <h2 class="text-lg font-black text-slate-900">Doanh thu</h2>
              <p class="text-sm text-slate-500">Biểu đồ 6 tháng gần nhất</p>
            </div>
            <button class="rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-600">Theo ngày ⌄</button>
          </div>
          <div class="grid h-72 grid-cols-6 items-end gap-4">
            <div v-for="bar in revenueBars" :key="bar.label" class="flex h-full flex-col justify-end gap-2">
              <div class="flex items-end gap-1.5 rounded-t-2xl border-b border-slate-100 pb-1">
                <div class="w-6 rounded-t-xl bg-indigo-500/90" :style="{ height: `${bar.revenue}%` }"></div>
                <div class="w-6 rounded-t-xl bg-slate-200" :style="{ height: `${bar.cost}%` }"></div>
              </div>
              <div class="text-center text-xs font-semibold text-slate-500">{{ bar.label }}</div>
            </div>
          </div>
        </section>

        <section class="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <h2 class="text-lg font-black text-slate-900">Tỷ lệ lấp đầy phòng</h2>
          <div class="mt-6 flex flex-col items-center">
            <div class="relative h-52 w-52">
              <div class="absolute inset-0 rounded-full bg-[conic-gradient(#4f46e5_0deg_282deg,#93c5fd_282deg_345deg,#f59e0b_345deg_360deg)]"></div>
              <div class="absolute inset-5 rounded-full bg-white"></div>
              <div class="absolute inset-0 flex flex-col items-center justify-center">
                <div class="text-4xl font-black text-slate-900">{{ occupancyRate }}%</div>
                <div class="text-sm text-slate-500">Đã lấp đầy</div>
              </div>
            </div>
            <div class="mt-6 space-y-3 w-full text-sm">
              <div class="flex items-center justify-between">
                <span class="flex items-center gap-2 text-slate-600"><span class="h-3 w-3 rounded-full bg-indigo-500"></span> Đã đặt</span>
                <span class="font-semibold">{{ occupiedCount }} phòng</span>
              </div>
              <div class="flex items-center justify-between">
                <span class="flex items-center gap-2 text-slate-600"><span class="h-3 w-3 rounded-full bg-blue-400"></span> Còn trống</span>
                <span class="font-semibold">{{ vacantCount }} phòng</span>
              </div>
              <div class="flex items-center justify-between">
                <span class="flex items-center gap-2 text-slate-600"><span class="h-3 w-3 rounded-full bg-amber-400"></span> Bảo trì</span>
                <span class="font-semibold">{{ maintenanceCount }} phòng</span>
              </div>
            </div>
          </div>
        </section>
      </div>

      <div class="grid gap-4 md:grid-cols-4">
        <div v-for="action in quickActions" :key="action.title" class="rounded-[1.5rem] border border-slate-200 bg-white p-5 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="flex h-12 w-12 items-center justify-center rounded-2xl" :class="action.bg">{{ action.icon }}</div>
          <div class="mt-4 text-base font-black text-slate-900">{{ action.title }}</div>
          <div class="mt-1 text-sm text-slate-500">{{ action.desc }}</div>
        </div>
      </div>

      <div class="grid gap-6 xl:grid-cols-3">
        <section class="xl:col-span-2 rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="mb-5 flex items-center justify-between">
            <div>
              <h2 class="text-lg font-black text-slate-900">Đặt phòng mới nhất</h2>
              <p class="text-sm text-slate-500">Theo dõi booking và trạng thái xử lý</p>
            </div>
            <a href="/contracts" class="text-sm font-semibold text-indigo-600">Xem tất cả</a>
          </div>
          <div class="overflow-hidden rounded-2xl border border-slate-200">
            <table class="w-full text-left text-sm">
              <thead class="bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500">
                <tr>
                  <th class="px-4 py-3">Mã đặt phòng</th>
                  <th class="px-4 py-3">Khách hàng</th>
                  <th class="px-4 py-3">Phòng</th>
                  <th class="px-4 py-3">Nhận phòng</th>
                  <th class="px-4 py-3">Trạng thái</th>
                  <th class="px-4 py-3 text-right">Tổng tiền</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in bookingRows" :key="row.code" class="border-t border-slate-100">
                  <td class="px-4 py-4 font-semibold text-slate-900">{{ row.code }}</td>
                  <td class="px-4 py-4">
                    <div class="font-semibold text-slate-900">{{ row.customer }}</div>
                    <div class="text-xs text-slate-500">{{ row.email }}</div>
                  </td>
                  <td class="px-4 py-4">
                    <div class="font-semibold text-slate-900">{{ row.room }}</div>
                    <div class="text-xs text-slate-500">{{ row.property }}</div>
                  </td>
                  <td class="px-4 py-4 text-slate-600">{{ row.checkin }}</td>
                  <td class="px-4 py-4">
                    <span class="rounded-full px-2.5 py-1 text-xs font-bold" :class="row.statusClass">{{ row.status }}</span>
                  </td>
                  <td class="px-4 py-4 text-right font-semibold text-slate-900">{{ row.total }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section class="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="mb-5 flex items-center justify-between">
            <div>
              <h2 class="text-lg font-black text-slate-900">Phòng hoạt động</h2>
              <p class="text-sm text-slate-500">Xem nhanh mức lấp đầy</p>
            </div>
            <a href="/properties" class="text-sm font-semibold text-indigo-600">Xem tất cả</a>
          </div>
          <div class="space-y-4">
            <div v-for="room in activeRooms" :key="room.name" class="flex items-center gap-3">
              <img :src="room.image" class="h-14 w-14 rounded-2xl object-cover" :alt="room.name" />
              <div class="min-w-0 flex-1">
                <div class="text-sm font-bold text-slate-900">{{ room.name }}</div>
                <div class="text-xs text-slate-500">{{ room.rooms }}</div>
                <div class="mt-2 h-2 rounded-full bg-slate-100">
                  <div class="h-2 rounded-full bg-indigo-500" :style="{ width: room.fill }"></div>
                </div>
              </div>
              <div class="text-sm font-semibold text-slate-500">{{ room.fill }}</div>
            </div>
          </div>
        </section>
      </div>

      <div class="grid gap-6 xl:grid-cols-3">
        <section class="xl:col-span-2 rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="mb-5 flex items-center justify-between">
            <div>
              <h2 class="text-lg font-black text-slate-900">Doanh thu theo phòng</h2>
              <p class="text-sm text-slate-500">Bảng tóm tắt theo từng phòng</p>
            </div>
            <a href="/reports" class="text-sm font-semibold text-indigo-600">Xem báo cáo chi tiết</a>
          </div>
          <div class="overflow-hidden rounded-2xl border border-slate-200">
            <table class="w-full text-left text-sm">
              <thead class="bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500">
                <tr>
                  <th class="px-4 py-3">Phòng</th>
                  <th class="px-4 py-3">Doanh thu</th>
                  <th class="px-4 py-3">Đặt phòng</th>
                  <th class="px-4 py-3">Tỷ lệ lấp đầy</th>
                  <th class="px-4 py-3 text-right">Giá trung bình</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in revenueByRoom" :key="row.name" class="border-t border-slate-100">
                  <td class="px-4 py-4">
                    <div class="font-semibold text-slate-900">{{ row.name }}</div>
                  </td>
                  <td class="px-4 py-4 font-semibold text-slate-900">{{ row.revenue }}</td>
                  <td class="px-4 py-4 text-slate-600">{{ row.bookings }}</td>
                  <td class="px-4 py-4">
                    <div class="mb-1 text-xs font-semibold text-slate-600">{{ row.fillLabel }}</div>
                    <div class="h-2 rounded-full bg-slate-100">
                      <div class="h-2 rounded-full" :class="row.fillColor" :style="{ width: row.fillLabel }"></div>
                    </div>
                  </td>
                  <td class="px-4 py-4 text-right text-slate-600">{{ row.avg }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section class="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
          <div class="mb-5 flex items-center justify-between">
            <div>
              <h2 class="text-lg font-black text-slate-900">Thông báo mới</h2>
              <p class="text-sm text-slate-500">Những việc cần xử lý ngay</p>
            </div>
            <a href="/notifications" class="text-sm font-semibold text-indigo-600">Xem tất cả</a>
          </div>
          <div class="space-y-4">
            <div v-for="item in notifications" :key="item.title" class="flex gap-3 rounded-2xl border border-slate-100 p-3">
              <div class="flex h-11 w-11 items-center justify-center rounded-2xl" :class="item.bg">{{ item.icon }}</div>
              <div class="min-w-0 flex-1">
                <div class="text-sm font-bold text-slate-900">{{ item.title }}</div>
                <div class="text-xs text-slate-500">{{ item.desc }}</div>
              </div>
              <div class="text-xs text-slate-400">{{ item.time }}</div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const dashboardData = ref(null)
const rooms = ref([])

const fallbackRooms = [
  { id: 1, property_name: 'Deluxe City View', room_number: '101', price: 2850000, status: 'occupied', floor: 1 },
  { id: 2, property_name: 'Studio Balcony', room_number: '203', price: 1950000, status: 'vacant', floor: 2 },
  { id: 3, property_name: 'Family Room', room_number: '301', price: 3200000, status: 'reserved', floor: 3 },
  { id: 4, property_name: 'Standard Room', room_number: '102', price: 1560000, status: 'occupied', floor: 1 },
  { id: 5, property_name: 'Penthouse Suite', room_number: '501', price: 4250000, status: 'maintenance', floor: 5 }
]

const normalizeStatus = (status) => {
  if (status === 0 || status === '0') return 'vacant'
  if (status === 1 || status === '1') return 'occupied'
  if (status === 2 || status === '2') return 'reserved'
  if (status === 3 || status === '3') return 'maintenance'
  return status
}

const fetchData = async () => {
  try {
    const [resRooms, resDash] = await Promise.all([api.get('/rooms'), api.get('/dashboard/summary')])
    rooms.value = Array.isArray(resRooms?.data) ? resRooms.data.map((room) => ({ ...room, status: normalizeStatus(room.status) })) : fallbackRooms
    dashboardData.value = resDash?.data || null
  } catch {
    rooms.value = fallbackRooms
  }
}

onMounted(fetchData)

const vacantCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'vacant').length)
const occupiedCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'occupied').length)
const reservedCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'reserved').length)
const maintenanceCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'maintenance').length)
const occupancyRate = computed(() => {
  const total = rooms.value.length || 1
  return Math.round((occupiedCount.value / total) * 100)
})

const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value || 0)

const statCards = computed(() => [
  { label: 'Tổng doanh thu', value: formatCurrency(dashboardData.value?.financials?.paid_billed || 128500000), delta: '18.5%', icon: '💳', bg: 'bg-indigo-50 text-indigo-600' },
  { label: 'Đơn đặt phòng', value: '156', delta: '12.5%', icon: '📄', bg: 'bg-sky-50 text-sky-600' },
  { label: 'Tỷ lệ lấp đầy', value: `${occupancyRate.value}%`, delta: '8.3%', icon: '🧡', bg: 'bg-amber-50 text-amber-500' },
  { label: 'Đánh giá trung bình', value: '4.8/5', delta: '0.3', icon: '⭐', bg: 'bg-violet-50 text-violet-500' }
])

const revenueBars = [
  { label: '01/06', revenue: 22, cost: 10 },
  { label: '06/06', revenue: 34, cost: 12 },
  { label: '11/06', revenue: 52, cost: 18 },
  { label: '16/06', revenue: 58, cost: 16 },
  { label: '21/06', revenue: 44, cost: 15 },
  { label: '31/06', revenue: 66, cost: 22 }
]

const quickActions = [
  { title: 'Thêm phòng mới', desc: 'Đăng phòng cho thuê', icon: '🏠', bg: 'bg-indigo-50 text-indigo-600' },
  { title: 'Quản lý giá', desc: 'Cập nhật giá phòng', icon: '💲', bg: 'bg-emerald-50 text-emerald-600' },
  { title: 'Xem lịch đặt phòng', desc: 'Quản lý lịch & đặt phòng', icon: '📅', bg: 'bg-sky-50 text-sky-600' },
  { title: 'Báo cáo doanh thu', desc: 'Xem chi tiết báo cáo', icon: '📊', bg: 'bg-amber-50 text-amber-500' }
]

const bookingRows = [
  { code: '#BKT12456', customer: 'Trần Thị Mai', email: 'maitran@email.com', room: 'Deluxe City View 101', property: 'Homestay Minh House', checkin: '20/06/2024', status: 'Đã xác nhận', statusClass: 'bg-emerald-100 text-emerald-700', total: '2.500.000 đ' },
  { code: '#BKT12455', customer: 'Lê Hoàng Nam', email: 'namle@email.com', room: 'Studio Balcony 203', property: 'Homestay Minh House', checkin: '21/06/2024', status: 'Chờ xác nhận', statusClass: 'bg-amber-100 text-amber-700', total: '1.800.000 đ' },
  { code: '#BKT12454', customer: 'Phạm Minh Anh', email: 'anhpham@email.com', room: 'Family Room 301', property: 'Homestay Minh House', checkin: '22/06/2024', status: 'Đã thanh toán', statusClass: 'bg-sky-100 text-sky-700', total: '3.200.000 đ' },
  { code: '#BKT12453', customer: 'Nguyễn Văn Hùng', email: 'hungnguyen@email.com', room: 'Deluxe City View 102', property: 'Homestay Minh House', checkin: '23/06/2024', status: 'Đã xác nhận', statusClass: 'bg-emerald-100 text-emerald-700', total: '2.500.000 đ' },
  { code: '#BKT12452', customer: 'Vũ Thị Hương', email: 'huongvu@email.com', room: 'Studio Balcony 204', property: 'Homestay Minh House', checkin: '24/06/2024', status: 'Đã hủy', statusClass: 'bg-rose-100 text-rose-700', total: '1.800.000 đ' }
]

const activeRooms = [
  { name: 'Deluxe City View', rooms: '12 phòng', fill: '86%', image: '/images/rooms/main.png' },
  { name: 'Studio Balcony', rooms: '8 phòng', fill: '70%', image: '/images/rooms/living.png' },
  { name: 'Family Room', rooms: '6 phòng', fill: '73%', image: '/images/rooms/kitchen.png' },
  { name: 'Standard Room', rooms: '10 phòng', fill: '60%', image: '/images/rooms/bathroom.png' },
  { name: 'Penthouse Suite', rooms: '2 phòng', fill: '50%', image: '/images/bedroom.png' }
]

const revenueByRoom = [
  { name: 'Deluxe City View', revenue: '28.500.000 đ', bookings: 35, fillLabel: '85%', fillColor: 'bg-emerald-500', avg: '2.850.000 đ' },
  { name: 'Studio Balcony', revenue: '18.200.000 đ', bookings: 28, fillLabel: '70%', fillColor: 'bg-amber-500', avg: '1.950.000 đ' },
  { name: 'Family Room', revenue: '24.800.000 đ', bookings: 22, fillLabel: '73%', fillColor: 'bg-emerald-500', avg: '3.200.000 đ' },
  { name: 'Standard Room', revenue: '15.600.000 đ', bookings: 30, fillLabel: '60%', fillColor: 'bg-orange-500', avg: '1.560.000 đ' },
  { name: 'Penthouse Suite', revenue: '8.500.000 đ', bookings: 8, fillLabel: '50%', fillColor: 'bg-rose-500', avg: '4.250.000 đ' }
]

const notifications = [
  { icon: '🧾', title: 'Đặt phòng mới', desc: 'Trần Thị Mai đã đặt phòng Deluxe City View', time: '2 phút trước', bg: 'bg-emerald-50 text-emerald-600' },
  { icon: '⭐', title: 'Nhận xét mới', desc: 'Khách hàng đã để lại đánh giá 5 sao', time: '15 phút trước', bg: 'bg-amber-50 text-amber-500' },
  { icon: '💳', title: 'Thanh toán thành công', desc: 'Lê Hoàng Nam đã thanh toán thành công', time: '1 giờ trước', bg: 'bg-sky-50 text-sky-600' },
  { icon: '🔔', title: 'Nhắc nhở', desc: 'Có 3 đặt phòng sẽ đến trong hôm nay', time: '2 giờ trước', bg: 'bg-violet-50 text-violet-600' }
]
</script>
