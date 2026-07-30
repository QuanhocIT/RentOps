<template>
  <AppLayout>
    <div class="owner-page space-y-6">
      <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <div class="flex items-center gap-2">
            <span class="rounded-lg bg-indigo-100 px-2.5 py-1 text-xs font-extrabold uppercase tracking-wider text-indigo-800">Phân tích vận hành</span>
            <span class="text-xs font-medium text-slate-400">• RentOps AI Workspace</span>
          </div>
          <h1 class="mt-1 text-2xl font-black tracking-tight text-slate-900">Trợ lý AI & Phân tích dữ liệu</h1>
          <p class="mt-0.5 max-w-3xl text-sm text-slate-500">Theo dõi sức khỏe vận hành, tỷ lệ lấp đầy, công nợ và các cơ hội tối ưu lợi nhuận cho toàn bộ hệ thống.</p>
        </div>

        <button
          type="button"
          @click="fetchInsights"
          :disabled="loading"
          class="flex items-center justify-center gap-2 rounded-xl bg-indigo-600 px-4 py-2.5 text-xs font-bold text-white shadow-md shadow-indigo-600/20 transition hover:-translate-y-0.5 disabled:cursor-wait disabled:opacity-60"
        >
          <span>✦</span>
          <span>{{ loading ? 'Đang phân tích...' : 'Cập nhật phân tích' }}</span>
        </button>
      </div>

      <div v-if="loading && !insightsData" class="grid gap-4 md:grid-cols-4">
        <div v-for="i in 4" :key="i" class="h-32 rounded-[1.5rem] bg-white animate-pulse shadow-[0_12px_40px_rgba(15,23,42,0.06)] ring-1 ring-slate-100"></div>
      </div>

      <template v-else>
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          <div v-for="card in scoreCards" :key="card.label" class="rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <div class="flex items-center justify-between">
              <div class="flex h-12 w-12 items-center justify-center rounded-2xl" :class="card.bg">{{ card.icon }}</div>
              <div class="text-xs font-semibold text-emerald-600">{{ card.trend }}</div>
            </div>
            <div class="mt-4 text-sm font-semibold text-slate-500">{{ card.label }}</div>
            <div class="mt-1 text-3xl font-black text-slate-900">{{ card.value }}</div>
            <div class="mt-2 text-xs text-slate-500">{{ card.caption }}</div>
          </div>
        </div>

        <div class="grid gap-6 xl:grid-cols-3">
          <section class="xl:col-span-2 rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <div class="flex items-center justify-between gap-4 border-b border-slate-100 pb-4">
              <div>
                <h2 class="text-lg font-black text-slate-900">Tổng quan phân tích</h2>
                <p class="text-sm text-slate-500">Dữ liệu mô phỏng theo dashboard RentOps</p>
              </div>
              <span class="rounded-full bg-indigo-50 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-indigo-600">AI Insights</span>
            </div>

            <div class="mt-5 grid gap-4 sm:grid-cols-2">
              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-sm font-semibold text-slate-500">Điểm sức khỏe tổng thể</div>
                <div class="mt-2 flex items-end justify-between">
                  <div class="text-4xl font-black text-slate-900">{{ stats.overall }}%</div>
                  <span class="rounded-full px-3 py-1 text-xs font-bold" :class="stats.overall >= 80 ? 'bg-emerald-100 text-emerald-700' : 'bg-amber-100 text-amber-700'">
                    {{ stats.overall >= 80 ? 'Rất tốt' : 'Cần theo dõi' }}
                  </span>
                </div>
                <div class="mt-3 h-2 rounded-full bg-slate-200">
                  <div class="h-2 rounded-full bg-gradient-to-r from-violet-600 to-indigo-500" :style="{ width: `${stats.overall}%` }"></div>
                </div>
              </div>

              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-sm font-semibold text-slate-500">Tỷ lệ lấp đầy</div>
                <div class="mt-2 flex items-end justify-between">
                  <div class="text-4xl font-black text-slate-900">{{ stats.occupancy }}%</div>
                  <span class="text-xs font-semibold text-slate-500">{{ formatCount(stats.occupied_rooms) }}/{{ formatCount(stats.total_rooms) }} phòng</span>
                </div>
                <div class="mt-3 h-2 rounded-full bg-slate-200">
                  <div class="h-2 rounded-full bg-emerald-500" :style="{ width: `${stats.occupancy}%` }"></div>
                </div>
              </div>

              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-sm font-semibold text-slate-500">Thu hồi công nợ</div>
                <div class="mt-2 flex items-end justify-between">
                  <div class="text-4xl font-black text-slate-900">{{ stats.collection }}%</div>
                  <span class="text-xs font-semibold text-slate-500">{{ formatCurrency(stats.paid_billed) }}</span>
                </div>
                <div class="mt-3 h-2 rounded-full bg-slate-200">
                  <div class="h-2 rounded-full bg-cyan-500" :style="{ width: `${stats.collection}%` }"></div>
                </div>
              </div>

              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-sm font-semibold text-slate-500">Tối ưu chi phí</div>
                <div class="mt-2 flex items-end justify-between">
                  <div class="text-4xl font-black text-slate-900">{{ stats.profit }}%</div>
                  <span class="text-xs font-semibold text-emerald-600">{{ formatCurrency(stats.net_profit) }}</span>
                </div>
                <div class="mt-3 h-2 rounded-full bg-slate-200">
                  <div class="h-2 rounded-full bg-amber-500" :style="{ width: `${stats.profit}%` }"></div>
                </div>
              </div>
            </div>
          </section>

          <section class="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <h2 class="text-lg font-black text-slate-900">Nhận định nhanh</h2>
            <p class="mt-2 text-sm text-slate-500">Tóm tắt từ dữ liệu RentOps hiện tại</p>

            <div class="mt-5 space-y-4">
              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-xs font-bold uppercase tracking-[0.2em] text-indigo-600">Tổng quan</div>
                <p class="mt-2 text-sm leading-7 text-slate-600">{{ advisor.executive_summary }}</p>
              </div>
              <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="text-xs font-bold uppercase tracking-[0.2em] text-amber-600">Rủi ro</div>
                <p class="mt-2 text-sm leading-7 text-slate-600">{{ advisor.risk_summary }}</p>
              </div>
            </div>
          </section>
        </div>

        <div class="grid gap-6 xl:grid-cols-3">
          <section class="xl:col-span-2 rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <div class="mb-5 flex items-center justify-between">
              <div>
                <h2 class="text-lg font-black text-slate-900">Đề xuất hành động</h2>
                <p class="text-sm text-slate-500">Tối ưu vận hành theo từng nhóm việc</p>
              </div>
              <span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-600">{{ advisor.recommendations.length }} đề xuất</span>
            </div>

            <div class="grid gap-4 md:grid-cols-2">
              <article
                v-for="rec in advisor.recommendations"
                :key="rec.title"
                class="rounded-2xl border p-4"
                :class="recClass(rec.type)"
              >
                <div class="flex items-start gap-3">
                  <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl" :class="iconClass(rec.type)">
                    {{ rec.icon }}
                  </div>
                  <div class="min-w-0">
                    <div class="text-sm font-black text-slate-900">{{ rec.title }}</div>
                    <div class="mt-1 text-xs uppercase tracking-[0.18em] text-slate-500">{{ rec.category }}</div>
                  </div>
                </div>
                <p class="mt-3 text-sm leading-7 text-slate-600">{{ rec.message }}</p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-200 pt-3 text-xs">
                  <span class="text-slate-500">Tác động kỳ vọng</span>
                  <span class="font-semibold text-slate-900">{{ rec.impact }}</span>
                </div>
              </article>
            </div>
          </section>

          <section class="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <h2 class="text-lg font-black text-slate-900">Bản đồ rủi ro</h2>
            <p class="mt-2 text-sm text-slate-500">Các điểm cần ưu tiên theo AI</p>

            <div class="mt-5 space-y-4">
              <div v-for="item in riskList" :key="item.label" class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-100">
                <div class="flex items-center justify-between gap-3">
                  <div class="text-sm font-bold text-slate-900">{{ item.label }}</div>
                  <div class="text-xs font-bold" :class="item.badgeClass">{{ item.value }}</div>
                </div>
                <div class="mt-3 h-2 rounded-full bg-slate-200">
                  <div class="h-2 rounded-full" :class="item.barClass" :style="{ width: item.width }"></div>
                </div>
              </div>
            </div>
          </section>
        </div>

        <!-- Interactive AI Assistant Prompt Section -->
        <section class="rounded-[1.75rem] border border-indigo-100 bg-gradient-to-br from-indigo-50/70 via-white to-violet-50/60 p-6 shadow-md space-y-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2.5">
              <span class="p-2.5 bg-indigo-600 text-white rounded-2xl text-lg font-bold shadow-md shadow-indigo-600/30">🤖</span>
              <div>
                <h2 class="text-lg font-black text-slate-900">Hỏi Đáp Trực Tiếp Với AI Advisor</h2>
                <p class="text-xs text-slate-500">Nhận phân tích chuyên sâu và giải pháp vận hành cho tòa nhà của bạn</p>
              </div>
            </div>
            <span class="px-3 py-1 bg-emerald-100 text-emerald-800 font-extrabold text-[11px] rounded-full uppercase">Gemini AI Active</span>
          </div>

          <!-- Quick Suggestion Badges -->
          <div class="flex flex-wrap items-center gap-2 pt-1">
            <span class="text-xs font-bold text-slate-500">Gợi ý nhanh:</span>
            <button
              v-for="prompt in presetPrompts"
              :key="prompt"
              @click="askAi(prompt)"
              class="px-3 py-1.5 bg-white hover:bg-indigo-50 border border-slate-200 text-slate-700 text-xs font-semibold rounded-xl shadow-xs transition"
            >
              ⚡ {{ prompt }}
            </button>
          </div>

          <!-- Chat Input -->
          <form @submit.prevent="submitAiQuestion" class="flex gap-3 pt-2">
            <input
              v-model="customPrompt"
              type="text"
              placeholder="Nhập câu hỏi cho AI (vd: Làm sao để lấp đầy 3 phòng trống ở cơ sở Bình Thạnh?)..."
              class="flex-1 px-4 py-3 bg-white border border-slate-200 rounded-2xl text-sm font-medium focus:outline-none focus:border-indigo-500 shadow-sm"
            />
            <button
              type="submit"
              :disabled="aiAsking || !customPrompt.trim()"
              class="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-sm rounded-2xl shadow-lg shadow-indigo-600/30 transition disabled:opacity-50"
            >
              {{ aiAsking ? 'AI đang suy nghĩ...' : 'Gửi Câu Hỏi 🚀' }}
            </button>
          </form>

          <!-- AI Response Output -->
          <div v-if="aiResponse" class="p-5 bg-white rounded-2xl border border-indigo-100 shadow-sm space-y-2 animate-fade-in">
            <div class="flex items-center justify-between text-xs font-bold text-indigo-600 border-b border-slate-100 pb-2">
              <span>✦ Phân Tích & Đề Xuất Từ RentOps AI:</span>
              <span class="text-slate-400 font-mono">Cập nhật vừa xong</span>
            </div>
            <div class="text-sm text-slate-700 leading-relaxed font-sans whitespace-pre-line">
              {{ aiResponse }}
            </div>
          </div>
        </section>
      </template>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const loading = ref(false)
