<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white/90 backdrop-blur-md p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div>
          <h1 class="text-2xl font-black text-slate-900 tracking-tight flex items-center gap-2">
            <span>🏛️</span> Khu Trọ & Tòa Nhà
          </h1>
          <p class="text-slate-500 text-xs mt-1 font-medium">Quản lý các tòa nhà, dãy nhà trọ và địa chỉ cụm cho thuê</p>
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-[380px_1fr]">
        <form class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4 h-fit" @submit.prevent="createProperty">
          <h3 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-3">Thêm Tòa Nhà Mới</h3>
          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên Tòa Nhà / Dãy Trọ</label>
            <input v-model="form.name" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="VD: Tòa Nhà A - Nam Từ Liêm" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Địa Chỉ Chi Tiết</label>
            <input v-model="form.address" required class="w-full rounded-xl border border-slate-300 px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội" />
          </div>
          <button class="w-full rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white py-3 font-semibold text-sm shadow-md shadow-indigo-600/30 transition" :disabled="loading">
            {{ loading ? 'Đang lưu...' : 'Tạo tòa nhà mới' }}
          </button>
          <p v-if="message" :class="['text-xs rounded-xl px-4 py-2.5 font-medium', messageType === 'error' ? 'bg-rose-50 text-rose-700' : 'bg-emerald-50 text-emerald-700']">
            {{ message }}
          </p>
        </form>

        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b border-slate-100 pb-3">
            <h2 class="font-bold text-slate-900 text-lg">Danh Sách Tòa Nhà ({{ properties.length }})</h2>
            <div class="flex items-center gap-3">
              <input v-model="searchQuery" class="w-64 rounded-xl border border-slate-300 px-3.5 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm theo tên hoặc địa chỉ..." />
              <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200" @click="loadProperties">🔄</button>
            </div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div v-for="item in filteredProperties" :key="item.id" class="rounded-2xl border border-slate-200 p-5 hover:shadow-md transition bg-slate-50/60 flex flex-col justify-between space-y-4">
              <div>
                <div class="flex items-center justify-between">
                  <h3 class="font-bold text-slate-900 text-lg">🏛️ {{ item.name }}</h3>
                  <span class="px-2 py-0.5 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 uppercase">Multi-Tenant</span>
                </div>
                <div class="text-xs text-slate-500 mt-1.5 flex items-center gap-1">
                  <span>📍</span> <span>{{ item.address || 'Chưa cập nhật địa chỉ' }}</span>
                </div>
              </div>

              <div class="space-y-1.5 border-t border-slate-200 pt-3">
                <div class="flex justify-between text-xs text-slate-600 font-medium">
                  <span>Tỷ lệ lấp đầy phòng:</span>
                  <span class="font-bold text-indigo-600">85%</span>
                </div>
                <div class="w-full h-2 rounded-full bg-slate-200 overflow-hidden">
                  <div class="h-full bg-gradient-to-r from-indigo-500 to-emerald-500 w-[85%] rounded-full"></div>
                </div>
              </div>

              <div class="flex items-center justify-end gap-2">
                <button class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg" @click="deleteProperty(item.id)">
                  Xóa tòa nhà
                </button>
              </div>
            </div>
          </div>
          <p v-if="!filteredProperties.length" class="text-sm text-slate-500 py-8 text-center">Chưa có tòa nhà nào phù hợp.</p>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
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
  if (!confirm('Bạn có chắc muốn xóa tòa nhà này?')) return
  await api.delete(`/properties/${id}`)
  await loadProperties()
}

onMounted(loadProperties)
</script>
