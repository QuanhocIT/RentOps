<template>
  <AppLayout>
    <div class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Báo Cáo Tài Chính & Vận Hành</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tổng hợp doanh thu, dòng tiền thực thu, chi phí vận hành và lợi nhuận ròng</p>
        </div>

        <div class="flex items-center space-x-3">
          <button @click="exportCSV" class="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-bold text-sm shadow-sm transition">
            📊 Xuất Báo Cáo Excel/CSV
          </button>
          <button @click="loadData" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-slate-300 rounded-xl font-semibold text-slate-700 text-sm hover:bg-slate-50 shadow-sm">
            🔄 Cập nhật báo cáo
          </button>
        </div>
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

      <!-- Property Performance Breakdown Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex items-center justify-between">
          <h3 class="font-bold text-slate-900 text-lg">Phân Tích Hiệu Quả Theo Tòa Nhà / Cơ Sở</h3>
          <span class="text-xs bg-indigo-50 text-indigo-700 font-bold px-3 py-1 rounded-full uppercase">Property Breakdown</span>
        </div>

        <div v-if="byProperty.length === 0" class="text-slate-400 text-sm py-4 text-center">Chưa có dữ liệu tòa nhà.</div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="py-3 px-4">Tên Tòa Nhà</th>
                <th class="py-3 px-4">Số Phòng / Lấp Đầy</th>
                <th class="py-3 px-4">Doanh Thu Dự Kiến</th>
                <th class="py-3 px-4">Đã Thu Thực Tế</th>
                <th class="py-3 px-4">Chi Phí Vận Hành</th>
                <th class="py-3 px-4 text-right">Lợi Nhuận Ròng</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 font-mono">
              <tr v-for="p in byProperty" :key="p.id" class="hover:bg-slate-50 transition">
                <td class="py-3 px-4 font-bold text-slate-900 font-sans">{{ p.name }}</td>
                <td class="py-3 px-4 font-sans text-xs">
                  <span class="font-bold text-slate-800">{{ p.occupied_rooms }}/{{ p.total_rooms }}</span>
                  <span class="text-slate-400 ml-1">({{ p.occupancy_rate }}%)</span>
                </td>
                <td class="py-3 px-4 text-slate-900">{{ formatCurrency(p.revenue_estimate) }}</td>
                <td class="py-3 px-4 text-emerald-600 font-bold">{{ formatCurrency(p.paid_billed) }}</td>
                <td class="py-3 px-4 text-rose-600">{{ formatCurrency(p.expenses) }}</td>
                <td class="py-3 px-4 text-right font-black" :class="p.net_profit >= 0 ? 'text-indigo-600' : 'text-rose-600'">
                  {{ formatCurrency(p.net_profit) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Expense Categories Breakdown -->
      <div v-if="expenseCategories.length > 0" class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
        <h3 class="font-bold text-slate-900 text-lg">Phân Tốc Chi Phí Vận Hành Theo Danh Mục</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div v-for="cat in expenseCategories" :key="cat.category" class="p-4 bg-slate-50 border border-slate-200 rounded-xl space-y-2">
            <div class="flex justify-between items-center text-sm">
              <span class="font-bold text-slate-800 capitalize">{{ cat.category }}</span>
              <span class="font-mono text-rose-600 font-bold">{{ formatCurrency(cat.amount) }}</span>
            </div>
            <div class="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
              <div class="bg-rose-500 h-full rounded-full" :style="{ width: `${cat.percentage}%` }"></div>
            </div>
            <div class="text-right text-xs text-slate-500 font-mono">{{ cat.percentage }}% tổng chi phí</div>
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

const byProperty = ref([])
const expenseCategories = ref([])

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const exportCSV = () => {
  const rows = [
    ['CHỈ SỐ BÁO CÁO TÀI CHÍNH RENTOPS', 'GIÁ TRỊ'],
    ['Doanh thu ước tính', financials.value.monthly_revenue_estimate],
    ['Đã thu thực tế', financials.value.paid_billed],
    ['Tổng chi phí vận hành', financials.value.total_expenses],
    ['Lợi nhuận ròng', financials.value.net_profit_estimate],
    ['Tổng số phòng', counters.value.total_rooms],
    ['Phòng đang ở', counters.value.occupied_rooms],
    ['Tỷ lệ lấp đầy (%)', counters.value.occupancy_rate + '%']
  ]

  let csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + rows.map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `RentOps_Financial_Report_${new Date().toISOString().slice(0,10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

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
      byProperty.value = res.data.by_property || []
      expenseCategories.value = res.data.expense_categories || []
    }
  } catch (err) {
    console.warn('API error fetching summary report:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>
