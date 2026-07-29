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
        <p v-if="message" :class="['text-sm rounded-xl px-4 py-3', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
          {{ message }}
        </p>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách khu trọ</h2>
          <div class="flex items-center gap-3">
            <input v-model="searchQuery" class="w-56 rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Tìm khu trọ..." />
            <button class="text-sm text-indigo-600" @click="loadProperties">Tải lại</button>
          </div>
        </div>
        <div class="space-y-3">
          <div v-for="item in filteredProperties" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex justify-between items-start gap-3">
            <div>
              <div class="font-semibold text-slate-900">{{ item.name }}</div>
              <div class="text-sm text-slate-500">{{ item.address || 'Chưa có địa chỉ' }}</div>
            </div>
            <div class="flex items-center gap-3">
              <div class="text-xs text-slate-400">#{{ item.id }}</div>
              <button class="text-xs text-rose-600" @click="deleteProperty(item.id)">Xóa</button>
            </div>
          </div>
          <p v-if="!filteredProperties.length" class="text-sm text-slate-500">Chưa có khu trọ nào phù hợp.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const properties = ref([])
const loading = ref(false)
const form = ref({ name: '', address: '' })
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')

const filteredProperties = computed(() =>
  properties.value.filter((item) =>
    !searchQuery.value ||
    String(item.name).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(item.address || '').toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const loadProperties = async () => {
  try {
    const res = await api.get('/properties')
    properties.value = Array.isArray(res.data) ? res.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách khu trọ.'
  }
}

const createProperty = async () => {
  if (!form.value.name.trim()) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập tên khu trọ.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/properties', { property: form.value })
    form.value = { name: '', address: '' }
    await loadProperties()
    messageType.value = 'success'
    message.value = 'Tạo khu trọ thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo khu trọ.'
  } finally {
    loading.value = false
  }
}

const deleteProperty = async (id) => {
  await api.delete(`/properties/${id}`)
  await loadProperties()
}

onMounted(loadProperties)
</script>
