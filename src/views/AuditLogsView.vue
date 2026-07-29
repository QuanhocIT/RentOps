<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Nhật Ký Vết Thao Tác (Audit Logs)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi lịch sử chỉnh sửa, gạch nợ hóa đơn, thanh lý hợp đồng và lưu vết nhân viên</p>
        </div>

        <div class="flex items-center gap-3">
          <button @click="exportCSV" class="inline-flex items-center gap-2 px-4 py-2 bg-emerald-700 hover:bg-emerald-800 text-white rounded-xl font-semibold text-sm shadow-md transition">
            📥 Xuất File CSV
          </button>
          <button @click="loadLogs" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-slate-300 rounded-xl font-semibold text-slate-700 text-sm hover:bg-slate-50 shadow-sm">
            🔄 Tải lại
          </button>
        </div>
      </div>

      <!-- Filter Bar -->
      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div class="flex flex-wrap items-center gap-3">
          <select
            v-model="selectedAction"
            @change="loadLogs"
            class="px-4 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-semibold text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">⚡ Tất cả thao tác</option>
            <option value="CREATE_CONTRACT">📄 Tạo Hợp Đồng</option>
            <option value="CHECKOUT_CONTRACT">🚪 Thanh Lý Hợp Đồng</option>
            <option value="RENEW_CONTRACT">🔄 Gia Hạn Hợp Đồng</option>
            <option value="MARK_BILL_PAID">💰 Thu Tiền Hóa Đơn</option>
            <option value="SEND_DEBT_REMINDER">📩 Gửi Nhắc Nợ</option>
            <option value="SEND_BATCH_REMINDERS">📢 Nhắc Nợ Hàng Loạt</option>
          </select>
        </div>

        <div class="flex items-center gap-2">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm theo nội dung payload..."
            class="w-full md:w-72 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>
      </div>

      <!-- Logs Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải nhật ký thao tác...</div>

        <div v-else-if="filteredLogs.length === 0" class="p-12 text-center text-slate-500">Chưa có vết thao tác nào được ghi nhận.</div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Thời gian</th>
                <th class="px-6 py-4">Người thực hiện</th>
                <th class="px-6 py-4">Hành động</th>
                <th class="px-6 py-4">Đối tượng</th>
                <th class="px-6 py-4">Dữ liệu Payload</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 font-mono text-xs">
              <tr v-for="log in filteredLogs" :key="log.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-sans text-slate-500">{{ formatDate(log.created_at) }}</td>
                <td class="px-6 py-4 font-sans font-bold text-slate-900">👤 {{ log.user_name }}</td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-md font-bold bg-indigo-50 text-indigo-700 uppercase">
                    {{ log.action }}
                  </span>
                </td>
                <td class="px-6 py-4 font-sans text-slate-800">{{ log.record_type }} #{{ log.record_id }}</td>
                <td class="px-6 py-4 text-slate-500 max-w-xs truncate" :title="JSON.stringify(log.payload)">
                  {{ typeof log.payload === 'object' ? JSON.stringify(log.payload) : log.payload }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const logs = ref([])
const loading = ref(false)
const selectedAction = ref('')
const searchQuery = ref('')

const formatDate = (iso) => new Date(iso).toLocaleString('vi-VN')

const loadLogs = async () => {
  loading.value = true
  try {
    let url = '/audit_logs'
    if (selectedAction.value) url += `?action_name=${selectedAction.value}`
    const res = await api.get(url)
    logs.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) {
    console.warn('Error loading audit logs:', err)
  } finally {
    loading.value = false
  }
}

const filteredLogs = computed(() => {
  if (!searchQuery.value) return logs.value
  const q = searchQuery.value.toLowerCase()
  return logs.value.filter(log =>
    String(log.action).toLowerCase().includes(q) ||
    String(log.record_type).toLowerCase().includes(q) ||
    JSON.stringify(log.payload || {}).toLowerCase().includes(q)
  )
})

const exportCSV = () => {
  if (!logs.value.length) {
    alert('Không có dữ liệu để xuất file.')
    return
  }
  const headers = ['Thời gian', 'Người thực hiện', 'Hành động', 'Đối tượng', 'Payload']
  const rows = logs.value.map(l => [
    formatDate(l.created_at),
    l.user_name,
    l.action,
    `${l.record_type} #${l.record_id}`,
    `"${JSON.stringify(l.payload || {}).replace(/"/g, '""')}"`
  ])

  const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers, ...rows].map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `Audit_Logs_RentOps_${new Date().toISOString().slice(0, 10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

onMounted(loadLogs)
</script>
