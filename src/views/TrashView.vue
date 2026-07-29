<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Trung Tâm Khôi Phục Dữ Liệu</h1>
          <p class="text-slate-500 text-sm mt-0.5">Danh sách phòng, hợp đồng và hóa đơn đã xóa mềm (soft delete) - Khôi phục 1-click bất kỳ lúc nào</p>
        </div>
      </div>

      <!-- Tabs -->
      <div class="flex space-x-2 bg-slate-200/60 p-1.5 rounded-xl w-fit">
        <button
          @click="activeTab = 'rooms'"
          :class="activeTab === 'rooms' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          🔑 Phòng trọ ({{ (trash.rooms || []).length }})
        </button>
        <button
          @click="activeTab = 'contracts'"
          :class="activeTab === 'contracts' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          📄 Hợp đồng ({{ (trash.contracts || []).length }})
        </button>
        <button
          @click="activeTab = 'bills'"
          :class="activeTab === 'bills' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          💳 Hóa đơn ({{ (trash.bills || []).length }})
        </button>
      </div>

      <!-- Rooms Trash Table -->
      <div v-if="activeTab === 'rooms'" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
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
            <tr v-for="item in trash.rooms" :key="item.id" class="hover:bg-slate-50/80">
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
            <tr v-if="(trash.rooms || []).length === 0">
              <td colspan="5" class="text-center py-8 text-slate-400">Không có phòng nào trong thùng rác.</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Contracts Trash Table -->
      <div v-if="activeTab === 'contracts'" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
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
            <tr v-for="item in trash.contracts" :key="item.id" class="hover:bg-slate-50/80">
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
            <tr v-if="(trash.contracts || []).length === 0">
              <td colspan="5" class="text-center py-8 text-slate-400">Không có hợp đồng nào trong thùng rác.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'

const activeTab = ref('rooms')
const trash = ref({ rooms: [], contracts: [], bills: [] })

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
const formatDate = (val) => val ? new Date(val).toLocaleDateString('vi-VN') : 'N/A'

const fetchTrash = async () => {
  try {
    const res = await fetch('/api/v1/trash')
    if (res.ok) {
      const json = await res.json()
      trash.value = json.data || {}
    }
  } catch (err) {
    console.error(err)
  }
}

const restoreItem = async (type, id) => {
  try {
    const res = await fetch('/api/v1/trash/restore', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ type, id })
    })

    if (res.ok) {
      alert('Đã khôi phục dữ liệu thành công!')
      fetchTrash()
    }
  } catch (err) {
    alert('Lỗi khôi phục')
  }
}

onMounted(fetchTrash)
</script>
