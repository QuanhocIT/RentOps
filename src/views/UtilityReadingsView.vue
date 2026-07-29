<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
      <!-- Title & Actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white/90 backdrop-blur-md p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div>
          <h1 class="text-2xl font-black text-slate-900 tracking-tight flex items-center gap-2">
            <span>⚡</span> Quản Lý Chỉ Số Điện Nước
          </h1>
          <p class="text-slate-500 text-xs mt-1 font-medium">Nhập nhanh ma trận chỉ số công tơ điện nước hoặc quản lý danh sách phòng</p>
        </div>

        <div class="flex items-center gap-3">
          <input
            v-model="selectedMonth"
            type="month"
            @change="fetchData"
            class="px-4 py-2 bg-white border border-slate-300 rounded-xl text-sm font-bold text-indigo-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
          <button
            @click="showModal = true"
            class="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-sm shadow-lg shadow-indigo-600/30 transition"
          >
            <span>⚡</span> Nhập 1 phòng
          </button>
        </div>
      </div>

      <!-- Mode Tabs -->
      <div class="flex space-x-2 bg-slate-200/60 p-1.5 rounded-xl w-fit">
        <button
          @click="activeMode = 'list'"
          :class="activeMode === 'list' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition"
        >
          📋 Danh Sách Chỉ Số Tháng {{ selectedMonth }}
        </button>
        <button
          @click="activeMode = 'batch'; prepareBatchData()"
          :class="activeMode === 'batch' ? 'bg-white text-indigo-600 font-bold shadow-sm' : 'text-slate-600 hover:text-slate-900'"
          class="px-4 py-2 text-xs rounded-lg transition flex items-center space-x-1"
        >
          <span>⚡ Nhập Điện Nước Hàng Loạt Tất Cả Phòng</span>
        </button>
      </div>

      <!-- BATCH MATRIX INPUT TABLE -->
      <div v-if="activeMode === 'batch'" class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
        <div class="flex justify-between items-center border-b border-slate-100 pb-3">
          <div>
            <h3 class="font-bold text-slate-900 text-base">⚡ Bảng Ma Trận Nhập Nhanh Điện Nước Kỳ {{ selectedMonth }}</h3>
            <p class="text-xs text-slate-500">Nhập trực tiếp số điện/nước mới cho tất cả các phòng và nhấn Lưu</p>
          </div>
          <button
            @click="saveBatchReadings"
            :disabled="submittingBatch"
            class="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs rounded-xl shadow-lg transition"
          >
            {{ submittingBatch ? 'Đang lưu...' : '✓ Lưu Tất Cả Chỉ Số Phòng' }}
          </button>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-4 py-3">Phòng</th>
                <th class="px-4 py-3">Điện cũ</th>
                <th class="px-4 py-3">Điện mới (kWh)</th>
                <th class="px-4 py-3">⚡ Dùng (kWh)</th>
                <th class="px-4 py-3">Nước cũ</th>
                <th class="px-4 py-3">Nước mới (m³)</th>
                <th class="px-4 py-3">💧 Dùng (m³)</th>
                <th class="px-4 py-3">Cảnh báo</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="item in batchItems" :key="item.room_id" class="hover:bg-slate-50/80">
                <td class="px-4 py-3 font-bold text-slate-900">Phòng {{ item.room_number }}</td>
                <td class="px-4 py-3">
                  <input v-model.number="item.electric_old" type="number" class="w-24 bg-slate-50 border border-slate-300 rounded-lg px-2 py-1 text-xs font-mono" />
                </td>
                <td class="px-4 py-3">
                  <input v-model.number="item.electric_new" type="number" class="w-28 bg-amber-50 border border-amber-300 rounded-lg px-2 py-1 text-xs font-mono font-bold text-amber-900" />
                </td>
                <td class="px-4 py-3 font-mono font-bold text-amber-600">
                  {{ Math.max(0, (item.electric_new || 0) - (item.electric_old || 0)) }}
                </td>
                <td class="px-4 py-3">
                  <input v-model.number="item.water_old" type="number" class="w-24 bg-slate-50 border border-slate-300 rounded-lg px-2 py-1 text-xs font-mono" />
                </td>
                <td class="px-4 py-3">
                  <input v-model.number="item.water_new" type="number" class="w-28 bg-blue-50 border border-blue-300 rounded-lg px-2 py-1 text-xs font-mono font-bold text-blue-900" />
                </td>
                <td class="px-4 py-3 font-mono font-bold text-blue-600">
                  {{ Math.max(0, (item.water_new || 0) - (item.water_old || 0)) }}
                </td>
                <td class="px-4 py-3 text-xs font-bold">
                  <span v-if="(item.electric_new - item.electric_old) > 250" class="text-rose-600 bg-rose-50 px-2 py-0.5 rounded border border-rose-200">
                    ⚡ Tiêu thụ cao
                  </span>
                  <span v-else-if="(item.water_new - item.water_old) > 15" class="text-amber-600 bg-amber-50 px-2 py-0.5 rounded border border-amber-200">
                    💧 Nước tăng cao
                  </span>
                  <span v-else class="text-slate-400 font-normal">Bình thường</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Readings Table -->
      <div v-else class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div v-if="loading" class="p-8 text-center text-slate-500">
          Đang tải dữ liệu chỉ số điện nước...
        </div>

        <div v-else-if="readings.length === 0" class="p-12 text-center text-slate-500">
          Chưa có chỉ số điện nước nào được ghi cho kỳ <span class="font-bold text-slate-700">{{ selectedMonth }}</span>.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Phòng</th>
                <th class="px-6 py-4">Kỳ thanh toán</th>
                <th class="px-6 py-4">Chỉ số Điện (Cũ ➔ Mới)</th>
                <th class="px-6 py-4">Điện Tiêu Thụ</th>
                <th class="px-6 py-4">Chỉ số Nước (Cũ ➔ Mới)</th>
                <th class="px-6 py-4">Nước Tiêu Thụ</th>
                <th class="px-6 py-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="r in readings" :key="r.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">
                  Phòng {{ r.room_number || r.room_id }}
                </td>
                <td class="px-6 py-4 text-slate-500 font-mono">{{ r.billing_month }}</td>
                <td class="px-6 py-4">
                  <span class="font-mono text-slate-500">{{ r.electric_old }}</span>
                  <span class="mx-1 text-slate-300">➔</span>
                  <span class="font-mono font-bold text-amber-600">{{ r.electric_new }}</span>
                </td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-1 rounded-lg bg-amber-50 text-amber-700 font-bold font-mono">
                    ⚡ {{ r.electric_usage || (r.electric_new - r.electric_old) }} kWh
                  </span>
                </td>
                <td class="px-6 py-4">
                  <span class="font-mono text-slate-500">{{ r.water_old }}</span>
                  <span class="mx-1 text-slate-300">➔</span>
                  <span class="font-mono font-bold text-blue-600">{{ r.water_new }}</span>
                </td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-1 rounded-lg bg-blue-50 text-blue-700 font-bold font-mono">
                    💧 {{ r.water_usage || (r.water_new - r.water_old) }} m³
                  </span>
                </td>
                <td class="px-6 py-4 text-right">
                  <button
                    @click="deleteReading(r.id)"
                    class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1 rounded-lg hover:bg-rose-100 transition"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add Reading Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Ghi Chỉ Số Điện Nước Mới</h3>
            <button @click="showModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="submitForm" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn phòng trọ</label>
              <select
                v-model="form.room_id"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              >
                <option value="" disabled>-- Chọn phòng --</option>
                <option v-for="room in rooms" :key="room.id" :value="room.id">
                  Phòng {{ room.room_number }} ({{ room.property_name }})
                </option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Kỳ thanh toán (Tháng)</label>
              <input
                v-model="form.billing_month"
                type="month"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-amber-700 uppercase mb-1">Điện cũ (kWh)</label>
                <input
                  v-model.number="form.electric_old"
                  type="number"
                  min="0"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-amber-700 uppercase mb-1">Điện mới (kWh)</label>
                <input
                  v-model.number="form.electric_new"
                  type="number"
                  min="0"
                  required
                  class="w-full px-3 py-2 bg-amber-50/50 border border-amber-300 rounded-xl text-sm font-bold focus:bg-white"
                />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-blue-700 uppercase mb-1">Nước cũ (m³)</label>
                <input
                  v-model.number="form.water_old"
                  type="number"
                  min="0"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-blue-700 uppercase mb-1">Nước mới (m³)</label>
                <input
                  v-model.number="form.water_new"
                  type="number"
                  min="0"
                  required
                  class="w-full px-3 py-2 bg-blue-50/50 border border-blue-300 rounded-xl text-sm font-bold focus:bg-white"
                />
              </div>
            </div>

            <div class="bg-indigo-50 p-3 rounded-xl border border-indigo-100 flex items-center justify-between text-sm text-indigo-900 font-semibold">
              <span>⚡ Điện tiêu thụ: <strong class="text-amber-600 font-mono">{{ calculatedElectricUsage }} kWh</strong></span>
              <span>💧 Nước tiêu thụ: <strong class="text-blue-600 font-mono">{{ calculatedWaterUsage }} m³</strong></span>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="showModal = false"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submitting"
                class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30"
              >
                {{ submitting ? 'Đang lưu...' : 'Lưu chỉ số' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const activeMode = ref('list')
const batchItems = ref([])
const loading = ref(false)
const submitting = ref(false)
const submittingBatch = ref(false)
const showModal = ref(false)

const readings = ref([])
const rooms = ref([])
const selectedMonth = ref(new Date().toISOString().slice(0, 7))

const form = ref({
  room_id: '',
  billing_month: selectedMonth.value,
  electric_old: 1200,
  electric_new: 1350,
  water_old: 40,
  water_new: 48
})

const calculatedElectricUsage = computed(() => Math.max(0, (form.value.electric_new || 0) - (form.value.electric_old || 0)))
const calculatedWaterUsage = computed(() => Math.max(0, (form.value.water_new || 0) - (form.value.water_old || 0)))

const prepareBatchData = () => {
  batchItems.value = rooms.value.map(room => {
    const existing = readings.value.find(r => r.room_id === room.id || r.room_number === room.room_number)
    return {
      room_id: room.id,
      room_number: room.room_number,
      billing_month: selectedMonth.value,
      electric_old: existing ? existing.electric_old : 1200,
      electric_new: existing ? existing.electric_new : 1350,
      water_old: existing ? existing.water_old : 40,
      water_new: existing ? existing.water_new : 48
    }
  })
}

const saveBatchReadings = async () => {
  submittingBatch.value = true
  try {
    const res = await api.post('/utility_readings/batch_create', { readings: batchItems.value })
    alert(res?.message || 'Lưu chỉ số hàng loạt thành công!')
    activeMode.value = 'list'
    fetchData()
  } catch (err) {
    alert(err?.message || 'Lỗi lưu chỉ số hàng loạt')
  } finally {
    submittingBatch.value = false
  }
}

const fetchData = async () => {
  loading.value = true
  try {
    const [resReadings, resRooms] = await Promise.all([
      api.get(`/utility_readings?billing_month=${selectedMonth.value}`),
      api.get('/rooms')
    ])
    readings.value = Array.isArray(resReadings?.data) ? resReadings.data : []
    rooms.value = Array.isArray(resRooms?.data) ? resRooms.data : []
  } catch (err) {
    console.warn('API error fetching utility readings:', err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)

const submitForm = async () => {
  submitting.value = true
  try {
    await api.post('/utility_readings', { utility_reading: form.value })
    showModal.value = false
    form.value.room_id = ''
    fetchData()
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra khi lưu chỉ số')
  } finally {
    submitting.value = false
  }
}

const deleteReading = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa bản ghi chỉ số này?')) return
  try {
    await api.delete(`/utility_readings/${id}`)
    fetchData()
  } catch (err) {
    alert(err?.message || 'Không thể xóa chỉ số')
  }
}
</script>
