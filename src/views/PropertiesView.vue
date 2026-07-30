<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Khu Trọ & Tòa Nhà</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Multi-Property</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Tòa Nhà & Bất Động Sản Cho Thuê</h1>
          <p class="text-slate-500 text-sm mt-0.5">Quản lý Chung cư mini, Căn hộ cao cấp, Nhà nguyên căn và Dãy phòng trọ</p>
        </div>
      </div>

      <!-- Quick Type Filter Badges -->
      <div class="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-none">
        <button
          @click="selectedTypeFilter = ''"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', !selectedTypeFilter ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/30' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏢 All</span>
          <span>Tất cả ({{ properties.length }})</span>
        </button>
        <button
          @click="selectedTypeFilter = 'chung_cu_mini'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'chung_cu_mini' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏢</span>
          <span>Chung Cư Mini</span>
        </button>
        <button
          @click="selectedTypeFilter = 'can_ho_cao_cap'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'can_ho_cao_cap' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏢✨</span>
          <span>Căn Hộ Cao Cấp</span>
        </button>
        <button
          @click="selectedTypeFilter = 'nha_nguyen_can'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'nha_nguyen_can' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏡</span>
          <span>Nhà Nguyên Căn</span>
        </button>
        <button
          @click="selectedTypeFilter = 'shophouse'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'shophouse' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏪</span>
          <span>Shophouse</span>
        </button>
        <button
          @click="selectedTypeFilter = 'homestay'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'homestay' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏩</span>
          <span>Homestay / Serviced</span>
        </button>
        <button
          @click="selectedTypeFilter = 'phong_tro'"
          :class="['px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap', selectedTypeFilter === 'phong_tro' ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50']"
        >
          <span>🏠</span>
          <span>Phòng Trọ</span>
        </button>
      </div>

      <div class="grid gap-6 md:grid-cols-[380px_1fr]">
        <!-- Form Add Property -->
        <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4 h-fit" @submit.prevent="createProperty">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-base font-extrabold text-slate-900">Thêm Tòa Nhà / Bất Động Sản</h3>
            <span class="text-xs bg-indigo-50 text-indigo-700 font-bold px-2 py-0.5 rounded-lg">Mới</span>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Loại Bất Động Sản</label>
            <select v-model="form.property_type" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm font-bold bg-slate-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="phong_tro">🏠 Phòng Trọ / Dãy Trọ Truyền Thống</option>
              <option value="chung_cu_mini">🏢 Chung Cư Mini (Nhiều tầng, thang máy)</option>
              <option value="can_ho_cao_cap">🏢✨ Căn Hộ Cao Cấp / Penthouse</option>
              <option value="nha_nguyen_can">🏡 Nhà Nguyên Căn / Nhà Phố</option>
              <option value="biet_thu">🏰 Biệt Thự / Villa Cho Thuê</option>
              <option value="shophouse">🏪 Shophouse / Mặt Bằng Kinh Doanh</option>
              <option value="homestay">🏩 Căn Hộ Dịch Vụ / Homestay</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Tên Tòa Nhà / Bất Động Sản</label>
            <input v-model="form.name" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="VD: Chung Cư Mini Trần Thái Tông" />
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Địa Chỉ Chi Tiết</label>
            <input v-model="form.address" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội" />
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Mô Tả Tiện Ích & Ghi Chú</label>
            <textarea v-model="form.description" rows="2" class="w-full rounded-xl border border-slate-300 px-4 py-2 text-xs focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Thang máy, bảo vệ 24/7, hầm để xe..."></textarea>
          </div>

          <button class="w-full rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white py-3 font-bold text-sm shadow-lg shadow-indigo-600/30 transition flex items-center justify-center gap-2" :disabled="loading">
            <span>➕</span>
            <span>{{ loading ? 'Đang lưu...' : 'Thêm Bất Động Sản Mới' }}</span>
          </button>

          <p v-if="message" :class="['text-xs rounded-xl px-4 py-2.5 font-semibold', messageType === 'error' ? 'bg-rose-50 text-rose-700 border border-rose-200' : 'bg-emerald-50 text-emerald-700 border border-emerald-200']">
            {{ message }}
          </p>
        </form>

        <!-- Properties List -->
        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b border-slate-100 pb-3">
            <h2 class="font-bold text-slate-900 text-lg flex items-center gap-2">
              <span>Danh Sách Bất Động Sản</span>
              <span class="text-xs font-normal text-slate-400">({{ filteredProperties.length }})</span>
            </h2>
            <div class="flex items-center gap-3">
              <!-- View Switcher -->
              <div class="flex items-center bg-slate-100 p-1 rounded-xl border border-slate-200">
                <button 
                  @click="viewMode = 'grid'"
                  :class="['px-3 py-1 rounded-lg text-xs font-bold transition flex items-center gap-1', viewMode === 'grid' ? 'bg-indigo-600 text-white shadow-xs' : 'text-slate-600 hover:text-slate-900']"
                >
                  <span>🎴</span> Dạng Thẻ
                </button>
                <button 
                  @click="viewMode = 'table'"
                  :class="['px-3 py-1 rounded-lg text-xs font-bold transition flex items-center gap-1', viewMode === 'table' ? 'bg-indigo-600 text-white shadow-xs' : 'text-slate-600 hover:text-slate-900']"
                >
                  <span>📊</span> Dạng Bảng
                </button>
              </div>

              <input v-model="searchQuery" class="w-56 rounded-xl border border-slate-300 px-3.5 py-2 text-xs font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm theo tên hoặc địa chỉ..." />
              <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200 transition" @click="loadProperties">🔄</button>
            </div>
          </div>

          <!-- Table View Mode -->
          <div v-if="viewMode === 'table' && filteredProperties.length" class="overflow-x-auto rounded-xl border border-slate-200">
            <table class="w-full text-left border-collapse text-xs">
              <thead>
                <tr class="bg-slate-100/80 border-b border-slate-200 text-[11px] font-extrabold uppercase text-slate-600 tracking-wider">
                  <th class="py-3 px-4">Tên Bất Động Sản</th>
                  <th class="py-3 px-4">Loại Hình</th>
                  <th class="py-3 px-4">Địa Chỉ</th>
                  <th class="py-3 px-4">Tổng Căn / Đã Thuê</th>
                  <th class="py-3 px-4">Lấp Đầy</th>
                  <th class="py-3 px-4 text-right">Thao Tác</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100">
                <tr v-for="item in filteredProperties" :key="item.id" class="hover:bg-slate-50 transition">
                  <td class="py-3 px-4 font-extrabold text-slate-900 whitespace-nowrap">
                    <span class="text-base mr-1.5">{{ item.property_type_icon || getPropertyIcon(item.property_type) }}</span>
                    <span>{{ item.name }}</span>
                  </td>
                  <td class="py-3 px-4 whitespace-nowrap">
                    <span :class="['px-2.5 py-0.5 rounded-lg text-[10px] font-extrabold uppercase shadow-2xs', getBadgeColor(item.property_type)]">
                      {{ item.property_type_label || getPropertyTypeLabel(item.property_type) }}
                    </span>
                  </td>
                  <td class="py-3 px-4 text-slate-600 max-w-xs truncate">
                    📍 {{ item.address || 'Chưa cập nhật' }}
                  </td>
                  <td class="py-3 px-4 font-mono font-bold text-slate-800 whitespace-nowrap">
                    {{ item.occupied_rooms || 0 }} / {{ item.total_rooms || 0 }} căn
                  </td>
                  <td class="py-3 px-4 font-mono font-extrabold text-indigo-600 whitespace-nowrap">
                    {{ calculateOccupancy(item) }}%
                  </td>
                  <td class="py-3 px-4 text-right whitespace-nowrap">
                    <div class="flex items-center justify-end gap-2">
                      <button
                        @click="openDetailModal(item)"
                        class="px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md shadow-indigo-600/20 transition flex items-center gap-1"
                      >
                        <span>👁️</span> <span>Xem Chi Tiết</span>
                      </button>
                      <button class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1.5 rounded-xl transition" @click="deleteProperty(item.id)">
                        Xóa
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Grid Cards Mode -->
          <div v-else-if="viewMode === 'grid' && filteredProperties.length" class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div v-for="item in filteredProperties" :key="item.id" class="rounded-2xl border border-slate-200 p-5 hover:shadow-lg transition-all duration-200 bg-slate-50/60 flex flex-col justify-between space-y-4 group">
              <div>
                <div class="flex items-start justify-between gap-2">
                  <div>
                    <span class="text-2xl mr-1">{{ item.property_type_icon || getPropertyIcon(item.property_type) }}</span>
                    <h3 class="font-extrabold text-slate-900 text-lg inline">{{ item.name }}</h3>
                  </div>
                  <span :class="['px-2.5 py-1 rounded-lg text-[11px] font-extrabold uppercase shadow-2xs whitespace-nowrap', getBadgeColor(item.property_type)]">
                    {{ item.property_type_label || getPropertyTypeLabel(item.property_type) }}
                  </span>
                </div>
                <div class="text-xs text-slate-500 mt-2 flex items-center gap-1.5">
                  <span>📍</span>
                  <span class="line-clamp-1">{{ item.address || 'Chưa cập nhật địa chỉ' }}</span>
                </div>
                <p v-if="item.description" class="text-xs text-slate-600 bg-white/80 rounded-lg p-2 mt-2.5 border border-slate-100 italic line-clamp-2">
                  "{{ item.description }}"
                </p>
              </div>

              <!-- Stats & Occupancy -->
              <div class="space-y-2 border-t border-slate-200/80 pt-3">
                <div class="grid grid-cols-3 gap-2 text-center text-xs">
                  <div class="bg-white p-2 rounded-xl border border-slate-100">
                    <span class="block text-[10px] uppercase font-bold text-slate-400">Tổng căn</span>
                    <span class="font-black text-slate-800 text-sm font-mono">{{ item.total_rooms || 0 }}</span>
                  </div>
                  <div class="bg-emerald-50/80 p-2 rounded-xl border border-emerald-100">
                    <span class="block text-[10px] uppercase font-bold text-emerald-600">Còn trống</span>
                    <span class="font-black text-emerald-700 text-sm font-mono">{{ item.vacant_rooms || 0 }}</span>
                  </div>
                  <div class="bg-rose-50/80 p-2 rounded-xl border border-rose-100">
                    <span class="block text-[10px] uppercase font-bold text-rose-600">Đã cho thuê</span>
                    <span class="font-black text-rose-700 text-sm font-mono">{{ item.occupied_rooms || 0 }}</span>
                  </div>
                </div>

                <div class="flex justify-between text-xs text-slate-600 font-medium pt-1">
                  <span>Tỷ lệ lấp đầy:</span>
                  <span class="font-bold text-indigo-600 font-mono">{{ calculateOccupancy(item) }}%</span>
                </div>
                <div class="w-full h-2 rounded-full bg-slate-200 overflow-hidden">
                  <div class="h-full bg-gradient-to-r from-indigo-500 to-emerald-500 transition-all duration-500" :style="{ width: calculateOccupancy(item) + '%' }"></div>
                </div>
              </div>

              <div class="flex items-center justify-between gap-2 pt-1 border-t border-slate-200/60">
                <button
                  @click="openDetailModal(item)"
                  class="flex-1 px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md shadow-indigo-600/20 transition flex items-center justify-center gap-1"
                >
                  <span>👁️</span> <span>Xem Chi Tiết</span>
                </button>
                <button class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-3 py-1.5 rounded-xl transition" @click="deleteProperty(item.id)">
                  Xóa
                </button>
              </div>
            </div>
          </div>

          <div v-if="!filteredProperties.length" class="text-center py-12 bg-slate-50 rounded-2xl border border-dashed border-slate-300">
            <span class="text-4xl block mb-2">🏢</span>
            <p class="text-sm font-bold text-slate-700">Chưa có tòa nhà / bất động sản nào phù hợp.</p>
            <p class="text-xs text-slate-400 mt-1">Hãy thêm bất động sản mới ở form bên trái.</p>
          </div>
        </div>
      </div>

      <!-- Property Detail Modal -->
      <div v-if="showDetailModal && selectedDetailProperty" class="fixed inset-0 z-50 bg-slate-950/70 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl space-y-5 animate-scale-in max-h-[90vh] overflow-y-auto">
          <!-- Header -->
          <div class="flex items-start justify-between border-b border-slate-100 pb-3">
            <div class="space-y-1">
              <span :class="['px-2.5 py-0.5 rounded-lg text-[10px] font-extrabold uppercase', getBadgeColor(selectedDetailProperty.property_type)]">
                {{ selectedDetailProperty.property_type_label || getPropertyTypeLabel(selectedDetailProperty.property_type) }}
              </span>
              <h2 class="text-2xl font-black text-slate-900 flex items-center gap-2">
                <span>{{ selectedDetailProperty.property_type_icon || getPropertyIcon(selectedDetailProperty.property_type) }}</span>
                <span>{{ selectedDetailProperty.name }}</span>
              </h2>
            </div>
            <button @click="showDetailModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center">✕</button>
          </div>

          <!-- Address Banner -->
          <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 text-xs space-y-1.5">
            <div class="font-extrabold text-slate-700 uppercase tracking-wider text-[10px]">📍 Địa chỉ chi tiết</div>
            <div class="text-slate-900 font-semibold text-sm">{{ selectedDetailProperty.address || 'Chưa cập nhật địa chỉ' }}</div>
          </div>

          <!-- Room Stats breakdown -->
          <div class="grid grid-cols-3 gap-3 text-center text-xs">
            <div class="bg-indigo-50/80 p-3 rounded-2xl border border-indigo-100">
              <span class="block text-[10px] uppercase font-extrabold text-indigo-600">Tổng Căn</span>
              <span class="font-black text-indigo-900 text-xl font-mono mt-1 block">{{ selectedDetailProperty.total_rooms || 0 }}</span>
            </div>
            <div class="bg-emerald-50/80 p-3 rounded-2xl border border-emerald-100">
              <span class="block text-[10px] uppercase font-extrabold text-emerald-600">Sẵn Sàng (Trống)</span>
              <span class="font-black text-emerald-800 text-xl font-mono mt-1 block">{{ selectedDetailProperty.vacant_rooms || 0 }}</span>
            </div>
            <div class="bg-rose-50/80 p-3 rounded-2xl border border-rose-100">
              <span class="block text-[10px] uppercase font-extrabold text-rose-600">Đã Cho Thuê</span>
              <span class="font-black text-rose-800 text-xl font-mono mt-1 block">{{ selectedDetailProperty.occupied_rooms || 0 }}</span>
            </div>
          </div>

          <!-- Occupancy Rate Bar -->
          <div class="bg-indigo-950 text-white p-4 rounded-2xl space-y-2 shadow-lg">
            <div class="flex justify-between text-xs font-bold">
              <span>📊 Tỷ Lệ Lấp Đầy Hiện Tại</span>
              <span class="font-mono text-emerald-400">{{ calculateOccupancy(selectedDetailProperty) }}%</span>
            </div>
            <div class="w-full h-2.5 rounded-full bg-slate-800 overflow-hidden">
              <div class="h-full bg-gradient-to-r from-indigo-400 to-emerald-400 transition-all duration-500" :style="{ width: calculateOccupancy(selectedDetailProperty) + '%' }"></div>
            </div>
          </div>

          <!-- Description / Amenities Notes -->
          <div v-if="selectedDetailProperty.description" class="space-y-1 text-xs">
            <span class="font-extrabold text-slate-700 uppercase text-[10px] tracking-wider">📝 Ghi Chú & Tiện Ích Tòa Nhà</span>
            <p class="p-3 bg-slate-50 rounded-xl border border-slate-200 text-slate-600 italic">"{{ selectedDetailProperty.description }}"</p>
          </div>

          <!-- Actions -->
          <div class="flex items-center justify-between border-t border-slate-100 pt-4">
            <RouterLink to="/rooms" class="px-4 py-2 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 font-bold text-xs rounded-xl transition flex items-center gap-1.5">
              <span>🔑 Xem Danh Sách Phòng</span>
            </RouterLink>
            <button @click="showDetailModal = false" class="px-6 py-2 bg-slate-900 text-white font-bold text-xs rounded-xl hover:bg-slate-800 transition">
              Đóng
            </button>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const properties = ref([])
