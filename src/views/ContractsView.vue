<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <div class="max-w-6xl mx-auto mb-6 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900">Hợp đồng</h1>
        <p class="text-sm text-slate-500">Tạo và quản lý hợp đồng thuê</p>
      </div>
      <RouterLink to="/" class="px-4 py-2 rounded-lg bg-slate-900 text-white text-sm">Về dashboard</RouterLink>
    </div>

    <div class="max-w-6xl mx-auto grid gap-6 md:grid-cols-[380px_1fr]">
      <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4" @submit.prevent="createContract">
        <input v-model="form.contract_code" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Mã hợp đồng" />
        <input v-model="form.room_id" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Room ID" />
        <input v-model="form.renter_id" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Renter ID" />
        <input v-model="form.start_date" type="date" class="w-full rounded-xl border border-slate-300 px-4 py-3" />
        <div class="grid grid-cols-2 gap-3">
          <input v-model="form.monthly_rent" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Tiền thuê" />
          <input v-model="form.deposit_amount" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Đặt cọc" />
        </div>
        <button class="w-full rounded-xl bg-indigo-600 text-white py-3 font-semibold" :disabled="loading">
          {{ loading ? 'Đang lưu...' : 'Tạo hợp đồng' }}
        </button>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách hợp đồng</h2>
          <button class="text-sm text-indigo-600" @click="loadContracts">Tải lại</button>
        </div>
        <div class="space-y-3">
          <div v-for="item in contracts" :key="item.id" class="rounded-xl border border-slate-200 p-4">
            <div class="font-semibold text-slate-900">{{ item.contract_code }}</div>
            <div class="text-sm text-slate-500">Room #{{ item.room_id }} | Trạng thái: {{ item.status }}</div>
          </div>
          <p v-if="!contracts.length" class="text-sm text-slate-500">Chưa có hợp đồng nào.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const contracts = ref([])
const loading = ref(false)
const form = ref({
  contract_code: '',
  room_id: '',
  renter_id: '',
  start_date: '',
  monthly_rent: '',
  deposit_amount: ''
})

const loadContracts = async () => {
  const res = await api.get('/contracts')
  contracts.value = res.data || []
}

const createContract = async () => {
  loading.value = true
  try {
    await api.post('/contracts', { contract: form.value })
    await loadContracts()
  } finally {
    loading.value = false
  }
}

onMounted(loadContracts)
</script>
