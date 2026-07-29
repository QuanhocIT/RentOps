<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <div class="max-w-7xl mx-auto mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-slate-900 tracking-tight">
          Sơ Đồ Phòng Trọ - RentOps
        </h1>
        <p class="text-slate-500 text-sm mt-1">
          Tenant: <span class="font-semibold text-indigo-600">{{ authStore.currentTenant?.name || 'Tòa Nhà Demo RentOps' }}</span>
        </p>
      </div>

      <div class="flex items-center gap-3">
        <button
          @click="fetchRooms"
          class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition"
        >
          Làm mới
        </button>
        <RouterLink to="/rooms" class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition">
          Phòng
        </RouterLink>
        <RouterLink to="/properties" class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition">
          Khu trọ
        </RouterLink>
        <RouterLink to="/contracts" class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition">
          Hợp đồng
        </RouterLink>
        <RouterLink to="/bills" class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition">
          Hóa đơn
        </RouterLink>
        <button
          @click="logout"
          class="inline-flex items-center px-4 py-2 bg-slate-900 text-white rounded-lg text-sm font-medium hover:bg-slate-700 shadow-sm transition"
        >
          Đăng xuất
        </button>
      </div>
    </div>

    <div class="max-w-7xl mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <StatCard title="Tổng Số Phòng" :value="rooms.length" tone="indigo" />
      <StatCard title="Phòng Trống" :value="vacantCount" tone="emerald" />
      <StatCard title="Đang Ở" :value="occupiedCount" tone="rose" />
      <StatCard title="Đã Giữ Cọc" :value="reservedCount" tone="amber" />
    </div>

    <div class="max-w-7xl mx-auto bg-white rounded-xl p-4 border border-slate-200 shadow-sm mb-6 flex flex-col md:flex-row items-center justify-between gap-4">
      <div class="flex items-center gap-2 overflow-x-auto w-full md:w-auto">
        <FilterButton label="Tất cả" :count="rooms.length" :active="selectedFilter === 'all'" @click="selectedFilter = 'all'" />
        <FilterButton label="Trống" :count="vacantCount" :active="selectedFilter === 'vacant'" tone="emerald" @click="selectedFilter = 'vacant'" />
        <FilterButton label="Đang ở" :count="occupiedCount" :active="selectedFilter === 'occupied'" tone="rose" @click="selectedFilter = 'occupied'" />
        <FilterButton label="Cọc" :count="reservedCount" :active="selectedFilter === 'reserved'" tone="amber" @click="selectedFilter = 'reserved'" />
      </div>

      <div class="relative w-full md:w-72">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Tìm phòng theo số..."
          class="w-full pl-4 pr-4 py-2 bg-slate-50 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:bg-white"
        />
      </div>
    </div>

    <div class="max-w-7xl mx-auto">
      <div v-if="loading" class="text-center py-16 text-slate-500">
        Đang tải danh sách phòng trọ...
      </div>

      <div v-else-if="filteredRooms.length === 0" class="bg-white rounded-xl p-12 text-center border border-slate-200">
        <p class="text-slate-500 text-base">Không tìm thấy phòng nào phù hợp với bộ lọc.</p>
      </div>

      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <div
          v-for="room in filteredRooms"
          :key="room.id"
          @click="selectedRoomDetail = room"
          :class="[
            'cursor-pointer rounded-2xl p-5 border-2 transition-all hover:-translate-y-1 hover:shadow-lg relative flex flex-col justify-between h-48',
            getStatusCardStyle(room.status)
          ]"
        >
          <div class="flex items-start justify-between">
            <div>
              <span class="text-xs font-semibold uppercase tracking-wider opacity-75">{{ room.property_name }}</span>
              <h3 class="text-2xl font-bold mt-1">Phòng {{ room.room_number }}</h3>
            </div>
            <span :class="['px-2.5 py-1 rounded-full text-xs font-bold uppercase tracking-wide', getStatusBadgeStyle(room.status)]">
              {{ getStatusLabel(room.status) }}
            </span>
          </div>

          <div>
            <div class="text-sm opacity-80 mb-1">Giá thuê hằng tháng:</div>
            <div class="text-xl font-bold">
              {{ formatCurrency(room.price) }} <span class="text-xs font-normal">/tháng</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, defineComponent, h } from 'vue'
import { RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

const authStore = useAuthStore()
const loading = ref(false)
const rooms = ref([])
const selectedFilter = ref('all')
const searchQuery = ref('')
const selectedRoomDetail = ref(null)

const fallbackRooms = [
  { id: 1, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '101', price: 3500000, status: 'vacant' },
  { id: 2, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '102', price: 3800000, status: 'occupied' },
  { id: 3, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '103', price: 3500000, status: 'reserved' }
]

const normalizeStatus = (status) => {
  if (status === 0 || status === '0') return 'vacant'
  if (status === 1 || status === '1') return 'occupied'
  if (status === 2 || status === '2') return 'reserved'
  return status
}

const fetchRooms = async () => {
  loading.value = true
  try {
    const res = await api.get('/rooms')
    rooms.value = Array.isArray(res?.data) ? res.data.map((room) => ({ ...room, status: normalizeStatus(room.status) })) : fallbackRooms
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

const filteredRooms = computed(() => {
  return rooms.value.filter((room) => {
    const status = normalizeStatus(room.status)
    const matchesStatus = selectedFilter.value === 'all' || status === selectedFilter.value
    const matchesSearch = !searchQuery.value || String(room.room_number).toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesStatus && matchesSearch
  })
})

const getStatusCardStyle = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'bg-emerald-50/80 border-emerald-300 text-emerald-900 hover:border-emerald-500'
    case 'occupied':
      return 'bg-rose-50/80 border-rose-300 text-rose-900 hover:border-rose-500'
    case 'reserved':
      return 'bg-amber-50/80 border-amber-300 text-amber-900 hover:border-amber-500'
    default:
      return 'bg-slate-50 border-slate-200 text-slate-900'
  }
}

const getStatusBadgeStyle = (status) => {
  switch (normalizeStatus(status)) {
    case 'vacant':
      return 'bg-emerald-200 text-emerald-800'
    case 'occupied':
      return 'bg-rose-200 text-rose-800'
    case 'reserved':
      return 'bg-amber-200 text-amber-800'
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
    default:
      return 'N/A'
  }
}

const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value || 0)

const logout = () => {
  authStore.logout()
}

const StatCard = defineComponent({
  props: { title: String, value: [String, Number], tone: String },
  setup(props) {
    const tones = {
      indigo: 'bg-indigo-50 text-indigo-600',
      emerald: 'bg-emerald-50 text-emerald-600',
      rose: 'bg-rose-50 text-rose-600',
      amber: 'bg-amber-50 text-amber-600'
    }
    return () => h('div', { class: 'bg-white rounded-xl p-5 border border-slate-200 shadow-sm' }, [
      h('div', { class: 'flex items-center justify-between' }, [
        h('span', { class: 'text-sm font-medium text-slate-500' }, props.title),
        h('div', { class: `w-10 h-10 rounded-lg flex items-center justify-center font-bold ${tones[props.tone || 'indigo']}` }, String(props.value))
      ]),
      h('div', { class: 'text-3xl font-bold text-slate-900 mt-2' }, String(props.value))
    ])
  }
})

const FilterButton = defineComponent({
  props: { label: String, count: Number, active: Boolean, tone: String },
  emits: ['click'],
  setup(props, { emit }) {
    const toneClass = props.tone === 'emerald'
      ? 'text-emerald-700 bg-emerald-50 hover:bg-emerald-100'
      : props.tone === 'rose'
        ? 'text-rose-700 bg-rose-50 hover:bg-rose-100'
        : props.tone === 'amber'
          ? 'text-amber-700 bg-amber-50 hover:bg-amber-100'
          : 'text-slate-600 hover:bg-slate-100'
    return () => h(
      'button',
      {
        class: [
          'px-4 py-2 rounded-lg text-sm font-medium transition',
          props.active ? 'bg-slate-900 text-white' : toneClass
        ],
        onClick: () => emit('click')
      },
      `${props.label} (${props.count || 0})`
    )
  }
})
</script>
