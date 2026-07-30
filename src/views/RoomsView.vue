<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Quản Lý Căn Hộ & Phòng</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Property Units</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Danh Sách Căn Hộ & Phòng Cho Thuê</h1>
          <p class="text-slate-500 text-sm mt-0.5">Cấu hình chi tiết layout: Số phòng ngủ (2 PN), Phòng khách (1 PK), WC, Ban công & Diện tích</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="openModal()"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center gap-1.5"
          >
            <span>🔑</span>
            <span>Thêm Căn Hộ / Phòng Mới</span>
          </button>
        </div>
      </div>

      <!-- Stat Badges -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Số Căn / Phòng</span>
            <span>🔑</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ rooms.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ bất động sản</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Đang Trống</span>
            <span>🟢</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'vacant' || r.status === 0).length }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Sẵn sàng bàn giao</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Đang Ở</span>
            <span>🔴</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'occupied' || r.status === 1).length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Đã có hợp đồng</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-amber-600 flex items-center justify-between">
            <span>Đã Cọc / Bảo Trì</span>
            <span>🟡</span>
          </div>
          <p class="text-2xl font-black text-amber-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'reserved' || r.status === 'maintenance' || r.status === 2).length }}</p>
          <p class="text-[11px] text-amber-600 font-semibold mt-1">Cần theo dõi</p>
        </div>
      </div>

      <!-- Rooms List -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-extrabold text-slate-900 text-base">Danh Sách Tất Cả Căn Hộ</div>
          
          <div class="flex flex-wrap items-center gap-3">
            <select v-model="filterProperty" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả tòa nhà / khu</option>
              <option v-for="p in properties" :key="p.id" :value="p.id">{{ p.name }} ({{ p.property_type_label }})</option>
            </select>

            <select v-model="filterStatus" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả trạng thái</option>
              <option value="vacant">Trống 🟢</option>
              <option value="occupied">Đang ở 🔴</option>
              <option value="reserved">Đã cọc 🟡</option>
              <option value="maintenance">Bảo trì 🔧</option>
            </select>

            <input v-model="searchQuery" class="w-56 rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm số phòng hoặc layout..." />
            <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200 transition" @click="loadData">🔄</button>
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
          <div v-for="item in filteredRooms" :key="item.id" class="rounded-2xl border border-slate-200/80 p-5 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col justify-between space-y-4 bg-slate-50/50 group">
            <div>
              <div class="flex items-center justify-between gap-1">
                <span class="text-[10px] font-extrabold uppercase text-indigo-600 tracking-wider truncate block max-w-[130px]">
                  {{ item.property_type_icon || '🏢' }} {{ item.property_name }}
                </span>
                <span :class="['px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase shadow-2xs whitespace-nowrap', getStatusBadge(item.status)]">
                  {{ getStatusLabel(item.status) }}
                </span>
              </div>

              <h3 class="text-2xl font-black text-slate-900 mt-2 group-hover:scale-105 transition-transform flex items-center gap-1.5">
                <span>Mã/Phòng {{ item.room_number }}</span>
              </h3>

              <div class="flex items-center justify-between text-xs text-slate-500 mt-1">
                <span>Vị trí: <strong>Tầng {{ item.floor || 1 }}</strong></span>
                <span class="px-2 py-0.5 bg-slate-200/70 text-slate-700 font-extrabold rounded-md text-[10px] uppercase">
                  {{ item.room_type_label || getRoomTypeLabel(item.room_type) }}
                </span>
              </div>

              <!-- Detailed Layout Specs Badge -->
              <div class="mt-3 p-2.5 bg-white rounded-xl border border-slate-200/80 text-xs font-semibold text-slate-700 space-y-1">
                <div class="flex items-center justify-between text-[11px]">
                  <span class="text-slate-500">Cấu trúc căn:</span>
                  <span class="font-extrabold text-indigo-600 font-mono">{{ item.layout_summary || formatLayout(item) }}</span>
                </div>
                <div class="flex items-center gap-2 text-[10px] text-slate-500 pt-1 border-t border-slate-100">
                  <span v-if="item.bedrooms_count">🛏️ {{ item.bedrooms_count }} PN</span>
                  <span v-if="item.living_rooms_count">🛋️ {{ item.living_rooms_count }} PK</span>
                  <span v-if="item.bathrooms_count">🚿 {{ item.bathrooms_count }} WC</span>
                  <span v-if="item.has_balcony" class="text-emerald-600 font-bold">🌅 Ban công</span>
                </div>
              </div>

              <div class="text-lg font-black text-indigo-600 font-mono mt-3">{{ formatCurrency(item.price) }} / tháng</div>
            </div>

            <div class="space-y-2 border-t border-slate-200/80 pt-3">
              <div class="flex items-center justify-between text-xs">
                <span class="text-slate-500 font-medium">Trạng thái:</span>
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
                <button @click="openModal(item)" class="text-xs font-bold text-indigo-700 bg-indigo-50 hover:bg-indigo-100 px-3 py-1.5 rounded-lg transition">
                  Sửa Layout
                </button>
                <button @click="deleteRoom(item.id)" class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-3 py-1.5 rounded-lg transition">
                  Xóa
                </button>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!filteredRooms.length" class="text-center py-12 bg-slate-50 rounded-2xl border border-dashed border-slate-300">
          <span class="text-4xl block mb-2">🔑</span>
          <p class="text-sm font-bold text-slate-700">Chưa có phòng / căn hộ nào phù hợp.</p>
        </div>
      </div>

      <!-- Add / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl space-y-4 animate-scale-in max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <div>
              <h3 class="text-lg font-extrabold text-slate-900">{{ editingRoom ? 'Chỉnh Sửa Layout Căn Hộ' : 'Thêm Căn Hộ / Phòng Mới' }}</h3>
              <p class="text-xs text-slate-500">Cấu hình mô hình cho thuê (Chung cư mini, Căn hộ cao cấp, Nhà nguyên căn)</p>
            </div>
            <button @click="showModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
          </div>

          <form @submit.prevent="saveRoom" class="space-y-4">
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Thuộc Tòa Nhà / Bất Động Sản</label>
              <select v-model="form.property_id" @change="onPropertySelect" required class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                <option value="" disabled>-- Chọn Tòa nhà --</option>
                <option v-for="p in properties" :key="p.id" :value="p.id">
                  {{ p.property_type_icon || '🏢' }} {{ p.name }} ({{ p.property_type_label }})
                </option>
              </select>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Loại Mô Hình Căn Hộ</label>
                <select v-model="form.room_type" required class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                  <option value="can_ho_2pn">🏢 Căn hộ 2 Phòng Ngủ + 1 PK</option>
                  <option value="can_ho_1pn">🏢 Căn hộ 1 Phòng Ngủ</option>
                  <option value="can_ho_3pn">🏢 Căn hộ 3 Phòng Ngủ</option>
                  <option value="studio">✨ Căn hộ Studio</option>
                  <option value="duplex">🌆 Căn hộ Duplex / Loft</option>
                  <option value="nha_nguyen_can">🏡 Nhà Nguyên Căn</option>
                  <option value="phong_don">🏠 Phòng đơn khép kín</option>
                </select>
              </div>

              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Mã Căn / Số Phòng</label>
                <input v-model="form.room_number" required type="text" placeholder="VD: 302 hoặc CH-201" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-indigo-500" />
              </div>
            </div>

            <!-- Detailed Layout Config (2 Bedrooms, 1 Living Room, 1 WC, Kitchen, etc.) -->
            <div class="bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100 space-y-3">
              <span class="text-xs font-extrabold text-indigo-900 uppercase tracking-wider block">📐 Cấu Hình Layout & Tiện Ích</span>

              <div class="grid grid-cols-4 gap-2">
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số Phòng Ngủ</label>
                  <input v-model.number="form.bedrooms_count" required type="number" min="0" max="10" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Phòng Khách</label>
                  <input v-model.number="form.living_rooms_count" required type="number" min="0" max="5" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Nhà Vệ Sinh</label>
                  <input v-model.number="form.bathrooms_count" required type="number" min="1" max="10" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số Bếp</label>
                  <input v-model.number="form.kitchens_count" required type="number" min="0" max="5" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
              </div>

              <div class="grid grid-cols-3 gap-3 pt-1">
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Diện tích (m²)</label>
                  <input v-model.number="form.area" required type="number" min="10" step="0.5" class="w-full px-3 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold" placeholder="45" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Tầng số</label>
                  <input v-model.number="form.floor" required type="number" min="1" class="w-full px-3 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold" placeholder="3" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Tình Trạng Nội Thất</label>
                  <select v-model="form.furnished_status" class="w-full px-2 py-2 bg-white border border-indigo-200 rounded-xl text-[11px] font-bold">
                    <option value="full_noi_that">🛋️ Full Nội Thất</option>
                    <option value="co_ban">🪑 Nội Thất Cơ Bản</option>
                    <option value="nha_tho">🧱 Bàn Giao Thô</option>
                  </select>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-2 pt-1 text-[11px]">
                <div class="flex items-center gap-1.5">
                  <input v-model="form.has_balcony" type="checkbox" id="balcony_check" class="w-4 h-4 text-indigo-600 rounded border-slate-300 focus:ring-indigo-500" />
                  <label for="balcony_check" class="font-bold text-slate-700 cursor-pointer">🌅 Ban công</label>
                </div>
                <div class="flex items-center gap-1.5">
                  <input v-model="form.is_mezzanine" type="checkbox" id="mezzanine_check" class="w-4 h-4 text-purple-600 rounded border-slate-300 focus:ring-purple-500" />
                  <label for="mezzanine_check" class="font-bold text-purple-800 cursor-pointer">🏠 Gác lửng</label>
                </div>
                <div class="flex items-center gap-1.5">
                  <input v-model="form.is_shared_bathroom" type="checkbox" id="shared_wc_check" class="w-4 h-4 text-amber-600 rounded border-slate-300 focus:ring-amber-500" />
                  <label for="shared_wc_check" class="font-bold text-amber-800 cursor-pointer">🚽 WC chung</label>
                </div>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Giá Thuê Thỏa Thuận (VNĐ/tháng)</label>
                <input v-model.number="form.price" required type="number" placeholder="5200000" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-mono font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500" />
              </div>
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Trạng Thái Hiện Tại</label>
                <select v-model="form.status" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                  <option value="vacant">Sẵn sàng (Trống)</option>
                  <option value="occupied">Đang cho thuê</option>
                  <option value="reserved">Khách đã đặt cọc</option>
                  <option value="maintenance">Đang bảo trì / sửa chữa</option>
                </select>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 border-t border-slate-100 pt-3">
              <button type="button" @click="showModal = false" class="px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-xs transition">
                Hủy
              </button>
              <button type="submit" class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-xs shadow-lg shadow-indigo-600/30 transition">
                Lưu Thay Đổi Layout
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
const properties = ref([])
const showModal = ref(false)
const editingRoom = ref(null)
const filterStatus = ref('')
const filterProperty = ref('')
const searchQuery = ref('')

