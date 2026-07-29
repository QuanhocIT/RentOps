<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Quản Lý Phòng Trọ Chuyên Sâu</h1>
          <p class="text-slate-500 text-sm mt-0.5">Thêm mới, sửa giá thuê, chọn tầng và theo dõi danh mục tiện ích phòng</p>
        </div>

        <button
          @click="openModal()"
          class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
        >
          <span>🔑</span> Thêm phòng trọ mới
        </button>
      </div>

      <!-- Stat Badges -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-slate-400">Tổng Số Phòng</div>
            <div class="text-xl font-black text-slate-900 mt-0.5">{{ rooms.length }}</div>
          </div>
          <span class="text-2xl">🔑</span>
        </div>
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-emerald-600">Phòng Trống</div>
            <div class="text-xl font-black text-emerald-700 mt-0.5">{{ rooms.filter(r => r.status === 'vacant' || r.status === 0).length }}</div>
          </div>
          <span class="text-2xl">🟢</span>
        </div>
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-rose-600">Đang Ở</div>
            <div class="text-xl font-black text-rose-700 mt-0.5">{{ rooms.filter(r => r.status === 'occupied' || r.status === 1).length }}</div>
          </div>
          <span class="text-2xl">🔴</span>
        </div>
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-amber-600">Đã Cọc / Bảo Trì</div>
            <div class="text-xl font-black text-amber-700 mt-0.5">{{ rooms.filter(r => r.status === 'reserved' || r.status === 'maintenance' || r.status === 2).length }}</div>
          </div>
          <span class="text-2xl">🟡</span>
        </div>
      </div>

      <!-- Rooms List -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div class="font-bold text-slate-900 text-base">Danh Sách Tất Cả Phòng Trọ</div>
          <div class="flex items-center gap-3">
            <input v-model="searchQuery" class="w-64 rounded-xl border border-slate-300 px-3.5 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm theo số phòng hoặc khu..." />
            <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200" @click="loadRooms">🔄</button>
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
          <div v-for="item in filteredRooms" :key="item.id" class="rounded-2xl border border-slate-200 p-5 hover:shadow-lg transition flex flex-col justify-between space-y-4 bg-slate-50/50">
            <div>
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold uppercase text-indigo-600">{{ item.property_name }}</span>
                <span :class="['px-2.5 py-0.5 rounded-full text-[11px] font-bold uppercase', getStatusBadge(item.status)]">
                  {{ getStatusLabel(item.status) }}
                </span>
              </div>
              <h3 class="text-2xl font-black text-slate-900 mt-2">Phòng {{ item.room_number }}</h3>
              <div class="text-xs text-slate-500 mt-1">Tầng: <strong>Tầng {{ item.floor || 1 }}</strong></div>
              <div class="text-lg font-black text-indigo-600 font-mono mt-2">{{ formatCurrency(item.price) }} / tháng</div>
            </div>

            <div class="flex items-center justify-end gap-2 border-t border-slate-200 pt-3">
              <button @click="openModal(item)" class="text-xs font-semibold text-indigo-700 bg-indigo-50 hover:bg-indigo-100 px-2.5 py-1 rounded-lg">
                Sửa
              </button>
              <button @click="deleteRoom(item.id)" class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg">
                Xóa
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Add / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">{{ editingRoom ? 'Chỉnh Sửa Phòng Trọ' : 'Thêm Phòng Trọ Mới' }}</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="saveRoom" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên Tòa Nhà / Khu Trọ</label>
              <input v-model="form.property_name" required type="text" placeholder="Tòa Nhà A - Nam Từ Liêm" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số phòng</label>
                <input v-model="form.room_number" required type="text" placeholder="101" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số tầng</label>
                <input v-model.number="form.floor" required type="number" min="1" placeholder="1" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Giá thuê (VNĐ)</label>
                <input v-model.number="form.price" required type="number" placeholder="3500000" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-mono focus:bg-white" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Trạng thái</label>
                <select v-model="form.status" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white">
                  <option value="vacant">Trống</option>
                  <option value="occupied">Đang ở</option>
                  <option value="reserved">Đã cọc</option>
                  <option value="maintenance">Bảo trì</option>
                </select>
              </div>
            </div>

            <div class="flex justify-end gap-3 pt-2">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Lưu phòng' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const rooms = ref([])
const showModal = ref(false)
const editingRoom = ref(null)
const submitting = ref(false)
const searchQuery = ref('')

const form = ref({ property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '', floor: 1, price: 3500000, status: 'vacant' })

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const getStatusBadge = (s) => {
  if (s === 'vacant' || s === 0) return 'bg-emerald-100 text-emerald-800'
  if (s === 'occupied' || s === 1) return 'bg-rose-100 text-rose-800'
  return 'bg-amber-100 text-amber-800'
}

const getStatusLabel = (s) => {
  if (s === 'vacant' || s === 0) return 'Trống'
  if (s === 'occupied' || s === 1) return 'Đang ở'
  if (s === 'reserved' || s === 2) return 'Đã cọc'
  return 'Bảo trì'
}

const loadRooms = async () => {
  try {
    const res = await api.get('/rooms')
    rooms.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.warn('Error loading rooms:', err)
  }
}

onMounted(loadRooms)

const filteredRooms = computed(() =>
  rooms.value.filter((r) =>
    !searchQuery.value ||
    String(r.room_number).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(r.property_name).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const openModal = (item = null) => {
  editingRoom.value = item
  if (item) {
    form.value = { ...item }
  } else {
    form.value = { property_name: 'Tòa Nhà A - Nam Từ Liêm', room_number: '', floor: 1, price: 3500000, status: 'vacant' }
  }
  showModal.value = true
}

const saveRoom = async () => {
  submitting.value = true
  try {
    if (editingRoom.value) {
      await api.put(`/rooms/${editingRoom.value.id}`, { room: form.value })
    } else {
      await api.post('/rooms', { room: form.value })
    }
    showModal.value = false
    loadRooms()
  } catch (err) {
    alert(err?.message || 'Không thể lưu phòng')
  } finally {
    submitting.value = false
  }
}

const deleteRoom = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa phòng này?')) return
  await api.delete(`/rooms/${id}`)
  await loadRooms()
}
</script>
