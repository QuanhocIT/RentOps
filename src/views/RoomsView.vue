<template>
  <div class="min-h-screen bg-slate-50 p-4 md:p-8">
    <div class="max-w-6xl mx-auto mb-6 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900">Phòng</h1>
        <p class="text-sm text-slate-500">Tạo và quản lý phòng trọ</p>
      </div>
      <RouterLink to="/" class="px-4 py-2 rounded-lg bg-slate-900 text-white text-sm">Về dashboard</RouterLink>
    </div>

    <div class="max-w-6xl mx-auto grid gap-6 md:grid-cols-[380px_1fr]">
      <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4" @submit.prevent="createRoom">
        <input v-model="form.property_name" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Tên khu trọ" />
        <input v-model="form.room_number" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Số phòng" />
        <input v-model="form.price" class="w-full rounded-xl border border-slate-300 px-4 py-3" placeholder="Giá thuê" />
        <select v-model="form.status" class="w-full rounded-xl border border-slate-300 px-4 py-3">
          <option value="vacant">Trống</option>
          <option value="occupied">Đang ở</option>
          <option value="reserved">Đã cọc</option>
        </select>
        <button class="w-full rounded-xl bg-indigo-600 text-white py-3 font-semibold" :disabled="loading">
          {{ loading ? 'Đang lưu...' : 'Tạo phòng' }}
        </button>
        <p v-if="message" :class="['text-sm rounded-xl px-4 py-3', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
          {{ message }}
        </p>
      </form>

      <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
          <h2 class="font-semibold text-slate-900">Danh sách phòng</h2>
          <div class="flex items-center gap-3">
            <input v-model="searchQuery" class="w-56 rounded-lg border border-slate-300 px-3 py-2 text-sm" placeholder="Tìm phòng..." />
            <button class="text-sm text-indigo-600" @click="loadRooms">Tải lại</button>
          </div>
        </div>
        <div class="space-y-3">
          <div v-for="item in filteredRooms" :key="item.id" class="rounded-xl border border-slate-200 p-4 flex justify-between items-start gap-3">
            <div>
              <div class="font-semibold text-slate-900">Phòng {{ item.room_number }}</div>
              <div class="text-sm text-slate-500">{{ item.property_name }} | {{ item.status }}</div>
            </div>
            <div class="text-right">
              <div class="text-sm font-semibold text-slate-900">{{ formatCurrency(item.price) }}</div>
              <button class="text-xs text-rose-600 mt-1" @click="deleteRoom(item.id)">Xóa</button>
            </div>
          </div>
          <p v-if="!filteredRooms.length" class="text-sm text-slate-500">Chưa có phòng nào phù hợp.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const rooms = ref([])
const loading = ref(false)
const message = ref('')
const messageType = ref('success')
const searchQuery = ref('')
const form = ref({
  property_name: '',
  room_number: '',
  price: '',
  status: 'vacant'
})

const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value || 0)

const filteredRooms = computed(() =>
  rooms.value.filter((room) =>
    !searchQuery.value ||
    String(room.room_number).toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    String(room.property_name).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
)

const loadRooms = async () => {
  try {
    const res = await api.get('/rooms')
    rooms.value = Array.isArray(res.data) ? res.data : []
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tải danh sách phòng.'
  }
}

const createRoom = async () => {
  if (!form.value.property_name.trim() || !form.value.room_number.trim()) {
    messageType.value = 'error'
    message.value = 'Vui lòng nhập tên khu trọ và số phòng.'
    return
  }

  loading.value = true
  message.value = ''
  try {
    await api.post('/rooms', { room: form.value })
    form.value = { property_name: '', room_number: '', price: '', status: 'vacant' }
    await loadRooms()
    messageType.value = 'success'
    message.value = 'Tạo phòng thành công.'
  } catch (error) {
    messageType.value = 'error'
    message.value = error?.message || 'Không thể tạo phòng.'
  } finally {
    loading.value = false
  }
}

const deleteRoom = async (id) => {
  await api.delete(`/rooms/${id}`)
  await loadRooms()
}

onMounted(loadRooms)
</script>
