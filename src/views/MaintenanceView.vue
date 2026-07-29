<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Quản Lý Sự Cố & Bảo Trì</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tiếp nhận báo hỏng hóc, phân công sửa chữa và ghi nhận chi phí vật tư</p>
        </div>

        <button
          @click="showModal = true"
          class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
        >
          <span>🔧</span> Báo sự cố mới
        </button>
      </div>

      <!-- Maintenance List -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-bold text-slate-900 text-base">Danh Sách Yêu Cầu Sửa Chữa</div>
          <button @click="loadData" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200" title="Tải lại">🔄</button>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải danh sách sự cố...</div>

        <div v-else-if="requests.length === 0" class="p-12 text-center text-slate-500">Chưa có sự cố nào cần xử lý.</div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Tên sự cố / Tiêu đề</th>
                <th class="px-6 py-4">Phòng</th>
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
                    @click="markResolved(req)"
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
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const requests = ref([])
const rooms = ref([])
const loading = ref(false)
const submitting = ref(false)
const showModal = ref(false)

const form = ref({
  title: '',
  room_id: '',
  priority: 'medium',
  description: ''
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

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
    const [resReqs, resRooms] = await Promise.all([
      api.get('/maintenance_requests'),
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
    form.value = { title: '', room_id: '', priority: 'medium', description: '' }
    loadData()
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra')
  } finally {
    submitting.value = false
  }
}

const markResolved = async (req) => {
  const cost = prompt('Nhập chi phí sửa chữa vật tư (VNĐ):', '150000')
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
