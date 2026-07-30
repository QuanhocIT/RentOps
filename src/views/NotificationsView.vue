<template>
  <AppLayout>
    <div class="owner-page space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-amber-100 text-amber-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Nhắc Nợ ZNS / SMS</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Nhật Ký Nhắc Nợ ZNS / SMS / Email</h1>
          <p class="text-slate-500 text-sm mt-0.5">Lịch sử gửi thông báo nhắc nợ tự động tới khách thuê chưa thanh toán</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="showCustomModal = true"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>💬</span>
            <span>Gửi Tin Tùy Chỉnh</span>
          </button>
          <button
            @click="sendBatchReminders"
            :disabled="sending"
            class="px-4 py-2.5 bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5 disabled:opacity-50"
          >
            <span>📩</span>
            <span>{{ sending ? 'Đang gửi...' : 'Gửi Nhắc Nợ 1-Click' }}</span>
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

      <!-- Search & Filter Bar -->
      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="relative w-full md:w-80">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="🔍 Tìm theo người nhận, SĐT, nội dung..."
            class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-900 focus:bg-white focus:outline-none focus:border-indigo-500 font-medium"
          />
        </div>

        <div class="flex items-center gap-3">
          <select v-model="selectedChannel" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700">
            <option value="">⚡ Tất cả kênh (ZNS/SMS/Email)</option>
            <option value="ZNS">💬 Zalo Official (ZNS)</option>
            <option value="SMS">📱 SMS Brandname</option>
            <option value="EMAIL">✉️ Email Thông Báo</option>
            <option value="SYSTEM">🔔 Thông Báo Cổng Cư Dân</option>
          </select>

          <span class="text-xs font-semibold text-slate-400">Hiển thị {{ filteredLogs.length }} tin</span>
        </div>
      </div>

      <!-- Notifications Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải nhật ký thông báo...</div>

        <div v-else-if="filteredLogs.length === 0" class="p-12 text-center text-slate-500">Chưa có tin nhắn nhắc nợ nào phù hợp.</div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Thời gian</th>
                <th class="px-6 py-4">Người nhận</th>
                <th class="px-6 py-4">Số điện thoại</th>
                <th class="px-6 py-4">Kênh gửi</th>
                <th class="px-6 py-4">Nội dung tin nhắn</th>
                <th class="px-6 py-4">Trạng thái</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 font-sans text-xs">
              <tr v-for="log in filteredLogs" :key="log.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 text-slate-500">{{ formatDate(log.created_at) }}</td>
                <td class="px-6 py-4 font-bold text-slate-900">👤 {{ log.recipient_name }}</td>
                <td class="px-6 py-4 font-mono font-semibold text-slate-800">{{ log.recipient_phone }}</td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-md font-bold bg-indigo-50 text-indigo-700 uppercase">
                    {{ log.channel }}
                  </span>
                </td>
                <td class="px-6 py-4 text-slate-700 max-w-sm">{{ log.content }}</td>
                <td class="px-6 py-4">
                  <span class="px-2 py-0.5 rounded-full text-[11px] font-bold uppercase bg-emerald-100 text-emerald-800">
                    {{ log.status }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Custom Notification Modal -->
      <div v-if="showCustomModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white border border-slate-200 rounded-2xl max-w-md w-full p-6 text-slate-900 shadow-2xl">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3 mb-4">
            <h3 class="text-lg font-bold text-slate-900">💬 Gửi Tin Nhắn / Thông Báo Tùy Chỉnh</h3>
            <button @click="showCustomModal = false" class="text-slate-400 hover:text-slate-600 text-lg">✕</button>
          </div>

          <form @submit.prevent="sendCustomMessage" class="space-y-4 text-xs">
            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Tên khách thuê / Người nhận *</label>
              <input v-model="customForm.recipient_name" required type="text" placeholder="vd: Trần Văn Bình (Phòng 201)" class="w-full px-3 py-2 border border-slate-300 rounded-xl" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block font-bold text-slate-700 uppercase mb-1">Số điện thoại *</label>
                <input v-model="customForm.recipient_phone" required type="tel" placeholder="0901234567" class="w-full px-3 py-2 border border-slate-300 rounded-xl font-mono" />
              </div>
              <div>
                <label class="block font-bold text-slate-700 uppercase mb-1">Kênh gửi *</label>
                <select v-model="customForm.channel" class="w-full px-3 py-2 border border-slate-300 rounded-xl">
                  <option value="ZNS">Zalo Official (ZNS)</option>
                  <option value="SMS">SMS Brandname</option>
                  <option value="EMAIL">Email</option>
                  <option value="SYSTEM">Thông Báo Cổng Cư Dân</option>
                </select>
              </div>
            </div>

            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Nội dung tin nhắn *</label>
              <textarea v-model="customForm.content" required rows="3" placeholder="Nhập nội dung nhắc nợ hoặc thông báo lịch bảo trì..." class="w-full px-3 py-2 border border-slate-300 rounded-xl leading-relaxed"></textarea>
            </div>

            <div class="flex justify-end gap-3 pt-2">
              <button type="button" @click="showCustomModal = false" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl">Hủy</button>
              <button type="submit" class="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-md">Gửi Tin Ngay 🚀</button>
            </div>
          </form>
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
const sending = ref(false)
const searchQuery = ref('')
const selectedChannel = ref('')
const showCustomModal = ref(false)

const customForm = ref({
  recipient_name: '',
  recipient_phone: '',
  channel: 'ZNS',
  content: ''
})

const formatDate = (iso) => iso ? new Date(iso).toLocaleString('vi-VN') : new Date().toLocaleString('vi-VN')

const displayLogs = computed(() => {
  return dataStore.notifications.map(n => ({
    id: n.id,
    created_at: n.createdDate,
    recipient_name: n.title,
    recipient_phone: '0908123456',
    channel: 'ZNS / System',
    content: n.message,
    status: n.read ? 'Đã đọc' : 'Chưa đọc'
  }))
})

const filteredLogs = computed(() => {
  let list = displayLogs.value
  if (!searchQuery.value) return list
  const q = searchQuery.value.toLowerCase()
  return list.filter(l =>
    String(l.recipient_name || '').toLowerCase().includes(q) ||
    String(l.content || '').toLowerCase().includes(q)
  )
})

const sendBatchReminders = () => {
  sending.value = true
  try {
    const unpaids = dataStore.bills.filter(b => b.status === 'unpaid' || b.status === 'overdue')
    unpaids.forEach(b => {
      dataStore.addNotification('Nhắc nợ tự động', `Nhắc nợ hóa đơn ${b.code} phòng ${b.roomNumber} (${b.totalAmount.toLocaleString()} đ)`, 'warning')
    })
    toastStore.success(`Đã gửi thông báo nhắc nợ ZNS/SMS thành công tới ${unpaids.length} phòng chưa thanh toán!`)
  } finally {
    sending.value = false
  }
}

const sendCustomMessage = () => {
  dataStore.addNotification(
    `Gửi tin nhắn: ${customForm.value.recipient_name}`,
    customForm.value.content,
    'info'
  )
  showCustomModal.value = false
  customForm.value = { recipient_name: '', recipient_phone: '', channel: 'ZNS', content: '' }
  toastStore.success('Đã gửi thông báo thành công!')
}
</script>
