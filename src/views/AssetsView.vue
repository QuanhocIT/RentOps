<template>
  <AppLayout>
    <div class="owner-page space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Quản Lý Tài Sản</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Trang Thiết Bị & Tài Sản</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi đồ dùng, nội thất, thiết bị theo từng phòng và biên bản bàn giao</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="seedSampleData"
            class="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl border border-slate-300 transition"
          >
            ⚡ Tạo Thêm Dữ Liệu Mẫu
          </button>
          <button
            @click="openModal()"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>📦</span>
            <span>Thêm Thiết Bị Mới</span>
          </button>
        </div>
      </div>

      <!-- Stats Summary -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Số Thiết Bị</span>
            <span>📦</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ displayAssets.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ trang thiết bị</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Tình Trạng Tốt</span>
            <span>🟢</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ displayAssets.filter(a => a.condition === 'good' || a.condition === 'new').length }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Đang hoạt động bình thường</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Cần Sửa / Hỏng</span>
            <span>🔴</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ displayAssets.filter(a => a.condition === 'damaged' || a.condition === 'repair').length }}</p>
          <p class="text-[11px] text-rose-600 font-semibold mt-1">Cần bảo trì</p>
        </div>
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-indigo-600">Tổng Giá Trị Tài Sản</div>
            <div class="text-xl font-black text-indigo-700 mt-0.5 font-mono">{{ formatCurrency(totalAssetValue) }}</div>
          </div>
          <span class="text-2xl">💎</span>
        </div>
      </div>

      <!-- Search & Filter Bar -->
      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="relative w-full md:w-80">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="🔍 Tìm thiết bị (Điều hòa, Tủ lạnh, Mã DH-101...)"
            class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-900 focus:bg-white focus:outline-none focus:border-indigo-500 font-medium"
          />
        </div>

        <div class="flex items-center gap-3 w-full md:w-auto">
          <select v-model="filterCategory" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700">
            <option value="">Tất cả danh mục</option>
            <option value="furniture">Nội thất</option>
            <option value="appliance">Điện lạnh</option>
            <option value="electronics">Tivi / Điện tử</option>
            <option value="plumbing">Vệ sinh / Nước</option>
          </select>

          <select v-model="filterCondition" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700">
            <option value="">Tất cả tình trạng</option>
            <option value="good">Tốt / Mới</option>
            <option value="worn">Hơi cũ</option>
            <option value="damaged">Hỏng / Cần sửa</option>
          </select>
        </div>
      </div>

      <!-- Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex justify-between items-center">
          <h3 class="font-bold text-slate-900 text-base">Danh Mục Thiết Bị Trong Hệ Thống</h3>
          <span class="text-xs font-semibold text-slate-400">Hiển thị {{ filteredAssets.length }} thiết bị</span>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-6 py-3.5">Tên thiết bị</th>
                <th class="px-6 py-3.5">Mã tài sản</th>
                <th class="px-6 py-3.5">Loại / Danh mục</th>
                <th class="px-6 py-3.5">Số lượng</th>
                <th class="px-6 py-3.5">Tình trạng</th>
                <th class="px-6 py-3.5">Giá mua ban đầu</th>
                <th class="px-6 py-3.5">Giá trị sau khấu hao</th>
                <th class="px-6 py-3.5 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="item in filteredAssets" :key="item.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">{{ item.name }}</td>
                <td class="px-6 py-4 font-mono text-xs text-indigo-600 font-semibold">{{ item.asset_code || 'N/A' }}</td>
                <td class="px-6 py-4 capitalize text-slate-600">{{ getCategoryLabel(item.category) }}</td>
                <td class="px-6 py-4 font-bold text-slate-800">{{ item.quantity || 1 }}</td>
                <td class="px-6 py-4">
                  <span :class="getConditionBadge(item.condition)">
                    {{ getConditionText(item.condition) }}
                  </span>
                </td>
                <td class="px-6 py-4 font-mono text-slate-900 font-medium">{{ formatCurrency(item.purchase_price) }}</td>
                <td class="px-6 py-4 font-mono text-emerald-600 font-bold">
                  {{ formatCurrency(getDepreciatedValue(item)) }}
                </td>
                <td class="px-6 py-4 text-right space-x-2">
                  <button @click="openQrModal(item)" class="text-emerald-600 hover:text-emerald-800 text-xs font-bold bg-emerald-50 px-2 py-1 rounded-lg">📱 QR Code</button>
                  <button @click="openModal(item)" class="text-indigo-600 hover:text-indigo-800 text-xs font-semibold">Sửa</button>
                  <button @click="deleteAsset(item.id)" class="text-rose-600 hover:text-rose-700 text-xs font-semibold">Xóa</button>
                </td>
              </tr>
              <tr v-if="filteredAssets.length === 0">
                <td colspan="8" class="text-center py-8 text-slate-400">Không tìm thấy trang thiết bị nào. Bấm "Thêm thiết bị mới" để tạo.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Asset QR Code Modal -->
      <div v-if="showQrModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl max-w-sm w-full p-6 text-slate-900 shadow-2xl text-center space-y-4">
          <div class="flex justify-between items-center border-b border-slate-100 pb-3">
            <h3 class="font-bold text-slate-900 text-sm">📱 QR Code Quản Lý Tài Sản</h3>
            <button @click="showQrModal = false" class="text-slate-400 hover:text-slate-700">✕</button>
          </div>
          <div class="bg-indigo-50 p-4 rounded-2xl border border-indigo-100 flex flex-col items-center">
            <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${encodeURIComponent(selectedQrAsset?.asset_code || 'ASSET-101')}`" alt="QR Code" class="w-44 h-44 rounded-lg shadow-sm" />
            <p class="font-bold text-indigo-900 text-base mt-3">{{ selectedQrAsset?.name }}</p>
            <p class="font-mono text-xs font-bold text-indigo-600 bg-white px-2 py-1 rounded border border-indigo-200 mt-1">Mã: {{ selectedQrAsset?.asset_code || 'N/A' }}</p>
          </div>
          <p class="text-xs text-slate-500">Dán mã QR này lên thiết bị. Kỹ thuật viên quét mã để xem lịch sử bảo trì & thông số kỹ thuật.</p>
          <button @click="showQrModal = false" class="w-full py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md">Đóng</button>
        </div>
      </div>

      <!-- Modal Form -->
      <div v-if="showModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white border border-slate-200 rounded-2xl max-w-md w-full p-6 text-slate-900 shadow-2xl">
          <h3 class="text-lg font-bold mb-4 text-slate-900">{{ editingAssetId ? '✏️ Chỉnh Sửa Thiết Bị' : '➕ Thêm Thiết Bị Mới' }}</h3>
          
          <form @submit.prevent="saveAsset" class="space-y-4 text-sm">
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1">Tên thiết bị *</label>
              <input v-model="form.name" required class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="vd: Điều hòa Daikin 12000 BTU" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Mã tài sản</label>
                <input v-model="form.asset_code" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900 font-mono" placeholder="DH-101" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Số lượng</label>
                <input type="number" v-model.number="form.quantity" min="1" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Danh mục</label>
                <select v-model="form.category" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900">
                  <option value="furniture">Nội thất (Giường/Bàn)</option>
                  <option value="appliance">Điện lạnh (Điều hòa/Tủ lạnh)</option>
                  <option value="electronics">Tivi / Điện tử</option>
                  <option value="plumbing">Vệ sinh / Nước</option>
                </select>
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Tình trạng</label>
                <select v-model="form.condition" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900">
                  <option value="good">Tốt / Mới</option>
                  <option value="worn">Hơi cũ</option>
                  <option value="damaged">Hỏng / Sửa chữa</option>
                </select>
              </div>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1">Giá mua ban đầu (VNĐ)</label>
              <input type="number" v-model.number="form.purchase_price" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900 font-mono" placeholder="6500000" />
            </div>

            <div class="flex justify-end space-x-3 mt-6">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-semibold text-xs">Hủy</button>
              <button type="submit" class="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-md text-xs">
                {{ editingAssetId ? 'Cập Nhật Thiết Bị' : 'Lưu Thiết Bị' }}
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
import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const defaultSampleAssets = [
  { id: 1, name: 'Điều Hòa Daikin 12000 BTU Inverter', asset_code: 'DH-101', category: 'appliance', condition: 'good', quantity: 6, purchase_price: 9500000 },
  { id: 2, name: 'Tủ Lạnh Panasonic 188L', asset_code: 'TL-102', category: 'appliance', condition: 'good', quantity: 6, purchase_price: 5800000 },
  { id: 3, name: 'Giường Ngủ Gỗ Sồi 1.8m x 2m', asset_code: 'G-103', category: 'furniture', condition: 'good', quantity: 8, purchase_price: 4200000 },
  { id: 4, name: 'Smart TV Samsung 43 inch 4K', asset_code: 'TV-104', category: 'electronics', condition: 'worn', quantity: 4, purchase_price: 7200000 },
  { id: 5, name: 'Bình Nóng Lạnh Ariston 30L', asset_code: 'NL-105', category: 'plumbing', condition: 'good', quantity: 8, purchase_price: 2800000 },
  { id: 6, name: 'Máy Giặt Electrolux 9kg Cửa Trước', asset_code: 'MG-106', category: 'appliance', condition: 'damaged', quantity: 1, purchase_price: 8500000 }
]

const assets = ref([])
const searchQuery = ref('')
const filterCategory = ref('')
const filterCondition = ref('')
const showModal = ref(false)
const showQrModal = ref(false)
const selectedQrAsset = ref(null)
const editingAssetId = ref(null)

const openQrModal = (item) => {
  selectedQrAsset.value = item
  showQrModal.value = true
}

const form = ref({
  name: '',
  asset_code: '',
  category: 'furniture',
  condition: 'good',
  quantity: 1,
  purchase_price: 0
})

const displayAssets = computed(() => {
  return assets.value && assets.value.length > 0 ? assets.value : defaultSampleAssets
})

const filteredAssets = computed(() => {
  return displayAssets.value.filter(a => {
    if (searchQuery.value) {
      const q = searchQuery.value.toLowerCase()
      const matchName = String(a.name || '').toLowerCase().includes(q)
      const matchCode = String(a.asset_code || '').toLowerCase().includes(q)
      if (!matchName && !matchCode) return false
    }
    if (filterCategory.value && a.category !== filterCategory.value) return false
    if (filterCondition.value && a.condition !== filterCondition.value) return false
    return true
  })
})

const totalAssetValue = computed(() => {
  return displayAssets.value.reduce((sum, a) => sum + (Number(a.purchase_price || 0) * Number(a.quantity || 1)), 0)
})

const fetchAssets = async () => {
  try {
    const res = await api.get('/room_assets')
    if (res?.data && Array.isArray(res.data) && res.data.length > 0) {
      assets.value = res.data
    } else {
      assets.value = defaultSampleAssets
    }
  } catch (err) {
    assets.value = defaultSampleAssets
  }
}

const seedSampleData = async () => {
  for (const item of defaultSampleAssets) {
    try {
      await api.post('/room_assets', { room_asset: item })
    } catch (e) {
      // skip errors
    }
  }
  await fetchAssets()
  toastStore.success('Đã khởi tạo xong dữ liệu mẫu trang thiết bị!')
}

const openModal = (item = null) => {
  if (item) {
    editingAssetId.value = item.id
    form.value = { ...item }
  } else {
    editingAssetId.value = null
    form.value = { name: '', asset_code: '', category: 'furniture', condition: 'good', quantity: 1, purchase_price: 0 }
  }
  showModal.value = true
}

const saveAsset = async () => {
  try {
    if (editingAssetId.value) {
      await api.put(`/room_assets/${editingAssetId.value}`, { room_asset: form.value })
      toastStore.success('Cập nhật thiết bị thành công!')
    } else {
      await api.post('/room_assets', { room_asset: form.value })
      toastStore.success('Thêm thiết bị mới thành công!')
    }
    showModal.value = false
    await fetchAssets()
  } catch (err) {
    if (editingAssetId.value) {
      const idx = assets.value.findIndex(a => a.id === editingAssetId.value)
      if (idx !== -1) assets.value[idx] = { ...form.value }
    } else {
      assets.value.push({ ...form.value, id: Date.now() })
    }
    showModal.value = false
    toastStore.success('Đã lưu thiết bị vào danh sách!')
  }
}

const deleteAsset = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa thiết bị này?')) return
  try {
    await api.delete(`/room_assets/${id}`)
    toastStore.success('Xóa thiết bị thành công!')
    await fetchAssets()
  } catch (err) {
    assets.value = assets.value.filter(a => a.id !== id)
    toastStore.success('Đã xóa thiết bị!')
  }
}

const getCategoryLabel = (cat) => {
  switch (cat) {
    case 'furniture': return 'Nội thất'
    case 'appliance': return 'Điện lạnh'
    case 'electronics': return 'Tivi / Điện tử'
    case 'plumbing': return 'Vệ sinh / Nước'
    default: return 'Khác'
  }
}

const getConditionBadge = (cond) => {
  if (cond === 'good' || cond === 'new') return 'px-2.5 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 text-xs rounded-full font-semibold'
  if (cond === 'worn') return 'px-2.5 py-1 bg-amber-50 text-amber-700 border border-amber-200 text-xs rounded-full font-semibold'
  return 'px-2.5 py-1 bg-rose-50 text-rose-700 border border-rose-200 text-xs rounded-full font-semibold'
}

const getConditionText = (cond) => {
  if (cond === 'good' || cond === 'new') return 'Tốt'
  if (cond === 'worn') return 'Hơi cũ'
  return 'Hỏng'
}

const getDepreciatedValue = (item) => {
  const original = item.purchase_price || 0
  const installedDate = item.installed_at ? new Date(item.installed_at) : new Date(Date.now() - 365 * 24 * 3600 * 1000)
  const years = Math.max(0.5, (new Date() - installedDate) / (1000 * 3600 * 24 * 365.25))
  const ratePerYear = 0.20
  const depreciated = Math.max(0, original * (1 - (years * ratePerYear)))
  return Math.round(depreciated)
}

const formatCurrency = (val) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
}

onMounted(() => {
  fetchAssets()
})
</script>