const form = ref({
  property_id: '',
  property_name: '',
  room_number: '',
  floor: 1,
  area: 45,
  price: 5200000,
  status: 'vacant',
  room_type: 'can_ho_2pn',
  bedrooms_count: 2,
  living_rooms_count: 1,
  bathrooms_count: 1,
  kitchens_count: 1,
  has_balcony: true,
  is_mezzanine: false,
  is_shared_bathroom: false,
  furnished_status: 'full_noi_that'
})

const defaultProperties = [
  { id: 1, name: 'Tòa B - Cầu Giấy', property_type: 'chung_cu_mini', property_type_label: 'Chung cư mini', property_type_icon: '🏢' },
  { id: 2, name: 'Tòa C - Bình Thạnh', property_type: 'can_ho_cao_cap', property_type_label: 'Căn hộ cao cấp', property_type_icon: '🏢✨' },
  { id: 3, name: 'Tòa D - Thanh Xuân', property_type: 'nha_nguyen_can', property_type_label: 'Nhà nguyên căn', property_type_icon: '🏡' }
]

const defaultRooms = [
  { id: 1, property_id: 1, property_name: 'Tòa B - Cầu Giấy', property_type_icon: '🏢', room_number: '302', floor: 3, area: 45, price: 5200000, status: 'occupied', room_type: 'can_ho_2pn', room_type_label: 'Căn hộ 2 Phòng Ngủ', bedrooms_count: 2, living_rooms_count: 1, bathrooms_count: 1, has_balcony: true, layout_summary: '2 PN • 1 PK • 1 WC • 45m² • Ban công' },
  { id: 2, property_id: 2, property_name: 'Tòa C - Bình Thạnh', property_type_icon: '🏢✨', room_number: 'C-101', floor: 1, area: 55, price: 6800000, status: 'vacant', room_type: 'can_ho_2pn', room_type_label: 'Căn hộ 2 Phòng Ngủ', bedrooms_count: 2, living_rooms_count: 1, bathrooms_count: 2, has_balcony: true, layout_summary: '2 PN • 1 PK • 2 WC • 55m² • Ban công' },
  { id: 3, property_id: 3, property_name: 'Tòa D - Thanh Xuân', property_type_icon: '🏡', room_number: 'D-101', floor: 1, area: 90, price: 14500000, status: 'occupied', room_type: 'nha_nguyen_can', room_type_label: 'Nhà nguyên căn', bedrooms_count: 3, living_rooms_count: 1, bathrooms_count: 3, has_balcony: true, layout_summary: '3 PN • 1 PK • 3 WC • 90m²' }
]

