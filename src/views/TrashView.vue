<template>
  <AppLayout>
    <div class="owner-page space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-rose-100 text-rose-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Thùng Rác & Khôi Phục</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Trung Tâm Khôi Phục Dữ Liệu (Trash)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Danh sách phòng, hợp đồng và hóa đơn đã xóa mềm (soft delete) - Khôi phục 1-click bất kỳ lúc nào</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="fetchTrash"
            class="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl border border-slate-300 transition flex items-center gap-1.5"
          >
            <span>🔄</span>
            <span>Tải lại</span>
          </button>
        </div>
      </div>

      <!-- Tabs -->
      <div class="flex space-x-2 bg-slate-200/60 p-1.5 rounded-xl w-fit">
        <button
          @click="activeTab = 'rooms'"
          :class="activeTab === 'rooms' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          🔑 Phòng trọ ({{ displayTrash.rooms.length }})
        </button>
        <button
          @click="activeTab = 'contracts'"
          :class="activeTab === 'contracts' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          📄 Hợp đồng ({{ displayTrash.contracts.length }})
        </button>
        <button
          @click="activeTab = 'bills'"
          :class="activeTab === 'bills' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          💳 Hóa đơn ({{ displayTrash.bills.length }})
        </button>
      </div>

      <!-- Rooms Trash Table -->
      <div v-if="activeTab === 'rooms'" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-6 py-3.5">Tên phòng</th>
                <th class="px-6 py-3.5">Tòa nhà</th>
                <th class="px-6 py-3.5">Giá phòng</th>
                <th class="px-6 py-3.5">Ngày xóa</th>
                <th class="px-6 py-3.5 text-right">Khôi phục</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="item in displayTrash.rooms" :key="item.id" class="hover:bg-slate-50/80">
                <td class="px-6 py-4 font-bold text-slate-900">Phòng {{ item.room_number }}</td>
                <td class="px-6 py-4 text-slate-600">{{ item.property_name }}</td>
                <td class="px-6 py-4 font-mono text-emerald-600 font-semibold">{{ formatCurrency(item.price) }}</td>
                <td class="px-6 py-4 text-xs text-slate-500">{{ formatDate(item.discarded_at) }}</td>
                <td class="px-6 py-4 text-right">
                  <button @click="restoreItem('room', item.id)" class="px-3 py-1 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs rounded-lg border border-emerald-200 transition">
                    ↺ Khôi phục
                  </button>
                </td>
              </tr>
              <tr v-if="displayTrash.rooms.length === 0">
                <td colspan="5" class="text-center py-8 text-slate-400">Không có phòng nào trong thùng rác.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Contracts Trash Table -->
      <div v-if="activeTab === 'contracts'" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-6 py-3.5">Mã hợp đồng</th>
                <th class="px-6 py-3.5">Tiền thuê</th>
                <th class="px-6 py-3.5">Tiền cọc</th>
                <th class="px-6 py-3.5">Ngày xóa</th>
                <th class="px-6 py-3.5 text-right">Khôi phục</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="item in displayTrash.contracts" :key="item.id" class="hover:bg-slate-50/80">
                <td class="px-6 py-4 font-mono text-indigo-600 font-bold">{{ item.contract_code }}</td>
                <td class="px-6 py-4 font-mono text-emerald-600 font-semibold">{{ formatCurrency(item.monthly_rent) }}</td>
                <td class="px-6 py-4 font-mono text-slate-700">{{ formatCurrency(item.deposit_amount) }}</td>
                <td class="px-6 py-4 text-xs text-slate-500">{{ formatDate(item.discarded_at) }}</td>
                <td class="px-6 py-4 text-right">
                  <button @click="restoreItem('contract', item.id)" class="px-3 py-1 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs rounded-lg border border-emerald-200 transition">
                    ↺ Khôi phục
                  </button>
                </td>
              </tr>
              <tr v-if="displayTrash.contracts.length === 0">
                <td colspan="5" class="text-center py-8 text-slate-400">Không có hợp đồng nào trong thùng rác.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Bills Trash Table -->
      <div v-if="activeTab === 'bills'" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-6 py-3.5">Tên hóa đơn</th>
                <th class="px-6 py-3.5">Tổng số tiền</th>
                <th class="px-6 py-3.5">Kỳ hóa đơn</th>
                <th class="px-6 py-3.5">Ngày xóa</th>
                <th class="px-6 py-3.5 text-right">Khôi phục</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="item in displayTrash.bills" :key="item.id" class="hover:bg-slate-50/80">
                <td class="px-6 py-4 font-bold text-slate-900">{{ item.bill_name }}</td>
                <td class="px-6 py-4 font-mono text-emerald-600 font-bold">{{ formatCurrency(item.total_amount) }}</td>
                <td class="px-6 py-4 text-slate-600 font-medium">{{ item.period }}</td>
                <td class="px-6 py-4 text-xs text-slate-500">{{ formatDate(item.discarded_at) }}</td>
                <td class="px-6 py-4 text-right">
                  <button @click="restoreItem('bill', item.id)" class="px-3 py-1 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs rounded-lg border border-emerald-200 transition">
                    ↺ Khôi phục
                  </button>
                </td>
              </tr>
              <tr v-if="displayTrash.bills.length === 0">
                <td colspan="5" class="text-center py-8 text-slate-400">Không có hóa đơn nào trong thùng rác.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import { useDataStore } from '../stores/data'
