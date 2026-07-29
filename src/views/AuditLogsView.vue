<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Nhật Ký Vết Thao Tác (Audit Logs)</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi lịch sử chỉnh sửa, gạch nợ hóa đơn, thanh lý hợp đồng và lưu vết nhân viên</p>
        </div>

        <button @click="loadLogs" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-slate-300 rounded-xl font-semibold text-slate-700 text-sm hover:bg-slate-50 shadow-sm">
          🔄 Tải lại nhật ký
        </button>
      </div>

      <!-- Logs Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div v-if="loading" class="p-8 text-center text-slate-500">Đang tải nhật ký thao tác...</div>

        <div v-else-if="logs.length === 0" class="p-12 text-center text-slate-500">Chưa có vết thao tác nào được ghi nhận.</div>

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
              <tr v-for="log in logs" :key="log.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-sans text-slate-500">{{ formatDate(log.created_at) }}</td>
                <td class="px-6 py-4 font-sans font-bold text-slate-900">👤 {{ log.user_name }}</td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-md font-bold bg-indigo-50 text-indigo-700 uppercase">
                    {{ log.action }}
                  </span>
                </td>
                <td class="px-6 py-4 font-sans text-slate-800">{{ log.record_type }} #{{ log.record_id }}</td>
                <td class="px-6 py-4 text-slate-500 max-w-xs truncate">{{ log.payload }}</td>
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

const formatDate = (iso) => new Date(iso).toLocaleString('vi-VN')

const loadLogs = async () => {
  loading.value = true
  try {
    const res = await api.get('/audit_logs')
    logs.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) {
    console.warn('Error loading audit logs:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadLogs)
</script>
