<template>
  <AppLayout>
    <div class="space-y-6">
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
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ assets.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ trang thiết bị</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Tình Trạng Tốt</span>
            <span>🟢</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ assets.filter(a => a.condition === 'good' || a.condition === 'new').length }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Đang hoạt động bình thường</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Cần Sửa / Hỏng</span>
            <span>🔴</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ assets.filter(a => a.condition === 'damaged' || a.condition === 'repair').length }}</p>
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

      <!-- Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex justify-between items-center">
          <h3 class="font-bold text-slate-900 text-base">Danh Mục Thiết Bị Trong Hệ Thống</h3>
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
              <tr v-for="item in assets" :key="item.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">{{ item.name }}</td>
                <td class="px-6 py-4 font-mono text-xs text-indigo-600 font-semibold">{{ item.asset_code || 'N/A' }}</td>
                <td class="px-6 py-4 capitalize text-slate-600">{{ item.category || 'Nội thất' }}</td>
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
                <td class="px-6 py-4 text-right">
                  <button @click="deleteAsset(item.id)" class="text-rose-600 hover:text-rose-700 text-xs font-semibold">Xóa</button>
                </td>
              </tr>
              <tr v-if="assets.length === 0">
                <td colspan="7" class="text-center py-8 text-slate-400">Chưa có trang thiết bị nào. Bấm "Thêm thiết bị mới" để tạo.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Modal Form -->
      <div v-if="showModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white border border-slate-200 rounded-2xl max-w-md w-full p-6 text-slate-900 shadow-2xl">
          <h3 class="text-lg font-bold mb-4 text-slate-900">➕ Thêm Thiết Bị Mới</h3>
          
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
                <input type="number" v-model="form.quantity" min="1" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900" />
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
              <label class="block text-xs font-semibold text-slate-600 mb-1">Giá mua (VNĐ)</label>
              <input type="number" v-model="form.purchase_price" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-slate-900 font-mono" placeholder="6500000" />
            </div>

            <div class="flex justify-end space-x-3 mt-6">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-semibold text-xs">Hủy</button>
              <button type="submit" class="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-md text-xs">Lưu Thiết Bị</button>
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

const assets = ref([])
const showModal = ref(false)
const form = ref({
  name: '',
  asset_code: '',
  category: 'furniture',
  condition: 'good',
  quantity: 1,
  purchase_price: 0
})

const totalAssetValue = computed(() => {
  return assets.value.reduce((sum, a) => sum + (Number(a.purchase_price || 0) * Number(a.quantity || 1)), 0)
})

const fetchAssets = async () => {
  try {
    const res = await fetch('/api/v1/room_assets')
    if (res.ok) {
      assets.value = await res.json()
    }
  } catch (err) {
    console.error(err)
  }
}

const openModal = () => {
  form.value = { name: '', asset_code: '', category: 'furniture', condition: 'good', quantity: 1, purchase_price: 0 }
  showModal.value = true
}

const saveAsset = async () => {
  try {
    const res = await fetch('/api/v1/room_assets', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ room_asset: form.value })
    })

    if (res.ok) {
      showModal.value = false
      fetchAssets()
    }
  } catch (err) {
    alert('Lỗi lưu thiết bị')
  }
}

const deleteAsset = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa thiết bị này?')) return
  await fetch(`/api/v1/room_assets/${id}`, { method: 'DELETE' })
  fetchAssets()
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