const loadData = async () => {
  try {
    const propRes = await api.get('/properties')
    if (Array.isArray(propRes?.data) && propRes.data.length > 0) {
      properties.value = propRes.data
    } else {
      properties.value = defaultProperties
    }

    const roomRes = await api.get('/rooms')
    if (Array.isArray(roomRes?.data) && roomRes.data.length > 0) {
      rooms.value = roomRes.data
    } else {
      rooms.value = defaultRooms
    }
  } catch (err) {
    properties.value = defaultProperties
    rooms.value = defaultRooms
  }
}

const filteredRooms = computed(() => {
  return rooms.value.filter(r => {
    const matchStatus = !filterStatus.value || r.status === filterStatus.value || (filterStatus.value === 'vacant' && r.status === 0)
    const matchProp = !filterProperty.value || String(r.property_id) === String(filterProperty.value)
    const q = searchQuery.value.toLowerCase()
    const matchQuery = !q || (r.room_number || '').toLowerCase().includes(q) || (r.property_name || '').toLowerCase().includes(q) || (r.layout_summary || '').toLowerCase().includes(q)
    return matchStatus && matchProp && matchQuery
  })
})

const openModal = (room = null) => {
  editingRoom.value = room
  if (room) {
    form.value = { ...room }
  } else {
    const defaultProp = properties.value[0] || {}
    form.value = {
      property_id: defaultProp.id || '',
      property_name: defaultProp.name || '',
      room_number: '',
      floor: 1,
      area: 45,
      price: 5200000,
      status: 'vacant',
      room_type: 'can_ho_2pn',
      bedrooms_count: 2,
      living_rooms_count: 1,
      bathrooms_count: 1,
      has_balcony: true
    }
  }
  showModal.value = true
}

