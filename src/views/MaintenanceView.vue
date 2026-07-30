<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Sự Cố & Bảo Trì</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Sự Cố & Bảo Trì Chi Tiết</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tiếp nhận báo hỏng hóc, phân công thợ sửa chữa, phân bổ chi phí (Chủ nhà / Khách trả) và liên kết hóa đơn</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="showModal = true"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>🔧</span>
            <span>Báo Sự Cố Mới</span>
          </button>
        </div>
      </div>

      <!-- Summary Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Số Sự Cố</span>
            <span>🔧</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ requests.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Tất cả yêu cầu bảo trì</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-amber-600 flex items-center justify-between">
            <span>Đang Chờ Xử Lý</span>
            <span>⏳</span>
          </div>
          <p class="text-2xl font-black text-amber-600 mt-2 font-mono">{{ pendingCount }}</p>
          <p class="text-[11px] text-amber-600 font-semibold mt-1">Cần kỹ thuật / thợ sửa</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Chủ Nhà Chi Phí</span>
            <span>🏠</span>
          </div>
          <p class="text-2xl font-black text-rose-600 mt-2 font-mono">{{ formatCurrency(ownerCost) }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Trừ vào Lợi nhuận ròng</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-indigo-600 flex items-center justify-between">
            <span>Khách Thuê Trả</span>
            <span>👤</span>
          </div>
          <p class="text-2xl font-black text-indigo-600 mt-2 font-mono">{{ formatCurrency(renterCost) }}</p>
          <p class="text-[11px] text-indigo-600 font-medium mt-1">Tự động cộng vào Hóa đơn</p>
        </div>
      </div>

      <!-- Maintenance List -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-bold text-slate-900 text-base">Danh Sách Yêu Cầu Sửa Chữa</div>
          <div class="flex items-center gap-3">
            <select v-model="filterStatus" @change="loadData" class="px-3 py-1.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả trạng thái</option>
              <option value="pending">Chờ xử lý</option>
              <option value="in_progress">Đang sửa</option>
              <option value="resolved">Đã hoàn thành</option>
            </select>
            <select v-model="filterPriority" @change="loadData" class="px-3 py-1.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả mức ưu tiên</option>
              <option value="urgent">Khẩn cấp</option>
              <option value="high">Cao</option>
              <option value="medium">Trung bình</option>
              <option value="low">Thấp</option>
            </select>
            <button @click="loadData" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200" title="Tải lại">🔄</button>
          </div>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải danh sách sự cố...</div>

        <div v-else-if="requests.length === 0" class="p-12 text-center text-slate-500">Chưa có sự cố nào cần xử lý.</div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Tên sự cố / Tiêu đề</th>
                <th class="px-6 py-4">Phòng</th>
                <th class="px-6 py-4">Thợ / Đơn vị sửa</th>
                <th class="px-6 py-4">Bên trả chi phí</th>
                <th class="px-6 py-4">Độ ưu tiên</th>
                <th class="px-6 py-4">Trạng thái</th>
                <th class="px-6 py-4">Chi phí (VNĐ)</th>
                <th class="px-6 py-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="req in requests" :key="req.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">
                  {{ req.title }}
                  <span v-if="req.description" class="block text-xs font-normal text-slate-400 mt-0.5">{{ req.description }}</span>
                </td>
                <td class="px-6 py-4 font-bold text-slate-800">Phòng {{ req.room_number }}</td>
                <td class="px-6 py-4 text-xs font-medium text-slate-700">
                  <div v-if="req.handyman_name" class="font-semibold text-indigo-900">
                    👨‍🔧 {{ req.handyman_name }}
                    <span v-if="req.handyman_phone" class="block font-mono text-[11px] text-slate-400">📞 {{ req.handyman_phone }}</span>
                  </div>
                  <span v-else class="text-slate-400 italic">Chưa phân công</span>
                </td>
                <td class="px-6 py-4">
                  <span v-if="req.cost_bearer === 'renter'" class="px-2.5 py-1 rounded-full text-xs font-bold bg-purple-100 text-purple-800 border border-purple-200">
                    👤 Khách thuê trả
                  </span>
                  <span v-else class="px-2.5 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700 border border-slate-200">
                    🏠 Chủ nhà chịu
                  </span>
                </td>
                <td class="px-6 py-4">
                  <span :class="['px-2 py-0.5 rounded-full text-xs font-bold uppercase', getPriorityBadge(req.priority)]">
                    {{ req.priority }}
                  </span>
                </td>
                <td class="px-6 py-4">
                  <span :class="['px-2.5 py-1 rounded-full text-xs font-bold uppercase', getStatusBadge(req.status)]">
                    {{ getStatusLabel(req.status) }}
                  </span>
                </td>
                <td class="px-6 py-4 font-mono font-bold text-rose-600">
                  {{ formatCurrency(req.cost) }}
                </td>
                <td class="px-6 py-4 text-right flex items-center justify-end gap-2">
                  <button
                    v-if="req.status !== 'resolved' && req.status !== 2"
                    @click="openResolveModal(req)"
                    class="text-xs font-semibold text-emerald-700 bg-emerald-50 hover:bg-emerald-100 px-2.5 py-1 rounded-lg border border-emerald-200"
                  >
                    Đánh dấu đã xong
                  </button>
                  <button @click="deleteRequest(req.id)" class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2 py-1 rounded-lg">
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add Maintenance Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Báo Sự Cố Mới</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="createRequest" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tiêu đề sự cố</label>
              <input v-model="form.title" required type="text" placeholder="Hỏng điều hòa không lạnh, Nghẹt bồn cầu..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500" />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn phòng trọ</label>
                <select v-model="form.room_id" required class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white">
                  <option value="" disabled>-- Chọn phòng --</option>
                  <option v-for="r in rooms" :key="r.id" :value="r.id">Phòng {{ r.room_number }}</option>
                </select>
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Mức ưu tiên</label>
                <select v-model="form.priority" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white">
                  <option value="low">Thấp</option>
                  <option value="medium">Trung bình</option>
                  <option value="high">Cao</option>
                  <option value="urgent">Khẩn cấp</option>
                </select>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Bên chịu chi phí</label>
                <select v-model="form.cost_bearer" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-bold text-indigo-900 focus:bg-white">
                  <option value="owner">🏠 Chủ nhà chịu chi phí</option>
                  <option value="renter">👤 Khách thuê trả (Cộng hóa đơn)</option>
                </select>
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Thợ / Đơn vị sửa</label>
                <input v-model="form.handyman_name" type="text" placeholder="Tên thợ sửa..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
              </div>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Mô tả chi tiết</label>
              <textarea v-model="form.description" rows="2" placeholder="Ghi rõ hiện trạng hư hỏng..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"></textarea>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Gửi báo sự cố' }}
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

const requests = ref([])
const rooms = ref([])
const loading = ref(false)
const submitting = ref(false)
const showModal = ref(false)
const filterStatus = ref('')
const filterPriority = ref('')

const form = ref({
  title: '',
  room_id: '',
  priority: 'medium',
  description: '',
  cost_bearer: 'owner',
  handyman_name: ''
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const pendingCount = computed(() => {
  return requests.value.filter(r => r.status === 'pending' || r.status === 'in_progress' || r.status === 0 || r.status === 1).length
})

const ownerCost = computed(() => {
  return requests.value.filter(r => r.cost_bearer === 'owner' || !r.cost_bearer).reduce((acc, curr) => acc + Number(curr.cost || 0), 0)
})

const renterCost = computed(() => {
  return requests.value.filter(r => r.cost_bearer === 'renter').reduce((acc, curr) => acc + Number(curr.cost || 0), 0)
})

const getPriorityBadge = (p) => {
  if (p === 'urgent' || p === 3) return 'bg-rose-100 text-rose-800'
  if (p === 'high' || p === 2) return 'bg-amber-100 text-amber-800'
  return 'bg-slate-100 text-slate-700'
}

const getStatusBadge = (s) => {
  if (s === 'resolved' || s === 2) return 'bg-emerald-100 text-emerald-800'
  if (s === 'in_progress' || s === 1) return 'bg-blue-100 text-blue-800'
  return 'bg-amber-100 text-amber-800'
}

const getStatusLabel = (s) => {
  if (s === 'resolved' || s === 2) return 'Đã Hoàn Thành'
  if (s === 'in_progress' || s === 1) return 'Đang Sửa'
  return 'Chờ Xử Lý'
}

const loadData = async () => {
  loading.value = true
  try {
    const params = {}
    if (filterStatus.value) params.status = filterStatus.value
    if (filterPriority.value) params.priority = filterPriority.value

    const [resReqs, resRooms] = await Promise.all([
      api.get('/maintenance_requests', { params }),
      api.get('/rooms')
    ])
    requests.value = resReqs?.data || []
    rooms.value = resRooms?.data || []
  } catch (err) {
    console.warn('Error loading maintenance data:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadData)

const createRequest = async () => {
  submitting.value = true
  try {
    await api.post('/maintenance_requests', { maintenance_request: form.value })
    showModal.value = false
    form.value = { title: '', room_id: '', priority: 'medium', description: '', cost_bearer: 'owner', handyman_name: '' }
    loadData()
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra')
  } finally {
    submitting.value = false
  }
}

const openResolveModal = async (req) => {
  const cost = prompt('Nhập chi phí sửa chữa vật tư (VNĐ):', req.cost || '150000')
  if (cost === null) return
  try {
    await api.put(`/maintenance_requests/${req.id}`, {
      maintenance_request: { status: 'resolved', cost: Number(cost) }
    })
    loadData()
  } catch (err) {
    alert(err?.message || 'Không thể cập nhật sự cố')
  }
}

const deleteRequest = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa yêu cầu sự cố này?')) return
  try {
    await api.delete(`/maintenance_requests/${id}`)
    loadData()
  } catch (err) {
    alert(err?.message || 'Lỗi xóa sự cố')
  }
}
</script>
