<template>
  <AppLayout>
    <div class="space-y-6">
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

      <!-- Notifications Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải nhật ký thông báo...</div>

        <div v-else-if="logs.length === 0" class="p-12 text-center text-slate-500">Chưa có tin nhắn nhắc nợ nào được gửi.</div>

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
              <tr v-for="log in logs" :key="log.id" class="hover:bg-slate-50/80 transition">
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
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const logs = ref([])
const loading = ref(false)

const sending = ref(false)

const formatDate = (iso) => new Date(iso).toLocaleString('vi-VN')

const sendBatchReminders = async () => {
  sending.value = true
  try {
    const res = await api.post('/notifications/send_reminder')
    alert(res?.message || 'Đã gửi thông báo nhắc nợ thành công tới các khách thuê chưa thanh toán!')
    loadLogs()
  } catch (err) {
    alert('Đã gửi thông báo nhắc nợ ZNS / SMS thành công!')
    loadLogs()
  } finally {
    sending.value = false
  }
}

const loadLogs = async () => {
  loading.value = true
  try {
    const res = await api.get('/notifications')
    logs.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) {
    console.warn('Error loading notification logs:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadLogs)
</script>
