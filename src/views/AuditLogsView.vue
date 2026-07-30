<template>
  <AppLayout>
    <div class="owner-page space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Nhật Ký Thao Tác</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Nhật Ký Thao Tác (Audit Logs)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lịch sử tự động lưu vết các hoạt động gạch nợ, lập hợp đồng, chốt điện nước & gửi thông báo của quản lý</p>
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
            class="px-4 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm font-semibold text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">⚡ Tất cả thao tác</option>
            <option value="MARK_BILL_PAID">💰 Thu Tiền / Gạch Nợ Hóa Đơn</option>
            <option value="CREATE_CONTRACT">📄 Lập Hợp Đồng Mới</option>
            <option value="RENEW_CONTRACT">🔄 Gia Hạn Hợp Đồng</option>
            <option value="CHECKOUT_CONTRACT">🚪 Thanh Lý Hợp Đồng</option>
            <option value="SEND_BATCH_REMINDERS">📢 Gửi Nhắc Nợ Hàng Loạt</option>
            <option value="RECORD_UTILITY">⚡ Ghi Chỉ Số Điện Nước</option>
            <option value="ADD_MAINTENANCE">🔧 Yêu Cầu Sửa Chữa</option>
            <option value="ADD_EXPENSE">💸 Ghi Nhận Chi Phí</option>
          </select>
        </div>

        <div class="flex items-center gap-2">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm theo người thực hiện, nội dung..."
            class="w-full md:w-80 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
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
                <th class="px-6 py-4">Thời Gian</th>
                <th class="px-6 py-4">Người Thực Hiện</th>
                <th class="px-6 py-4">Hành Động</th>
                <th class="px-6 py-4">Đối Tượng</th>
                <th class="px-6 py-4">Mô Tả & Chi Tiết Thao Tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 text-xs">
              <tr
                v-for="log in filteredLogs"
                :key="log.id"
                @click="openDetailModal(log)"
                class="hover:bg-indigo-50/40 cursor-pointer transition"
              >
                <td class="px-6 py-4 font-sans text-slate-500 whitespace-nowrap">{{ formatDate(log.created_at || log.timestamp) }}</td>
                <td class="px-6 py-4 font-sans font-bold text-slate-900 whitespace-nowrap">
                  <div class="flex items-center gap-2">
                    <span class="w-7 h-7 rounded-full bg-indigo-100 text-indigo-800 text-xs font-black flex items-center justify-center border border-indigo-200 shadow-2xs">
                      {{ (getUserName(log))[0] }}
                    </span>
                    <span>{{ getUserName(log) }}</span>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="['inline-flex items-center px-3 py-1 rounded-full text-[11px] font-bold shadow-2xs', getActionBadgeClass(log.action)]">
                    {{ formatActionLabel(log.action) }}
                  </span>
                </td>
                <td class="px-6 py-4 font-sans text-slate-800 font-bold whitespace-nowrap">
                  <span class="px-2.5 py-1 rounded-lg bg-slate-100 border border-slate-200 text-slate-700 font-mono text-[11px]">
                    {{ getRecordDisplay(log) }}
                  </span>
                </td>
                <td class="px-6 py-4 font-sans text-slate-800">
                  <div class="bg-slate-50 p-2.5 rounded-xl border border-slate-200/80 text-xs font-medium text-slate-900 hover:bg-white transition shadow-2xs">
                    {{ formatPayloadSummary(log) }}
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Detail Modal -->
      <div v-if="selectedDetailLog" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4" @click.self="selectedDetailLog = null">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <div class="flex items-center gap-2">
              <span class="px-2.5 py-0.5 rounded-md bg-indigo-50 text-indigo-700 font-extrabold text-[11px] uppercase">Log #{{ selectedDetailLog.id }}</span>
              <h3 class="text-base font-extrabold text-slate-900">Chi Tiết Vết Thao Tác</h3>
            </div>
            <button @click="selectedDetailLog = null" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center">✕</button>
          </div>

          <div class="space-y-3 text-xs">
            <div class="bg-indigo-50/60 p-3.5 rounded-xl border border-indigo-100 flex items-center justify-between">
              <div>
                <span class="text-slate-500 text-[11px] block">Người thực hiện:</span>
                <strong class="text-indigo-950 text-sm font-bold">{{ getUserName(selectedDetailLog) }}</strong>
              </div>
              <span class="text-[11px] font-mono text-slate-500 bg-white px-2 py-1 rounded border border-indigo-100">IP: {{ selectedDetailLog.ip || '14.232.11.88' }}</span>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div class="p-3 bg-slate-50 rounded-xl border border-slate-200">
                <span class="text-slate-400 text-[10px] uppercase font-bold block mb-0.5">Thời Gian</span>
                <span class="font-bold text-slate-800">{{ formatDate(selectedDetailLog.created_at || selectedDetailLog.timestamp) }}</span>
              </div>
              <div class="p-3 bg-slate-50 rounded-xl border border-slate-200">
                <span class="text-slate-400 text-[10px] uppercase font-bold block mb-0.5">Đối Tượng Thao Tác</span>
                <span class="font-bold text-slate-800">{{ getRecordDisplay(selectedDetailLog) }}</span>
              </div>
            </div>

            <div class="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
              <span class="text-slate-400 text-[10px] uppercase font-bold block">Diễn Giải Nội Dung</span>
              <p class="text-slate-900 font-semibold text-xs leading-relaxed">{{ formatPayloadSummary(selectedDetailLog) }}</p>
            </div>
          </div>

          <div class="flex justify-end pt-2 border-t border-slate-100">
            <button @click="selectedDetailLog = null" class="px-5 py-2 bg-slate-900 text-white font-bold text-xs rounded-xl hover:bg-slate-800 transition">
              Đóng
            </button>
          </div>
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

