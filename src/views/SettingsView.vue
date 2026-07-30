<template>
  <AppLayout>
    <div class="owner-page space-y-6 max-w-4xl mx-auto animate-slide-up">
      <div class="flex items-center justify-between">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Tài Khoản & Hệ Thống</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Enterprise</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Cấu Hình Tài Khoản Chủ Trọ & Gói Dịch Vụ</h1>
          <p class="text-slate-500 text-sm mt-0.5">Quản lý nâng cấp tài khoản cho thuê Chung cư mini, Căn hộ cao cấp, Nhà nguyên căn & VietQR</p>
        </div>
      </div>

      <!-- Landlord Subscription & Account Tier Card -->
      <div class="bg-gradient-to-br from-indigo-900 via-indigo-800 to-slate-900 rounded-3xl p-8 text-white shadow-xl relative overflow-hidden">
        <div class="absolute -right-10 -bottom-10 w-64 h-64 bg-indigo-500/20 rounded-full blur-3xl pointer-events-none"></div>

        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 border-b border-indigo-700/60 pb-6">
          <div>
            <div class="flex items-center gap-2">
              <span class="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/30 rounded-full text-xs font-black uppercase tracking-wider">
                👑 {{ planInfo.plan_name || 'Gói Pro Enterprise' }}
              </span>
              <span class="text-xs text-indigo-200">Đang hoạt động</span>
            </div>
            <h2 class="text-2xl font-black mt-2">Hạn Mức Quản Lý Bất Động Sản</h2>
            <p class="text-xs text-indigo-200 mt-1 max-w-md">
              Tài khoản chủ trọ của bạn được cấp phép quản lý đa dạng mô hình: Chung cư mini, Căn hộ cao cấp, Nhà nguyên căn và Dãy phòng trọ.
            </p>
          </div>

          <button
            @click="openUpgradeModal"
            class="px-6 py-3.5 bg-gradient-to-r from-amber-400 to-orange-500 hover:from-amber-300 hover:to-orange-400 text-slate-950 font-black text-xs uppercase tracking-wider rounded-2xl shadow-lg shadow-amber-500/30 transition transform hover:-translate-y-0.5"
          >
            🚀 Nâng Cấp Gói Dịch Vụ
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-6">
          <div class="bg-indigo-950/50 p-4 rounded-2xl border border-indigo-700/50">
            <span class="text-xs font-bold text-indigo-300 block uppercase">Hạn mức phòng / Căn</span>
            <span class="text-2xl font-black text-white font-mono mt-1 block">
              {{ planInfo.current_rooms_count || 32 }} / {{ planInfo.max_rooms || 500 }} Căn
            </span>
            <div class="w-full bg-indigo-900 h-2 rounded-full mt-2 overflow-hidden">
              <div class="bg-emerald-400 h-full rounded-full" :style="{ width: Math.min(100, ((planInfo.current_rooms_count || 32) / (planInfo.max_rooms || 500)) * 100) + '%' }"></div>
            </div>
          </div>

          <div class="bg-indigo-950/50 p-4 rounded-2xl border border-indigo-700/50">
            <span class="text-xs font-bold text-indigo-300 block uppercase">Hạn mức tòa nhà / BĐS</span>
            <span class="text-2xl font-black text-amber-300 font-mono mt-1 block">
              {{ planInfo.current_properties_count || 8 }} / {{ planInfo.max_properties || 50 }} Tòa
            </span>
            <div class="flex items-center gap-1.5 mt-2 flex-wrap text-[11px] font-bold text-emerald-300">
              <span class="bg-emerald-950/80 px-1.5 py-0.5 rounded border border-emerald-800">🏢 Chung Cư Mini</span>
              <span class="bg-emerald-950/80 px-1.5 py-0.5 rounded border border-emerald-800">🏢✨ Căn Hộ Cao Cấp</span>
              <span class="bg-emerald-950/80 px-1.5 py-0.5 rounded border border-emerald-800">🏡 Nhà Nguyên Căn</span>
            </div>
          </div>

          <div class="bg-indigo-950/50 p-4 rounded-2xl border border-indigo-700/50">
            <span class="text-xs font-bold text-indigo-300 block uppercase">Tính năng đặc quyền</span>
            <p class="text-xs text-indigo-200 mt-2 font-medium">
              ✓ AI Financial Advisor<br/>
              ✓ VietQR Tự động khớp lệnh<br/>
              ✓ Layout 2PN-1PK-1WC & Ban công
            </p>
          </div>
        </div>
      </div>

      <!-- Form Bank VietQR -->
      <div class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm space-y-6">
        <div class="flex items-center gap-4 border-b border-slate-100 pb-5">
          <div class="w-14 h-14 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold text-2xl">
            🏦
          </div>
          <div>
            <h3 class="text-lg font-bold text-slate-900">Cấu Hình Ngân Hàng Thụ Hưởng VietQR</h3>
            <p class="text-xs text-slate-500">Mã QR trên hóa đơn hàng tháng sẽ tự động đổi theo thông tin ngân hàng này</p>
          </div>
        </div>

        <form @submit.prevent="updateSettings" class="space-y-5">
          <div>
            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên Tòa Nhà / Chuỗi Cho Thuê</label>
            <input v-model="form.name" required type="text" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500" />
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số Điện Thoại Liên Hệ</label>
              <input v-model="form.phone" type="text" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm font-mono focus:bg-white" />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tên Subdomain SaaS</label>
              <input v-model="form.subdomain" disabled type="text" class="w-full px-4 py-2.5 bg-slate-100 border border-slate-200 rounded-xl text-sm font-mono text-slate-500 cursor-not-allowed" />
            </div>
          </div>

          <div class="border-t border-slate-100 pt-4 grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="block text-xs font-semibold text-indigo-700 uppercase mb-1">Mã Ngân Hàng (Bank Code)</label>
              <select v-model="form.bank_code" required class="w-full px-4 py-2.5 bg-indigo-50/50 border border-indigo-300 rounded-xl text-sm font-bold focus:bg-white">
                <option value="MB">MBBank (Ngân Hàng Quân Đội)</option>
                <option value="VCB">Vietcombank (Ngoại Thương)</option>
                <option value="TCB">Techcombank (Kỹ Thương)</option>
                <option value="VPB">VPBank (Thịnh Vượng)</option>
                <option value="ACB">ACB (Á Châu)</option>
                <option value="BIDV">BIDV (Đầu Tư & Phát Triển)</option>
                <option value="CTG">VietinBank (Công Thương)</option>
                <option value="TPB">TPBank (Tiên Phong)</option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-indigo-700 uppercase mb-1">Số Tài Khoản</label>
              <input v-model="form.bank_account" required type="text" placeholder="0901234567" class="w-full px-4 py-2.5 bg-indigo-50/50 border border-indigo-300 rounded-xl text-sm font-mono font-bold focus:bg-white" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-indigo-700 uppercase mb-1">Tên Chủ Tài Khoản (Không dấu)</label>
              <input v-model="form.bank_account_name" required type="text" placeholder="NGUYEN VAN A" class="w-full px-4 py-2.5 bg-indigo-50/50 border border-indigo-300 rounded-xl text-sm font-bold uppercase focus:bg-white" />
            </div>
          </div>

          <div class="pt-4 flex items-center justify-between border-t border-slate-100">
            <span v-if="savedMessage" class="text-xs font-semibold text-emerald-600 bg-emerald-50 px-3 py-1.5 rounded-lg border border-emerald-200">
              ✓ {{ savedMessage }}
            </span>
            <span v-else></span>

            <button
              type="submit"
              :disabled="submitting"
              class="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-sm shadow-lg shadow-indigo-600/30 transition"
            >
              {{ submitting ? 'Đang lưu...' : 'Lưu cấu hình hệ thống' }}
            </button>
          </div>
        </form>
      </div>

      <!-- Upgrade Plan Modal -->
      <div v-if="showUpgradeModal" class="fixed inset-0 z-50 bg-slate-950/70 backdrop-blur-md flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-2xl w-full p-8 shadow-2xl space-y-6 animate-scale-in max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between border-b border-slate-100 pb-4">
            <div>
              <span class="text-xs font-extrabold uppercase tracking-wider text-indigo-600">Nâng Cấp Tài Khoản</span>
              <h3 class="text-xl font-black text-slate-900">Chọn Gói Dịch Vụ Chủ Trọ RentOps</h3>
            </div>
            <button @click="showUpgradeModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div
              v-for="plan in availablePlans"
              :key="plan.id"
              :class="['rounded-2xl p-5 border-2 transition flex flex-col justify-between space-y-4 cursor-pointer', plan.is_current ? 'border-indigo-600 bg-indigo-50/50 shadow-md' : 'border-slate-200 hover:border-indigo-300 bg-white']"
              @click="selectedPlanId = plan.id"
            >
              <div>
                <div class="flex items-center justify-between">
                  <span class="font-extrabold text-sm text-slate-900">{{ plan.name }}</span>
                  <span v-if="plan.is_current" class="px-2 py-0.5 bg-indigo-600 text-white text-[10px] font-black rounded-full uppercase">Hiện Tại</span>
                </div>
                <div class="text-xl font-black text-indigo-600 font-mono mt-3">
                  {{ formatCurrency(plan.monthly_price) }} <span class="text-xs text-slate-400 font-normal">/ tháng</span>
                </div>
                <p class="text-xs text-slate-500 mt-2 font-medium">{{ plan.description }}</p>
                <div class="mt-3 text-xs font-bold text-slate-700 space-y-1">
                  <div>✓ Tối đa: <strong>{{ plan.max_rooms }} căn</strong></div>
                  <div>✓ Quản lý Chung cư mini</div>
                  <div>✓ Hỗ trợ căn hộ 2PN-1PK</div>
                </div>
              </div>

              <button
                @click.stop="upgradePlan(plan.id)"
                :disabled="plan.is_current || upgrading"
                :class="['w-full py-2.5 rounded-xl text-xs font-bold transition shadow-sm', plan.is_current ? 'bg-slate-200 text-slate-500 cursor-not-allowed' : 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-indigo-600/30']"
              >
                {{ plan.is_current ? 'Đang Sử Dụng' : 'Nâng Cấp Ngay' }}
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const submitting = ref(false)
const upgrading = ref(false)
const savedMessage = ref('')
const showUpgradeModal = ref(false)
const selectedPlanId = ref(null)

