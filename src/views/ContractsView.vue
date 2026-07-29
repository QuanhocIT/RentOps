<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Quản Lý Hợp Đồng Thuê</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lập hợp đồng mới, lưu tiền cọc và thanh lý hợp đồng khi khách trả phòng</p>
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-[380px_1fr]">
        <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4 h-fit" @submit.prevent="createContract">
          <h3 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-3">Tạo Hợp Đồng Thuê Mới</h3>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Mã Hợp Đồng</label>
            <input v-model="form.contract_code" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="CTR-202607-101" />
          </div>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn Phòng Thuê</label>
            <select v-model="form.room_id" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="" disabled>-- Chọn phòng --</option>
              <option v-for="r in rooms" :key="r.id" :value="r.id">
                Phòng {{ r.room_number }} ({{ formatCurrency(r.price) }})
              </option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ngày Bắt Đầu Thuê</label>
            <input v-model="form.start_date" type="date" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tiền Thuê (VNĐ)</label>
              <input v-model.number="form.monthly_rent" type="number" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="3500000" />
            </div>
            <div>
              <label class="block text-xs font-semibold text-amber-700 uppercase mb-1">Tiền Cọc (VNĐ)</label>
              <input v-model.number="form.deposit_amount" type="number" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="3500000" />
            </div>
          </div>

          <button class="w-full rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white py-3 font-semibold text-sm shadow-md shadow-indigo-600/30 transition" :disabled="loading">
            {{ loading ? 'Đang tạo...' : 'Ký hợp đồng mới' }}
          </button>
          <p v-if="message" :class="['text-xs rounded-xl px-4 py-2.5 font-medium', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
            {{ message }}
          </p>
        </form>

        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
            <h2 class="font-bold text-slate-900 text-lg">Danh Sách Hợp Đồng ({{ contracts.length }})</h2>
            <div class="flex items-center gap-3">
              <input v-model="searchQuery" class="w-64 rounded-xl border border-slate-300 px-3.5 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm mã hợp đồng hoặc phòng..." />
              <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200" @click="loadContracts">🔄</button>
            </div>
          </div>

          <div class="space-y-3">
            <div v-for="item in filteredContracts" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex justify-between items-center hover:bg-slate-50 transition">
              <div>
                <div class="font-mono font-bold text-indigo-600 text-base">📄 {{ item.contract_code }}</div>
                <div class="text-xs text-slate-500 mt-0.5">Phòng {{ item.room_number || item.room_id }} | Tiền cọc: <span class="font-bold text-emerald-600 font-mono">{{ formatCurrency(item.deposit_amount) }}</span> | Trạng thái: <span class="font-bold text-slate-700 uppercase">{{ item.status }}</span></div>
              </div>
              <div class="flex items-center gap-2">
                <button
                  v-if="item.status === 'active' || item.status === 1"
                  class="text-xs font-semibold text-rose-700 bg-rose-50 hover:bg-rose-100 px-3 py-1.5 rounded-lg border border-rose-200"
                  @click="openCheckoutModal(item)"
                >
                  Thanh lý & Hoàn cọc
                </button>
                <button class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1.5 rounded-lg" @click="deleteContract(item.id)">
                  Xóa
                </button>
              </div>
            </div>
            <p v-if="!filteredContracts.length" class="text-sm text-slate-500 py-8 text-center">Chưa có hợp đồng nào phù hợp.</p>
          </div>
        </div>
      </div>

      <!-- Checkout Modal -->
      <CheckoutContractModal
        v-if="selectedCheckoutContract"
        :contract="selectedCheckoutContract"
        @close="selectedCheckoutContract = null"
        @success="loadContracts"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import CheckoutContractModal from '../components/CheckoutContractModal.vue'
import api from '../services/api'

const contracts = ref([])
const rooms = ref([])
const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const selectedCheckoutContract = ref(null)

const form = ref({
  contract_code: `CTR-${new Date().toISOString().slice(0, 7).replace('-', '')}-${Math.floor(100 + Math.random() * 900)}`,
  room_id: '',
  renter_id: 1,
  start_date: new Date().toISOString().slice(0, 10),
  monthly_rent: 3500000,
  deposit_amount: 3500000
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const loadContracts = async () => {
  try {
    const [resContracts, resRooms] = await Promise.all([
      api.get('/contracts'),
      api.get('/rooms')
    ])
    contracts.value = Array.isArray(resContracts.data) ? resContracts.data : []
    rooms.value = Array.isArray(resRooms.data) ? resRooms.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách hợp đồng.'
  }
}

const filteredContracts = computed(() =>
  contracts.value.filter((item) =>
    !searchQuery.value ||
    String(item.contract_code).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(item.room_number || item.room_id).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const createContract = async () => {
  if (!form.value.contract_code.trim() || !form.value.room_id || !form.value.start_date) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập mã hợp đồng, phòng và ngày bắt đầu.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/contracts', { contract: form.value })
    await loadContracts()
    messageType.value = 'success'
    message.value = 'Tạo hợp đồng thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo hợp đồng.'
  } finally {
    loading.value = false
  }
}

const openCheckoutModal = (item) => {
  selectedCheckoutContract.value = item
}

const deleteContract = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa hợp đồng này?')) return
  await api.delete(`/contracts/${id}`)
  await loadContracts()
}

onMounted(loadContracts)
</script>
