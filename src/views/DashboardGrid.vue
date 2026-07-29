<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <!-- Header -->
    <div class="max-w-7xl mx-auto mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-slate-900 tracking-tight">
          Sơ Đồ Phòng Trọ - RentOps
        </h1>
        <p class="text-slate-500 text-sm mt-1">
          Tenant: <span class="font-semibold text-indigo-600">{{ authStore.currentTenant?.name || 'Tòa Nhà Demo RentOps' }}</span>
        </p>
      </div>

      <!-- Quick Action buttons -->
      <div class="flex items-center gap-3">
        <button 
          @click="fetchRooms" 
          class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition"
        >
          <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          Làm mới
        </button>
        <button 
          class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-lg text-sm font-medium text-white hover:bg-indigo-700 shadow-sm transition"
        >
          + Thêm Phòng Mới
        </button>
      </div>
    </div>

    <!-- Summary Stats Bar -->
    <div class="max-w-7xl mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <!-- Total Rooms -->
      <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between">
          <span class="text-sm font-medium text-slate-500">Tổng Số Phòng</span>
          <div class="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center text-indigo-600 font-bold">
            🏢
          </div>
        </div>
        <div class="text-3xl font-bold text-slate-900 mt-2">{{ rooms.length }}</div>
        <div class="text-xs text-slate-400 mt-1">Cập nhật thời gian thực</div>
      </div>

      <!-- Vacant (Trống) -->
      <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between">
          <span class="text-sm font-medium text-slate-500">Phòng Trống</span>
          <div class="w-10 h-10 rounded-lg bg-emerald-50 flex items-center justify-center text-emerald-600 font-bold">
            🟢
          </div>
        </div>
        <div class="text-3xl font-bold text-emerald-600 mt-2">{{ vacantCount }}</div>
        <div class="text-xs text-emerald-700/70 mt-1">Sẵn sàng cho thuê</div>
      </div>

      <!-- Occupied (Đang ở) -->
      <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between">
          <span class="text-sm font-medium text-slate-500">Đang Ở</span>
          <div class="w-10 h-10 rounded-lg bg-rose-50 flex items-center justify-center text-rose-600 font-bold">
            🔴
          </div>
        </div>
        <div class="text-3xl font-bold text-rose-600 mt-2">{{ occupiedCount }}</div>
        <div class="text-xs text-rose-700/70 mt-1">Đã có hợp đồng</div>
      </div>

      <!-- Reserved (Cọc) -->
      <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between">
          <span class="text-sm font-medium text-slate-500">Đã Giữ Cọc</span>
          <div class="w-10 h-10 rounded-lg bg-amber-50 flex items-center justify-center text-amber-600 font-bold">
            🟡
          </div>
        </div>
        <div class="text-3xl font-bold text-amber-600 mt-2">{{ reservedCount }}</div>
        <div class="text-xs text-amber-700/70 mt-1">Chờ nhận phòng</div>
      </div>
    </div>

    <!-- Filter & Search Controls -->
    <div class="max-w-7xl mx-auto bg-white rounded-xl p-4 border border-slate-200 shadow-sm mb-6 flex flex-col md:flex-row items-center justify-between gap-4">
      <!-- Status Filter Tabs -->
      <div class="flex items-center gap-2 overflow-x-auto w-full md:w-auto">
        <button 
          @click="selectedFilter = 'all'"
          :class="[
            'px-4 py-2 rounded-lg text-sm font-medium transition',
            selectedFilter === 'all' 
              ? 'bg-slate-900 text-white' 
              : 'text-slate-600 hover:bg-slate-100'
          ]"
        >
          Tất cả ({{ rooms.length }})
        </button>

        <button 
          @click="selectedFilter = 'vacant'"
          :class="[
            'px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2',
            selectedFilter === 'vacant' 
              ? 'bg-emerald-600 text-white' 
              : 'text-emerald-700 bg-emerald-50 hover:bg-emerald-100'
          ]"
        >
          <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
          Trống ({{ vacantCount }})
        </button>

        <button 
          @click="selectedFilter = 'occupied'"
          :class="[
            'px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2',
            selectedFilter === 'occupied' 
              ? 'bg-rose-600 text-white' 
              : 'text-rose-700 bg-rose-50 hover:bg-rose-100'
          ]"
        >
          <span class="w-2 h-2 rounded-full bg-rose-500"></span>
          Đang ở ({{ occupiedCount }})
        </button>

        <button 
          @click="selectedFilter = 'reserved'"
          :class="[
            'px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2',
            selectedFilter === 'reserved' 
              ? 'bg-amber-500 text-white' 
              : 'text-amber-700 bg-amber-50 hover:bg-amber-100'
          ]"
        >
          <span class="w-2 h-2 rounded-full bg-amber-500"></span>
          Cọc ({{ reservedCount }})
        </button>
      </div>

      <!-- Search Box -->
      <div class="relative w-full md:w-72">
        <input 
          v-model="searchQuery"
          type="text"
          placeholder="Tìm phòng theo số..."
          class="w-full pl-10 pr-4 py-2 bg-slate-50 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:bg-white"
        />
        <svg class="w-4 h-4 text-slate-400 absolute left-3 top-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
    </div>

    <!-- Room Cards Grid -->
    <div class="max-w-7xl mx-auto">
      <div v-if="loading" class="text-center py-16">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-indigo-600 border-t-transparent"></div>
        <p class="text-slate-500 text-sm mt-3">Đang tải danh sách phòng trọ...</p>
      </div>

      <div v-else-if="filteredRooms.length === 0" class="bg-white rounded-xl p-12 text-center border border-slate-200">
        <p class="text-slate-500 text-base">Không tìm thấy phòng nào phù hợp với bộ lọc.</p>
      </div>

      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <div 
          v-for="room in filteredRooms" 
          :key="room.id"
          @click="selectRoom(room)"
          :class="[
            'cursor-pointer rounded-2xl p-5 border-2 transition-all transform hover:-translate-y-1 hover:shadow-lg relative flex flex-col justify-between h-48',
            getStatusCardStyle(room.status)
          ]"
        >
          <!-- Card Header -->
          <div class="flex items-start justify-between">
            <div>
              <span class="text-xs font-semibold uppercase tracking-wider opacity-75">
                {{ room.property_name }}
              </span>
              <h3 class="text-2xl font-bold mt-1">
                Phòng {{ room.room_number }}
              </h3>
            </div>
            <!-- Status Badge -->
            <span :class="['px-2.5 py-1 rounded-full text-xs font-bold uppercase tracking-wide', getStatusBadgeStyle(room.status)]">
              {{ getStatusLabel(room.status) }}
            </span>
          </div>

          <!-- Card Body: Price & Footer -->
          <div>
            <div class="text-sm opacity-80 mb-1">Giá thuê hàng tháng:</div>
            <div class="text-xl font-bold">
              {{ formatCurrency(room.price) }} <span class="text-xs font-normal">/tháng</span>
            </div>
          </div>

          <!-- Bottom indicator line -->
          <div class="w-full h-1.5 rounded-full mt-3 opacity-60" :class="getStatusLineStyle(room.status)"></div>
        </div>
      </div>
    </div>

    <!-- Selected Room Quick Action Drawer / Modal -->
    <div v-if="selectedRoomDetail" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-100 animate-in fade-in zoom-in duration-150">
        <div class="flex items-center justify-between border-b pb-4 mb-4">
          <div>
            <span class="text-xs font-semibold text-indigo-600 uppercase">{{ selectedRoomDetail.property_name }}</span>
            <h3 class="text-xl font-bold text-slate-900">Chi Tiết Phòng {{ selectedRoomDetail.room_number }}</h3>
          </div>
          <button @click="selectedRoomDetail = null" class="text-slate-400 hover:text-slate-600 text-xl font-bold">&times;</button>
        </div>

        <div class="space-y-3 mb-6">
          <div class="flex justify-between py-2 border-b border-slate-100">
            <span class="text-sm text-slate-500">Trạng Thái</span>
            <span :class="['px-2.5 py-0.5 rounded-full text-xs font-bold', getStatusBadgeStyle(selectedRoomDetail.status)]">
              {{ getStatusLabel(selectedRoomDetail.status) }}
            </span>
          </div>
          <div class="flex justify-between py-2 border-b border-slate-100">
            <span class="text-sm text-slate-500">Giá Thuê Niêm Yết</span>
            <span class="text-sm font-bold text-slate-900">{{ formatCurrency(selectedRoomDetail.price) }}</span>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-3">
          <button class="py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-sm font-semibold transition">
            Tạo Hợp Đồng
          </button>
          <button @click="selectedRoomDetail = null" class="py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-sm font-semibold transition">
            Đóng
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

