<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="bg-slate-800/80 p-6 rounded-2xl border border-slate-700/60 shadow-lg text-white">
      <h1 class="text-2xl font-black bg-gradient-to-r from-amber-400 to-rose-300 bg-clip-text text-transparent">
        ♻️ Trung Tâm Khôi Phục Dữ Liệu (Trash Restore)
      </h1>
      <p class="text-xs text-slate-400 mt-1">Danh sách phòng, hợp đồng và hóa đơn đã xóa mềm (soft delete) - Bạn có thể khôi phục lại bất kỳ lúc nào</p>
    </div>

    <!-- Tabs -->
    <div class="flex space-x-3 bg-slate-800/60 p-2 rounded-xl border border-slate-700/60 w-fit">
      <button
        @click="activeTab = 'rooms'"
        :class="activeTab === 'rooms' ? 'bg-indigo-600 text-white font-bold' : 'text-slate-400 hover:text-white'"
        class="px-4 py-2 text-xs rounded-lg transition"
      >
        🔑 Phòng trọ ({{ (trash.rooms || []).length }})
      </button>
      <button
        @click="activeTab = 'contracts'"
        :class="activeTab === 'contracts' ? 'bg-indigo-600 text-white font-bold' : 'text-slate-400 hover:text-white'"
        class="px-4 py-2 text-xs rounded-lg transition"
      >
        📄 Hợp đồng ({{ (trash.contracts || []).length }})
      </button>
      <button
        @click="activeTab = 'bills'"
        :class="activeTab === 'bills' ? 'bg-indigo-600 text-white font-bold' : 'text-slate-400 hover:text-white'"
        class="px-4 py-2 text-xs rounded-lg transition"
      >
        💳 Hóa đơn ({{ (trash.bills || []).length }})
      </button>
    </div>

    <!-- Rooms Trash Table -->
    <div v-if="activeTab === 'rooms'" class="bg-slate-800/80 rounded-2xl border border-slate-700/60 overflow-hidden shadow-xl text-white">
      <table class="w-full text-left text-sm text-slate-300">
        <thead class="bg-slate-900/60 text-xs uppercase text-slate-400 border-b border-slate-700/60">
          <tr>
            <th class="px-6 py-4">Tên phòng</th>
            <th class="px-6 py-4">Tòa nhà</th>
            <th class="px-6 py-4">Giá phòng</th>
            <th class="px-6 py-4">Ngày xóa</th>
            <th class="px-6 py-4 text-right">Khôi phục</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-700/40">
          <tr v-for="item in trash.rooms" :key="item.id" class="hover:bg-slate-700/30">
            <td class="px-6 py-4 font-bold text-white">Phòng {{ item.room_number }}</td>
            <td class="px-6 py-4 text-slate-300">{{ item.property_name }}</td>
            <td class="px-6 py-4 font-mono text-emerald-400">{{ formatCurrency(item.price) }}</td>
            <td class="px-6 py-4 text-xs text-slate-400">{{ formatDate(item.discarded_at) }}</td>
            <td class="px-6 py-4 text-right">
              <button @click="restoreItem('room', item.id)" class="px-3 py-1 bg-emerald-500/20 hover:bg-emerald-500/30 text-emerald-400 font-bold text-xs rounded-lg border border-emerald-500/30 transition">
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
    <div v-if="activeTab === 'contracts'" class="bg-slate-800/80 rounded-2xl border border-slate-700/60 overflow-hidden shadow-xl text-white">
      <table class="w-full text-left text-sm text-slate-300">
        <thead class="bg-slate-900/60 text-xs uppercase text-slate-400 border-b border-slate-700/60">
          <tr>
            <th class="px-6 py-4">Mã hợp đồng</th>
            <th class="px-6 py-4">Tiền thuê</th>
            <th class="px-6 py-4">Tiền cọc</th>
            <th class="px-6 py-4">Ngày xóa</th>
            <th class="px-6 py-4 text-right">Khôi phục</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-700/40">
          <tr v-for="item in trash.contracts" :key="item.id" class="hover:bg-slate-700/30">
            <td class="px-6 py-4 font-mono text-amber-400 font-bold">{{ item.contract_code }}</td>
            <td class="px-6 py-4 font-mono text-emerald-400">{{ formatCurrency(item.monthly_rent) }}</td>
            <td class="px-6 py-4 font-mono text-teal-300">{{ formatCurrency(item.deposit_amount) }}</td>
            <td class="px-6 py-4 text-xs text-slate-400">{{ formatDate(item.discarded_at) }}</td>
            <td class="px-6 py-4 text-right">
              <button @click="restoreItem('contract', item.id)" class="px-3 py-1 bg-emerald-500/20 hover:bg-emerald-500/30 text-emerald-400 font-bold text-xs rounded-lg border border-emerald-500/30 transition">
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
</template>

<script setup>
import { ref, onMounted } from 'vue'

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
