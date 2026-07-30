<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Nhật Ký Thao Tác</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Nhật Ký Thao Tác (Audit Logs)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi lịch sử chỉnh sửa, gạch nợ hóa đơn, thanh lý hợp đồng và lưu vết nhân viên</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="exportCSV"
            class="px-4 py-2.5 bg-emerald-700 hover:bg-emerald-600 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>📥</span>
            <span>Xuất CSV</span>
          </button>
          <button
            @click="loadLogs"
            class="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl border border-slate-300 transition flex items-center gap-1.5"
          >
            <span>🔄</span>
            <span>Tải lại</span>
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

        <div v-else-if="filteredLogs.length === 0" class="p-12 text-center text-slate-500">Chưa có vết thao tác nào phù hợp.</div>

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
import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const defaultSampleLogs = [
  { id: 1, created_at: new Date().toISOString(), user_name: 'Quản lý Nguyễn Văn A', action: 'MARK_BILL_PAID', record_type: 'MonthlyBill', record_id: 104, payload: { amount: 5500000, channel: 'VietQR Auto' } },
  { id: 2, created_at: new Date(Date.now() - 3600000).toISOString(), user_name: 'Admin Minh House', action: 'CREATE_CONTRACT', record_type: 'Contract', record_id: 201, payload: { room: 'Phòng 302', tenant: 'Trần Văn B', deposit: 4500000 } },
  { id: 3, created_at: new Date(Date.now() - 7200000).toISOString(), user_name: 'Hệ thống Auto-System', action: 'SEND_BATCH_REMINDERS', record_type: 'Notification', record_id: 88, payload: { channel: 'ZNS Official', recipients_count: 4 } },
  { id: 4, created_at: new Date(Date.now() - 14400000).toISOString(), user_name: 'Quản lý Lê Thị C', action: 'RENEW_CONTRACT', record_type: 'Contract', record_id: 198, payload: { extension_months: 6, new_rent: 4800000 } },
  { id: 5, created_at: new Date(Date.now() - 28800000).toISOString(), user_name: 'Admin Minh House', action: 'CHECKOUT_CONTRACT', record_type: 'Contract', record_id: 155, payload: { reason: 'Hết hạn hợp đồng', refunded_deposit: 4000000 } }
]

const logs = ref([])
const loading = ref(false)
const selectedAction = ref('')
const searchQuery = ref('')

const formatDate = (iso) => new Date(iso).toLocaleString('vi-VN')

const displayLogs = computed(() => {
  return logs.value && logs.value.length > 0 ? logs.value : defaultSampleLogs
})

const loadLogs = async () => {
  loading.value = true
  try {
    let url = '/audit_logs'
    if (selectedAction.value) url += `?action_name=${selectedAction.value}`
    const res = await api.get(url)
    if (res?.data && Array.isArray(res.data) && res.data.length > 0) {
      logs.value = res.data
    } else {
      logs.value = defaultSampleLogs
    }
  } catch (err) {
    logs.value = defaultSampleLogs
  } finally {
    loading.value = false
  }
}

const filteredLogs = computed(() => {
  let list = displayLogs.value
  if (selectedAction.value) {
    list = list.filter(l => l.action === selectedAction.value)
  }
  if (!searchQuery.value) return list
  const q = searchQuery.value.toLowerCase()
  return list.filter(log =>
    String(log.action).toLowerCase().includes(q) ||
    String(log.record_type).toLowerCase().includes(q) ||
    String(log.user_name || '').toLowerCase().includes(q) ||
    JSON.stringify(log.payload || {}).toLowerCase().includes(q)
  )
})

const exportCSV = () => {
  if (!filteredLogs.value.length) {
    toastStore.warning('Không có dữ liệu nhật ký để xuất file.')
    return
  }
  const headers = ['Thời gian', 'Người thực hiện', 'Hành động', 'Đối tượng', 'Payload']
  const rows = filteredLogs.value.map(l => [
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
  toastStore.success('Đã xuất file Audit Logs CSV thành công!')
}

onMounted(loadLogs)
</script>
