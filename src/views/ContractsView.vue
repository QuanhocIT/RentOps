<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white/90 backdrop-blur-md p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div>
          <h1 class="text-2xl font-black text-slate-900 tracking-tight flex items-center gap-2">
            <span>📑</span> Quản Lý Hợp Đồng Thuê
          </h1>
          <p class="text-slate-500 text-xs mt-1 font-medium">Lập hợp đồng mới, lưu tiền cọc, gia hạn và thanh lý hợp đồng khi khách trả phòng</p>
        </div>
      </div>

      <!-- Summary Stats & Warning -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs font-semibold text-slate-400 uppercase">Hợp Đồng Hoạt Động</div>
            <div class="text-2xl font-black text-slate-900 mt-1">{{ activeContractsCount }} Hợp đồng</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold text-xl">
            📝
          </div>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs font-semibold text-emerald-600 uppercase">Tổng Tiền Cọc Đang Giữ</div>
            <div class="text-2xl font-black text-emerald-700 mt-1">{{ formatCurrency(totalDepositHolding) }}</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-xl">
            🛡️
          </div>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-amber-200 shadow-sm flex items-center justify-between">
          <div>
            <div class="text-xs font-semibold text-amber-600 uppercase">Sắp Hết Hạn (&lt;30 Ngày)</div>
            <div class="text-2xl font-black text-amber-700 mt-1">{{ expiringCount }} Hợp đồng</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-xl">
            ⏰
          </div>
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-[380px_1fr]">
        <!-- Create Contract Form -->
        <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4 h-fit" @submit.prevent="createContract">
          <h3 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-3">Tạo Hợp Đồng Thuê Mới</h3>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Mã Hợp Đồng</label>
            <input v-model="form.contract_code" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="CTR-202607-101" />
          </div>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn Phòng Thuê</label>
            <select v-model="form.room_id" required @change="onRoomSelect" class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="" disabled>-- Chọn phòng --</option>
              <option v-for="r in rooms" :key="r.id" :value="r.id">
                Phòng {{ r.room_number }} (Giá: {{ formatCurrency(r.price) }})
              </option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Khách Thuê Đại Diện</label>
            <select v-model="form.renter_id" class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">-- Chọn khách thuê --</option>
              <option v-for="renter in renters" :key="renter.id" :value="renter.id">
                {{ renter.full_name }} ({{ renter.phone || 'Không SĐT' }})
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

        <!-- Contract List -->
        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 pb-3 border-b border-slate-100">
            <div class="flex items-center gap-2">
              <button
                @click="filterStatus = 'all'"
                :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition', filterStatus === 'all' ? 'bg-slate-900 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']"
              >
                Tất cả ({{ contracts.length }})
              </button>
              <button
                @click="filterStatus = 'expiring'"
                :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition', filterStatus === 'expiring' ? 'bg-amber-600 text-white' : 'bg-amber-50 text-amber-800 hover:bg-amber-100']"
              >
                ⏰ Sắp hết hạn ({{ expiringCount }})
              </button>
            </div>

            <div class="flex items-center gap-3">
              <input v-model="searchQuery" class="w-64 rounded-xl border border-slate-300 px-3.5 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm mã hợp đồng hoặc phòng..." />
              <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200" @click="loadContracts">🔄</button>
            </div>
          </div>

          <div class="space-y-3">
            <div
              v-for="item in filteredContracts"
              :key="item.id"
              :class="['rounded-xl border p-4 flex flex-col md:flex-row md:items-center justify-between gap-4 transition', item.is_expiring_soon ? 'border-amber-300 bg-amber-50/40' : 'border-slate-200 hover:bg-slate-50']"
            >
              <div>
                <div class="flex items-center gap-2">
                  <span class="font-mono font-bold text-indigo-600 text-base">📄 {{ item.contract_code }}</span>
                  <span v-if="item.is_expiring_soon" class="px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-amber-100 text-amber-800 border border-amber-300">
                    ⏰ Hết hạn trong {{ item.days_remaining }} ngày
                  </span>
                </div>
                <div class="text-xs text-slate-500 mt-1 space-x-2">
                  <span>Phòng {{ item.room_number || item.room_id }}</span>
                  <span>•</span>
                  <span>Khách: <strong class="text-slate-700">{{ item.renter_name || 'Khách thuê' }}</strong></span>
                  <span>•</span>
                  <span>Cọc: <strong class="text-emerald-600 font-mono">{{ formatCurrency(item.deposit_amount) }}</strong></span>
                  <span>•</span>
                  <span>Trạng thái: <strong class="text-slate-700 uppercase">{{ item.status }}</strong></span>
                </div>
              </div>

              <div class="flex flex-wrap items-center gap-2">
                <button
                  @click="selectedPrintContract = item"
                  class="text-xs font-semibold text-slate-800 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-lg border border-slate-300 transition"
                >
                  🖨️ In A4
                </button>
                <button
                  v-if="item.status === 'active' || item.status === 1"
                  @click="renewContract(item)"
                  class="text-xs font-semibold text-indigo-700 bg-indigo-50 hover:bg-indigo-100 px-3 py-1.5 rounded-lg border border-indigo-200 transition"
                >
                  🔄 Gia Hạn
                </button>
                <button
                  v-if="item.status === 'active' || item.status === 1"
                  class="text-xs font-semibold text-rose-700 bg-rose-50 hover:bg-rose-100 px-3 py-1.5 rounded-lg border border-rose-200 transition"
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

      <!-- Print Contract Modal -->
      <PrintContractModal
        v-if="selectedPrintContract"
        :contract="selectedPrintContract"
        @close="selectedPrintContract = null"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import CheckoutContractModal from '../components/CheckoutContractModal.vue'