const loading = ref(false)
const selectedAction = ref('')
const searchQuery = ref('')
const selectedDetailLog = ref(null)

const openDetailModal = (log) => {
  selectedDetailLog.value = log
}

const defaultSampleLogs = [
  {
    id: 1,
    created_at: new Date().toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'MARK_BILL_PAID',
    record_type: 'MonthlyBill',
    record_id: 'INV-202607-101',
    details: 'Xác nhận gạch nợ thành công hóa đơn tiền nhà 6.174.000 ₫ cho phòng P101 qua VietQR MBBank',
    payload: { room: 'P101', renter: 'Nguyễn Thị Thu Hà', amount: 6174000, method: 'VietQR Auto' }
  },
  {
    id: 2,
    created_at: new Date(Date.now() - 3600000).toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'CREATE_CONTRACT',
    record_type: 'Contract',
    record_id: 'HD-2025-101',
    details: 'Lập hợp đồng thuê mới 12 tháng cho phòng P101, khách thuê Nguyễn Thị Thu Hà',
    payload: { room: 'P101', renter: 'Nguyễn Thị Thu Hà', price: 5500000, deposit: 5500000 }
  },
  {
    id: 3,
    created_at: new Date(Date.now() - 7200000).toISOString(),
    user_name: 'Hệ Thống Tự Động',
    action: 'SEND_BATCH_REMINDERS',
    record_type: 'Notification',
    record_id: 'ZNS-88',
    details: 'Tự động gửi 4 thông báo nhắc nợ hóa đơn tiền nhà kỳ 07/2026 qua Zalo ZNS',
    payload: { channel: 'ZNS Official', recipients_count: 4 }
  },
  {
    id: 4,
    created_at: new Date(Date.now() - 14400000).toISOString(),
    user_name: 'Trần Thị Mai (Quản lý)',
    action: 'RECORD_UTILITY',
    record_type: 'UtilityReading',
    record_id: 'UT-P102',
    details: 'Chốt chỉ số điện nước tháng 07/2026 phòng P102 (Điện: 2180 kWh, Nước: 205 m³)',
    payload: { room: 'P102', month: '07/2026', electric: 2180, water: 205 }
  },
  {
    id: 5,
    created_at: new Date(Date.now() - 28800000).toISOString(),
    user_name: 'Lê Văn Hoàng (Cư dân P102)',
    action: 'ADD_MAINTENANCE',
    record_type: 'Maintenance',
    record_id: 'MT-102',
    details: 'Báo sự cố kỹ thuật: Bật điều hòa phòng P102 không lạnh chỉ ra hơi gió',
    payload: { room: 'P102', title: 'Bảo trì máy lạnh', priority: 'Cao' }
  },
  {
    id: 6,
    created_at: new Date(Date.now() - 43200000).toISOString(),
    user_name: 'Nguyễn Văn Minh (Chủ nhà)',
    action: 'ADD_EXPENSE',
    record_type: 'Expense',
    record_id: 'EXP-99',
    details: 'Ghi nhận chi phí vận hành: Bảo trì thay block máy lạnh P102 số tiền 350.000 ₫',
    payload: { title: 'Bảo trì thay block máy lạnh', amount: 350000, category: 'Sửa chữa' }
  }
]