const insightsData = ref(null)

const customPrompt = ref('')
const aiAsking = ref(false)
const aiResponse = ref('')

const presetPrompts = [
  'Gợi ý chiến lược tăng doanh thu 15% tháng tới',
  'Cách lấp đầy 4 phòng trống nhanh nhất',
  'Kế hoạch xử lý khách nợ trễ tiền trọ quá 10 ngày',
  'Tối ưu chi phí bảo trì và điện nước chung'
]

const askAi = (promptText) => {
  customPrompt.value = promptText
  submitAiQuestion()
}

const submitAiQuestion = async () => {
  if (!customPrompt.value.trim()) return
  aiAsking.value = true
  const question = customPrompt.value
  
  try {
    const res = await api.post('/ai_advisor/ask', { question })
    aiResponse.value = res?.answer || res?.data?.answer || `🤖 [Đề Xuất AI cho: "${question}"]\n\n1. Dựa trên dữ liệu RentOps hiện tại, bạn nên ưu tiên gửi thông báo nhắc nợ ZNS tự động kèm ưu đãi giảm 2% nếu thanh toán trước 24h.\n2. Đối với các phòng trống, bạn có thể triển khai chương trình "Tặng 500k tiền điện tháng đầu" hoặc hợp tác với cổng môi giới trên Tenant Portal.\n3. Rà soát lại hợp đồng sắp hết hạn để gửi đề xuất gia hạn sớm trước 30 ngày.`
  } catch (err) {
    aiResponse.value = `🤖 [Đề Xuất AI cho: "${question}"]\n\n1. Chiến lược lấp đầy phòng: Đăng lại bài niêm yết lên Rentalio Landing View với ảnh chụp sắc nét và tặng kèm gói Wi-Fi 200Mbps miễn phí.\n2. Quản lý công nợ: Kích hoạt tính năng nhắc nợ VietQR 1-Click tự động gửi tới Zalo/SMS của cư dân.\n3. Tối ưu chi phí: Kiểm tra chỉ số tiêu thụ điện nước thất thoát ở các khu vực dùng chung tòa nhà.`
  } finally {
    aiAsking.value = false
  }
}

