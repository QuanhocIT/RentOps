<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Hợp Đồng Thuê</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Hợp Đồng Thuê Phòng</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lập hợp đồng mới, lưu tiền cọc, gia hạn và thanh lý hợp đồng khi khách trả phòng</p>
        </div>
      </div>

      <!-- Summary Stats & Warning -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Hợp Đồng Hoạt Động</span>
            <span>📝</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ activeContractsCount }} Hợp đồng</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Đang có hiệu lực</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Tổng Tiền Cọc Đang Giữ</span>
            <span>🛡️</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ formatCurrency(totalDepositHolding) }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Bảo đảm hợp đồng</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-amber-600 flex items-center justify-between">
            <span>Sắp Hết Hạn (&lt;30 Ngày)</span>
            <span>⏰</span>
          </div>
          <p class="text-2xl font-black text-amber-700 mt-2 font-mono">{{ expiringCount }} Hợp đồng</p>
          <p class="text-[11px] text-amber-600 font-semibold mt-1">Cần gia hạn sớm</p>
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
                  <span>Trạng thái: <strong class="text-slate-700 uppercase">{{ getContractStatusLabel(item.status) }}</strong></span>
                </div>
              </div>

              <div class="flex flex-wrap items-center gap-2">
                <button
                  @click="selectedCoTenantContract = item"
                  class="text-xs font-semibold text-purple-700 bg-purple-50 hover:bg-purple-100 px-3 py-1.5 rounded-lg border border-purple-200 transition"
                  title="Quản lý thành viên ở ghép"
                >
                  👥 Ở cùng ({{ item.co_tenants_count || 0 }})
                </button>
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

      <!-- CoTenants Modal -->
      <CoTenantsModal
        v-if="selectedCoTenantContract"
        :contract="selectedCoTenantContract"
        @close="selectedCoTenantContract = null"
        @updated="loadContracts"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import CheckoutContractModal from '../components/CheckoutContractModal.vue'
import PrintContractModal from '../components/PrintContractModal.vue'
import CoTenantsModal from '../components/CoTenantsModal.vue'
import { useDataStore } from '../stores/data'
import { useToastStore } from '../stores/toast'

const dataStore = useDataStore()
const toast = useToastStore()

const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const filterStatus = ref('all')

const selectedCheckoutContract = ref(null)

const loadContracts = () => {
  toast.success('Đã tải lại danh sách hợp đồng thuê!')
}
const selectedPrintContract = ref(null)
const selectedCoTenantContract = ref(null)

const form = ref({
  contract_code: `HD-2026-${Math.floor(100 + Math.random() * 900)}`,
  room_id: '',
  renter_id: '',
  start_date: new Date().toISOString().slice(0, 10),
  monthly_rent: 5500000,
  deposit_amount: 5500000
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const rooms = computed(() => dataStore.rooms)
const renters = computed(() => dataStore.renters)

const contracts = computed(() => {
  const now = new Date()
  return dataStore.contracts.map(c => {
    const endDate = new Date(c.endDate)
    const msRemaining = endDate - now
    const daysRemaining = Math.ceil(msRemaining / (24 * 60 * 60 * 1000))
    const isExpiringSoon = c.status === 'active' && daysRemaining >= 0 && daysRemaining <= 30
    return {
      ...c,
      contract_code: c.contractNumber,
      room_number: c.roomNumber,
      renter_name: c.renterName,
      monthly_rent: c.price,
      deposit_amount: c.deposit,
      start_date: c.startDate,
      end_date: c.endDate,
      co_tenants_count: dataStore.renters.find(r => r.id === c.renterId)?.coTenants?.length || 0,
      is_expiring_soon: isExpiringSoon,
      days_remaining: daysRemaining
    }
  })
})

const activeContractsCount = computed(() => contracts.value.filter(c => c.status === 'active').length)
const totalDepositHolding = computed(() => contracts.value.filter(c => c.status === 'active').reduce((acc, c) => acc + Number(c.deposit_amount || 0), 0))
const expiringCount = computed(() => contracts.value.filter(c => c.is_expiring_soon).length)

const onRoomSelect = () => {
  const room = rooms.value.find(r => r.id === Number(form.value.room_id))
  if (room && room.price) {
    form.value.monthly_rent = Number(room.price)
    form.value.deposit_amount = Number(room.price)
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

const createContract = () => {
  if (!form.value.room_id || !form.value.start_date || !form.value.renter_id) {
    toast.warning('Vui lòng chọn phòng, người thuê và ngày bắt đầu hợp đồng.')
    return
  }

  loading.value = true
  try {
    const end = new Date(form.value.start_date)
    end.setFullYear(end.getFullYear() + 1)

    dataStore.addContract({
      roomId: Number(form.value.room_id),
      renterId: Number(form.value.renter_id),
      startDate: form.value.start_date,
      endDate: end.toISOString().slice(0, 10),
      price: Number(form.value.monthly_rent),
      deposit: Number(form.value.deposit_amount),
      eSigned: true
    })

    toast.success('Tạo hợp đồng thuê mới thành công!')
    form.value.contract_code = `HD-2026-${Math.floor(100 + Math.random() * 900)}`
  } finally {
    loading.value = false
  }
}

const openCheckoutModal = (item) => {
  selectedCheckoutContract.value = item
}

const renewContract = (item) => {
  const monthsStr = prompt('Nhập số tháng muốn gia hạn hợp đồng (ví dụ: 6 hoặc 12):', '6')
  if (!monthsStr) return
  const months = parseInt(monthsStr, 10)
  if (isNaN(months) || months <= 0) {
    toast.warning('Số tháng gia hạn không hợp lệ')
    return
  }

  const currEnd = new Date(item.end_date || item.endDate)
  currEnd.setMonth(currEnd.getMonth() + months)
  const newEndDate = currEnd.toISOString().slice(0, 10)

  dataStore.updateContract(item.id, { endDate: newEndDate, status: 'active' })
  toast.success(`Đã gia hạn hợp đồng ${item.contract_code} thêm ${months} tháng đến ${newEndDate}!`)
}

const getContractStatusLabel = (status) => {
  if (status === 'active' || status === 1) return 'Đang hiệu lực'
  if (status === 'terminated') return 'Đã thanh lý'
  if (status === 'expired') return 'Hết hạn'
  if (status === 'pending') return 'Chờ ký'
  return status || 'Không rõ'
}

const deleteContract = (id) => {
  if (!confirm('Bạn có chắc muốn hủy/xóa hợp đồng này?')) return
  dataStore.terminateContract(id, 'Chủ trọ xóa hợp đồng')
  toast.success('Đã thanh lý và chuyển hợp đồng sang trạng thái kết thúc!')
}
</script>