const onPropertySelect = () => {
  const p = properties.value.find(item => String(item.id) === String(form.value.property_id))
  if (p) {
    form.value.property_name = p.name
  }
}

const saveRoom = async () => {
  try {
    if (editingRoom.value) {
      await api.put(`/rooms/${editingRoom.value.id}`, { room: form.value })
    } else {
      await api.post('/rooms', { room: form.value })
    }
    await loadData()
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
    await api.put(`/rooms/${room.id}`, { room: { status: newStatus } })
  } catch (err) {
    console.log('Updated state locally')
  }
}

const deleteRoom = async (id) => {
  if (!confirm('Bạn có chắc chắn muốn xóa căn hộ/phòng này?')) return
  try {
    await api.delete(`/rooms/${id}`)
    await loadData()
  } catch (err) {
    rooms.value = rooms.value.filter(r => r.id !== id)
  }
}

const formatLayout = (r) => {
  const parts = []
  if (r.bedrooms_count) parts.push(`${r.bedrooms_count} PN`)
  if (r.living_rooms_count) parts.push(`${r.living_rooms_count} PK`)
  if (r.bathrooms_count) parts.push(`${r.bathrooms_count} WC`)
  if (r.area) parts.push(`${r.area}m²`)
  return parts.join(' • ')
}

const getRoomTypeLabel = (type) => {
  switch (type) {
    case 'can_ho_2pn': return 'Căn hộ 2PN + 1PK'
    case 'can_ho_1pn': return 'Căn hộ 1PN'
    case 'can_ho_3pn': return 'Căn hộ 3PN'
    case 'studio': return 'Căn hộ Studio'
    case 'duplex': return 'Căn hộ Duplex'
    case 'nha_nguyen_can': return 'Nhà nguyên căn'
    default: return 'Phòng đơn'
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

onMounted(loadData)
</script>