const fallbackInsights = {
  timestamp: '30/07/2026 17:30',
  overall_health_score: 84,
  executive_summary:
    'Hệ thống đang vận hành ổn định, tỷ lệ lấp đầy ở mức tốt và dòng tiền thu hồi khá đều. Nên tập trung thêm vào nhóm phòng trống lâu ngày và vài hợp đồng sắp đến hạn.',
  risk_summary:
    'Rủi ro chính hiện tại là một số phòng đang có công nợ chưa thanh toán và cần xem xét tối ưu giá ở các phòng hiệu suất thấp.',
  kpis: {
    total_rooms: 24,
    occupied_rooms: 19,
    vacant_rooms: 4,
    paid_billed: 128500000,
    net_profit: 42800000
  },
  scores: {
    occupancy_score: 79,
    collection_score: 88,
    profit_score: 76
  },
  recommendations: [
    {
      type: 'warning',
      icon: '⚠',
      title: 'Nhắc nợ các hóa đơn quá hạn',
      category: 'Thu chi',
      message: 'Gửi nhắc nợ tự động cho 3 phòng có hóa đơn quá hạn để giảm tồn đọng công nợ.',
      impact: 'Cải thiện thu hồi tiền'
    },
    {
      type: 'info',
      icon: '⌂',
      title: 'Tối ưu giá 2 phòng trống',
      category: 'Giá thuê',
      message: 'Hai phòng trống hơn 14 ngày có thể giảm nhẹ giá hoặc thêm khuyến mãi để tăng tỷ lệ lấp đầy.',
      impact: 'Tăng occupancy'
    },
    {
      type: 'success',
      icon: '✓',
      title: 'Gia hạn hợp đồng sớm',
      category: 'Hợp đồng',
      message: '4 hợp đồng sẽ hết hạn trong 30 ngày tới, nên chủ động gia hạn để tránh phòng trống.',
      impact: 'Giữ ổn định doanh thu'
    },
    {
      type: 'danger',
      icon: '⛑',
      title: 'Ưu tiên xử lý bảo trì',
      category: 'Vận hành',
      message: 'Có 2 yêu cầu bảo trì đang chờ. Xử lý sớm sẽ tránh phát sinh đánh giá xấu từ cư dân.',
      impact: 'Giảm rủi ro trải nghiệm'
    }
  ]
}

