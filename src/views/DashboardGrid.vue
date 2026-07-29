<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Stat Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Tổng Số Phòng</div>
            <div class="text-2xl font-black text-slate-900 mt-1">{{ rooms.length }}</div>
          </div>
          <div class="w-11 h-11 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold text-lg">
            🏢
          </div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Phòng Trống</div>
            <div class="text-2xl font-black text-emerald-600 mt-1">{{ vacantCount }}</div>
          </div>
          <div class="w-11 h-11 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-lg">
            🟢
          </div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Đang Ở</div>
            <div class="text-2xl font-black text-rose-600 mt-1">{{ occupiedCount }}</div>
          </div>
          <div class="w-11 h-11 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center font-bold text-lg">
            🔴
          </div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Đã Cọc</div>
            <div class="text-2xl font-black text-amber-600 mt-1">{{ reservedCount }}</div>
          </div>
          <div class="w-11 h-11 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-lg">
            🟡
          </div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Tỷ Lệ Lấp Đầy</div>
            <div class="text-2xl font-black text-blue-600 mt-1">{{ occupancyRate }}%</div>
          </div>
          <div class="w-11 h-11 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold text-lg">
            📈
          </div>
        </div>
      </div>

      <!-- Property & Floor Selector Bar -->
      <div class="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="flex flex-wrap items-center gap-3 w-full md:w-auto">
          <select
            v-model="selectedProperty"
            class="px-4 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-bold text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="all">🏢 Tất cả tòa nhà</option>
            <option v-for="prop in properties" :key="prop.id" :value="prop.name">
              🏛️ {{ prop.name }}
            </option>
          </select>

          <select
            v-model="selectedFloor"
            class="px-4 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-semibold text-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500"
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
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition', selectedFilter === 'all' ? 'bg-slate-900 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']"
          >
            Tất cả ({{ rooms.length }})
          </button>
          <button
            @click="selectedFilter = 'vacant'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition', selectedFilter === 'vacant' ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30' : 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100']"
          >
            🟢 Trống ({{ vacantCount }})
          </button>
          <button
            @click="selectedFilter = 'occupied'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition', selectedFilter === 'occupied' ? 'bg-rose-600 text-white shadow-md shadow-rose-600/30' : 'bg-rose-50 text-rose-700 hover:bg-rose-100']"
          >
            🔴 Đang ở ({{ occupiedCount }})
          </button>
          <button
            @click="selectedFilter = 'reserved'"
            :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition', selectedFilter === 'reserved' ? 'bg-amber-600 text-white shadow-md shadow-amber-600/30' : 'bg-amber-50 text-amber-700 hover:bg-amber-100']"
          >
            🟡 Cọc ({{ reservedCount }})
          </button>
        </div>

        <div class="flex items-center gap-2 w-full md:w-auto">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm số phòng..."
            class="w-full md:w-48 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
          <button
            @click="fetchRooms"
            class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200 transition"
            title="Tải lại sơ đồ"
          >
            🔄
          </button>
        </div>
      </div>

      <!-- Room Grid -->
      <div>
        <div v-if="loading" class="text-center py-16 text-slate-500">
          Đang tải sơ đồ phòng trọ...
        </div>

        <div v-else-if="filteredRooms.length === 0" class="bg-white rounded-2xl p-12 text-center border border-slate-200">
          <p class="text-slate-500 text-base">Không tìm thấy phòng nào phù hợp bộ lọc.</p>
        </div>

        <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          <div
            v-for="room in filteredRooms"
            :key="room.id"
            @click="selectedRoomDetail = room"
            :class="[
              'cursor-pointer rounded-2xl p-5 border-2 transition-all hover:-translate-y-1.5 hover:shadow-xl relative flex flex-col justify-between h-48',
              getStatusCardStyle(room.status)
            ]"
          >
            <div class="flex items-start justify-between">
              <div>
                <span class="text-[11px] font-bold uppercase tracking-wider opacity-70">{{ room.property_name }}</span>
                <h3 class="text-2xl font-black mt-0.5">Phòng {{ room.room_number }}</h3>
              </div>
              <span :class="['px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-wide', getStatusBadgeStyle(room.status)]">
                {{ getStatusLabel(room.status) }}
              </span>
            </div>

            <div class="border-t border-current/10 pt-3 flex items-center justify-between">
              <div>
                <div class="text-xs opacity-75">Giá thuê hàng tháng</div>
                <div class="text-lg font-black font-mono">
                  {{ formatCurrency(room.price) }}
                </div>
              </div>
              <span class="text-xs font-bold underline opacity-80">Xem chi tiết ➔</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Side Drawer for Quick Actions -->
      <div v-if="selectedRoomDetail" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex justify-end">
        <div class="bg-white w-full max-w-md h-full p-6 shadow-2xl overflow-y-auto flex flex-col justify-between">
          <div class="space-y-6">
            <div class="flex items-center justify-between border-b border-slate-100 pb-4">
              <div>
                <span class="text-xs uppercase font-bold text-indigo-600">{{ selectedRoomDetail.property_name }}</span>
                <h3 class="text-2xl font-black text-slate-900">Phòng {{ selectedRoomDetail.room_number }}</h3>
              </div>
              <button @click="selectedRoomDetail = null" class="text-slate-400 hover:text-slate-700 text-xl font-bold">✕</button>
            </div>

            <div class="bg-slate-50 p-4 rounded-xl border border-slate-200 space-y-2 text-sm">
              <div class="flex justify-between">
                <span class="text-slate-500">Trạng thái:</span>
                <span :class="['px-2.5 py-0.5 rounded-full text-xs font-bold uppercase', getStatusBadgeStyle(selectedRoomDetail.status)]">
                  {{ getStatusLabel(selectedRoomDetail.status) }}
                </span>
              </div>
              <div class="flex justify-between">
                <span class="text-slate-500">Giá phòng:</span>
                <span class="font-bold text-slate-900 font-mono">{{ formatCurrency(selectedRoomDetail.price) }} / tháng</span>
              </div>
              <div class="flex justify-between">
                <span class="text-slate-500">Tầng:</span>
                <span class="font-semibold text-slate-800">Tầng {{ selectedRoomDetail.floor || 1 }}</span>
              </div>
            </div>

            <!-- Quick Action Buttons -->
            <div class="space-y-3">
              <h4 class="text-xs uppercase font-bold text-slate-400">Thao tác nhanh</h4>
              <RouterLink
                to="/contracts"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-indigo-600 text-white rounded-xl font-semibold text-sm hover:bg-indigo-700 transition shadow-md shadow-indigo-600/20"
              >
                <span>📄</span> Tạo hợp đồng thuê phòng này
              </RouterLink>
              <RouterLink
                to="/utility-readings"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-amber-500 text-white rounded-xl font-semibold text-sm hover:bg-amber-600 transition shadow-md shadow-amber-500/20"
              >
                <span>⚡</span> Nhập chỉ số điện nước
              </RouterLink>
              <RouterLink
                to="/bills"
                class="w-full flex items-center justify-center gap-2 px-4 py-3 bg-emerald-600 text-white rounded-xl font-semibold text-sm hover:bg-emerald-700 transition shadow-md shadow-emerald-600/20"
              >
                <span>💳</span> Lập hóa đơn & Sinh VietQR
              </RouterLink>
            </div>
          </div>

          <div class="pt-6 border-t border-slate-100">
            <button
              @click="selectedRoomDetail = null"
              class="w-full py-2.5 bg-slate-100 text-slate-700 rounded-xl font-medium text-sm hover:bg-slate-200"
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

const fetchRooms = async () => {
  loading.value = true
  try {
    const [resRooms, resProps] = await Promise.all([
      api.get('/rooms'),
      api.get('/properties')
    ])
    rooms.value = Array.isArray(resRooms?.data) ? resRooms.data.map((room) => ({ ...room, status: normalizeStatus(room.status) })) : fallbackRooms
    properties.value = Array.isArray(resProps?.data) ? resProps.data : []
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
      return 'bg-emerald-50/80 border-emerald-300 text-emerald-950 hover:border-emerald-500'
    case 'occupied':
      return 'bg-rose-50/80 border-rose-300 text-rose-950 hover:border-rose-500'
    case 'reserved':
      return 'bg-amber-50/80 border-amber-300 text-amber-950 hover:border-amber-500'
    default:
      return 'bg-slate-50 border-slate-200 text-slate-900'
  }
}

const getStatusBadgeStyle = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'bg-emerald-200 text-emerald-900'
    case 'occupied':
      return 'bg-rose-200 text-rose-900'
    case 'reserved':
      return 'bg-amber-200 text-amber-900'
    default:
      return 'bg-slate-200 text-slate-800'
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
