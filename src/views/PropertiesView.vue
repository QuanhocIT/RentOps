<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <div class="max-w-6xl mx-auto mb-6 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900">Khu trọ</h1>
        <p class="text-sm text-slate-500">Quản lý tòa nhà, dãy trọ và cụm phòng</p>
      </div>
      <RouterLink to="/" class="px-4 py-2 rounded-lg bg-slate-900 text-white text-sm">Về dashboard</RouterLink>
    </div>

    <div class="max-w-6xl mx-auto grid gap-6 md:grid-cols-[380px_1fr]">
      <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4" @submit.prevent="createProperty">
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-2">Tên khu trọ</label>
          <input v-model="form.name" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Tòa nhà A" />
        </div>
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-2">Địa chỉ</label>
          <input v-model="form.address" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Hà Nội" />
        </div>
        <button class="w-full rounded-xl bg-indigo-600 text-white py-3 font-semibold" :disabled="loading">
          {{ loading ? 'Đang lưu...' : 'Tạo khu trọ' }}
        </button>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách khu trọ</h2>
          <button class="text-sm text-indigo-600" @click="loadProperties">Tải lại</button>
        </div>
        <div class="space-y-3">
          <div v-for="item in properties" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex justify-between">
            <div>
              <div class="font-semibold text-slate-900">{{ item.name }}</div>
              <div class="text-sm text-slate-500">{{ item.address || 'Chưa có địa chỉ' }}</div>
            </div>
            <div class="text-xs text-slate-400">#{{ item.id }}</div>
          </div>
          <p v-if="!properties.length" class="text-sm text-slate-500">Chưa có khu trọ nào.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const properties = ref([])
const loading = ref(false)
const form = ref({ name: '', address: '' })

const loadProperties = async () => {
  const res = await api.get('/properties')
  properties.value = res.data || []
}

const createProperty = async () => {
  loading.value = true
  try {
    await api.post('/properties', { property: form.value })
    form.value = { name: '', address: '' }
    await loadProperties()
  } finally {
    loading.value = false
  }
}

onMounted(loadProperties)
</script>
