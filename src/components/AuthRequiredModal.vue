<template>
  <div v-if="show" class="fixed inset-0 z-50 bg-slate-950/85 backdrop-blur-md flex items-center justify-center p-4 animate-fade-in">
    <div class="bg-slate-900 border border-slate-700/90 rounded-3xl max-w-md w-full overflow-hidden shadow-2xl p-6 space-y-6 text-center animate-scale-in relative">
      <button
        @click="$emit('close')"
        class="absolute top-4 right-4 text-slate-400 hover:text-white font-bold text-lg w-8 h-8 rounded-full bg-slate-800 flex items-center justify-center transition"
      >
        ✕
      </button>

      <!-- Lock Icon Banner -->
      <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-indigo-500 to-blue-600 flex items-center justify-center text-white text-3xl font-black mx-auto shadow-lg shadow-indigo-500/30">
        🔒
      </div>

      <div class="space-y-2">
        <h3 class="text-2xl font-black text-white">Yêu Cầu Đăng Nhập</h3>
        <p class="text-xs text-slate-300 leading-relaxed max-w-xs mx-auto">
          Bạn đang xem chi tiết phòng dưới tư cách <strong>Khách vãng lai</strong>. Vui lòng đăng nhập tài khoản để thực hiện <strong>Đặt cọc giữ phòng trực tuyến, VietQR 24/7</strong> và ký hợp đồng điện tử.
        </p>
      </div>

      <!-- Features Checklist -->
      <div class="bg-slate-950/60 p-4 rounded-2xl border border-slate-800 text-left text-xs space-y-2 text-slate-300">
        <div class="font-bold text-indigo-300 uppercase tracking-wider text-[11px] mb-1">🎁 Quyền lợi sau khi Đăng nhập:</div>
        <div class="flex items-center gap-2">
          <span class="text-emerald-400 font-bold">✓</span>
          <span>Xem số Hotline & Nhận Video/Ảnh phòng quay trực tiếp qua Zalo</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-emerald-400 font-bold">✓</span>
          <span>Đặt cọc giữ phòng 1-Click bằng VietQR tự động 24/7</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-emerald-400 font-bold">✓</span>
          <span>Theo dõi hợp đồng điện tử & cổng dịch vụ cư dân</span>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="space-y-3">
        <button
          @click="goToLogin"
          class="w-full py-3.5 bg-gradient-to-r from-indigo-600 via-indigo-500 to-blue-600 hover:from-indigo-500 hover:to-blue-500 text-white font-black text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center justify-center space-x-2"
        >
          <span>🔑</span>
          <span>Đăng Nhập Tài Khoản Ngay</span>
        </button>

        <button
          @click="demoLogin"
          class="w-full py-3 bg-slate-800 hover:bg-slate-700 text-indigo-300 font-bold text-xs rounded-xl border border-slate-700 transition flex items-center justify-center space-x-2"
        >
          <span>🚀</span>
          <span>Đăng Nhập Tài Khoản Demo (Khách Thuê)</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const props = defineProps({
  show: Boolean,
  room: Object
})

const emit = defineEmits(['close', 'authenticated'])

const router = useRouter()
const authStore = useAuthStore()

const goToLogin = () => {
  emit('close')
  router.push('/login')
}

const demoLogin = async () => {
  await authStore.login('renter102@rentops.vn')
  emit('authenticated')
  emit('close')
}
</script>