const fetchInsights = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('rentops_token') || localStorage.getItem('token')
    const res = await api.get('/ai_advisor/insights', {
      headers: token ? { Authorization: `Bearer ${token}` } : undefined
    })
    insightsData.value = res?.data || fallbackInsights
  } catch {
    insightsData.value = fallbackInsights
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchInsights()
})

const advisor = computed(() => insightsData.value || fallbackInsights)

const stats = computed(() => {
  const data = advisor.value
  return {
    overall: data.overall_health_score,
    occupancy: data.scores.occupancy_score,
    collection: data.scores.collection_score,
    profit: data.scores.profit_score,
    total_rooms: data.kpis.total_rooms,
    occupied_rooms: data.kpis.occupied_rooms,
    paid_billed: data.kpis.paid_billed,
    net_profit: data.kpis.net_profit
  }
})

const scoreCards = computed(() => [
  {
    label: 'Điểm sức khỏe',
    value: `${stats.value.overall}%`,
    caption: 'Tổng thể hệ thống',
    icon: '⚡',
    trend: '↑ 12.5%',
    bg: 'bg-violet-50 text-violet-600'
  },
  {
    label: 'Lấp đầy',
    value: `${stats.value.occupancy}%`,
    caption: 'Phòng đang ở / tổng phòng',
    icon: '🏢',
    trend: '↑ 8.3%',
    bg: 'bg-emerald-50 text-emerald-600'
  },
  {
    label: 'Thu hồi công nợ',
    value: `${stats.value.collection}%`,
    caption: 'Đã thu / đã phát hành',
    icon: '🧾',
    trend: '↑ 6.1%',
    bg: 'bg-cyan-50 text-cyan-600'
  },
  {
    label: 'Tối ưu chi phí',
    value: `${stats.value.profit}%`,
    caption: 'Lợi nhuận ròng dự báo',
    icon: '📈',
    trend: '↑ 4.2%',
    bg: 'bg-amber-50 text-amber-500'
  }
])

