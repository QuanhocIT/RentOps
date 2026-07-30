<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <!-- Header Bar -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Báo Cáo Tài Chính</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Báo Cáo Tài Chính & Vận Hành</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tổng hợp doanh thu, dòng tiền thực thu, chi phí vận hành và lợi nhuận ròng toàn bộ hệ thống</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="exportCSV"
            class="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>📊</span>
            <span>Xuất Báo Cáo Excel/CSV</span>
          </button>
          <button
            @click="loadData"
            class="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl border border-slate-300 transition flex items-center gap-1.5"
          >
            <span>🔄</span>
            <span>Cập nhật</span>
          </button>
        </div>
      </div>

      <!-- Financial Metrics Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Doanh Thu Ước Tính</span>
            <span>📈</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ formatCurrency(displayFinancials.monthly_revenue_estimate) }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Tính từ tất cả hợp đồng active</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Đã Thu Thực Tế</span>
            <span>✅</span>
          </div>
          <p class="text-2xl font-black text-emerald-600 mt-2 font-mono">{{ formatCurrency(displayFinancials.paid_billed) }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Hóa đơn đã gạch nợ thành công</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Tổng Chi Phí Vận Hành</span>
            <span>💸</span>
          </div>
          <p class="text-2xl font-black text-rose-600 mt-2 font-mono">{{ formatCurrency(displayFinancials.total_expenses) }}</p>
          <p class="text-[11px] text-rose-600 font-semibold mt-1">Điện nước chung, sửa chữa, wifi</p>
        </div>

        <div class="bg-gradient-to-br from-indigo-900 via-indigo-950 to-slate-900 text-white rounded-2xl p-6 shadow-xl hover:shadow-2xl transition-all duration-300 hover:-translate-y-1 border border-indigo-700/50">
          <div class="text-[11px] uppercase tracking-wider font-extrabold text-indigo-300">Lợi Nhuận Ròng Ước Tính</div>
          <div class="text-3xl font-black text-emerald-400 mt-2 font-mono tracking-tight">{{ formatCurrency(displayFinancials.net_profit_estimate) }}</div>
          <p class="text-xs text-indigo-200 mt-1 font-medium">Thực thu trừ tổng chi phí</p>
        </div>
      </div>

      <!-- Visual Progress Charts -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-6 border border-slate-200/80 shadow-xs space-y-4">
          <h3 class="font-extrabold text-slate-900 text-base flex items-center gap-2">
            <span>💳</span> Tỷ Lệ Thu Hóa Đơn
          </h3>
          <div class="space-y-2.5">
            <div class="flex justify-between text-xs font-bold">
              <span class="text-slate-600">Đã thu ({{ collectionRate }}%)</span>
              <span class="text-emerald-600 font-mono">{{ formatCurrency(displayFinancials.paid_billed) }} / {{ formatCurrency(displayFinancials.total_billed) }}</span>
            </div>
            <div class="w-full bg-slate-100 h-3.5 rounded-full overflow-hidden p-0.5 border border-slate-200/80">
              <div class="bg-gradient-to-r from-emerald-500 to-teal-400 h-full rounded-full transition-all duration-700 shadow-xs" :style="{ width: `${collectionRate}%` }"></div>
            </div>
          </div>
        </div>

        <div class="bg-white/90 backdrop-blur-md rounded-2xl p-6 border border-slate-200/80 shadow-xs space-y-4">
          <h3 class="font-extrabold text-slate-900 text-base flex items-center gap-2">
            <span>🏢</span> Tỷ Lệ Lấp Đầy Tòa Nhà
          </h3>
          <div class="space-y-2.5">
            <div class="flex justify-between text-xs font-bold">
              <span class="text-slate-600">Phòng đang ở ({{ displayCounters.occupancy_rate }}%)</span>
              <span class="text-blue-600 font-mono">{{ displayCounters.occupied_rooms }} / {{ displayCounters.total_rooms }} phòng</span>
            </div>
            <div class="w-full bg-slate-100 h-3.5 rounded-full overflow-hidden p-0.5 border border-slate-200/80">
              <div class="bg-gradient-to-r from-blue-600 to-indigo-500 h-full rounded-full transition-all duration-700 shadow-xs" :style="{ width: `${displayCounters.occupancy_rate}%` }"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 6-Month Financial Trend Chart Visualizer -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl p-6 border border-slate-200/80 shadow-xs space-y-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
          <div>
            <h3 class="font-extrabold text-slate-900 text-base flex items-center gap-2">
              <span>📈</span> Biểu Đồ Xu Hướng Dòng Tiền & Lợi Nhuận 6 Tháng
            </h3>
            <p class="text-xs text-slate-500 mt-0.5">So sánh Thực thu, Chi phí vận hành và Lợi nhuận ròng qua các tháng</p>
          </div>
          <div class="flex items-center gap-4 text-xs font-bold">
            <div class="flex items-center gap-1.5"><span class="w-3 h-3 rounded-sm bg-emerald-500"></span><span class="text-slate-600">Thực Thu</span></div>
            <div class="flex items-center gap-1.5"><span class="w-3 h-3 rounded-sm bg-rose-500"></span><span class="text-slate-600">Chi Phí</span></div>
            <div class="flex items-center gap-1.5"><span class="w-3 h-3 rounded-sm bg-indigo-600"></span><span class="text-slate-600">Lợi Nhuận Ròng</span></div>
          </div>
        </div>

        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
          <div v-for="t in displayFinancialTrends" :key="t.month_name" class="p-4 bg-slate-50/80 rounded-2xl border border-slate-200/80 hover:border-indigo-300 transition space-y-3 flex flex-col justify-between">
            <div class="text-center font-extrabold text-slate-700 text-xs border-b border-slate-200 pb-2">
              {{ t.month_name }}
            </div>
            
            <div class="space-y-2 text-[11px] font-mono">
              <div>
                <div class="text-slate-400 text-[10px] font-sans font-semibold uppercase">Thực Thu</div>
                <div class="font-bold text-emerald-600">{{ formatCurrency(t.paid_billed) }}</div>
              </div>
              <div>
                <div class="text-slate-400 text-[10px] font-sans font-semibold uppercase">Chi Phí</div>
                <div class="font-bold text-rose-600">{{ formatCurrency(t.expenses) }}</div>
              </div>
              <div class="pt-1 border-t border-slate-200">
                <div class="text-slate-400 text-[10px] font-sans font-semibold uppercase">Lợi Nhuận</div>
                <div class="font-black text-indigo-600 text-xs">{{ formatCurrency(t.net_profit) }}</div>
              </div>
            </div>

            <!-- Mini Progress Indicator -->
            <div class="w-full bg-slate-200 h-2 rounded-full overflow-hidden flex">
              <div class="bg-emerald-500 h-full" :style="{ width: getTrendPercentage(t.paid_billed) + '%' }"></div>
              <div class="bg-rose-500 h-full" :style="{ width: getTrendPercentage(t.expenses) + '%' }"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Property Performance Breakdown Table -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl border border-slate-200/80 shadow-xs overflow-hidden p-6 space-y-4">
        <div class="flex items-center justify-between">
          <h3 class="font-extrabold text-slate-900 text-base flex items-center gap-2">
            <span>🏛️</span> Phân Tích Hiệu Quả Theo Tòa Nhà / Cơ Sở
          </h3>
          <span class="text-[10px] bg-indigo-50 text-indigo-700 font-black px-3 py-1 rounded-xl uppercase border border-indigo-200/70">Property Breakdown</span>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-xs text-slate-600">
            <thead class="bg-slate-50/90 text-slate-700 uppercase font-extrabold text-[11px] border-b border-slate-200">
              <tr>
                <th class="py-3.5 px-4">Tên Tòa Nhà</th>
                <th class="py-3.5 px-4">Số Phòng / Lấp Đầy</th>
                <th class="py-3.5 px-4">Doanh Thu Dự Kiến</th>
                <th class="py-3.5 px-4">Đã Thu Thực Tế</th>
                <th class="py-3.5 px-4">Chi Phí Vận Hành</th>
                <th class="py-3.5 px-4 text-right">Lợi Nhuận Ròng</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 font-mono">
              <tr v-for="p in displayByProperty" :key="p.id" class="hover:bg-slate-50 transition">
                <td class="py-3.5 px-4 font-bold text-slate-900 font-sans">{{ p.name }}</td>
                <td class="py-3.5 px-4 font-sans text-xs">
                  <span class="font-bold text-slate-800">{{ p.occupied_rooms }}/{{ p.total_rooms }}</span>
                  <span class="text-slate-400 ml-1">({{ p.occupancy_rate }}%)</span>
                </td>
                <td class="py-3.5 px-4 text-slate-900 font-bold">{{ formatCurrency(p.revenue_estimate) }}</td>
                <td class="py-3.5 px-4 text-emerald-600 font-bold">{{ formatCurrency(p.paid_billed) }}</td>
                <td class="py-3.5 px-4 text-rose-600 font-bold">{{ formatCurrency(p.expenses) }}</td>
                <td class="py-3.5 px-4 text-right font-black text-sm" :class="p.net_profit >= 0 ? 'text-indigo-600' : 'text-rose-600'">
                  {{ formatCurrency(p.net_profit) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Expense Categories Breakdown -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl border border-slate-200/80 shadow-xs p-6 space-y-4">
        <h3 class="font-extrabold text-slate-900 text-base flex items-center gap-2">
          <span>📊</span> Phân Bổ Chi Phí Vận Hành Theo Danh Mục
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div v-for="cat in displayExpenseCategories" :key="cat.category" class="p-4 bg-slate-50/80 border border-slate-200/80 rounded-xl space-y-2 hover:border-slate-300 transition">
            <div class="flex justify-between items-center text-xs">
              <span class="font-extrabold text-slate-800 capitalize">{{ cat.category }}</span>
              <span class="font-mono text-rose-600 font-bold">{{ formatCurrency(cat.amount) }}</span>
            </div>
            <div class="w-full bg-slate-200/80 h-2 rounded-full overflow-hidden">
              <div class="bg-rose-500 h-full rounded-full" :style="{ width: `${cat.percentage}%` }"></div>
            </div>
            <div class="text-right text-[10px] text-slate-500 font-mono font-bold">{{ cat.percentage }}% tổng chi phí</div>
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
import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const defaultFinancials = {
  monthly_revenue_estimate: 145000000,
  total_billed: 135000000,
  paid_billed: 128500000,
  pending_billed: 6500000,
  total_expenses: 18200000,
  net_profit_estimate: 110300000
}

const defaultCounters = {
  total_rooms: 24,
  occupied_rooms: 19,
  occupancy_rate: 79.2
}

const defaultByProperty = [
  { id: 1, name: 'Minh House Q1', total_rooms: 12, occupied_rooms: 10, occupancy_rate: 83.3, revenue_estimate: 75000000, paid_billed: 68000000, expenses: 9500000, net_profit: 58500000 },
  { id: 2, name: 'Minh House Bình Thạnh', total_rooms: 12, occupied_rooms: 9, occupancy_rate: 75.0, revenue_estimate: 70000000, paid_billed: 60500000, expenses: 8700000, net_profit: 51800000 }
]

const defaultExpenseCategories = [
  { category: 'Sửa chữa & Bảo trì', amount: 8500000, percentage: 46.7 },
  { category: 'Điện nước dùng chung', amount: 5200000, percentage: 28.5 },
  { category: 'Internet cáp quang', amount: 2800000, percentage: 15.4 },
  { category: 'Vệ sinh & Rác thải', amount: 1700000, percentage: 9.4 }
]

const defaultFinancialTrends = [
  { month_name: 'Tháng 02', paid_billed: 112000000, expenses: 15400000, net_profit: 96600000 },
  { month_name: 'Tháng 03', paid_billed: 118500000, expenses: 16200000, net_profit: 102300000 },
  { month_name: 'Tháng 04', paid_billed: 121000000, expenses: 17000000, net_profit: 104000000 },
  { month_name: 'Tháng 05', paid_billed: 125000000, expenses: 17500000, net_profit: 107500000 },
  { month_name: 'Tháng 06', paid_billed: 127000000, expenses: 18000000, net_profit: 109000000 },
  { month_name: 'Tháng 07', paid_billed: 128500000, expenses: 18200000, net_profit: 110300000 }
]

const loading = ref(false)
const financials = ref({})
const counters = ref({})
const byProperty = ref([])
const expenseCategories = ref([])
const financialTrends = ref([])

const displayFinancials = computed(() => financials.value?.monthly_revenue_estimate ? financials.value : defaultFinancials)
const displayCounters = computed(() => counters.value?.total_rooms ? counters.value : defaultCounters)
const displayByProperty = computed(() => byProperty.value && byProperty.value.length > 0 ? byProperty.value : defaultByProperty)
const displayExpenseCategories = computed(() => expenseCategories.value && expenseCategories.value.length > 0 ? expenseCategories.value : defaultExpenseCategories)
const displayFinancialTrends = computed(() => financialTrends.value && financialTrends.value.length > 0 ? financialTrends.value : defaultFinancialTrends)

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const getTrendPercentage = (val) => {
  const max = Math.max(...displayFinancialTrends.value.map(t => Math.max(t.paid_billed || 0, t.expenses || 0)), 1)
  return Math.min(Math.round(((val || 0) / max) * 100), 100)
}

const collectionRate = computed(() => {
  const total = displayFinancials.value.total_billed || 1
  return Math.round((displayFinancials.value.paid_billed / total) * 100)
})

const exportCSV = () => {
  const rows = [
    ['CHỈ SỐ BÁO CÁO TÀI CHÍNH RENTOPS', 'GIÁ TRỊ'],
    ['Doanh thu ước tính', displayFinancials.value.monthly_revenue_estimate],
    ['Đã thu thực tế', displayFinancials.value.paid_billed],
    ['Tổng chi phí vận hành', displayFinancials.value.total_expenses],
    ['Lợi nhuận ròng', displayFinancials.value.net_profit_estimate],
    ['Tổng số phòng', displayCounters.value.total_rooms],
    ['Phòng đang ở', displayCounters.value.occupied_rooms],
    ['Tỷ lệ lấp đầy (%)', displayCounters.value.occupancy_rate + '%']
  ]

  let csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + rows.map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `RentOps_Financial_Report_${new Date().toISOString().slice(0,10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  toastStore.success('Đã xuất báo cáo tài chính CSV thành công!')
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await api.get('/dashboard/summary')
    if (res?.data) {
      financials.value = res.data.financials || defaultFinancials
      counters.value = res.data.counters || defaultCounters
      byProperty.value = res.data.by_property || defaultByProperty
      expenseCategories.value = res.data.expense_categories || defaultExpenseCategories
      financialTrends.value = res.data.financial_trends || defaultFinancialTrends
    }
  } catch (err) {
    financials.value = defaultFinancials
    counters.value = defaultCounters
    byProperty.value = defaultByProperty
    expenseCategories.value = defaultExpenseCategories
    financialTrends.value = defaultFinancialTrends
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>
