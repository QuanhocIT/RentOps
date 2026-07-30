<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Quản Lý Khách Thuê</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Danh Sách Cư Dân & Khách Thuê</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lưu trữ thông tin định danh CCCD/CMND, số điện thoại và quê quán khách thuê</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="openModal()"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>👤</span>
            <span>Thêm Khách Thuê Mới</span>
          </button>
        </div>
      </div>

      <!-- Stat Cards Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Cư Dân</span>
            <span>👥</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ renters.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ khách thuê</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-indigo-600 flex items-center justify-between">
            <span>Khách Thuê Đã Xác Thực</span>
            <span>✅</span>
          </div>
          <p class="text-2xl font-black text-indigo-600 mt-2 font-mono">{{ renters.filter(r => r.id_card_number).length }}</p>
          <p class="text-[11px] text-indigo-600 font-semibold mt-1">Đã có CCCD / Định danh</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-amber-600 flex items-center justify-between">
            <span>Số Điện Thoại</span>
            <span>📱</span>
          </div>
          <p class="text-2xl font-black text-amber-700 mt-2 font-mono">{{ renters.filter(r => r.phone).length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Có thể gửi ZNS / SMS</p>
        </div>
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
          <table class="w-full text-left text-xs text-slate-600">
            <thead class="bg-slate-100/80 text-slate-700 uppercase font-extrabold text-[11px] border-b border-slate-200 tracking-wider">
              <tr>
                <th class="px-5 py-3.5">Họ và Tên Cư Dân</th>
                <th class="px-5 py-3.5">Số CCCD / CMND</th>
                <th class="px-5 py-3.5">Số Điện Thoại</th>
                <th class="px-5 py-3.5">Quê Quán</th>
                <th class="px-5 py-3.5 text-right">Thao Tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="r in filteredRenters" :key="r.id" class="hover:bg-indigo-50/30 transition">
                <td class="px-5 py-3.5 font-black text-slate-900 text-sm whitespace-nowrap">
                  👤 {{ r.full_name }}
                </td>
                <td class="px-5 py-3.5 font-mono font-bold text-indigo-600 whitespace-nowrap">
                  {{ r.id_card_number || 'Chưa cập nhật' }}
                </td>
                <td class="px-5 py-3.5 text-slate-800 font-mono font-semibold whitespace-nowrap">
                  📞 {{ r.phone || 'N/A' }}
                </td>
                <td class="px-5 py-3.5 text-slate-600 font-medium whitespace-nowrap">
                  🏡 {{ r.hometown || 'Chưa rõ' }}
                </td>
                <td class="px-5 py-3.5 text-right whitespace-nowrap">
                  <div class="flex items-center justify-end gap-2">
                    <button
                      @click="openDetailModal(r)"
                      class="px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md shadow-indigo-600/20 transition flex items-center gap-1"
                    >
                      <span>👁️</span> <span>Xem Chi Tiết</span>
                    </button>
                    <button @click="openModal(r)" class="text-xs font-bold text-slate-700 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-xl transition">
                      Sửa
                    </button>
                    <button @click="deleteRenter(r.id)" class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-3 py-1.5 rounded-xl transition">
                      Xóa
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Renter Detail Modal -->
      <div v-if="showDetailModal && selectedDetailRenter" class="fixed inset-0 z-50 bg-slate-950/70 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl space-y-5 animate-scale-in max-h-[90vh] overflow-y-auto">
          <!-- Modal Header -->
          <div class="flex items-start justify-between border-b border-slate-100 pb-3">
            <div class="space-y-1">
              <span class="px-2.5 py-0.5 rounded-full text-[10px] font-extrabold uppercase bg-emerald-100 text-emerald-800">
                ✓ Cư Dân Đã Xác Thực
              </span>
              <h2 class="text-2xl font-black text-slate-900">👤 {{ selectedDetailRenter.full_name }}</h2>
              <p class="text-xs text-slate-500 font-medium">Hồ sơ khách thuê đăng ký thường trú</p>
            </div>
            <button @click="showDetailModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center">✕</button>
          </div>

          <!-- Identification Card Box -->
          <div class="bg-gradient-to-r from-slate-900 to-indigo-950 text-white p-4 rounded-2xl space-y-1 shadow-lg">
            <span class="text-[10px] uppercase font-bold text-indigo-300 tracking-wider block">Số Căn Cước Công Dân (CCCD/CMND)</span>
            <div class="text-2xl font-black font-mono tracking-widest text-white">{{ selectedDetailRenter.id_card_number || 'Chưa cập nhật' }}</div>
          </div>

          <!-- Personal Info Grid -->
          <div class="space-y-2 text-xs">
            <h3 class="font-extrabold text-slate-700 uppercase text-[10px] tracking-wider">📞 Thông Tin Liên Hệ</h3>
            
            <div class="bg-slate-50 p-3.5 rounded-2xl border border-slate-200 space-y-2 font-medium">
              <div class="flex items-center justify-between">
                <span class="text-slate-500">Số điện thoại:</span>
                <a :href="'tel:' + selectedDetailRenter.phone" class="font-mono font-bold text-indigo-600 hover:underline">
                  📱 {{ selectedDetailRenter.phone || 'N/A' }}
                </a>
              </div>
              <div class="flex items-center justify-between border-t border-slate-100 pt-2">
                <span class="text-slate-500">Email:</span>
                <span class="font-bold text-slate-800">{{ selectedDetailRenter.email || 'Chưa có' }}</span>
              </div>
              <div class="flex items-center justify-between border-t border-slate-100 pt-2">
                <span class="text-slate-500">Quê quán:</span>
                <span class="font-bold text-slate-800">🏡 {{ selectedDetailRenter.hometown || 'Chưa cập nhật' }}</span>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex items-center justify-between border-t border-slate-100 pt-4">
            <button
              @click="openModal(selectedDetailRenter); showDetailModal = false"
              class="px-4 py-2 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 font-bold text-xs rounded-xl transition flex items-center gap-1.5"
            >
              <span>⚙️</span> <span>Sửa Hồ Sơ</span>
            </button>
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
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const renters = ref([])
const loading = ref(false)
const submitting = ref(false)
const showModal = ref(false)
const editingRenter = ref(null)
const searchQuery = ref('')

const showDetailModal = ref(false)
const selectedDetailRenter = ref(null)

const openDetailModal = (r) => {
  selectedDetailRenter.value = r
  showDetailModal.value = true
}

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