const loading = ref(false)
const selectedTypeFilter = ref('')
const viewMode = ref('grid')
const showDetailModal = ref(false)
const selectedDetailProperty = ref(null)

const openDetailModal = (item) => {
  selectedDetailProperty.value = item
  showDetailModal.value = true
}

const form = ref({
  name: '',
  address: '',
  property_type: 'chung_cu_mini',
  description: ''
})
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')

const defaultProperties = [
  { id: 1, name: 'Tòa A - Nam Từ Liêm', address: 'Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội', property_type: 'phong_tro', property_type_label: 'Phòng trọ / Dãy trọ', total_rooms: 6, vacant_rooms: 2, occupied_rooms: 4 },
  { id: 2, name: 'Tòa B - Cầu Giấy', address: 'Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội', property_type: 'chung_cu_mini', property_type_label: 'Chung cư mini', total_rooms: 12, vacant_rooms: 3, occupied_rooms: 9 },
  { id: 3, name: 'Tòa C - Bình Thạnh', address: 'Số 120 Điện Biên Phủ, P. 17, Bình Thạnh, TP.HCM', property_type: 'can_ho_cao_cap', property_type_label: 'Căn hộ cao cấp', total_rooms: 8, vacant_rooms: 1, occupied_rooms: 7 },
  { id: 4, name: 'Tòa D - Thanh Xuân', address: 'Số 45 Nguyễn Trãi, Thanh Xuân, Hà Nội', property_type: 'nha_nguyen_can', property_type_label: 'Nhà nguyên căn', total_rooms: 4, vacant_rooms: 0, occupied_rooms: 4 }
]

