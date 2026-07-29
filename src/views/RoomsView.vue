<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white/90 backdrop-blur-md p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div>
          <h1 class="text-2xl font-black text-slate-900 tracking-tight flex items-center gap-2">
            <span>🔑</span> Quản Lý Phòng Trọ Chuyên Sâu
          </h1>
          <p class="text-slate-500 text-xs mt-1 font-medium">Thêm mới, sửa giá thuê, chọn tầng và theo dõi danh mục tiện ích phòng</p>
        </div>

        <button
          @click="openModal()"
          class="inline-flex items-center gap-2 px-4.5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-extrabold text-xs shadow-md shadow-indigo-600/30 transition hover:scale-105 active:scale-95"
        >
          <span>🔑</span> Thêm phòng trọ mới
        </button>
      </div>

      <!-- Stat Badges -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="bg-white/90 backdrop-blur-md p-4 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition flex items-center justify-between">
          <div>
            <div class="text-[10px] uppercase font-extrabold text-slate-400">Tổng Số Phòng</div>
            <div class="text-2xl font-black text-slate-900 mt-0.5 font-mono">{{ rooms.length }}</div>
          </div>
          <span class="text-2xl">🔑</span>
        </div>
        <div class="bg-white/90 backdrop-blur-md p-4 rounded-2xl border border-emerald-100 shadow-sm hover:shadow-md transition flex items-center justify-between">
          <div>
            <div class="text-[10px] uppercase font-extrabold text-emerald-600">Phòng Trống</div>
            <div class="text-2xl font-black text-emerald-700 mt-0.5 font-mono">{{ rooms.filter(r => r.status === 'vacant' || r.status === 0).length }}</div>
          </div>
          <span class="text-2xl">🟢</span>
        </div>
        <div class="bg-white/90 backdrop-blur-md p-4 rounded-2xl border border-rose-100 shadow-sm hover:shadow-md transition flex items-center justify-between">
          <div>
            <div class="text-[10px] uppercase font-extrabold text-rose-600">Đang Ở</div>
            <div class="text-2xl font-black text-rose-700 mt-0.5 font-mono">{{ rooms.filter(r => r.status === 'occupied' || r.status === 1).length }}</div>
          </div>
          <span class="text-2xl">🔴</span>
        </div>
        <div class="bg-white/90 backdrop-blur-md p-4 rounded-2xl border border-amber-100 shadow-sm hover:shadow-md transition flex items-center justify-between">
          <div>
            <div class="text-[10px] uppercase font-extrabold text-amber-600">Đã Cọc / Bảo Trì</div>
            <div class="text-2xl font-black text-amber-700 mt-0.5 font-mono">{{ rooms.filter(r => r.status === 'reserved' || r.status === 'maintenance' || r.status === 2).length }}</div>
          </div>
          <span class="text-2xl">🟡</span>
        </div>
      </div>

      <!-- Rooms List -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div class="font-extrabold text-slate-900 text-base">Danh Sách Tất Cả Phòng Trọ</div>
          <div class="flex items-center gap-3">
            <select v-model="filterStatus" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả trạng thái</option>
              <option value="vacant">Trống 🟢</option>
              <option value="occupied">Đang ở 🔴</option>
              <option value="reserved">Đã cọc 🟡</option>
              <option value="maintenance">Bảo trì 🔧</option>
            </select>
            <input v-model="searchQuery" class="w-64 rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm theo số phòng hoặc khu..." />
            <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200 transition" @click="loadRooms">🔄</button>
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
          <div v-for="item in filteredRooms" :key="item.id" class="rounded-2xl border border-slate-200/80 p-5 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col justify-between space-y-4 bg-slate-50/50 group">
            <div>
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-extrabold uppercase text-indigo-600 tracking-wider truncate block max-w-[120px]">{{ item.property_name }}</span>
                <span :class="['px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase shadow-2xs', getStatusBadge(item.status)]">
                  {{ getStatusLabel(item.status) }}
                </span>
              </div>
              <h3 class="text-2xl font-black text-slate-900 mt-2 group-hover:scale-105 transition-transform">Phòng {{ item.room_number }}</h3>
              <div class="text-xs text-slate-500 mt-1">Tầng: <strong>Tầng {{ item.floor || 1 }}</strong></div>
              <div class="text-lg font-black text-indigo-600 font-mono mt-2">{{ formatCurrency(item.price) }} / tháng</div>
            </div>

            <div class="space-y-2 border-t border-slate-200/80 pt-3">
              <div class="flex items-center justify-between text-xs">
                <span class="text-slate-500 font-medium">Đổi trạng thái:</span>
                <select
                  :value="item.status"
                  @change="quickUpdateStatus(item, $event.target.value)"
                  class="px-2 py-1 bg-white border border-slate-200 rounded-lg text-xs font-bold text-slate-700 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="vacant">Trống</option>
                  <option value="occupied">Đang ở</option>
                  <option value="reserved">Đã cọc</option>
                  <option value="maintenance">Bảo trì</option>
                </select>
              </div>

              <div class="flex items-center justify-end gap-2">
                <button @click="openModal(item)" class="text-xs font-bold text-indigo-700 bg-indigo-50 hover:bg-indigo-100 px-3 py-1 rounded-lg transition">
                  Sửa
                </button>
                <button @click="deleteRoom(item.id)" class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-3 py-1 rounded-lg transition">
                  Xóa
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Add / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl space-y-4 animate-scale-in">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-extrabold text-slate-900">{{ editingRoom ? 'Chỉnh Sửa Phòng Trọ' : 'Thêm Phòng Trọ Mới' }}</h3>
            <button @click="showModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
          </div>

          <form @submit.prevent="saveRoom" class="space-y-4">
            <div>
              <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Tên Tòa Nhà / Khu Trọ</label>
              <input v-model="form.property_name" required type="text" placeholder="Tòa Nhà A - Nam Từ Liêm" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-indigo-500 transition" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số phòng</label>
                <input v-model="form.room_number" required type="text" placeholder="101" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-indigo-500 transition" />
              </div>
              <div>
                <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số tầng</label>
                <input v-model.number="form.floor" required type="number" min="1" placeholder="1" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-indigo-500 transition" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Giá thuê (VNĐ)</label>
                <input v-model.number="form.price" required type="number" placeholder="3500000" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-mono font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500 transition" />
              </div>
              <div>
                <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Trạng thái</label>
                <select v-model="form.status" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500 transition">
                  <option value="vacant">Trống</option>
                  <option value="occupied">Đang ở</option>
                  <option value="reserved">Đã cọc</option>
                  <option value="maintenance">Bảo trì</option>
                </select>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 border-t border-slate-100 pt-3">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-xs transition">
                Hủy
              </button>
              <button type="submit" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-xs shadow-md shadow-indigo-600/20 transition">
                Lưu Thay Đổi
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const rooms = ref([])
const showModal = ref(false)
const editingRoom = ref(null)
const filterStatus = ref('')
const searchQuery = ref('')

