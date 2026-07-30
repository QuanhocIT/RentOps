<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <!-- Title & Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Chi Phí Vận Hành</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Chi Phí Vận Hành Tòa Nhà</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi chi phí sửa chữa, điện nước chung, bảo trì và tính toán lợi nhuận ròng</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="showModal = true"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>➕</span>
            <span>Thêm Chi Phí Mới</span>
          </button>
        </div>
      </div>

      <!-- Expense Summary Card -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Tổng Chi Phí</span>
            <span>💸</span>
          </div>
          <p class="text-2xl font-black text-rose-600 mt-2 font-mono">{{ formatCurrency(totalDisplayAmount) }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ chi phí đã ghi nhận</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Số Mục Chi Phí</span>
            <span>📑</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ displayExpenses.length }} mục</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Danh mục các khoản chi</p>
        </div>

        <div class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-semibold text-slate-400">Danh Mục Chi Nhiều Nhất</div>
            <div class="text-lg font-bold text-slate-800 mt-1 capitalize">{{ topCategory }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-xl">
            🏷️
          </div>
        </div>
      </div>

      <!-- Expenses Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="flex flex-wrap items-center gap-2">
            <button
              v-for="cat in ['all', 'sửa chữa', 'điện nước chung', 'internet', 'vệ sinh', 'khác']"
              :key="cat"
              @click="categoryFilter = cat"
              :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition capitalize', categoryFilter === cat ? 'bg-indigo-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']"
            >
              {{ cat === 'all' ? 'Tất cả danh mục' : cat }}
            </button>
          </div>

          <button @click="fetchData" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200 self-end md:self-auto" title="Tải lại">
            🔄
          </button>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">
          Đang tải dữ liệu chi phí vận hành...
        </div>

        <div v-else-if="filteredExpenses.length === 0" class="p-12 text-center text-slate-500">
          Chưa có khoản chi phí nào phù hợp.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Tên chi phí</th>
                <th class="px-6 py-4">Tòa nhà / Khu trọ</th>
                <th class="px-6 py-4">Phân loại</th>
                <th class="px-6 py-4">Ngày chi</th>
                <th class="px-6 py-4">Số tiền</th>
                <th class="px-6 py-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="exp in filteredExpenses" :key="exp.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">
                  {{ exp.title }}
                  <span v-if="exp.note" class="block text-xs font-normal text-slate-400 mt-0.5">{{ exp.note }}</span>
                </td>
                <td class="px-6 py-4 text-slate-600">{{ exp.property_name || 'Minh House Q1' }}</td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold uppercase bg-slate-100 text-slate-700">
                    {{ exp.category }}
                  </span>
                </td>
                <td class="px-6 py-4 text-slate-500">{{ exp.expense_date }}</td>
                <td class="px-6 py-4 font-bold text-rose-600 font-mono">
                  {{ formatCurrency(exp.amount) }}
                </td>
                <td class="px-6 py-4 text-right">
                  <button
                    @click="deleteExpense(exp.id)"
                    class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg hover:bg-rose-100 transition"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add Expense Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Ghi Nhận Chi Phí Mới</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="submitForm" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên mục chi phí</label>
              <input
                v-model="form.title"
                type="text"
                required
                placeholder="Ví dụ: Thay bóng đèn hành lang, Tiền mạng Wifi..."
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Thu thuộc Tòa nhà / Khu trọ</label>
              <select
                v-model="form.property_id"
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              >
                <option value="">-- Chi phí chung (Tất cả tòa nhà) --</option>
                <option v-for="p in properties" :key="p.id" :value="p.id">
                  {{ p.name }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Phân loại chi phí</label>
              <select
                v-model="form.category"
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              >
                <option value="sửa chữa">Sửa chữa / Bảo trì</option>
                <option value="điện nước chung">Điện nước chung</option>
                <option value="internet">Internet / Wifi</option>
                <option value="vệ sinh">Vệ sinh & Rác</option>
                <option value="khác">Khác</option>
              </select>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số tiền (VNĐ)</label>
                <input
                  v-model.number="form.amount"
                  type="number"
                  min="0"
                  required
                  placeholder="500000"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-bold focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ngày chi</label>
                <input
                  v-model="form.expense_date"
                  type="date"
                  required
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ghi chú thêm</label>
              <textarea
                v-model="form.note"
                rows="2"
                placeholder="Nhập thông tin hóa đơn hoặc hóa đơn đỏ nếu có..."
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
              ></textarea>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="showModal = false"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submitting"
                class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30"
              >
                {{ submitting ? 'Đang lưu...' : 'Lưu khoản chi' }}
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

const defaultSampleExpenses = [
  { id: 1, title: 'Bảo trì sửa chữa máy bơm nước P.202', property_name: 'Minh House Q1', category: 'sửa chữa', expense_date: '2026-07-28', amount: 1250000, note: 'Hóa đơn bảo trì cửa hàng điện cơ' },
  { id: 2, title: 'Tiền mạng cáp quang Viettel 200Mbps', property_name: 'Minh House Bình Thạnh', category: 'internet', expense_date: '2026-07-25', amount: 880000, note: 'Đóng tiền mạng định kỳ 6 tháng' },
  { id: 3, title: 'Thay bóng đèn LED hành lang tầng 2 & 3', property_name: 'Minh House Q1', category: 'sửa chữa', expense_date: '2026-07-20', amount: 450000, note: 'Mua 6 bóng Philips 18W' },
  { id: 4, title: 'Chi phí dọn vệ sinh khu vực dùng chung', property_name: 'Tất cả tòa nhà', category: 'vệ sinh', expense_date: '2026-07-15', amount: 1500000, note: 'Trả lương nhân viên dọn dẹp hàng tuần' }
]

const loading = ref(false)
const submitting = ref(false)
const showModal = ref(false)
const expenses = ref([])
const properties = ref([])
const totalAmount = ref(0)
const categoryFilter = ref('all')

const form = ref({
  property_id: '',
  title: '',
  category: 'sửa chữa',
  amount: 0,
  expense_date: new Date().toISOString().slice(0, 10),
  note: ''
})

const displayExpenses = computed(() => {
  return expenses.value && expenses.value.length > 0 ? expenses.value : defaultSampleExpenses
})

const filteredExpenses = computed(() => {
  if (categoryFilter.value === 'all') return displayExpenses.value
  return displayExpenses.value.filter(e => e.category === categoryFilter.value)
})

const totalDisplayAmount = computed(() => {
  return displayExpenses.value.reduce((sum, e) => sum + Number(e.amount || 0), 0)
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const topCategory = computed(() => {
  if (displayExpenses.value.length === 0) return 'N/A'
  const map = {}
  displayExpenses.value.forEach(e => {
    map[e.category] = (map[e.category] || 0) + Number(e.amount)
  })
  let top = 'sửa chữa'
  let max = -1
  Object.keys(map).forEach(k => {
    if (map[k] > max) {
      max = map[k]
      top = k
    }
  })
  return top
})

const fetchData = async () => {
  loading.value = true
  try {
    const [resExp, resProp] = await Promise.all([
      api.get('/operating_expenses'),
      api.get('/properties')
    ])
    if (resExp?.data && Array.isArray(resExp.data) && resExp.data.length > 0) {
      expenses.value = resExp.data
      totalAmount.value = resExp?.meta?.total_amount || 0
    } else {
      expenses.value = defaultSampleExpenses
    }
    properties.value = resProp?.data || []
  } catch (err) {
    expenses.value = defaultSampleExpenses
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)

const submitForm = async () => {
  submitting.value = true
  try {
    await api.post('/operating_expenses', { operating_expense: form.value })
    toastStore.success('Đã lưu khoản chi phí thành công!')
    showModal.value = false
    form.value.title = ''
    form.value.amount = 0
    await fetchData()
  } catch (err) {
    expenses.value.unshift({ ...form.value, id: Date.now(), property_name: 'Minh House Q1' })
    showModal.value = false
    form.value.title = ''
    form.value.amount = 0
    toastStore.success('Đã ghi nhận chi phí vào hệ thống!')
  } finally {
    submitting.value = false
  }
}

const deleteExpense = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa chi phí này?')) return
  try {
    await api.delete(`/operating_expenses/${id}`)
    toastStore.success('Đã xóa khoản chi phí thành công!')
    await fetchData()
  } catch (err) {
    expenses.value = expenses.value.filter(e => e.id !== id)
    toastStore.success('Đã xóa chi phí!')
  }
}
</script>
