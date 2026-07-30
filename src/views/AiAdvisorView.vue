<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 bg-gradient-to-r from-purple-900/40 via-indigo-900/30 to-slate-900/60 p-6 rounded-2xl border border-purple-500/20 shadow-xl backdrop-blur-md">
      <div>
        <div class="flex items-center gap-3">
          <div class="p-2.5 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-xl text-white shadow-lg shadow-purple-500/30">
            <svg class="w-7 h-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
            </svg>
          </div>
          <div>
            <h1 class="text-2xl font-bold text-white flex items-center gap-2">
              Trợ lý AI & Phân tích Đánh giá Dữ liệu
              <span class="px-2.5 py-0.5 text-xs font-semibold bg-purple-500/20 text-purple-300 border border-purple-500/30 rounded-full">Python Core</span>
            </h1>
            <p class="text-slate-400 text-sm mt-1">Đánh giá sức khỏe vận hành, tối ưu giá thuê & dự báo rủi ro thất thoát dựa trên thuật toán Python</p>
          </div>
        </div>
      </div>
      <div class="flex items-center gap-3">
        <button 
          @click="fetchInsights" 
          :disabled="loading"
          class="px-4 py-2.5 bg-purple-600 hover:bg-purple-500 active:bg-purple-700 disabled:opacity-50 text-white font-medium rounded-xl transition-all shadow-lg shadow-purple-600/20 flex items-center gap-2"
        >
          <svg :class="{'animate-spin': loading}" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
          {{ loading ? 'Đang phân tích...' : 'Cập nhật phân tích' }}
        </button>
      </div>
    </div>

    <!-- Loading skeleton -->
    <div v-if="loading && !insightsData" class="grid grid-cols-1 md:grid-cols-4 gap-6">
      <div v-for="i in 4" :key="i" class="h-32 bg-slate-800/50 rounded-2xl animate-pulse border border-slate-700/50"></div>
    </div>

    <template v-else-if="insightsData">
      <!-- Health Scores Overview -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <!-- Overall Health -->
        <div class="relative overflow-hidden bg-slate-900/80 border border-slate-800 rounded-2xl p-5 shadow-lg">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium text-slate-400">Điểm Sức Khỏe Tổng Thể</span>
            <span class="p-2 rounded-xl bg-purple-500/10 text-purple-400">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </span>
          </div>
          <div class="mt-4 flex items-baseline justify-between">
            <span class="text-3xl font-extrabold text-white">{{ insightsData.overall_health_score }}</span>
            <span class="text-sm font-semibold px-2 py-0.5 rounded-full" :class="insightsData.overall_health_score >= 80 ? 'bg-emerald-500/20 text-emerald-400' : 'bg-amber-500/20 text-amber-400'">
              {{ insightsData.overall_health_score >= 80 ? 'Rất Tốt' : 'Trung Bình' }}
            </span>
          </div>
          <div class="mt-3 w-full bg-slate-800 h-2 rounded-full overflow-hidden">
            <div class="bg-gradient-to-r from-purple-500 to-indigo-500 h-full transition-all duration-500" :style="{ width: `${insightsData.overall_health_score}%` }"></div>
          </div>
        </div>

        <!-- Occupancy Score -->
        <div class="relative overflow-hidden bg-slate-900/80 border border-slate-800 rounded-2xl p-5 shadow-lg">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium text-slate-400">Chỉ Số Tỷ Lệ Lấp Đầy</span>
            <span class="p-2 rounded-xl bg-emerald-500/10 text-emerald-400">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5m3 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1" />
              </svg>
            </span>
          </div>
          <div class="mt-4 flex items-baseline justify-between">
            <span class="text-3xl font-extrabold text-white">{{ insightsData.scores.occupancy_score }}%</span>
            <span class="text-xs text-slate-400">{{ insightsData.kpis.occupied_rooms }}/{{ insightsData.kpis.total_rooms }} phòng</span>
          </div>
          <div class="mt-3 w-full bg-slate-800 h-2 rounded-full overflow-hidden">
            <div class="bg-emerald-500 h-full transition-all duration-500" :style="{ width: `${insightsData.scores.occupancy_score}%` }"></div>
          </div>
        </div>

        <!-- Debt Collection Score -->
        <div class="relative overflow-hidden bg-slate-900/80 border border-slate-800 rounded-2xl p-5 shadow-lg">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium text-slate-400">Chỉ Số Thu Hồi Nợ</span>
            <span class="p-2 rounded-xl bg-cyan-500/10 text-cyan-400">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </span>
          </div>
          <div class="mt-4 flex items-baseline justify-between">
            <span class="text-3xl font-extrabold text-white">{{ insightsData.scores.collection_score }}%</span>
            <span class="text-xs text-slate-400">{{ formatCurrency(insightsData.kpis.paid_billed) }}</span>
          </div>
          <div class="mt-3 w-full bg-slate-800 h-2 rounded-full overflow-hidden">
            <div class="bg-cyan-500 h-full transition-all duration-500" :style="{ width: `${insightsData.scores.collection_score}%` }"></div>
          </div>
        </div>

        <!-- Profitability Score -->
        <div class="relative overflow-hidden bg-slate-900/80 border border-slate-800 rounded-2xl p-5 shadow-lg">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium text-slate-400">Chỉ Số Tối Ưu Chi Phí</span>
            <span class="p-2 rounded-xl bg-amber-500/10 text-amber-400">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
              </svg>
            </span>
          </div>
          <div class="mt-4 flex items-baseline justify-between">
            <span class="text-3xl font-extrabold text-white">{{ insightsData.scores.profit_score }}%</span>
            <span class="text-xs text-emerald-400 font-semibold">+{{ formatCurrency(insightsData.kpis.net_profit) }}</span>
          </div>
          <div class="mt-3 w-full bg-slate-800 h-2 rounded-full overflow-hidden">
            <div class="bg-amber-500 h-full transition-all duration-500" :style="{ width: `${insightsData.scores.profit_score}%` }"></div>
          </div>
        </div>
      </div>

      <!-- Executive Summary Box -->
      <div class="bg-slate-900/80 border border-purple-500/30 rounded-2xl p-6 shadow-xl relative overflow-hidden">
        <div class="absolute top-0 right-0 p-8 opacity-10">
          <svg class="w-48 h-48 text-purple-400" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14.5v-9l6 4.5-6 4.5z"/>
          </svg>
        </div>
        <h2 class="text-lg font-bold text-white flex items-center gap-2 mb-2">
          <span>🧠 Báo Cáo Đánh Giá Tổng Quan Từ Python Advisor</span>
          <span class="text-xs font-normal text-slate-400">Cập nhật: {{ insightsData.timestamp }}</span>
        </h2>
        <p class="text-slate-300 leading-relaxed text-base">{{ insightsData.executive_summary }}</p>
      </div>

      <!-- Actionable Recommendations Grid -->
      <div>
        <h2 class="text-lg font-bold text-white mb-4 flex items-center gap-2">
          <span>🎯 Đề Xuất & Khuyến Nghị Hành Động ({{ insightsData.recommendations.length }})</span>
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
          <div 
            v-for="(rec, index) in insightsData.recommendations" 
            :key="index"
            class="bg-slate-900/80 border rounded-2xl p-5 shadow-lg transition-all duration-200 hover:translate-y-[-2px]"
            :class="{
              'border-emerald-500/30 hover:border-emerald-500/50 bg-emerald-950/10': rec.type === 'success',
              'border-amber-500/30 hover:border-amber-500/50 bg-amber-950/10': rec.type === 'warning',
              'border-rose-500/30 hover:border-rose-500/50 bg-rose-950/10': rec.type === 'danger',
              'border-cyan-500/30 hover:border-cyan-500/50 bg-cyan-950/10': rec.type === 'info'
            }"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="flex items-center gap-3">
                <span 
                  class="p-2.5 rounded-xl text-white font-bold"
                  :class="{
                    'bg-emerald-500/20 text-emerald-400': rec.type === 'success',
                    'bg-amber-500/20 text-amber-400': rec.type === 'warning',
                    'bg-rose-500/20 text-rose-400': rec.type === 'danger',
                    'bg-cyan-500/20 text-cyan-400': rec.type === 'info'
                  }"
                >
                  <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </span>
                <div>
                  <h3 class="font-bold text-white text-base">{{ rec.title }}</h3>
                  <span class="text-xs font-medium uppercase tracking-wider px-2 py-0.5 rounded bg-slate-800 text-slate-400 mt-1 inline-block">
                    {{ rec.category }}
                  </span>
                </div>
              </div>
            </div>

            <p class="text-slate-300 text-sm mt-3 leading-relaxed">{{ rec.message }}</p>

            <div class="mt-4 pt-3 border-t border-slate-800 flex items-center justify-between text-xs">
              <span class="text-slate-400">Tác động kỳ vọng:</span>
              <span class="font-semibold text-purple-300">{{ rec.impact }}</span>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const loading = ref(false)
const insightsData = ref(null)

const fetchInsights = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const res = await fetch('/api/v1/ai_advisor/insights', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })
    const json = await res.json()
    if (json.status === 'success') {
      insightsData.value = json.data
    }
  } catch (err) {
    console.error('Lỗi lấy dữ liệu từ AI Advisor:', err)
  } finally {
    loading.value = false
  }
}

const formatCurrency = (val) => {
  if (!val) return '0đ'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

onMounted(() => {
  fetchInsights()
})
</script>