const form = ref({
  property_name: '',
  room_number: '',
  floor: 1,
  price: 3000000,
  status: 'vacant'
})

const defaultRooms = [
  { id: 1, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '101', floor: 1, price: 3500000, status: 'vacant' },
  { id: 2, property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '102', floor: 1, price: 3800000, status: 'occupied' },
  { id: 3, property_name: 'Tòa Nhà B - Cầu Giấy', room_number: '201', floor: 2, price: 4500000, status: 'reserved' },
  { id: 4, property_name: 'Tòa Nhà B - Cầu Giấy', room_number: '202', floor: 2, price: 4200000, status: 'maintenance' }
]

const loadRooms = async () => {
  try {
    const res = await api.get('/rooms')
    if (Array.isArray(res?.data) && res.data.length > 0) {
      rooms.value = res.data
    } else {
      rooms.value = defaultRooms
    }
  } catch (err) {
    rooms.value = defaultRooms
  }
}

const filteredRooms = computed(() => {
  return rooms.value.filter(r => {
    const matchStatus = !filterStatus.value || r.status === filterStatus.value || (filterStatus.value === 'vacant' && r.status === 0)
    const q = searchQuery.value.toLowerCase()
    const matchQuery = !q || (r.room_number || '').toLowerCase().includes(q) || (r.property_name || '').toLowerCase().includes(q)
    return matchStatus && matchQuery
  })
})

const openModal = (room = null) => {
  editingRoom.value = room
  if (room) {
    form.value = { ...room }
  } else {
    form.value = {
      property_name: 'Tòa Nhà A - Nam Từ Liêm',
      room_number: '',
      floor: 1,
      price: 3500000,
      status: 'vacant'
    }
  }
  showModal.value = true
}

const saveRoom = async () => {
  try {
    if (editingRoom.value) {
      await api.put(`/rooms/${editingRoom.value.id}`, form.value)
    } else {
      await api.post('/rooms', form.value)
    }
    await loadRooms()
    showModal.value = false
  } catch (err) {
    if (editingRoom.value) {
      const idx = rooms.value.findIndex(r => r.id === editingRoom.value.id)
      if (idx !== -1) rooms.value[idx] = { ...editingRoom.value, ...form.value }
    } else {
      rooms.value.push({ id: Date.now(), ...form.value })
    }
    showModal.value = false
  }
}

const quickUpdateStatus = async (room, newStatus) => {
  room.status = newStatus
  try {
    await api.put(`/rooms/${room.id}`, { status: newStatus })
  } catch (err) {
    console.log('Updated state locally')
  }
}

const deleteRoom = async (id) => {
  if (!confirm('Bạn có chắc chắn muốn xóa phòng trọ này?')) return
  try {
    await api.delete(`/rooms/${id}`)
    await loadRooms()
  } catch (err) {
    rooms.value = rooms.value.filter(r => r.id !== id)
  }
}

const getStatusBadge = (status) => {
  if (status === 'vacant' || status === 0) return 'bg-emerald-100 text-emerald-800'
  if (status === 'occupied' || status === 1) return 'bg-rose-100 text-rose-800'
  if (status === 'reserved' || status === 2) return 'bg-amber-100 text-amber-800'
  return 'bg-slate-200 text-slate-700'
}

const getStatusLabel = (status) => {
  if (status === 'vacant' || status === 0) return 'Trống'
  if (status === 'occupied' || status === 1) return 'Đang ở'
  if (status === 'reserved' || status === 2) return 'Đã cọc'
  if (status === 'maintenance') return 'Bảo trì'
  return 'Khác'
}

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

onMounted(loadRooms)
</script>
