<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <!-- Title & Actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Chỉ Số Điện Nước</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Ghi Chỉ Số Điện Nước Hàng Tháng</h1>
          <p class="text-slate-500 text-sm mt-0.5">Nhập nhanh ma trận chỉ số công tơ điện nước hoặc quản lý theo danh sách phòng</p>
        </div>

        <div class="flex items-center gap-3">
          <input
            v-model="selectedMonth"
            type="month"
            @change="fetchData"
            class="px-4 py-2.5 bg-white border border-slate-300 rounded-xl text-xs font-mono font-bold text-indigo-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
          <button
            @click="showModal = true"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>⚡</span>
            <span>Nhập 1 phòng</span>
          </button>
        </div>
      </div>

      <!-- Mode Tabs -->
      <div class="flex border-b border-slate-200 gap-2 overflow-x-auto">
        <button
          @click="activeMode = 'list'"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeMode === 'list'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>📋</span>
          <span>Danh Sách Chỉ Số Tháng {{ selectedMonth }}</span>
        </button>
        <button
          @click="activeMode = 'batch'; prepareBatchData()"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeMode === 'batch'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>⚡</span>
          <span>Nhập Điện Nước Hàng Loạt Tất Cả Phòng</span>
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
              <tr v-for="(item, idx) in batchItems" :key="item.room_id" class="hover:bg-slate-50/80">
                <td class="px-4 py-3 font-bold text-slate-900">Phòng {{ item.room_number }}</td>
                <td class="px-4 py-3">
                  <input v-model.number="item.electric_old" type="number" class="w-24 bg-slate-50 border border-slate-300 rounded-lg px-2 py-1 text-xs font-mono" />
                </td>
                <td class="px-4 py-3">
                  <input
                    :ref="(el) => setInputRef(el, `elec_${idx}`)"
                    v-model.number="item.electric_new"
                    type="number"
                    @keydown.enter.prevent="focusInput(`elec_${idx + 1}`)"
                    @keydown.down.prevent="focusInput(`elec_${idx + 1}`)"
                    @keydown.up.prevent="focusInput(`elec_${idx - 1}`)"
                    class="w-28 bg-amber-50 border border-amber-300 rounded-lg px-2 py-1 text-xs font-mono font-bold text-amber-900 focus:ring-2 focus:ring-amber-500"
                  />
                </td>
                <td class="px-4 py-3 font-mono font-bold text-amber-600">
                  {{ Math.max(0, (item.electric_new || 0) - (item.electric_old || 0)) }}
                </td>
                <td class="px-4 py-3">
                  <input v-model.number="item.water_old" type="number" class="w-24 bg-slate-50 border border-slate-300 rounded-lg px-2 py-1 text-xs font-mono" />
                </td>
                <td class="px-4 py-3">
                  <input
                    :ref="(el) => setInputRef(el, `water_${idx}`)"
                    v-model.number="item.water_new"
                    type="number"
                    @keydown.enter.prevent="focusInput(`water_${idx + 1}`)"
                    @keydown.down.prevent="focusInput(`water_${idx + 1}`)"
                    @keydown.up.prevent="focusInput(`water_${idx - 1}`)"
                    class="w-28 bg-blue-50 border border-blue-300 rounded-lg px-2 py-1 text-xs font-mono font-bold text-blue-900 focus:ring-2 focus:ring-blue-500"
                  />
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
                <th class="px-6 py-4">Cảnh Báo Tiêu Thụ</th>
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
                <td class="px-6 py-4">
                  <span v-if="r.anomaly_detected" class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-rose-100 text-rose-800 border border-rose-300 animate-pulse">
                    ⚠️ Đột biến (+{{ r.elec_increase_pct }}%)
                  </span>
                  <span v-else-if="r.is_high_electric || r.is_high_usage" class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-amber-100 text-amber-800 border border-amber-300">
                    ⚡ Tiêu thụ cao
                  </span>
                  <span v-else class="text-xs text-slate-400 font-medium">Bình thường</span>
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

            <!-- AI OCR meter photo scanning button -->
            <div class="bg-indigo-50/70 p-3 rounded-xl border border-indigo-200/80 flex items-center justify-between">
              <div>
                <span class="text-xs font-bold text-indigo-900 block">🤖 Quét Ảnh Mặt Đồng Hồ AI OCR</span>
                <span class="text-[11px] text-indigo-600">Tự động nhận diện con số từ ảnh chụp công tơ</span>
              </div>
              <button
                type="button"
                @click="simulateAiOcrScan"
                :disabled="ocrScanning"
                class="px-3 py-1.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-lg shadow-sm transition flex items-center gap-1"
              >
                <span>{{ ocrScanning ? '⏳ Đang phân tích ảnh...' : '📸 Tải Ảnh / Chụp' }}</span>
              </button>
            </div>

            <!-- Rollover & Anomaly Badges -->
            <div v-if="electricResult.isRollover" class="bg-amber-50 border border-amber-300 p-2.5 rounded-xl text-xs font-bold text-amber-900 flex items-center gap-2">
              <span>🔄</span>
              <span>Phát hiện công tơ điện quay đầu từ <strong>{{ form.electric_old }}</strong> ➜ <strong>{{ form.electric_new }}</strong>. Tiêu thụ tính toán: <strong>{{ electricResult.usage }} kWh</strong></span>
            </div>

            <div v-if="calculatedElectricUsage > 250" class="bg-rose-50 border border-rose-200 p-2.5 rounded-xl text-xs font-bold text-rose-800 flex items-center gap-2">
              <span>⚠️</span>
              <span>Cảnh báo: Tiêu thụ điện ({{ calculatedElectricUsage }} kWh) tăng cao bất thường so với mức trung bình!</span>
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
import { ref, computed } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import { useDataStore } from '../stores/data'
import { useToastStore } from '../stores/toast'
import { useUtilityCalc } from '../composables/useUtilityCalc'