const planInfo = ref({
  plan_name: 'Gói Pro Enterprise',
  max_rooms: 500,
  current_rooms_count: 32,
  monthly_price: 799000
})

const availablePlans = ref([
  { id: 1, name: 'Gói Free', max_rooms: 10, monthly_price: 0, description: 'Dành cho dãy nhà trọ nhỏ (tối đa 10 phòng)', is_current: false },
  { id: 2, name: 'Gói Standard', max_rooms: 50, monthly_price: 299000, description: 'Dành cho chung cư mini & nhà trọ vừa (tối đa 50 căn)', is_current: false },
  { id: 3, name: 'Gói Pro Enterprise', max_rooms: 500, monthly_price: 799000, description: 'Dành cho chuỗi căn hộ cao cấp, nhà nguyên căn & villa', is_current: true }
])

const form = ref({
  name: '',
  phone: '',
  subdomain: '',
  bank_code: 'MB',
  bank_account: '',
  bank_account_name: ''
})

const loadSettings = async () => {
  try {
    const res = await api.get('/tenant_settings')
    if (res?.data) {
      form.value = { ...res.data }
      planInfo.value = {
        plan_name: res.data.plan_name || 'Gói Pro Enterprise',
        max_rooms: res.data.max_rooms || 500,
        max_properties: res.data.max_properties || 50,
        current_rooms_count: res.data.current_rooms_count || 32,
        current_properties_count: res.data.current_properties_count || 8,
        monthly_price: res.data.monthly_price || 799000
      }
    }
  } catch (err) {
    console.warn('Error loading tenant settings:', err)
  }
}