const filteredProperties = computed(() =>
  properties.value.filter((item) => {
    const matchType = !selectedTypeFilter.value || item.property_type === selectedTypeFilter.value
    const q = searchQuery.value.toLowerCase()
    const matchQuery = !q ||
      String(item.name || '').toLowerCase().includes(q) ||
      String(item.address || '').toLowerCase().includes(q)
    return matchType && matchQuery
  })
)

const loadProperties = async () => {
  try {
    const res = await api.get('/properties')
    if (Array.isArray(res?.data) && res.data.length > 0) {
      properties.value = res.data
    } else {
      properties.value = defaultProperties
    }
  } catch (error) {
    properties.value = defaultProperties
  }
}

const createProperty = async () => {
  if (!form.value.name.trim()) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập tên tòa nhà / bất động sản.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/properties', { property: form.value })
    form.value = { name: '', address: '', property_type: 'chung_cu_mini', description: '' }
    await loadProperties()
    messageType.value = 'success'
    message.value = 'Tạo bất động sản mới thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo bất động sản.'
  } finally {
    loading.value = false
  }
}

const deleteProperty = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa tòa nhà này? Tất cả dữ liệu phòng liên quan có thể bị ảnh hưởng.')) return
  try {
    await api.delete(`/properties/${id}`)
    await loadProperties()
  } catch (error) {
    properties.value = properties.value.filter(p => p.id !== id)
  }
}

