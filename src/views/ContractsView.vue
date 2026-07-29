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
        <p v-if="message" :class="['text-sm rounded-xl px-4 py-3', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
          {{ message }}
        </p>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách hợp đồng</h2>
          <div class="flex items-center gap-3">
            <input v-model="searchQuery" class="w-56 rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Tìm hợp đồng..." />
            <button class="text-sm text-indigo-600" @click="loadContracts">Tải lại</button>
          </div>
        </div>
        <div class="space-y-3">
          <div v-for="item in filteredContracts" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex items-start justify-between gap-3">
            <div class="font-semibold text-slate-900">{{ item.contract_code }}</div>
            <div class="text-sm text-slate-500">Room #{{ item.room_id }} | Trạng thái: {{ item.status }}</div>
            <div class="flex flex-col gap-2">
              <button class="text-xs text-indigo-600" @click="checkoutContract(item.id)">Checkout</button>
              <button class="text-xs text-rose-600" @click="deleteContract(item.id)">Xóa</button>
            </div>
          </div>
          <p v-if="!filteredContracts.length" class="text-sm text-slate-500">Chưa có hợp đồng nào phù hợp.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const contracts = ref([])
const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const form = ref({
  contract_code: '',
  room_id: '',
  renter_id: '',
  start_date: '',
  monthly_rent: '',
  deposit_amount: ''
})

const loadContracts = async () => {
  try {
    const res = await api.get('/contracts')
    contracts.value = Array.isArray(res.data) ? res.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách hợp đồng.'
  }
}

const filteredContracts = computed(() =>
  contracts.value.filter((item) =>
    !searchQuery.value ||
    String(item.contract_code).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(item.room_id).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const createContract = async () => {
  if (!form.value.contract_code.trim() || !form.value.room_id || !form.value.start_date) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập mã hợp đồng, phòng và ngày bắt đầu.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/contracts', { contract: form.value })
    await loadContracts()
    messageType.value = 'success'
    message.value = 'Tạo hợp đồng thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo hợp đồng.'
  } finally {
    loading.value = false
  }
}

const checkoutContract = async (id) => {
  await api.post(`/contracts/${id}/checkout`)
  await loadContracts()
}

const deleteContract = async (id) => {
  await api.delete(`/contracts/${id}`)
  await loadContracts()
}

onMounted(loadContracts)
</script>
