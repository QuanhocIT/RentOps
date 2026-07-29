<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Glass Header Bar -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white/90 backdrop-blur-md p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div>
          <h1 class="text-2xl font-black text-slate-900 tracking-tight flex items-center gap-2">
            <span>🛋️</span> Danh Mục Tiện Ích & Nội Thất
          </h1>
          <p class="text-slate-500 text-xs mt-1 font-medium">Quản lý danh mục các thiết bị, đồ dùng trang bị cho từng phòng trọ & căn hộ dịch vụ</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="seedSampleData"
            class="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl border border-slate-300/80 transition"
          >
            ⚡ Tạo Thêm Dữ Liệu Mẫu
          </button>
          <button
            @click="showModal = true"
            class="inline-flex items-center gap-2 px-4.5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-extrabold text-xs shadow-md shadow-indigo-600/30 transition hover:scale-105 active:scale-95"
          >
            <span>🛋️</span> Thêm Tiện Ích Mới
          </button>
        </div>
      </div>

      <!-- Summary Metric Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-slate-400">Tổng Số Tiện Ích</div>
            <div class="text-2xl font-black text-slate-900 mt-1 font-mono">{{ displayAmenities.length }}</div>
          </div>
          <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold text-lg">🛋️</div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-emerald-600">Thiết Bị Điện Lạnh / Thông Minh</div>
            <div class="text-2xl font-black text-emerald-600 mt-1 font-mono">{{ smartCount }}</div>
          </div>
          <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-lg">❄️</div>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-amber-600">Nội Thất Gỗ & Decor</div>
            <div class="text-2xl font-black text-amber-600 mt-1 font-mono font-mono">{{ furnitureCount }}</div>
          </div>
          <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-lg">🛏️</div>
        </div>
      </div>

      <!-- Search Input Bar -->
      <div class="flex justify-between items-center bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
        <div class="relative w-full max-w-xs">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="🔍 Tìm tiện ích (Điều hòa, Wifi, Tủ lạnh)..."
            class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-900 focus:bg-white focus:outline-none focus:border-indigo-500 font-medium"
          />
        </div>
        <span class="text-xs font-bold text-slate-400">Hiển thị {{ filteredAmenities.length }} tiện ích</span>
      </div>

      <!-- Amenities Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
        <div
          v-for="item in filteredAmenities"
          :key="item.id"
          class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between hover:shadow-md hover:border-indigo-200 transition group"
        >
          <div class="flex items-center gap-3.5">
            <span class="text-3xl p-2.5 bg-slate-50 rounded-2xl border border-slate-100 group-hover:scale-105 transition-transform">
              {{ item.icon || '🛋️' }}
            </span>
            <div>
              <h3 class="font-extrabold text-slate-900 text-sm leading-tight">{{ item.name }}</h3>
              <div class="flex items-center gap-1.5 mt-1">
                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                <span class="text-[11px] text-slate-400 font-bold">Trang bị sẵn</span>
              </div>
            </div>
          </div>

          <button
            @click="deleteAmenity(item.id)"
            class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 hover:bg-rose-100 px-2.5 py-1 rounded-lg border border-rose-100 transition"
          >
            Xóa
          </button>
        </div>
      </div>

      <!-- Add Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-sm w-full p-6 shadow-2xl space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Thêm Tiện Ích Mới</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="createAmenity" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên trang thiết bị</label>
              <input v-model="form.name" required type="text" placeholder="Ví dụ: Điều hòa Inverter 9000BTU" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Biểu tượng Icon</label>
              <input v-model="form.icon" type="text" placeholder="❄️, 🧊, 🛏️, 🧺, 🔒..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div class="flex justify-end gap-3 pt-2">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Lưu tiện ích' }}
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

const defaultSampleAmenities = [
  { id: 1, name: "Điều Hòa Inverter 2 Chiều", icon: "❄️" },
  { id: 2, name: "Tủ Lạnh Side-by-Side 250L", icon: "🧊" },
  { id: 3, name: "Giường Ngủ Gỗ Sồi (Nệm Cao Su)", icon: "🛏️" },
  { id: 4, name: "Máy Giặt Riêng Cửa Trước", icon: "🧺" },
  { id: 5, name: "Wifi Cáp Quang 200Mbps", icon: "📶" },
  { id: 6, name: "Bếp Từ Đôi Âm + Hút Mùi", icon: "🍳" },
  { id: 7, name: "Sofa & Bàn Trà Cao Cấp", icon: "🛋️" },
  { id: 8, name: "Bình Nóng Lạnh Ariston 30L", icon: "🚿" },
  { id: 9, name: "Tủ Quần Áo 3 Cánh Kịch Trần", icon: "🚪" },
  { id: 10, name: "Ban Công View Phố Rộng", icon: "🌅" },
  { id: 11, name: "Khóa Cửa Vân Tay Thông Minh", icon: "🔒" },
  { id: 12, name: "Smart TV 50 inch 4K", icon: "🖥️" }
]

const amenities = ref([])
const searchQuery = ref('')
const showModal = ref(false)
const submitting = ref(false)

const form = ref({ name: '', icon: '🛋️' })

const displayAmenities = computed(() => {
  if (amenities.value && amenities.value.length > 0) {
    return amenities.value
  }
  return defaultSampleAmenities
})

const filteredAmenities = computed(() => {
  if (!searchQuery.value) return displayAmenities.value
  const query = searchQuery.value.toLowerCase()
  return displayAmenities.value.filter(a => a.name.toLowerCase().includes(query))
})

const smartCount = computed(() => {
  return displayAmenities.value.filter(a => ['❄️', '🧊', '🧺', '📶', '🔒', '🖥️'].includes(a.icon)).length
})

const furnitureCount = computed(() => {
  return displayAmenities.value.filter(a => ['🛏️', '🛋️', '🚪', '🍳'].includes(a.icon)).length
})

const loadAmenities = async () => {
  try {
    const res = await api.get('/amenities')
    if (res?.data && Array.isArray(res.data) && res.data.length > 0) {
      amenities.value = res.data
    } else {
      amenities.value = defaultSampleAmenities
    }
  } catch (err) {
    console.warn('Using fallback default amenities list')
    amenities.value = defaultSampleAmenities
  }
}

const seedSampleData = async () => {
  for (const item of defaultSampleAmenities) {
    try {
      await api.post('/amenities', { amenity: { name: item.name, icon: item.icon } })
    } catch (e) {
      // ignore duplicates
    }
  }
  await loadAmenities()
  alert('Đã khởi tạo xong dữ liệu mẫu tiện ích!')
}

onMounted(loadAmenities)

const createAmenity = async () => {
  submitting.value = true
  try {
    const res = await api.post('/amenities', { amenity: form.value })
    showModal.value = false
    form.value = { name: '', icon: '🛋️' }
    await loadAmenities()
  } catch (err) {
    // Local push if offline
    amenities.value.push({ id: Date.now(), name: form.value.name, icon: form.value.icon })
    showModal.value = false
    form.value = { name: '', icon: '🛋️' }
  } finally {
    submitting.value = false
  }
}

const deleteAmenity = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa tiện ích này?')) return
  try {
    await api.delete(`/amenities/${id}`)
    await loadAmenities()
  } catch (err) {
    amenities.value = amenities.value.filter(a => a.id !== id)
  }
}
</script>