const calculateOccupancy = (item) => {
  if (!item.total_rooms || item.total_rooms === 0) return 0
  const rate = (item.occupied_rooms / item.total_rooms) * 100
  return Math.round(rate)
}

const getPropertyIcon = (type) => {
  switch (type) {
    case 'chung_cu_mini': return '🏢'
    case 'can_ho_cao_cap': return '🏢✨'
    case 'nha_nguyen_can': return '🏡'
    case 'biet_thu': return '🏰'
    default: return '🏠'
  }
}

const getPropertyTypeLabel = (type) => {
  switch (type) {
    case 'chung_cu_mini': return 'Chung cư mini'
    case 'can_ho_cao_cap': return 'Căn hộ cao cấp'
    case 'nha_nguyen_can': return 'Nhà nguyên căn'
    case 'biet_thu': return 'Biệt thự'
    default: return 'Phòng trọ'
  }
}

const getBadgeColor = (type) => {
  switch (type) {
    case 'chung_cu_mini': return 'bg-indigo-100 text-indigo-800 border border-indigo-200'
    case 'can_ho_cao_cap': return 'bg-purple-100 text-purple-800 border border-purple-200'
    case 'nha_nguyen_can': return 'bg-emerald-100 text-emerald-800 border border-emerald-200'
    case 'biet_thu': return 'bg-amber-100 text-amber-800 border border-amber-200'
    default: return 'bg-slate-100 text-slate-800 border border-slate-200'
  }
}

onMounted(loadProperties)
</script>
