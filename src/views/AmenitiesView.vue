<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Danh Mục Tiện Ích & Nội Thất</h1>
          <p class="text-slate-500 text-sm mt-0.5">Quản lý các trang thiết bị đính kèm từng phòng trọ (Điều hòa, Tủ lạnh, Giường, Máy giặt)</p>
        </div>

        <button
          @click="showModal = true"
          class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
        >
          <span>🛋️</span> Thêm tiện ích mới
        </button>
      </div>

      <!-- Amenities Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
        <div v-for="item in amenities" :key="item.id" class="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm flex items-center justify-between hover:shadow-md transition">
          <div class="flex items-center gap-3">
            <span class="text-3xl p-2 bg-slate-50 rounded-xl">{{ item.icon || '🛋️' }}</span>
            <div>
              <h3 class="font-bold text-slate-900 text-base">{{ item.name }}</h3>
              <span class="text-xs text-slate-400">Trang bị sẵn</span>
            </div>
          </div>
          <button @click="deleteAmenity(item.id)" class="text-xs text-rose-600 hover:text-rose-800 bg-rose-50 px-2 py-1 rounded-lg">Xóa</button>
        </div>
      </div>

      <!-- Add Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-sm w-full p-6 shadow-2xl space-y-4">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Thêm Tiện Ích Mới</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="createAmenity" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên trang thiết bị</label>
              <input v-model="form.name" required type="text" placeholder="Ví dụ: Điều hòa Inverter 9000BTU" class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Biểu tượng Icon</label>
              <input v-model="form.icon" type="text" placeholder="❄️, 🧊, 🛏️, 🧺..." class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white" />
            </div>

            <div class="flex justify-end gap-3 pt-2">
              <button type="button" @click="showModal = false" class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm">Hủy</button>
              <button type="submit" :disabled="submitting" class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30">
                {{ submitting ? 'Đang lưu...' : 'Lưu tiện ích' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const amenities = ref([])
const showModal = ref(false)
const submitting = ref(false)

const form = ref({ name: '', icon: '🛋️' })

const loadAmenities = async () => {
  try {
    const res = await api.get('/amenities')
    amenities.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) {
    console.warn('Error loading amenities:', err)
  }
}

onMounted(loadAmenities)

const createAmenity = async () => {
  submitting.value = true
  try {
    await api.post('/amenities', { amenity: form.value })
    showModal.value = false
    form.value = { name: '', icon: '🛋️' }
    loadAmenities()
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra')
  } finally {
    submitting.value = false
  }
}

const deleteAmenity = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa tiện ích này?')) return
  try {
    await api.delete(`/amenities/${id}`)
    loadAmenities()
  } catch (err) {
    alert(err?.message || 'Không thể xóa')
  }
}
</script>
