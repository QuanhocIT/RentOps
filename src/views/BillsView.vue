<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Title & Actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Quản Lý Hóa Đơn & VietQR</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tạo hóa đơn tháng, tự động tính tiền phòng + điện nước và xuất mã VietQR thanh toán</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="exportCSV"
            class="inline-flex items-center gap-2 px-4 py-2.5 bg-emerald-700 hover:bg-emerald-800 text-white rounded-xl font-semibold text-sm shadow-md transition"
          >
            <span>📥</span> Xuất File CSV
          </button>
          <button
            @click="showCreateModal = true"
            class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
          >
            <span>✨</span> Sinh hóa đơn mới
          </button>
        </div>
      </div>

      <!-- Bills List Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-bold text-slate-900 text-base">Danh Sách Hóa Đơn Hàng Tháng</div>
          <div class="flex items-center gap-3">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Tìm theo mã hoặc tháng..."
              class="w-64 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button @click="loadBills" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200" title="Tải lại">
              🔄
            </button>
          </div>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">
          Đang tải danh sách hóa đơn...
        </div>

        <div v-else-if="filteredBills.length === 0" class="p-12 text-center text-slate-500">
          Chưa có hóa đơn nào phù hợp.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Mã Hóa Đơn</th>
                <th class="px-6 py-4">Phòng</th>
                <th class="px-6 py-4">Kỳ Tháng</th>
                <th class="px-6 py-4">Tiền Phòng</th>
                <th class="px-6 py-4">Điện Nước</th>
                <th class="px-6 py-4">Tổng Tiền</th>
                <th class="px-6 py-4">Trạng Thái</th>
                <th class="px-6 py-4 text-right">In A4 / VietQR / Nhắc Nợ</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="b in filteredBills" :key="b.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-mono font-bold text-indigo-600">
                  {{ b.bill_code }}
                </td>
                <td class="px-6 py-4 font-bold text-slate-900">
                  Phòng {{ b.room_number || b.room_id }}
                </td>
                <td class="px-6 py-4 text-slate-500">{{ b.billing_month }}</td>
                <td class="px-6 py-4 font-mono">{{ formatCurrency(b.room_fee || b.total_amount) }}</td>
                <td class="px-6 py-4 font-mono text-amber-600">{{ formatCurrency(b.utility_fee || 0) }}</td>
                <td class="px-6 py-4 font-mono font-bold text-slate-900 text-base">
                  {{ formatCurrency(b.total_amount) }}
                </td>
                <td class="px-6 py-4">
                  <span :class="['px-2.5 py-1 rounded-full text-xs font-bold uppercase', getStatusBadge(b.status)]">
                    {{ getStatusLabel(b.status) }}
                  </span>
                </td>
                <td class="px-6 py-4 text-right flex items-center justify-end gap-2">
                  <button
                    v-if="b.status !== 'paid' && b.status !== 3"
                    @click="sendDebtReminder(b.id)"
                    class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-amber-50 text-amber-800 font-semibold rounded-lg text-xs hover:bg-amber-100 border border-amber-200 transition"
                    title="Gửi tin nhắn ZNS nhắc nợ"
                  >
                    <span>📩</span> Nhắc nợ ZNS
                  </button>
                  <button
                    @click="selectedPrintBill = b"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-slate-100 text-slate-800 font-semibold rounded-lg text-xs hover:bg-slate-200 border border-slate-300 transition"
                  >
                    <span>🖨️</span> In A4
                  </button>
                  <button
                    @click="openQRModal(b)"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-indigo-50 text-indigo-700 font-semibold rounded-lg text-xs hover:bg-indigo-100 border border-indigo-200 transition"
                  >
                    <span>📱</span> VietQR
                  </button>
                  <button
                    @click="deleteBill(b.id)"
                    class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1.5 rounded-lg hover:bg-rose-100 transition"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Create Bill Modal -->
      <div v-if="showCreateModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Sinh Hóa Đơn Mới</h3>
            <button @click="showCreateModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="generateBill" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn phòng trọ</label>
              <select
                v-model="form.room_id"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              >
                <option value="" disabled>-- Chọn phòng --</option>
                <option v-for="room in rooms" :key="room.id" :value="room.id">
                  Phòng {{ room.room_number }} (Giá: {{ formatCurrency(room.price) }})
                </option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Kỳ tháng (YYYY-MM)</label>
              <input
                v-model="form.billing_month"
                type="month"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tiền phòng (VNĐ)</label>
                <input
                  v-model.number="form.room_fee"
                  type="number"
                  placeholder="Để trống tự lấy giá phòng"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-amber-700 uppercase mb-1">Tiền Điện Nước (VNĐ)</label>
                <input
                  v-model.number="form.utility_fee"
                  type="number"
                  placeholder="Ví dụ: 500000"
                  class="w-full px-3 py-2 bg-amber-50/50 border border-amber-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Phụ phí / Dịch vụ khác</label>
                <input
                  v-model.number="form.service_fee"
                  type="number"
                  placeholder="150000"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Hạn thanh toán</label>
                <input
                  v-model="form.due_date"
                  type="date"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="showCreateModal = false"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submitting"
                class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30"
              >
                {{ submitting ? 'Đang tạo...' : 'Sinh hóa đơn' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- VietQR Modal -->
      <div v-if="selectedQRBill" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl text-center space-y-5 relative">
          <button @click="selectedQRBill = null" class="absolute top-4 right-4 text-slate-400 hover:text-slate-700 text-lg font-bold">✕</button>

          <div>
            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 uppercase tracking-wider mb-2">
              Mã Thanh Toán VietQR
            </span>
            <h3 class="text-xl font-black text-slate-900">Hóa Đơn {{ selectedQRBill.bill_code }}</h3>
            <p class="text-sm text-slate-500 mt-0.5">Phòng {{ selectedQRBill.room_number }} - Kỳ tháng {{ selectedQRBill.billing_month }}</p>
          </div>

          <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 inline-block shadow-inner">
            <img
              :src="selectedQRBill.vietqr_url"
              alt="Mã VietQR"
              class="w-64 h-64 mx-auto object-contain rounded-xl"
            />
          </div>

          <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 text-left space-y-2 text-sm font-mono">
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Số tiền:</span>
              <strong class="text-lg text-emerald-600 font-black">{{ formatCurrency(selectedQRBill.total_amount) }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Ngân hàng:</span>
              <strong class="text-slate-900">MB (Nội Địa)</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Số tài khoản:</span>
              <strong class="text-indigo-600">0901234567</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Nội dung chuyển khoản:</span>
              <strong class="text-slate-900 bg-amber-100 px-2 py-0.5 rounded text-xs">{{ selectedQRBill.bill_code }}</strong>
            </div>
          </div>

          <button
            @click="selectedQRBill = null"
            class="w-full py-3 bg-slate-900 text-white rounded-xl font-bold text-sm hover:bg-slate-800 transition"
          >
            Đóng
          </button>
        </div>
      </div>

      <!-- Print Modal -->
      <PrintInvoiceModal
        v-if="selectedPrintBill"
        :bill="selectedPrintBill"
        @close="selectedPrintBill = null"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import PrintInvoiceModal from '../components/PrintInvoiceModal.vue'
import api from '../services/api'

const bills = ref([])
const rooms = ref([])
const loading = ref(false)
const submitting = ref(false)
const showCreateModal = ref(false)
const selectedQRBill = ref(null)
const selectedPrintBill = ref(null)
const searchQuery = ref('')

const form = ref({
  room_id: '',
  billing_month: new Date().toISOString().slice(0, 7),
  room_fee: null,
  utility_fee: null,
  service_fee: 150000,
  due_date: ''
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const getStatusBadge = (status) => {
  if (status === 'paid' || status === 3) return 'bg-emerald-100 text-emerald-800'
  if (status === 'partially_paid' || status === 2) return 'bg-amber-100 text-amber-800'
  if (status === 'overdue' || status === 4) return 'bg-rose-100 text-rose-800'
  return 'bg-blue-100 text-blue-800'
}

const getStatusLabel = (status) => {
  if (status === 'paid' || status === 3) return 'Đã Trả'
  if (status === 'partially_paid' || status === 2) return 'Trả 1 phần'
  if (status === 'overdue' || status === 4) return 'Quá Hạn'
  return 'Chưa Trả'
}

const loadBills = async () => {
  loading.value = true
  try {
    const [resBills, resRooms] = await Promise.all([
      api.get('/monthly_bills'),
      api.get('/rooms')
    ])
    bills.value = resBills?.data || []
    rooms.value = resRooms?.data || []
  } catch (err) {
    console.warn('Error loading bills:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadBills)

const filteredBills = computed(() => {
  return bills.value.filter(b => {
    if (!searchQuery.value) return true
    const q = searchQuery.value.toLowerCase()
    return String(b.bill_code).toLowerCase().includes(q) ||
           String(b.billing_month).toLowerCase().includes(q) ||
           String(b.room_number).toLowerCase().includes(q)
  })
})

const generateBill = async () => {
  submitting.value = true
  try {
    await api.post('/monthly_bills/generate', { monthly_bill: form.value })
    showCreateModal.value = false
    loadBills()
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra khi tạo hóa đơn')
  } finally {
    submitting.value = false
  }
}

const openQRModal = (bill) => {
  selectedQRBill.value = bill
}

const sendDebtReminder = async (billId) => {
  try {
    const res = await api.post('/notifications/send_reminder', { bill_id: billId, channel: 'zns' })
    alert(res?.message || 'Đã gửi tin nhắn nhắc nợ thành công!')
  } catch (err) {
    alert(err?.message || 'Gửi nhắc nợ thất bại')
  }
}

const exportCSV = () => {
  if (!bills.value.length) {
    alert('Không có dữ liệu hóa đơn để xuất file.')
    return
  }

  const headers = ['Mã Hóa Đơn', 'Phòng', 'Kỳ Tháng', 'Tiền Phòng', 'Điện Nước', 'Tổng Tiền', 'Trạng Thái']
  const rows = bills.value.map(b => [
    b.bill_code,
    `Phòng ${b.room_number || b.room_id}`,
    b.billing_month,
    b.room_fee || b.total_amount,
    b.utility_fee || 0,
    b.total_amount,
    getStatusLabel(b.status)
  ])

  const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers, ...rows].map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `HoaDon_RentOps_${new Date().toISOString().slice(0, 10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

const deleteBill = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa hóa đơn này?')) return
  try {
    await api.delete(`/monthly_bills/${id}`)
    loadBills()
  } catch (err) {
    alert(err?.message || 'Không thể xóa hóa đơn')
  }
}
</script>