import PrintContractModal from '../components/PrintContractModal.vue'
import api from '../services/api'

const contracts = ref([])
const rooms = ref([])
const renters = ref([])
const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const filterStatus = ref('all')

const selectedCheckoutContract = ref(null)
const selectedPrintContract = ref(null)

const form = ref({
  contract_code: `CTR-${new Date().toISOString().slice(0, 7).replace('-', '')}-${Math.floor(100 + Math.random() * 900)}`,
  room_id: '',
  renter_id: '',
  start_date: new Date().toISOString().slice(0, 10),
  monthly_rent: 3500000,
  deposit_amount: 3500000
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const activeContractsCount = computed(() => contracts.value.filter(c => c.status === 'active' || c.status === 1).length)
const totalDepositHolding = computed(() => contracts.value.filter(c => c.status === 'active' || c.status === 1).reduce((acc, c) => acc + Number(c.deposit_amount || 0), 0))
const expiringCount = computed(() => contracts.value.filter(c => c.is_expiring_soon).length)

const onRoomSelect = () => {
  const room = rooms.value.find(r => r.id === form.value.room_id)
  if (room && room.price) {
    form.value.monthly_rent = Number(room.price)
    form.value.deposit_amount = Number(room.price)
  }
}

const loadContracts = async () => {
  try {
    const [resContracts, resRooms, resRenters] = await Promise.all([
      api.get('/contracts'),
      api.get('/rooms'),
      api.get('/renters')
    ])
    contracts.value = Array.isArray(resContracts.data) ? resContracts.data : []
    rooms.value = Array.isArray(resRooms.data) ? resRooms.data : []
    renters.value = Array.isArray(resRenters.data) ? resRenters.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách hợp đồng.'
  }
}

const filteredContracts = computed(() =>
  contracts.value.filter((item) => {
    if (filterStatus.value === 'expiring' && !item.is_expiring_soon) return false

    if (!searchQuery.value) return true
    const q = searchQuery.value.toLowerCase()
    return String(item.contract_code).toLowerCase().includes(q) ||
           String(item.room_number || item.room_id).toLowerCase().includes(q) ||
           String(item.renter_name || '').toLowerCase().includes(q)
  })
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

const renewContract = async (item) => {
  const monthsStr = prompt('Nhập số tháng muốn gia hạn hợp đồng (ví dụ: 6 hoặc 12):', '6')
  if (!monthsStr) return
  const months = parseInt(monthsStr, 10)
  if (isNaN(months) || months <= 0) {
    alert('Số tháng gia hạn không hợp lệ')
    return
  }

  try {
    const res = await api.post(`/contracts/${item.id}/renew`, { months })
    alert(res?.message || 'Gia hạn hợp đồng thành công!')
    loadContracts()
  } catch (err) {
    alert(err?.message || 'Gia hạn hợp đồng thất bại')
  }
}

const deleteContract = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa hợp đồng này?')) return
  await api.delete(`/contracts/${id}`)
  await loadContracts()
}

onMounted(loadContracts)
</script>