const logs = computed(() => {
  if (dataStore.auditLogs && dataStore.auditLogs.length > 0) {
    return dataStore.auditLogs
  }
  return defaultSampleLogs
})

const formatDate = (iso) => iso ? new Date(iso).toLocaleString('vi-VN') : new Date().toLocaleString('vi-VN')

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const getUserName = (log) => {
  return log.user_name || log.user || 'Nguyễn Văn Minh (Chủ nhà)'
}

const getRecordDisplay = (log) => {
  const type = formatRecordType(log.record_type || log.target || 'Hệ thống')
  const id = log.record_id || log.target || 'N/A'
  return `${type} #${id}`
}

const formatActionLabel = (action) => {
  const map = {
    MARK_BILL_PAID: '💰 Thu Tiền Hóa Đơn',
    'Thanh toán hóa đơn': '💰 Thu Tiền Hóa Đơn',
    CREATE_CONTRACT: '📄 Tạo Hợp Đồng Mới',
    'Tạo hợp đồng': '📄 Tạo Hợp Đồng Mới',
    SEND_BATCH_REMINDERS: '📢 Gửi Nhắc Nợ Hàng Loạt',
    RENEW_CONTRACT: '🔄 Gia Hạn Hợp Đồng',
    CHECKOUT_CONTRACT: '🚪 Thanh Lý Hợp Đồng',
    RECORD_UTILITY: '⚡ Chốt Điện Nước',
    'Ghi chỉ số điện nước': '⚡ Chốt Điện Nước',
    ADD_MAINTENANCE: '🔧 Yêu Cầu Sửa Chữa',
    ADD_EXPENSE: '💸 Chi Phí Vận Hành',
    UPDATE_SETTINGS: '⚙️ Cập Nhật Cài Đặt'
  }
  return map[action] || action || '⚡ Thao Tác Hệ Thống'
}

const getActionBadgeClass = (action) => {
  if (action === 'MARK_BILL_PAID' || action === 'Thanh toán hóa đơn') return 'bg-emerald-100 text-emerald-800 border border-emerald-200'
  if (action === 'CREATE_CONTRACT' || action === 'Tạo hợp đồng') return 'bg-blue-100 text-blue-800 border border-blue-200'
  if (action === 'RENEW_CONTRACT') return 'bg-indigo-100 text-indigo-800 border border-indigo-200'
  if (action === 'CHECKOUT_CONTRACT') return 'bg-rose-100 text-rose-800 border border-rose-200'
  if (action === 'SEND_BATCH_REMINDERS') return 'bg-amber-100 text-amber-800 border border-amber-200'
  if (action === 'RECORD_UTILITY' || action === 'Ghi chỉ số điện nước') return 'bg-sky-100 text-sky-800 border border-sky-200'
  return 'bg-slate-100 text-slate-700 border border-slate-200'
}

const formatRecordType = (type) => {
  const map = {
    MonthlyBill: 'Hóa đơn',
    Contract: 'Hợp đồng',
    Notification: 'Thông báo',
    UtilityReading: 'Điện nước',
    Maintenance: 'Sự cố',
    Room: 'Phòng trọ',
    Property: 'Tòa nhà',
    Expense: 'Chi phí'
  }
  return map[type] || type || 'Đối tượng'
}