const authStore = useAuthStore()
const loading = ref(false)
const rooms = ref([])
const selectedFilter = ref('all')
const searchQuery = ref('')
const selectedRoomDetail = ref(null)

// Fallback Mock Data in case API is not running locally yet
const mockRooms = [
  { id: 1, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '101', price: 3500000, status: 'vacant' },
  { id: 2, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '102', price: 3800000, status: 'occupied' },
  { id: 3, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '103', price: 3500000, status: 'reserved' },
  { id: 4, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '201', price: 4200000, status: 'occupied' },
  { id: 5, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '202', price: 4000000, status: 'vacant' },
  { id: 6, property_name: 'Tòa Nhà B - Cầu Giấy', room_number: '301', price: 5000000, status: 'occupied' },
  { id: 7, property_name: 'Tòa Nhà B - Cầu Giấy', room_number: '302', price: 5200000, status: 'vacant' },
  { id: 8, property_name: 'Tòa Nhà B - Cầu Giấy', room_number: '303', price: 4800000, status: 'reserved' }
]

const fetchRooms = async () => {
  loading.value = true
  try {
    const res = await api.get('/rooms')
    if (res && res.data) {
      rooms.value = res.data
    } else {
      rooms.value = mockRooms
    }
  } catch (err) {
    console.warn('Backend API connection failed, using fallback UI mock data:', err)
    rooms.value = mockRooms
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRooms()
})