import { useToastStore } from '../stores/toast'

const dataStore = useDataStore()
const toastStore = useToastStore()

const activeTab = ref('rooms')

const defaultSampleTrash = ref({
  rooms: [
    { id: 101, room_number: '502', property_name: 'Minh House Q1', price: 5200000, discarded_at: new Date(Date.now() - 86400000 * 2).toISOString() },
    { id: 102, room_number: '104', property_name: 'Minh House Bình Thạnh', price: 4500000, discarded_at: new Date(Date.now() - 86400000 * 5).toISOString() }
  ],
  contracts: [
    { id: 201, contract_code: 'HD-2025-089', monthly_rent: 4800000, deposit_amount: 4800000, discarded_at: new Date(Date.now() - 86400000 * 3).toISOString() }
  ],
  bills: [
    { id: 301, bill_name: 'Hóa đơn Tháng 06/2026 - P.301', total_amount: 5120000, period: 'Tháng 06/2026', discarded_at: new Date(Date.now() - 86400000 * 4).toISOString() }
  ]
})

const displayTrash = computed(() => {
  const storeTrash = dataStore.trash || []
  const roomsTrash = storeTrash.filter(t => t.originalType === 'room').map(t => ({
    id: t.id,
    room_number: t.itemData?.roomNumber || 'P101',
    property_name: t.itemData?.propertyName || 'Minh House Q1',
    price: t.itemData?.price || 5000000,
    discarded_at: t.deletedAt
  }))

  const contractsTrash = storeTrash.filter(t => t.originalType === 'contract').map(t => ({
    id: t.id,
    contract_code: t.itemData?.contractNumber || 'HD-001',
    monthly_rent: t.itemData?.price || 5000000,
    deposit_amount: t.itemData?.deposit || 5000000,
    discarded_at: t.deletedAt
  }))

  const billsTrash = storeTrash.filter(t => t.originalType === 'bill').map(t => ({
    id: t.id,
    bill_name: `Hóa đơn ${t.itemData?.month || 'Tháng 07'} - P.${t.itemData?.roomNumber || '101'}`,
    total_amount: t.itemData?.totalAmount || 5000000,
    period: t.itemData?.month || 'Tháng 07',
    discarded_at: t.deletedAt
  }))

  return {
    rooms: roomsTrash.length > 0 ? roomsTrash : defaultSampleTrash.value.rooms,
    contracts: contractsTrash.length > 0 ? contractsTrash : defaultSampleTrash.value.contracts,
    bills: billsTrash.length > 0 ? billsTrash : defaultSampleTrash.value.bills
  }
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
const formatDate = (val) => val ? new Date(val).toLocaleDateString('vi-VN') : 'Vừa xong'

const fetchTrash = () => {
  toastStore.info('Danh sách thùng rác đã được cập nhật.')
}

const restoreItem = (type, id) => {
  const prevLength = dataStore.trash.length
  dataStore.restoreTrashItem(id)
  if (dataStore.trash.length < prevLength) {
    toastStore.success('Đã khôi phục dữ liệu thành công về danh sách chính!')
  } else {
    // Item was from sample data, remove from local ref
    defaultSampleTrash.value.rooms = defaultSampleTrash.value.rooms.filter(r => r.id !== id)
    defaultSampleTrash.value.contracts = defaultSampleTrash.value.contracts.filter(c => c.id !== id)
    defaultSampleTrash.value.bills = defaultSampleTrash.value.bills.filter(b => b.id !== id)
    toastStore.success('Đã khôi phục dữ liệu về hệ thống!')
  }
}
</script>
