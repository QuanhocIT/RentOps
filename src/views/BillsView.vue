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
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách hóa đơn</h2>
          <button class="text-sm text-indigo-600" @click="loadBills">Tải lại</button>
        </div>
        <div class="space-y-3">
          <div v-for="item in bills" :key="item.id" class="rounded-xl border border-slate-200 p-4">
            <div class="font-semibold text-slate-900">{{ item.bill_code }}</div>
            <div class="text-sm text-slate-500">Tháng {{ item.billing_month }} | Trạng thái: {{ item.status }}</div>
          </div>
          <p v-if="!bills.length" class="text-sm text-slate-500">Chưa có hóa đơn nào.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const bills = ref([])
const loading = ref(false)
const form = ref({
  bill_code: '',
  room_id: '',
  contract_id: '',
  billing_month: '',
  total_amount: '',
  due_date: ''
})

const loadBills = async () => {
  const res = await api.get('/monthly_bills')
  bills.value = res.data || []
}

const createBill = async () => {
  loading.value = true
  try {
    await api.post('/monthly_bills', { monthly_bill: form.value })
    await loadBills()
  } finally {
    loading.value = false
  }
}

onMounted(loadBills)
</script>
