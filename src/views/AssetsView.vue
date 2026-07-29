<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-slate-800/80 p-6 rounded-2xl border border-slate-700/60 shadow-lg backdrop-blur">
      <div>
        <h1 class="text-2xl font-black bg-gradient-to-r from-teal-400 to-emerald-200 bg-clip-text text-transparent">
          📦 Quản Lý Trang Thiết Bị & Tài Sản
        </h1>
        <p class="text-xs text-slate-400 mt-1">Theo dõi đồ dùng, nội thất, thiết bị theo từng phòng và biên bản bàn giao</p>
      </div>

      <button
        @click="openModal()"
        class="px-5 py-2.5 bg-emerald-500 hover:bg-emerald-600 text-white font-bold text-sm rounded-xl shadow-lg transition flex items-center space-x-2"
      >
        <span>➕ Thêm Thiết Bị Mới</span>
      </button>
    </div>

    <!-- Stats Summary -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div class="bg-slate-800/80 p-4 rounded-xl border border-slate-700/60">
        <p class="text-xs text-slate-400">Tổng số thiết bị</p>
        <p class="text-2xl font-bold text-white mt-1">{{ assets.length }}</p>
      </div>
      <div class="bg-slate-800/80 p-4 rounded-xl border border-slate-700/60">
        <p class="text-xs text-slate-400">Tình trạng Tốt</p>
        <p class="text-2xl font-bold text-emerald-400 mt-1">{{ assets.filter(a => a.condition === 'good' || a.condition === 'new').length }}</p>
      </div>
      <div class="bg-slate-800/80 p-4 rounded-xl border border-slate-700/60">
        <p class="text-xs text-slate-400">Cần sửa chữa / Hỏng</p>
        <p class="text-2xl font-bold text-rose-400 mt-1">{{ assets.filter(a => a.condition === 'damaged' || a.condition === 'repair').length }}</p>
      </div>
      <div class="bg-slate-800/80 p-4 rounded-xl border border-slate-700/60">
        <p class="text-xs text-slate-400">Tổng giá trị tài sản</p>
        <p class="text-2xl font-bold text-amber-400 mt-1">{{ formatCurrency(totalAssetValue) }}</p>
      </div>
    </div>

    <!-- Table -->
    <div class="bg-slate-800/80 rounded-2xl border border-slate-700/60 overflow-hidden shadow-xl">
      <div class="p-4 border-b border-slate-700/60 flex justify-between items-center">
        <h3 class="font-bold text-slate-200">Danh Mục Thiết Bị Trong Hệ Thống</h3>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-300">
          <thead class="bg-slate-900/60 text-xs uppercase text-slate-400 border-b border-slate-700/60">
            <tr>
              <th class="px-6 py-4">Tên thiết bị</th>
              <th class="px-6 py-4">Mã tài sản</th>
              <th class="px-6 py-4">Loại / Danh mục</th>
              <th class="px-6 py-4">Số lượng</th>
              <th class="px-6 py-4">Tình trạng</th>
              <th class="px-6 py-4">Giá mua</th>
              <th class="px-6 py-4 text-right">Thao tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-700/40">
            <tr v-for="item in assets" :key="item.id" class="hover:bg-slate-700/30 transition">
              <td class="px-6 py-4 font-semibold text-white">{{ item.name }}</td>
              <td class="px-6 py-4 font-mono text-xs text-amber-400">{{ item.asset_code || 'N/A' }}</td>
              <td class="px-6 py-4 capitalize text-slate-300">{{ item.category || 'Nội thất' }}</td>
              <td class="px-6 py-4 font-bold text-teal-300">{{ item.quantity || 1 }}</td>
              <td class="px-6 py-4">
                <span :class="getConditionBadge(item.condition)">
                  {{ getConditionText(item.condition) }}
                </span>
              </td>
              <td class="px-6 py-4 font-mono text-slate-200">{{ formatCurrency(item.purchase_price) }}</td>
              <td class="px-6 py-4 text-right space-x-2">
                <button @click="deleteAsset(item.id)" class="text-rose-400 hover:text-rose-300 text-xs font-semibold">Xóa</button>
              </td>
            </tr>
            <tr v-if="assets.length === 0">
              <td colspan="7" class="text-center py-8 text-slate-400">Chưa có trang thiết bị nào. Bấm "Thêm Thiết Bị Mới" để tạo.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-slate-900 border border-slate-700 rounded-2xl max-w-md w-full p-6 text-white shadow-2xl">
        <h3 class="text-lg font-bold mb-4 text-emerald-400">➕ Thêm Thiết Bị Mới</h3>
        
        <form @submit.prevent="saveAsset" class="space-y-4 text-sm">
          <div>
            <label class="block text-xs text-slate-400 mb-1">Tên thiết bị *</label>
            <input v-model="form.name" required class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white" placeholder="vd: Điều hòa Daikin 12000 BTU" />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs text-slate-400 mb-1">Mã tài sản</label>
              <input v-model="form.asset_code" class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white font-mono" placeholder="DH-101" />
            </div>
            <div>
              <label class="block text-xs text-slate-400 mb-1">Số lượng</label>
              <input type="number" v-model="form.quantity" min="1" class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white" />
            </div>
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs text-slate-400 mb-1">Danh mục</label>
              <select v-model="form.category" class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white">
                <option value="furniture">Nội thất (Giường/Bàn)</option>
                <option value="appliance">Điện lạnh (Điều hòa/Tủ lạnh)</option>
                <option value="electronics">Tivi / Điện tử</option>
                <option value="plumbing">Vệ sinh / Nước</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-slate-400 mb-1">Tình trạng</label>
              <select v-model="form.condition" class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white">
                <option value="good">Tốt / Mới</option>
                <option value="worn">Hơi cũ</option>
                <option value="damaged">Hỏng / Sửa chữa</option>
              </select>
            </div>
          </div>

          <div>
            <label class="block text-xs text-slate-400 mb-1">Giá mua (VNĐ)</label>
            <input type="number" v-model="form.purchase_price" class="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-white" placeholder="6500000" />
          </div>

          <div class="flex justify-end space-x-3 mt-6">
            <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-800 text-slate-400 rounded-xl">Hủy</button>
            <button type="submit" class="px-5 py-2 bg-emerald-500 hover:bg-emerald-600 text-white font-bold rounded-xl shadow-lg">Lưu Thiết Bị</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

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
  if (cond === 'good' || cond === 'new') return 'px-2.5 py-1 bg-emerald-500/20 text-emerald-400 text-xs rounded-lg font-bold'
  if (cond === 'worn') return 'px-2.5 py-1 bg-amber-500/20 text-amber-400 text-xs rounded-lg font-bold'
  return 'px-2.5 py-1 bg-rose-500/20 text-rose-400 text-xs rounded-lg font-bold'
}

const getConditionText = (cond) => {
  if (cond === 'good' || cond === 'new') return 'Tốt'
  if (cond === 'worn') return 'Hơi cũ'
  return 'Hỏng'
}

const formatCurrency = (val) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
}

onMounted(() => {
  fetchAssets()
})
</script>
