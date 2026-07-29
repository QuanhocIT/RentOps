<template>
  <footer class="bg-slate-950 text-slate-300 border-t border-slate-800/80 pt-16 pb-8 px-6 font-sans">
    <div class="max-w-7xl mx-auto space-y-12">
      <!-- Top Grid: 4 Detailed Columns -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10">
        <!-- Col 1: Brand & Enterprise Info -->
        <div class="space-y-4">
          <div class="flex items-center gap-3 cursor-pointer" @click="$router.push('/landing')">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-blue-600 flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/30">
              R
            </div>
            <div>
              <h2 class="font-black text-xl text-white tracking-wide leading-tight">RentOps</h2>
              <p class="text-xs text-indigo-400 font-semibold">Multi-Tenant SaaS Platform</p>
            </div>
          </div>

          <p class="text-xs text-slate-400 leading-relaxed font-light">
            Nền tảng phần mềm dịch vụ (SaaS) quản lý nhà trọ, căn hộ dịch vụ và chuỗi bất động sản cho thuê số 1 Việt Nam. Tự động hóa gạch nợ VietQR 24/7, hợp đồng điện tử chữ ký số và báo cáo tài chính chuyên sâu.
          </p>

          <div class="pt-2 space-y-2 text-xs text-slate-400">
            <div class="flex items-start gap-2">
              <span class="text-indigo-400 text-sm">📍</span>
              <span><strong>Trụ sở:</strong> Tầng 12, Tòa nhà Keangnam Landmark 72, Đường Phạm Hùng, Mễ Trì, Nam Từ Liêm, Hà Nội</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-indigo-400 text-sm">📞</span>
              <span><strong>Hotline hỗ trợ 24/7:</strong> <a href="tel:0901234567" class="text-emerald-400 font-bold hover:underline">0901.234.567</a></span>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-indigo-400 text-sm">✉️</span>
              <span><strong>Email liên hệ:</strong> <a href="mailto:support@rentops.vn" class="text-indigo-300 hover:underline">support@rentops.vn</a></span>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-indigo-400 text-sm">🏛️</span>
              <span><strong>Mã số doanh nghiệp:</strong> 0109876543 (Cấp bởi Sở KH&ĐT Hà Nội)</span>
            </div>
          </div>
        </div>

        <!-- Col 2: Solutions & SaaS Features -->
        <div class="space-y-4">
          <h3 class="text-sm font-bold text-white uppercase tracking-wider border-l-4 border-indigo-500 pl-3">
            Giải Pháp & Tính Năng
          </h3>
          <ul class="space-y-2.5 text-xs text-slate-400 font-medium">
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>💳</span> VietQR Auto-Payment 24/7 (Ngân hàng gạch nợ)
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>✍️</span> Chữ Ký Số Hợp Đồng Điện Tử Online
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>⚡</span> Chốt Chỉ Số Điện Nước Hàng Loạt
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>📊</span> Báo Cáo Thu Chi & Lợi Nhuận Ròng (P&L)
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>📱</span> Cổng Khách Thuê Self-Service
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>🔧</span> Tiếp Nhận & Phân Công Sửa Chữa Bảo Trì
              </a>
            </li>
            <li>
              <a href="/landing#features" class="hover:text-indigo-400 transition flex items-center gap-2">
                <span>🛡️</span> Bảo Mật Multi-Tenancy Cô Lập Dữ Liệu
              </a>
            </li>
          </ul>
        </div>

        <!-- Col 3: Customer Support & Tenant Links -->
        <div class="space-y-4">
          <h3 class="text-sm font-bold text-white uppercase tracking-wider border-l-4 border-emerald-500 pl-3">
            Hỗ Trợ & Khách Hàng
          </h3>
          <ul class="space-y-2.5 text-xs text-slate-400 font-medium">
            <li>
              <a href="/landing#rooms" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>🔑</span> Danh Sách Phòng Trọ Đang Cho Thuê
              </a>
            </li>
            <li>
              <RouterLink to="/login" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>🔑</span> Đăng Nhập Hệ Thống Quản Lý
              </RouterLink>
            </li>
            <li>
              <button @click="demoAccess" class="hover:text-emerald-400 transition flex items-center gap-2 text-left">
                <span>🚀</span> Trải Nghiệm Demo Tài Khoản Chủ Trọ
              </button>
            </li>
            <li>
              <a href="#" @click.prevent="alert('Tải mẫu hợp đồng chuẩn 2026!')" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>📄</span> Tải Mẫu Hợp Đồng Thuê Trọ Chuẩn 2026
              </a>
            </li>
            <li>
              <a href="#" @click.prevent="alert('Trang hướng dẫn sử dụng dành cho Chủ nhà!')" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>📖</span> Hướng Dẫn Sử Dụng Cho Chủ Nhà
              </a>
            </li>
            <li>
              <a href="#" @click.prevent="alert('Chính sách bảo mật dữ liệu an toàn ISO 27001!')" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>🔒</span> Chính Sách Bảo Mật Dữ Liệu Dùng Chung
              </a>
            </li>
            <li>
              <a href="#" @click.prevent="alert('Điều khoản dịch vụ SaaS!')" class="hover:text-emerald-400 transition flex items-center gap-2">
                <span>📜</span> Điều Khoản Sử Dụng Dịch Vụ SaaS
              </a>
            </li>
          </ul>
        </div>

        <!-- Col 4: Newsletter & Verification Badges -->
        <div class="space-y-4">
          <h3 class="text-sm font-bold text-white uppercase tracking-wider border-l-4 border-amber-500 pl-3">
            Đăng Ký Nhận Tin & Kết Nối
          </h3>

          <p class="text-xs text-slate-400 leading-relaxed font-light">
            Nhận tin tức cập nhật tính năng mới và bí quyết tối ưu lợi nhuận kinh doanh nhà trọ:
          </p>

          <form @submit.prevent="subscribeNewsletter" class="space-y-2">
            <div class="flex gap-2">
              <input
                v-model="emailInput"
                type="email"
                required
                placeholder="Nhập email của bạn..."
                class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"
              />
              <button class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md transition">
                Gửi
              </button>
            </div>
            <p v-if="subscribedMsg" class="text-[11px] text-emerald-400 font-semibold">
              {{ subscribedMsg }}
            </p>
          </form>

          <!-- Social Channels -->
          <div class="pt-2">
            <p class="text-xs font-bold text-slate-300 mb-2">Kênh truyền thông chính thức:</p>
            <div class="flex items-center gap-2">
              <a href="#" class="px-3 py-1.5 bg-slate-900 hover:bg-indigo-900/60 border border-slate-800 text-indigo-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
                <span>🌐</span> Facebook
              </a>
              <a href="#" class="px-3 py-1.5 bg-slate-900 hover:bg-blue-900/60 border border-slate-800 text-blue-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
                <span>💬</span> Zalo Official
              </a>
              <a href="#" class="px-3 py-1.5 bg-slate-900 hover:bg-rose-900/60 border border-slate-800 text-rose-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
                <span>▶️</span> YouTube
              </a>
            </div>
          </div>

          <!-- Trust & Security Badges -->
          <div class="pt-3 border-t border-slate-800/80 flex flex-wrap items-center gap-3 text-[11px] text-slate-400 font-semibold">
            <span class="px-2.5 py-1 bg-slate-900 border border-slate-800 rounded-md text-emerald-400">✓ VietQR 24/7</span>
            <span class="px-2.5 py-1 bg-slate-900 border border-slate-800 rounded-md text-blue-400">🛡️ Cloudflare WAF</span>
            <span class="px-2.5 py-1 bg-slate-900 border border-slate-800 rounded-md text-amber-400">🔒 ISO 27001</span>
          </div>
        </div>
      </div>

      <!-- Bottom Bar: Copyright & Attribution -->
      <div class="pt-8 border-t border-slate-800/80 flex flex-col md:flex-row items-center justify-between gap-4 text-xs text-slate-500 font-light">
        <div>
          © 2026 <strong>RentOps Multi-Tenant SaaS Platform</strong>. Bản quyền thuộc về Công ty Cổ phần Công nghệ RentOps Việt Nam.
        </div>

        <div class="flex items-center gap-6">
          <a href="#" @click.prevent class="hover:text-slate-300 transition">Bảo mật</a>
          <a href="#" @click.prevent class="hover:text-slate-300 transition">Điều khoản</a>
          <a href="#" @click.prevent class="hover:text-slate-300 transition">Sơ đồ trang web</a>
          <span class="text-indigo-400 font-semibold">v1.2 Production Edition</span>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const emailInput = ref('')
const subscribedMsg = ref('')

const subscribeNewsletter = () => {
  if (emailInput.value) {
    subscribedMsg.value = '✓ Cảm ơn bạn! Đã đăng ký nhận bản tin thành công.'
    emailInput.value = ''
    setTimeout(() => { subscribedMsg.value = '' }, 4000)
  }
}

const demoAccess = async () => {
  await authStore.login('demo@rentops.vn')
  router.push('/')
}
</script>