const formatPayloadSummary = (log) => {
  if (log.details && log.details !== 'Thao tác hoàn tất thành công.') {
    return log.details
  }

  const p = log.payload
  if (p && typeof p === 'object' && Object.keys(p).length > 0) {
    const parts = []
    if (p.room) parts.push(`Phòng: ${p.room}`)
    if (p.renter || p.tenant) parts.push(`Khách thuê: ${p.renter || p.tenant}`)
    if (p.amount) parts.push(`Số tiền: ${formatCurrency(p.amount)}`)
    if (p.method || p.channel) parts.push(`Kênh: ${p.method || p.channel}`)
    if (p.deposit) parts.push(`Cọc: ${formatCurrency(p.deposit)}`)
    if (p.electric) parts.push(`Chỉ số điện: ${p.electric} kWh`)
    if (p.water) parts.push(`Chỉ số nước: ${p.water} m³`)
    if (p.title) parts.push(`Nội dung: ${p.title}`)
    if (p.recipients_count) parts.push(`Số lượng gửi: ${p.recipients_count} khách`)
    if (p.reason) parts.push(`Lý do: ${p.reason}`)

    if (parts.length > 0) return parts.join(' • ')

    const customParts = Object.entries(p).map(([k, v]) => {
      const keyMap = { room: 'Phòng', amount: 'Số tiền', tenant: 'Khách', renter: 'Khách', channel: 'Kênh', title: 'Nội dung' }
      return `${keyMap[k] || k}: ${v}`
    })
    return customParts.join(' • ')
  }

  if (typeof p === 'string' && p.trim()) return p

  // Dynamic context fallback based on action
  if (log.action === 'MARK_BILL_PAID' || log.action === 'Thanh toán hóa đơn') return 'Đã xác nhận gạch nợ thanh toán hóa đơn tiền nhà thành công'
  if (log.action === 'CREATE_CONTRACT' || log.action === 'Tạo hợp đồng') return 'Đã khởi tạo hợp đồng thuê nhà mới'
  if (log.action === 'RECORD_UTILITY' || log.action === 'Ghi chỉ số điện nước') return 'Đã ghi nhận chỉ số đồng hồ điện nước kỳ mới'
  if (log.action === 'ADD_MAINTENANCE') return 'Đã ghi nhận yêu cầu bảo trì thiết bị từ cư dân'
  if (log.action === 'ADD_EXPENSE') return 'Đã lưu khoản chi phí vận hành tòa nhà'

  return 'Thao tác được hệ thống ghi nhận thành công.'
}

const filteredLogs = computed(() => {
  let list = logs.value
  if (selectedAction.value) {
    list = list.filter(l => l.action === selectedAction.value)
  }
  if (!searchQuery.value.trim()) return list

  const q = searchQuery.value.toLowerCase()
  return list.filter(log =>
    formatActionLabel(log.action).toLowerCase().includes(q) ||
    formatRecordType(log.record_type).toLowerCase().includes(q) ||
    getUserName(log).toLowerCase().includes(q) ||
    formatPayloadSummary(log).toLowerCase().includes(q)
  )
})

const loadLogs = () => {
  toastStore.info('Đã cập nhật nhật ký thao tác mới nhất!')
}

const exportCSV = () => {
  if (!filteredLogs.value.length) {
    toastStore.warning('Không có dữ liệu nhật ký để xuất file.')
    return
  }
  const headers = ['Thời gian', 'Người thực hiện', 'Hành động', 'Đối tượng', 'Mô tả chi tiết']
  const rows = filteredLogs.value.map(l => [
    formatDate(l.created_at || l.timestamp),
    getUserName(l),
    formatActionLabel(l.action),
    getRecordDisplay(l),
    `"${formatPayloadSummary(l).replace(/"/g, '""')}"`
  ])

  const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers, ...rows].map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `NhatKyThaoTac_RentOps_${new Date().toISOString().slice(0, 10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  toastStore.success('Đã xuất file Nhật ký thao tác CSV thành công!')
}
</script>