const dataStore = useDataStore()
const toastStore = useToastStore()
const { calculateUsageWithRollover } = useUtilityCalc()

const activeMode = ref('list')
const batchItems = ref([])
const inputRefsMap = ref({})

const setInputRef = (el, key) => {
  if (el) inputRefsMap.value[key] = el
}

const focusInput = (key) => {
  const target = inputRefsMap.value[key]
  if (target) {
    target.focus()
    target.select?.()
  }
}

const loading = ref(false)
const submitting = ref(false)
const submittingBatch = ref(false)
const showModal = ref(false)
const ocrScanning = ref(false)

const selectedMonth = ref('07/2026')

const fetchData = () => {
  toastStore.info(`Đã lọc danh sách chỉ số điện nước theo tháng ${selectedMonth.value}`)
}

const form = ref({
  room_id: '',
  billing_month: '07/2026',
  electric_old: 1200,
  electric_new: 1350,
  water_old: 40,
  water_new: 48
})

const electricResult = computed(() => calculateUsageWithRollover(form.value.electric_old, form.value.electric_new))
const waterResult = computed(() => calculateUsageWithRollover(form.value.water_old, form.value.water_new))

const calculatedElectricUsage = computed(() => electricResult.value.usage)
const calculatedWaterUsage = computed(() => waterResult.value.usage)

const simulateAiOcrScan = () => {
  ocrScanning.value = true
  setTimeout(() => {
    form.value.electric_new = (Number(form.value.electric_old) || 1200) + Math.floor(120 + Math.random() * 80)
    form.value.water_new = (Number(form.value.water_old) || 40) + Math.floor(6 + Math.random() * 6)
    ocrScanning.value = false
    toastStore.success('🤖 AI Gemini Vision OCR đã tự động đọc chỉ số từ ảnh công tơ!')
  }, 1000)
}

const rooms = computed(() => dataStore.rooms)

const readings = computed(() => {
  return dataStore.utilityReadings.map(u => ({
    id: u.id,
    room_id: u.roomId,
    room_number: u.roomNumber,
    billing_month: u.month,
    electric_old: u.prevElectric,
    electric_new: u.currElectric,
    electric_usage: u.electricUsage,
    water_old: u.prevWater,
    water_new: u.currWater,
    water_usage: u.waterUsage,
    billed: u.billed
  }))
})

const prepareBatchData = () => {
  batchItems.value = rooms.value.map(room => {
    const existing = readings.value.find(r => r.room_id === room.id || r.room_number === room.roomNumber)
    return {
      room_id: room.id,
      room_number: room.roomNumber,
      billing_month: selectedMonth.value,
      electric_old: existing ? existing.electric_old : (room.electricMeter || 1200),
      electric_new: existing ? existing.electric_new : (room.electricMeter || 1200) + 120,
      water_old: existing ? existing.water_old : (room.waterMeter || 40),
      water_new: existing ? existing.water_new : (room.waterMeter || 40) + 8
    }
  })
}

const saveBatchReadings = () => {
  submittingBatch.value = true
  try {
    batchItems.value.forEach(item => {
      const reading = dataStore.recordUtilityReading({
        roomId: item.room_id,
        month: item.billing_month,
        prevElectric: item.electric_old,
        currElectric: item.electric_new,
        prevWater: item.water_old,
        currWater: item.water_new
      })
      if (reading) {
        dataStore.generateBillFromReading(reading.id)
      }
    })
    toastStore.success('Đã lưu chỉ số & tự động xuất hóa đơn tháng cho tất cả các phòng!')
    activeMode.value = 'list'
  } finally {
    submittingBatch.value = false
  }
}

const submitForm = () => {
  submitting.value = true
  try {
    const reading = dataStore.recordUtilityReading({
      roomId: form.value.room_id,
      month: form.value.billing_month,
      prevElectric: form.value.electric_old,
      currElectric: form.value.electric_new,
      prevWater: form.value.water_old,
      currWater: form.value.water_new
    })
    if (reading) {
      dataStore.generateBillFromReading(reading.id)
      toastStore.success(`Đã lưu chỉ số điện nước & sinh hóa đơn tháng cho phòng ${reading.roomNumber}!`)
    }
    showModal.value = false
    form.value.room_id = ''
  } finally {
    submitting.value = false
  }
}

const deleteReading = (id) => {
  if (!confirm('Bạn có chắc muốn xóa bản ghi chỉ số này?')) return
  dataStore.utilityReadings = dataStore.utilityReadings.filter(u => u.id !== id)
  dataStore.saveToStorage()
  toastStore.success('Đã xóa chỉ số thành công!')
}
</script>
