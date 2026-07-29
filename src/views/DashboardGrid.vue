<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <!-- Top Alert Notifications Bar -->
      <div v-if="dashboardData?.expiring_contracts?.length > 0 || dashboardData?.counters?.pending_maintenance_count > 0" class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div v-if="dashboardData?.expiring_contracts?.length > 0" class="bg-amber-500/10 border border-amber-500/30 backdrop-blur-md rounded-2xl p-4 flex items-center justify-between shadow-sm hover:shadow-md transition">
          <div class="flex items-center gap-3">
            <span class="text-2xl animate-pulse">⚠️</span>
            <div>
              <div class="text-sm font-bold text-amber-950">Có {{ dashboardData.expiring_contracts.length }} hợp đồng sắp hết hạn (30 ngày)</div>
              <div class="text-xs text-amber-800">Phòng {{ dashboardData.expiring_contracts.map(c => c.room_number).join(', ') }}</div>
            </div>
          </div>
          <RouterLink to="/contracts" class="px-3.5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold shadow-md shadow-amber-600/20 transition hover:scale-105">Gia hạn ➔</RouterLink>
        </div>

        <div v-if="dashboardData?.counters?.pending_maintenance_count > 0" class="bg-rose-500/10 border border-rose-500/30 backdrop-blur-md rounded-2xl p-4 flex items-center justify-between shadow-sm hover:shadow-md transition">
          <div class="flex items-center gap-3">
            <span class="text-2xl animate-bounce">🛠️</span>
            <div>
              <div class="text-sm font-bold text-rose-950">Có {{ dashboardData.counters.pending_maintenance_count }} sự cố sửa chữa chưa xử lý</div>
              <div class="text-xs text-rose-800">Cần phân công kỹ thuật viên kiểm tra</div>
            </div>
          </div>
          <RouterLink to="/maintenance" class="px-3.5 py-2 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-xs font-bold shadow-md shadow-rose-600/20 transition hover:scale-105">Xem sự cố ➔</RouterLink>
        </div>
      </div>

      <!-- Stat Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-5 border border-slate-200/80 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1 flex items-center justify-between group">
          <div>
            <div class="text-[11px] uppercase tracking-wider font-extrabold text-slate-400">Tổng Số Phòng</div>
            <div class="text-3xl font-black text-slate-900 mt-1 font-mono group-hover:text-indigo-600 transition-colors">{{ rooms.length }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold text-xl shadow-inner group-hover:scale-110 transition-transform">
            🏢
          </div>
        </div>

        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-5 border border-emerald-100 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1 flex items-center justify-between group">
          <div>
            <div class="text-[11px] uppercase tracking-wider font-extrabold text-emerald-600/70">Phòng Trống</div>
            <div class="text-3xl font-black text-emerald-600 mt-1 font-mono">{{ vacantCount }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-xl shadow-inner group-hover:scale-110 transition-transform">
            🟢
          </div>
        </div>

        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-5 border border-rose-100 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1 flex items-center justify-between group">
          <div>
            <div class="text-[11px] uppercase tracking-wider font-extrabold text-rose-600/70">Đang Ở</div>
            <div class="text-3xl font-black text-rose-600 mt-1 font-mono">{{ occupiedCount }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center font-bold text-xl shadow-inner group-hover:scale-110 transition-transform">
            🔴
          </div>
        </div>

        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-5 border border-amber-100 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1 flex items-center justify-between group">
          <div>
            <div class="text-[11px] uppercase tracking-wider font-extrabold text-amber-600/70">Đã Cọc</div>
            <div class="text-3xl font-black text-amber-600 mt-1 font-mono">{{ reservedCount }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-xl shadow-inner group-hover:scale-110 transition-transform">
            🟡
          </div>
        </div>

        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-5 border border-blue-100 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1 flex items-center justify-between group">
          <div>
            <div class="text-[11px] uppercase tracking-wider font-extrabold text-blue-600/70">Tỷ Lệ Lấp Đầy</div>
            <div class="text-3xl font-black text-blue-600 mt-1 font-mono">{{ occupancyRate }}%</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold text-xl shadow-inner group-hover:scale-110 transition-transform">
            📈
          </div>
        </div>
      </div>

      <!-- Financial Overview & Trend Chart Section -->
      <div v-if="dashboardData?.financials" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- 6-Month Financial Trend Chart -->
        <div class="lg:col-span-2 bg-white/90 backdrop-blur-md rounded-2xl p-6 border border-slate-200/80 shadow-sm hover:shadow-md transition space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <div>
              <h3 class="text-base font-extrabold text-slate-900 flex items-center gap-2">📊 Xu Hướng Tài Chính 6 Tháng Gần Nhất</h3>
              <p class="text-xs text-slate-500 mt-0.5">So sánh Tiền Đã Thu vs Chi Phí Vận Hành thực tế</p>
            </div>
            <div class="flex items-center gap-4 text-xs font-bold">
              <span class="flex items-center gap-1.5 text-emerald-600"><span class="w-3 h-3 rounded-full bg-emerald-500 inline-block shadow-xs"></span> Đã thu</span>
              <span class="flex items-center gap-1.5 text-rose-500"><span class="w-3 h-3 rounded-full bg-rose-400 inline-block shadow-xs"></span> Chi phí</span>
            </div>
          </div>

          <!-- SVG Chart / Bar chart -->
          <div class="h-56 flex items-end justify-between gap-4 pt-6 pb-2 px-2">
            <div
              v-for="(item, idx) in dashboardData.financial_trends || []"
              :key="idx"
              class="flex-1 flex flex-col items-center gap-2 h-full justify-end group relative"
            >
              <!-- Tooltip -->
              <div class="absolute -top-12 opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-slate-900 text-white text-[11px] font-semibold py-1.5 px-3 rounded-xl whitespace-nowrap z-20 pointer-events-none shadow-xl">
                {{ item.month_name }}: Thu {{ formatCurrency(item.paid_billed) }} | Chi {{ formatCurrency(item.expenses) }}
              </div>

              <!-- Bars container -->
              <div class="w-full flex items-end justify-center gap-1.5 h-44 border-b border-slate-200 pb-1">
                <!-- Paid Revenue Bar -->
                <div
                  class="w-5/12 bg-gradient-to-t from-emerald-600 to-emerald-400 rounded-t-lg transition-all duration-300 group-hover:brightness-110 shadow-sm"
                  :style="{ height: getBarHeight(item.paid_billed) + '%' }"
                ></div>
                <!-- Expenses Bar -->
                <div
                  class="w-5/12 bg-gradient-to-t from-rose-500 to-rose-300 rounded-t-lg transition-all duration-300 group-hover:brightness-110 shadow-sm"
                  :style="{ height: getBarHeight(item.expenses) + '%' }"
                ></div>
              </div>
              <span class="text-xs font-bold text-slate-600 mt-1">{{ item.month_name }}</span>
            </div>
          </div>
        </div>

        <!-- Quick Financial Summary Card -->
        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-6 border border-slate-200/80 shadow-sm flex flex-col justify-between space-y-4">
          <div>
            <h3 class="text-base font-extrabold text-slate-900 border-b border-slate-100 pb-3">💰 Tổng Quan Thu Chi Tháng Này</h3>
            <div class="mt-4 space-y-3">
              <div class="flex justify-between items-center text-xs font-medium">
                <span class="text-slate-500">Doanh thu dự kiến:</span>
                <span class="font-bold text-slate-900 font-mono">{{ formatCurrency(dashboardData.financials.monthly_revenue_estimate) }}</span>
              </div>
              <div class="flex justify-between items-center text-xs font-medium">
                <span class="text-slate-500">Đã phát hành hóa đơn:</span>
                <span class="font-bold text-indigo-600 font-mono">{{ formatCurrency(dashboardData.financials.total_billed) }}</span>
              </div>
              <div class="flex justify-between items-center text-xs font-medium">
                <span class="text-slate-500">Đã thực thu:</span>
                <span class="font-bold text-emerald-600 font-mono">{{ formatCurrency(dashboardData.financials.paid_billed) }}</span>
              </div>
              <div class="flex justify-between items-center text-xs font-medium">
                <span class="text-slate-500">Hóa đơn còn nợ:</span>
                <span class="font-bold text-amber-600 font-mono">{{ formatCurrency(dashboardData.financials.pending_billed) }}</span>
              </div>
              <div class="flex justify-between items-center text-xs font-medium">
                <span class="text-slate-500">Tổng chi phí vận hành:</span>
                <span class="font-bold text-rose-600 font-mono">{{ formatCurrency(dashboardData.financials.total_expenses) }}</span>
              </div>
            </div>
          </div>

          <div class="gradient-dark-card text-white rounded-2xl p-4 space-y-1 shadow-lg border border-slate-700/50">
            <div class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Lợi Nhuận Thuần Ước Tính</div>
            <div class="text-2xl font-black font-mono text-emerald-400">
              {{ formatCurrency(dashboardData.financials.net_profit_estimate) }}
            </div>
          </div>
        </div>
      </div>

      <!-- Property & Floor Selector Bar -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl p-4 border border-slate-200/80 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="flex flex-wrap items-center gap-3 w-full md:w-auto">
          <select
            v-model="selectedProperty"
            class="px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
          >
            <option value="all">🏢 Tất cả tòa nhà</option>
            <option v-for="prop in properties" :key="prop.id" :value="prop.name">
              🏛️ {{ prop.name }}
            </option>
          </select>

          <select
            v-model="selectedFloor"
            class="px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold text-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
          >
            <option value="all">📐 Tất cả các tầng</option>
            <option value="1">Tầng 1</option>
            <option value="2">Tầng 2</option>
            <option value="3">Tầng 3</option>
          </select>
        </div>

        <div class="flex items-center gap-2 overflow-x-auto w-full md:w-auto">
          <button
            @click="selectedFilter = 'all'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition duration-200', selectedFilter === 'all' ? 'bg-slate-900 text-white shadow-md' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']"
          >
            Tất cả ({{ rooms.length }})
          </button>
          <button
            @click="selectedFilter = 'vacant'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition duration-200', selectedFilter === 'vacant' ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30' : 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100']"
          >
            🟢 Trống ({{ vacantCount }})
          </button>
          <button
            @click="selectedFilter = 'occupied'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition duration-200', selectedFilter === 'occupied' ? 'bg-rose-600 text-white shadow-md shadow-rose-600/30' : 'bg-rose-50 text-rose-700 hover:bg-rose-100']"
          >
            🔴 Đang ở ({{ occupiedCount }})
          </button>
          <button
            @click="selectedFilter = 'reserved'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition duration-200', selectedFilter === 'reserved' ? 'bg-amber-600 text-white shadow-md shadow-amber-600/30' : 'bg-amber-50 text-amber-700 hover:bg-amber-100']"
          >
            🟡 Cọc ({{ reservedCount }})
          </button>
        </div>

        <div class="flex items-center gap-2 w-full md:w-auto">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm số phòng..."
            class="w-full md:w-48 px-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
          />
          <button
            @click="fetchRooms"
            class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200 transition active:scale-95"
            title="Tải lại sơ đồ"
          >
            🔄
          </button>
        </div>
      </div>

      <!-- Room Grid -->
      <div>
        <div v-if="loading" class="text-center py-16 text-slate-500 animate-pulse">
          Đang tải sơ đồ phòng trọ...
        </div>

        <div v-else-if="filteredRooms.length === 0" class="bg-white/90 rounded-2xl p-12 text-center border border-slate-200">
          <p class="text-slate-500 text-sm">Không tìm thấy phòng nào phù hợp bộ lọc.</p>
        </div>

        <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
          <div
            v-for="room in filteredRooms"
            :key="room.id"
            @click="selectedRoomDetail = room"
            :class="[
              'cursor-pointer rounded-2xl p-5 border-2 transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl relative flex flex-col justify-between h-48 group',
              getStatusCardStyle(room.status)
            ]"
          >
            <div class="flex items-start justify-between">
              <div>
                <span class="text-[10px] font-extrabold uppercase tracking-wider opacity-75 truncate block max-w-[140px]">{{ room.property_name }}</span>
                <h3 class="text-2xl font-black mt-0.5 group-hover:scale-105 transition-transform">Phòng {{ room.room_number }}</h3>
              </div>
              <span :class="['px-2.5 py-1 rounded-full text-[10px] font-extrabold uppercase tracking-wide shadow-2xs', getStatusBadgeStyle(room.status)]">
                {{ getStatusLabel(room.status) }}
              </span>
            </div>

            <div class="border-t border-current/10 pt-3 flex items-center justify-between">
              <div>
                <div class="text-[11px] opacity-75">Giá thuê hàng tháng</div>
                <div class="text-lg font-black font-mono">
                  {{ formatCurrency(room.price) }}
                </div>
              </div>
              <span class="text-xs font-bold underline opacity-80 group-hover:opacity-100 group-hover:translate-x-1 transition">Xem chi tiết ➔</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Side Drawer for Quick Actions -->
      <div v-if="selectedRoomDetail" class="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-sm flex justify-end animate-fade-in">
        <div class="bg-white w-full max-w-md h-full p-6 shadow-2xl overflow-y-auto flex flex-col justify-between animate-scale-in">
          <div class="space-y-6">
            <div class="flex items-center justify-between border-b border-slate-100 pb-4">
              <div>
                <span class="text-xs uppercase font-extrabold text-indigo-600">{{ selectedRoomDetail.property_name }}</span>
                <h3 class="text-2xl font-black text-slate-900">Phòng {{ selectedRoomDetail.room_number }}</h3>
              </div>
              <button @click="selectedRoomDetail = null" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
            </div>

            <div class="bg-slate-50/80 p-4 rounded-2xl border border-slate-200 space-y-2.5 text-xs font-medium">
              <div class="flex justify-between items-center">
                <span class="text-slate-500">Trạng thái:</span>
                <span :class="['px-2.5 py-0.5 rounded-full text-[10px] font-extrabold uppercase', getStatusBadgeStyle(selectedRoomDetail.status)]">
                  {{ getStatusLabel(selectedRoomDetail.status) }}
                </span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-slate-500">Giá phòng:</span>
                <span class="font-bold text-slate-900 font-mono text-sm">{{ formatCurrency(selectedRoomDetail.price) }} / tháng</span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-slate-500">Tầng:</span>
                <span class="font-semibold text-slate-800">Tầng {{ selectedRoomDetail.floor || 1 }}</span>
              </div>
            </div>

            <!-- Quick Action Buttons -->
            <div class="space-y-3">
              <h4 class="text-[11px] uppercase font-extrabold text-slate-400 tracking-wider">Thao tác nhanh</h4>
              <RouterLink
                to="/contracts"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-indigo-600 text-white rounded-xl font-bold text-xs hover:bg-indigo-700 transition shadow-md shadow-indigo-600/20 active:scale-98"
              >
                <span>📄</span> Tạo hợp đồng thuê phòng này
              </RouterLink>
              <RouterLink
                to="/utility-readings"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-amber-500 text-white rounded-xl font-bold text-xs hover:bg-amber-600 transition shadow-md shadow-amber-500/20 active:scale-98"
              >
                <span>⚡</span> Nhập chỉ số điện nước
              </RouterLink>
              <RouterLink
                to="/bills"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-emerald-600 text-white rounded-xl font-bold text-xs hover:bg-emerald-700 transition shadow-md shadow-emerald-600/20 active:scale-98"
              >
                <span>💳</span> Lập hóa đơn & Sinh VietQR
              </RouterLink>
            </div>
          </div>

          <div class="pt-6 border-t border-slate-100">
            <button
              @click="selectedRoomDetail = null"
              class="w-full py-2.5 bg-slate-100 text-slate-700 rounded-xl font-bold text-xs hover:bg-slate-200 transition"
            >
              Đóng lại
            </button>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const loading = ref(false)
const rooms = ref([])
const properties = ref([])
const selectedProperty = ref('all')
const selectedFloor = ref('all')
const selectedFilter = ref('all')
const searchQuery = ref('')
const selectedRoomDetail = ref(null)

const fallbackRooms = [
  { id: 1, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '101', price: 3500000, status: 'vacant', floor: 1 },
  { id: 2, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '102', price: 3800000, status: 'occupied', floor: 1 },
  { id: 3, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '103', price: 3500000, status: 'reserved', floor: 1 },
  { id: 4, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '201', price: 4200000, status: 'occupied', floor: 2 }
]

const normalizeStatus = (status) => {
  if (status === 0 || status === '0') return 'vacant'
  if (status === 1 || status === '1') return 'occupied'
  if (status === 2 || status === '2') return 'reserved'
  if (status === 3 || status === '3') return 'maintenance'
  return status
}

const dashboardData = ref(null)

const getBarHeight = (amount) => {
  if (!dashboardData.value?.financial_trends || dashboardData.value.financial_trends.length === 0) return 10
  const maxVal = Math.max(
    ...dashboardData.value.financial_trends.map(t => Math.max(t.paid_billed || 0, t.expenses || 0)),
    1000000
  )
  return Math.max(10, Math.min(100, Math.round(((amount || 0) / maxVal) * 100)))
}

const fetchRooms = async () => {
  loading.value = true
  try {
    const [resRooms, resProps, resDash] = await Promise.all([
      api.get('/rooms'),
      api.get('/properties'),
      api.get('/dashboard/summary')
    ])
    rooms.value = Array.isArray(resRooms?.data) ? resRooms.data.map((room) => ({ ...room, status: normalizeStatus(room.status) })) : fallbackRooms
    properties.value = Array.isArray(resProps?.data) ? resProps.data : []
    dashboardData.value = resDash?.data || null
  } catch (error) {
    console.warn('Backend API unavailable, using fallback data.', error)
    rooms.value = fallbackRooms
  } finally {
    loading.value = false
  }
}

onMounted(fetchRooms)

const vacantCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'vacant').length)
const occupiedCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'occupied').length)
const reservedCount = computed(() => rooms.value.filter((room) => normalizeStatus(room.status) === 'reserved').length)
const occupancyRate = computed(() => {
  if (rooms.value.length === 0) return 0
  return Math.round((occupiedCount.value / rooms.value.length) * 100)
})