// Counts
const vacantCount = computed(() => rooms.value.filter(r => r.status === 'vacant' || r.status === 0).length)
const occupiedCount = computed(() => rooms.value.filter(r => r.status === 'occupied' || r.status === 1).length)
const reservedCount = computed(() => rooms.value.filter(r => r.status === 'reserved' || r.status === 2).length)

// Filtered Rooms
const filteredRooms = computed(() => {
  return rooms.value.filter(room => {
    const matchesStatus = selectedFilter.value === 'all' || room.status === selectedFilter.value
    const matchesSearch = !searchQuery.value || room.room_number.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesStatus && matchesSearch
  })
})

// UI Styling Helpers
const getStatusCardStyle = (status) => {
  switch (status) {
    case 'vacant':
    case 0:
      return 'bg-emerald-50/80 border-emerald-300 text-emerald-900 hover:border-emerald-500'
    case 'occupied':
    case 1:
      return 'bg-rose-50/80 border-rose-300 text-rose-900 hover:border-rose-500'
    case 'reserved':
    case 2:
      return 'bg-amber-50/80 border-amber-300 text-amber-900 hover:border-amber-500'
    default:
      return 'bg-slate-50 border-slate-200 text-slate-900'
  }
}

const getStatusBadgeStyle = (status) => {
  switch (status) {
    case 'vacant':
    case 0:
      return 'bg-emerald-200 text-emerald-800'
    case 'occupied':
    case 1:
      return 'bg-rose-200 text-rose-800'
    case 'reserved':
    case 2:
      return 'bg-amber-200 text-amber-800'
    default:
      return 'bg-slate-200 text-slate-800'
  }
}

const getStatusLineStyle = (status) => {
  switch (status) {
    case 'vacant':
    case 0:
      return 'bg-emerald-500'
    case 'occupied':
    case 1:
      return 'bg-rose-500'
    case 'reserved':
    case 2:
      return 'bg-amber-500'
    default:
      return 'bg-slate-400'
  }
}

const getStatusLabel = (status) => {
  switch (status) {
    case 'vacant':
    case 0:
      return 'Trống'
    case 'occupied':
    case 1:
      return 'Đang ở'
    case 'reserved':
    case 2:
      return 'Đã Cọc'
    default:
      return 'N/A'
  }
}

const formatCurrency = (val) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
}

const selectRoom = (room) => {
  selectedRoomDetail.value = room
}
</script>
