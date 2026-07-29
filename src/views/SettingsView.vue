<template>
  <AppLayout>
    <div class="space-y-6 max-w-4xl mx-auto">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Cấu Hình Hệ Thống & VietQR</h1>
          <p class="text-slate-500 text-sm mt-0.5">Cấu hình thông tin tòa nhà và tài khoản ngân hàng thụ hưởng mã QR</p>
        </div>
      </div>

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
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const submitting = ref(false)
const savedMessage = ref('')
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
    }
  } catch (err) {
    console.warn('Error loading tenant settings:', err)
  }
}

onMounted(loadSettings)

const updateSettings = async () => {
  submitting.value = true
  savedMessage.value = ''
  try {
    await api.put('/tenant_settings', { tenant: form.value })
    savedMessage.value = 'Đã lưu thông tin cấu hình thành công!'
    setTimeout(() => { savedMessage.value = '' }, 3000)
  } catch (err) {
    alert(err?.message || 'Không thể lưu cấu hình')
  } finally {
    submitting.value = false
  }
}
</script>
