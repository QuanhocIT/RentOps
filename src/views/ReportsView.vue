<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Báo Cáo Tài Chính & Vận Hành</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tổng hợp doanh thu, dòng tiền thực thu, chi phí vận hành và lợi nhuận ròng</p>
        </div>

        <button @click="loadData" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-slate-300 rounded-xl font-semibold text-slate-700 text-sm hover:bg-slate-50 shadow-sm">
          🔄 Cập nhật báo cáo
        </button>
      </div>

      <!-- Financial Metrics Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div class="text-xs uppercase font-bold text-slate-400">Doanh Thu Ước Tính</div>
          <div class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ formatCurrency(financials.monthly_revenue_estimate) }}</div>
          <p class="text-xs text-slate-500 mt-1">Tính từ tất cả hợp đồng active</p>
        </div>

        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div class="text-xs uppercase font-bold text-emerald-600">Đã Thu Thực Tế</div>
          <div class="text-2xl font-black text-emerald-600 mt-2 font-mono">{{ formatCurrency(financials.paid_billed) }}</div>
          <p class="text-xs text-emerald-700 mt-1">Hóa đơn đã gạch nợ thành công</p>
        </div>

        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div class="text-xs uppercase font-bold text-rose-600">Tổng Chi Phí Vận Hành</div>
          <div class="text-2xl font-black text-rose-600 mt-2 font-mono">{{ formatCurrency(financials.total_expenses) }}</div>
          <p class="text-xs text-rose-700 mt-1">Điện nước chung, sửa chữa, wifi</p>
        </div>

        <div class="bg-gradient-to-br from-indigo-900 to-slate-900 text-white rounded-2xl p-6 shadow-xl">
          <div class="text-xs uppercase font-bold text-indigo-300">Lợi Nhuận Ròng Ước Tính</div>
          <div class="text-3xl font-black text-white mt-2 font-mono">{{ formatCurrency(financials.net_profit_estimate) }}</div>
          <p class="text-xs text-indigo-200 mt-1">Thực thu trừ tổng chi phí</p>
        </div>
      </div>

      <!-- Visual Progress Charts -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <h3 class="font-bold text-slate-900 text-lg">Tỷ Lệ Thu Hóa Đơn</h3>
          <div class="space-y-2">
            <div class="flex justify-between text-sm font-semibold">
              <span class="text-slate-600">Đã thu ({{ collectionRate }}%)</span>
              <span class="text-emerald-600 font-mono">{{ formatCurrency(financials.paid_billed) }} / {{ formatCurrency(financials.total_billed) }}</span>
            </div>
            <div class="w-full bg-slate-100 h-4 rounded-full overflow-hidden p-0.5 border border-slate-200">
              <div class="bg-emerald-500 h-full rounded-full transition-all duration-500" :style="{ width: `${collectionRate}%` }"></div>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <h3 class="font-bold text-slate-900 text-lg">Tỷ Lệ Lấp Đầy Tòa Nhà</h3>
          <div class="space-y-2">
            <div class="flex justify-between text-sm font-semibold">
              <span class="text-slate-600">Phòng đang ở ({{ counters.occupancy_rate }}%)</span>
              <span class="text-blue-600 font-mono">{{ counters.occupied_rooms }} / {{ counters.total_rooms }} phòng</span>
            </div>
            <div class="w-full bg-slate-100 h-4 rounded-full overflow-hidden p-0.5 border border-slate-200">
              <div class="bg-blue-600 h-full rounded-full transition-all duration-500" :style="{ width: `${counters.occupancy_rate}%` }"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const loading = ref(false)
const financials = ref({
  monthly_revenue_estimate: 0,
  total_billed: 0,
  paid_billed: 0,
  pending_billed: 0,
  total_expenses: 0,
  net_profit_estimate: 0
})

const counters = ref({
  total_rooms: 0,
  occupied_rooms: 0,
  occupancy_rate: 0
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const collectionRate = computed(() => {
  if (!financials.value.total_billed) return 0
  return Math.round((financials.value.paid_billed / financials.value.total_billed) * 100)
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await api.get('/dashboard/summary')
    if (res?.data) {
      financials.value = res.data.financials || {}
      counters.value = res.data.counters || {}
    }
  } catch (err) {
    console.warn('API error fetching summary report:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>
