<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <div class="max-w-6xl mx-auto mb-6 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900">Hóa đơn</h1>
        <p class="text-sm text-slate-500">Sinh và quản lý hóa đơn tháng</p>
      </div>
      <RouterLink to="/" class="px-4 py-2 rounded-lg bg-slate-900 text-white text-sm">Về dashboard</RouterLink>
    </div>

    <div class="max-w-6xl mx-auto grid gap-6 md:grid-cols-[380px_1fr]">
      <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4" @submit.prevent="createBill">
        <input v-model="form.bill_code" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Mã hóa đơn" />
        <input v-model="form.room_id" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Room ID" />
        <input v-model="form.contract_id" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Contract ID" />
        <input v-model="form.billing_month" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="2026-07" />
        <div class="grid grid-cols-2 gap-3">
          <input v-model="form.total_amount" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Tổng tiền" />
          <input v-model="form.due_date" type="date" class="w-full rounded-xl border border-slate-300 px-4 py-3" />
        </div>
        <button class="w-full rounded-xl bg-indigo-600 text-white py-3 font-semibold" :disabled="loading">
          {{ loading ? 'Đang lưu...' : 'Tạo hóa đơn' }}
        </button>
        <button type="button" class="w-full rounded-xl bg-slate-900 text-white py-3 font-semibold" @click="generateBill" :disabled="loading">
          Sinh hóa đơn nhanh
        </button>
        <p v-if="message" :class="['text-sm rounded-xl px-4 py-3', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
          {{ message }}
        </p>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách hóa đơn</h2>
          <div class="flex items-center gap-3">
            <input v-model="searchQuery" class="w-56 rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Tìm hóa đơn..." />
            <button class="text-sm text-indigo-600" @click="loadBills">Tải lại</button>
          </div>
        </div>
        <div class="space-y-3">
          <div v-for="item in filteredBills" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex items-start justify-between gap-3">
            <div class="font-semibold text-slate-900">{{ item.bill_code }}</div>
            <div class="text-sm text-slate-500">Tháng {{ item.billing_month }} | Trạng thái: {{ item.status }}</div>
            <div class="flex flex-col gap-2">
              <button class="text-xs text-rose-600" @click="deleteBill(item.id)">Xóa</button>
            </div>
          </div>
          <p v-if="!filteredBills.length" class="text-sm text-slate-500">Chưa có hóa đơn nào phù hợp.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const bills = ref([])
const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const form = ref({
  bill_code: '',
  room_id: '',
  contract_id: '',
  billing_month: '',
  total_amount: '',
  due_date: ''
})

const loadBills = async () => {
  try {
    const res = await api.get('/monthly_bills')
    bills.value = Array.isArray(res.data) ? res.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách hóa đơn.'
  }
}

const filteredBills = computed(() =>
  bills.value.filter((item) =>
    !searchQuery.value ||
    String(item.bill_code).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(item.billing_month).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const createBill = async () => {
  if (!form.value.bill_code.trim() || !form.value.room_id || !form.value.billing_month) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập mã hóa đơn, phòng và tháng.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/monthly_bills', { monthly_bill: form.value })
    await loadBills()
    messageType.value = 'success'
    message.value = 'Tạo hóa đơn thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo hóa đơn.'
  } finally {
    loading.value = false
  }
}

const generateBill = async () => {
  if (!form.value.room_id || !form.value.billing_month) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập phòng và tháng để sinh hóa đơn.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/monthly_bills/generate', { monthly_bill: form.value })
    await loadBills()
    messageType.value = 'success'
    message.value = 'Sinh hóa đơn nhanh thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể sinh hóa đơn.'
  } finally {
    loading.value = false
  }
}

const deleteBill = async (id) => {
  await api.delete(`/monthly_bills/${id}`)
  await loadBills()
}

onMounted(loadBills)
</script>
