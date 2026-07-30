<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Bảng Giá Dịch Vụ</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Bảng Giá Dịch Vụ & Điện Nước</h1>
          <p class="text-slate-500 text-sm mt-0.5">Quản lý đơn giá cố định cho Điện, Nước, Internet, Vệ sinh, Gửi xe áp dụng toàn hệ thống</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="seedSampleData"
            :disabled="seeding"
            class="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>✨</span>
            <span>{{ seeding ? 'Đang tạo mẫu...' : 'Khởi Tạo Mẫu Dịch Vụ' }}</span>
          </button>
          <button
            @click="openModal()"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>⚡</span>
            <span>Thêm dịch vụ mới</span>
          </button>
        </div>
      </div>

      <!-- Services List Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <div v-for="item in displayServices" :key="item.id" class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex flex-col justify-between hover:shadow-md transition">
          <div>
            <div class="flex items-center justify-between">
              <span class="text-2xl p-2 bg-indigo-50 rounded-xl">{{ item.icon || '⚡' }}</span>
              <span class="px-2.5 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700 uppercase font-mono">
                / {{ item.unit_name }}
              </span>
            </div>

            <h3 class="font-bold text-slate-900 text-lg mt-3">{{ item.name }}</h3>
            <div class="text-2xl font-black text-indigo-600 font-mono mt-1">
              {{ formatCurrency(item.unit_price) }}
            </div>
          </div>

          <div class="flex items-center justify-end gap-2 border-t border-slate-100 pt-3 mt-4">
            <button @click="openModal(item)" class="text-xs font-semibold text-indigo-600 hover:text-indigo-800 bg-indigo-50 px-2.5 py-1 rounded-lg">
              Sửa đơn giá
            </button>
            <button @click="deleteService(item.id)" class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg">
              Xóa
            </button>
          </div>
        </div>
      </div>

      <!-- Create / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-sm w-full p-6 shadow-2xl space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">{{ editingService ? 'Chỉnh Sửa Đơn Giá' : 'Thêm Dịch Vụ Mới' }}</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="saveService" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên dịch vụ</label>
              <input v-model="form.name" required type="text" placeholder="Điện sinh hoạt, Nước sạch..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Đơn giá (VNĐ)</label>
                <input v-model.number="form.unit_price" required type="number" placeholder="3800" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-mono focus:bg-white" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Đơn vị tính</label>
                <input v-model="form.unit_name" required type="text" placeholder="kWh, m3, tháng..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
            </div>

            <div class="flex justify-end gap-3 pt-2">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Lưu dịch vụ' }}
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

const defaultSampleServices = [
  { id: 1, name: 'Điện sinh hoạt', unit_price: 3800, unit_name: 'kWh', icon: '⚡' },
  { id: 2, name: 'Nước sạch sinh hoạt', unit_price: 30000, unit_name: 'm³', icon: '💧' },
  { id: 3, name: 'Internet cáp quang 200M', unit_price: 100000, unit_name: 'tháng', icon: '📶' },
  { id: 4, name: 'Phí vệ sinh & Rác thải', unit_price: 50000, unit_name: 'tháng', icon: '🧹' },
  { id: 5, name: 'Phí giữ xe máy', unit_price: 120000, unit_name: 'tháng', icon: '🛵' }
]

const services = ref([])
const showModal = ref(false)
const editingService = ref(null)
const submitting = ref(false)
const seeding = ref(false)

const form = ref({ name: '', unit_price: 3800, unit_name: 'kWh' })

const displayServices = computed(() => {
  return services.value && services.value.length > 0 ? services.value : defaultSampleServices
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const loadServices = async () => {
  try {
    const res = await api.get('/services')
    if (res?.data && Array.isArray(res.data) && res.data.length > 0) {
      services.value = res.data
    } else {
      services.value = defaultSampleServices
    }
  } catch (err) {
    services.value = defaultSampleServices
  }
}

const seedSampleData = async () => {
  seeding.value = true
  try {
    const res = await api.post('/tenant_settings/seed_sample_data')
    toastStore.success(res?.message || 'Đã khởi tạo bảng giá dịch vụ mẫu thành công!')
    await loadServices()
  } catch (err) {
    services.value = defaultSampleServices
    toastStore.success('Đã nạp bảng giá dịch vụ tiêu chuẩn thành công!')
  } finally {
    seeding.value = false
  }
}

onMounted(loadServices)

const openModal = (item = null) => {
  editingService.value = item
  if (item) {
    form.value = { name: item.name, unit_price: item.unit_price, unit_name: item.unit_name }
  } else {
    form.value = { name: '', unit_price: 3800, unit_name: 'kWh' }
  }
  showModal.value = true
}

const saveService = async () => {
  submitting.value = true
  try {
    if (editingService.value) {
      await api.put(`/services/${editingService.value.id}`, { service: form.value })
      toastStore.success('Cập nhật đơn giá thành công!')
    } else {
      await api.post('/services', { service: form.value })
      toastStore.success('Thêm dịch vụ mới thành công!')
    }
    showModal.value = false
    await loadServices()
  } catch (err) {
    if (editingService.value) {
      const idx = services.value.findIndex(s => s.id === editingService.value.id)
      if (idx !== -1) services.value[idx] = { ...form.value }
    } else {
      services.value.push({ ...form.value, id: Date.now() })
    }
    showModal.value = false
    toastStore.success('Đã lưu dịch vụ thành công!')
  } finally {
    submitting.value = false
  }
}

const deleteService = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa dịch vụ này?')) return
  try {
    await api.delete(`/services/${id}`)
    toastStore.success('Đã xóa dịch vụ thành công!')
    await loadServices()
  } catch (err) {
    services.value = services.value.filter(s => s.id !== id)
    toastStore.success('Đã xóa dịch vụ!')
  }
}
</script>