const filteredRooms = computed(() => {
  return rooms.value.filter((room) => {
    const status = normalizeStatus(room.status)
    const matchesStatus = selectedFilter.value === 'all' || status === selectedFilter.value
    const matchesProp = selectedProperty.value === 'all' || room.property_name === selectedProperty.value
    const matchesFloor = selectedFloor.value === 'all' || String(room.floor || 1) === selectedFloor.value
    const matchesSearch = !searchQuery.value || String(room.room_number).toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesStatus && matchesProp && matchesFloor && matchesSearch
  })
})

const getStatusCardStyle = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'bg-emerald-50/90 border-emerald-300/80 text-emerald-950 hover:border-emerald-500'
    case 'occupied':
      return 'bg-rose-50/90 border-rose-300/80 text-rose-950 hover:border-rose-500'
    case 'reserved':
      return 'bg-amber-50/90 border-amber-300/80 text-amber-950 hover:border-amber-500'
    default:
      return 'bg-slate-50 border-slate-200 text-slate-900'
  }
}

const getStatusBadgeStyle = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'bg-emerald-200/80 text-emerald-900'
    case 'occupied':
      return 'bg-rose-200/80 text-rose-900'
    case 'reserved':
      return 'bg-amber-200/80 text-amber-900'
    default:
      return 'bg-slate-200/80 text-slate-800'
  }
}

const getStatusLabel = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'Trống'
    case 'occupied':
      return 'Đang Ở'
    case 'reserved':
      return 'Đã Cọc'
    case 'maintenance':
      return 'Bảo Trì'
    default:
      return 'N/A'
  }
}

const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value || 0)
</script>