import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const openUpgradeModal = async () => {
  showUpgradeModal.value = true
  try {
    const res = await api.get('/tenant_settings/plans')
    if (Array.isArray(res?.data) && res.data.length > 0) {
      availablePlans.value = res.data
    }
  } catch (err) {
    console.warn('Error loading plans:', err)
  }
}

const upgradePlan = async (planId) => {
  upgrading.value = true
  try {
    const res = await api.post('/tenant_settings/upgrade_plan', { plan_id: planId })
    toastStore.success(res?.message || 'Nâng cấp gói tài khoản thành công!')
    showUpgradeModal.value = false
    await loadSettings()
  } catch (err) {
    toastStore.error(err?.message || 'Không thể nâng cấp gói dịch vụ')
  } finally {
    upgrading.value = false
  }
}

const updateSettings = async () => {
  submitting.value = true
  savedMessage.value = ''
  try {
    await api.put('/tenant_settings', { tenant: form.value })
    toastStore.success('Đã lưu thông tin cấu hình thành công!')
    savedMessage.value = 'Đã lưu thông tin cấu hình thành công!'
    setTimeout(() => { savedMessage.value = '' }, 3000)
  } catch (err) {
    toastStore.error(err?.message || 'Không thể lưu cấu hình')
  } finally {
    submitting.value = false
  }
}

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

onMounted(loadSettings)
</script>