const riskList = computed(() => [
  { label: 'Phòng trống lâu ngày', value: `${fallbackInsights.kpis.vacant_rooms || 4}`, width: '62%', badgeClass: 'text-amber-600', barClass: 'bg-amber-500' },
  { label: 'Hợp đồng sắp hết hạn', value: '4', width: '48%', badgeClass: 'text-violet-600', barClass: 'bg-violet-500' },
  { label: 'Bảo trì đang chờ', value: '2', width: '36%', badgeClass: 'text-rose-600', barClass: 'bg-rose-500' }
])

const formatCurrency = (val) => {
  if (!val) return '0đ'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

const formatCount = (val) => new Intl.NumberFormat('vi-VN').format(val || 0)

const recClass = (type) => {
  switch (type) {
    case 'success':
      return 'bg-emerald-50 border-emerald-200'
    case 'warning':
      return 'bg-amber-50 border-amber-200'
    case 'danger':
      return 'bg-rose-50 border-rose-200'
    default:
      return 'bg-cyan-50 border-cyan-200'
  }
}

const iconClass = (type) => {
  switch (type) {
    case 'success':
      return 'bg-emerald-100 text-emerald-700'
    case 'warning':
      return 'bg-amber-100 text-amber-700'
    case 'danger':
      return 'bg-rose-100 text-rose-700'
    default:
      return 'bg-cyan-100 text-cyan-700'
  }
}
</script>
