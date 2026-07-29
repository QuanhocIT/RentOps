<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Quản Lý Khách Thuê (Cư Dân)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lưu trữ thông tin định danh CCCD/CMND, số điện thoại và quê quán khách thuê</p>
        </div>

        <button
          @click="openModal()"
          class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
        >
          <span>👤</span> Thêm khách thuê mới
        </button>
      </div>

      <!-- Renters Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-bold text-slate-900 text-base">Danh Sách Cư Dân Thuê Phòng</div>
          <div class="flex items-center gap-3">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Tìm theo tên, SĐT, CCCD, Quê quán..."
              class="w-72 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button @click="loadRenters" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200" title="Tải lại">
              🔄
            </button>
          </div>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">
          Đang tải danh sách khách thuê...
        </div>

        <div v-else-if="filteredRenters.length === 0" class="p-12 text-center text-slate-500">
          Chưa có khách thuê nào phù hợp.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Họ và Tên Cư Dân</th>
                <th class="px-6 py-4">Số CCCD / CMND</th>
                <th class="px-6 py-4">Số Điện Thoại</th>
                <th class="px-6 py-4">Email</th>
                <th class="px-6 py-4">Quê Quán</th>
                <th class="px-6 py-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="r in filteredRenters" :key="r.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">
                  👤 {{ r.full_name }}
                </td>
                <td class="px-6 py-4 font-mono font-bold text-indigo-600">
                  {{ r.id_card_number || 'Chưa cập nhật' }}
                </td>
                <td class="px-6 py-4 text-slate-800 font-mono">{{ r.phone || 'N/A' }}</td>
                <td class="px-6 py-4 text-slate-500">{{ r.email }}</td>
                <td class="px-6 py-4 text-slate-600">{{ r.hometown || 'Chưa rõ' }}</td>
                <td class="px-6 py-4 text-right flex items-center justify-end gap-2">
                  <button @click="openModal(r)" class="text-xs font-semibold text-indigo-600 hover:text-indigo-800 bg-indigo-50 px-2.5 py-1 rounded-lg">
                    Sửa
                  </button>
                  <button @click="deleteRenter(r.id)" class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg">
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">{{ editingRenter ? 'Chỉnh Sửa Thông Tin Cư Dân' : 'Thêm Khách Thuê Mới' }}</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="saveRenter" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Họ và Tên Khách Thuê</label>
              <input v-model="form.full_name" required type="text" placeholder="Nguyễn Văn B" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500" />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-indigo-700 uppercase mb-1">Số CCCD/CMND (12 số)</label>
                <input v-model="form.id_card_number" required type="text" placeholder="001203004005" class="w-full px-3 py-2 bg-indigo-50/50 border border-indigo-300 rounded-xl text-sm font-mono font-bold focus:bg-white" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số Điện Thoại</label>
                <input v-model="form.phone" required type="text" placeholder="0987654321" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-mono focus:bg-white" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Email Liên Hệ</label>
                <input v-model="form.email" required type="email" placeholder="khachthue@gmail.com" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Quê Quán</label>
                <input v-model="form.hometown" type="text" placeholder="Nam Định, Hà Nội..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Lưu cư dân' }}
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

const renters = ref([])
const loading = ref(false)
const submitting = ref(false)
const showModal = ref(false)
const editingRenter = ref(null)
const searchQuery = ref('')

const form = ref({ full_name: '', email: '', phone: '', id_card_number: '', hometown: '' })

const loadRenters = async () => {
  loading.value = true
  try {
    const res = await api.get('/renters')
    renters.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) {
    console.warn('API error loading renters:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadRenters)

const filteredRenters = computed(() => {
  return renters.value.filter(r => {
    if (!searchQuery.value) return true
    const q = searchQuery.value.toLowerCase()
    return String(r.full_name || '').toLowerCase().includes(q) ||
           String(r.phone || '').toLowerCase().includes(q) ||
           String(r.hometown || '').toLowerCase().includes(q) ||
           String(r.id_card_number || '').toLowerCase().includes(q)
  })
})

const openModal = (item = null) => {
  editingRenter.value = item
  if (item) {
    form.value = { ...item }
  } else {
    form.value = { full_name: '', email: '', phone: '', id_card_number: '', hometown: '' }
  }
  showModal.value = true
}

const saveRenter = async () => {
  submitting.value = true
  try {
    if (editingRenter.value) {
      await api.put(`/renters/${editingRenter.value.id}`, { renter: form.value })
    } else {
      await api.post('/renters', { renter: form.value })
    }
    showModal.value = false
    loadRenters()
  } catch (err) {
    alert(err?.message || 'Có lỗi khi lưu khách thuê')
  } finally {
    submitting.value = false
  }
}

const deleteRenter = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa khách thuê này?')) return
  try {
    await api.delete(`/renters/${id}`)
    loadRenters()
  } catch (err) {
    alert(err?.message || 'Không thể xóa khách thuê')
  }
}
</script>
