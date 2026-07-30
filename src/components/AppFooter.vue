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
              <button @click="activeModal = 'contract'" class="hover:text-emerald-400 transition flex items-center gap-2 text-left">
                <span>📄</span> Tải Mẫu Hợp Đồng Thuê Trọ Chuẩn 2026
              </button>
            </li>
            <li>
              <button @click="activeModal = 'guide'" class="hover:text-emerald-400 transition flex items-center gap-2 text-left">
                <span>📖</span> Hướng Dẫn Sử Dụng Cho Chủ Nhà
              </button>
            </li>
            <li>
              <button @click="activeModal = 'security'" class="hover:text-emerald-400 transition flex items-center gap-2 text-left">
                <span>🔒</span> Chính Sách Bảo Mật Dữ Liệu Dùng Chung
              </button>
            </li>
            <li>
              <button @click="activeModal = 'terms'" class="hover:text-emerald-400 transition flex items-center gap-2 text-left">
                <span>📜</span> Điều Khoản Sử Dụng Dịch Vụ SaaS
              </button>
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
              <a href="#" @click.prevent="notifyChannel('Facebook')" class="px-3 py-1.5 bg-slate-900 hover:bg-indigo-900/60 border border-slate-800 text-indigo-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
                <span>🌐</span> Facebook
              </a>
              <a href="#" @click.prevent="notifyChannel('Zalo Official')" class="px-3 py-1.5 bg-slate-900 hover:bg-blue-900/60 border border-slate-800 text-blue-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
                <span>💬</span> Zalo Official
              </a>
              <a href="#" @click.prevent="notifyChannel('YouTube')" class="px-3 py-1.5 bg-slate-900 hover:bg-rose-900/60 border border-slate-800 text-rose-400 rounded-lg text-xs font-bold transition flex items-center gap-1">
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
          <a href="#" @click.prevent="activeModal = 'security'" class="hover:text-slate-300 transition">Bảo mật</a>
          <a href="#" @click.prevent="activeModal = 'terms'" class="hover:text-slate-300 transition">Điều khoản</a>
          <a href="#" @click.prevent="activeModal = 'guide'" class="hover:text-slate-300 transition">Sơ đồ trang web</a>
          <span class="text-indigo-400 font-semibold">v1.2 Production Edition</span>
        </div>
      </div>
    </div>

    <!-- Modals Dialogs -->
    <div v-if="activeModal" class="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-md flex items-center justify-center p-4">
      <div class="bg-slate-900 border border-slate-700 rounded-2xl max-w-2xl w-full p-6 text-slate-200 shadow-2xl space-y-4 max-h-[85vh] overflow-y-auto">
        
        <!-- Contract Modal -->
        <template v-if="activeModal === 'contract'">
          <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>📄</span> Mẫu Hợp Đồng Thuê Nhà Chuẩn 法 Lý 2026
            </h3>
            <button @click="activeModal = null" class="text-slate-400 hover:text-white text-xl">✕</button>
          </div>
          <div class="text-xs space-y-3 leading-relaxed text-slate-300 bg-slate-950 p-4 rounded-xl border border-slate-800 font-mono">
            <p class="font-bold text-center text-indigo-400 uppercase text-sm font-sans">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br />Độc lập - Tự do - Hạnh phúc</p>
            <p class="font-bold text-center text-white text-sm font-sans">HỢP ĐỒNG THUÊ NƠI Ở / PHÒNG TRỌ CHUẨN</p>
            <p><strong>Điều 1. Đối Tượng Thuê:</strong> Bên A cho Bên B thuê phòng số ... thuộc địa chỉ ... Đầy đủ trang thiết bị nội thất theo biên bản bàn giao kèm theo.</p>
            <p><strong>Điều 2. Thời Hạn & Giá Thuê:</strong> Thời hạn hợp đồng ... tháng. Giá thuê cố định ... VNĐ/tháng. Đặt cọc ... VNĐ.</p>
            <p><strong>Điều 3. Phương Thức Thanh Toán:</strong> Thanh toán qua mã VietQR chuyển khoản tự động gạch nợ trước ngày 05 hàng tháng.</p>
            <p><strong>Điều 4. Quyền & Nghĩa Vụ:</strong> Thực hiện đầy đủ quy định an toàn PCCC, an ninh trật tự và vệ sinh chung.</p>
          </div>
          <div class="flex justify-between items-center pt-2">
            <span class="text-xs text-slate-400">Đã cập nhật theo Bộ Luật Dân Sự mới nhất</span>
            <div class="flex gap-2">
              <button @click="downloadContractTemplate" class="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1">
                📥 Tải Mẫu File Word/PDF
              </button>
              <button @click="activeModal = null" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs rounded-xl">
                Đóng
              </button>
            </div>
          </div>
        </template>

        <!-- Guide Modal -->
        <template v-else-if="activeModal === 'guide'">
          <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>📖</span> Hướng Dẫn Sử Dụng Nhanh RentOps Cho Chủ Nhà
            </h3>
            <button @click="activeModal = null" class="text-slate-400 hover:text-white text-xl">✕</button>
          </div>
          <div class="space-y-4 text-xs">
            <div class="p-3 bg-slate-950 rounded-xl border border-slate-800">
              <strong class="text-indigo-400 block text-sm mb-1">Bước 1: Thiết lập Tòa nhà & Danh mục phòng</strong>
              <p class="text-slate-300">Vào menu <strong>Phòng & Bất động sản</strong>, thêm tên tòa nhà và danh sách các phòng trọ cùng đơn giá niêm yết.</p>
            </div>
            <div class="p-3 bg-slate-950 rounded-xl border border-slate-800">
              <strong class="text-indigo-400 block text-sm mb-1">Bước 2: Tạo Hợp đồng & Thông tin Khách thuê</strong>
              <p class="text-slate-300">Vào mục <strong>Đặt phòng / Hợp đồng</strong>, thêm thông tin khách thuê và tạo hợp đồng chữ ký số tự động.</p>
            </div>
            <div class="p-3 bg-slate-950 rounded-xl border border-slate-800">
              <strong class="text-indigo-400 block text-sm mb-1">Bước 3: Nhập chỉ số Điện Nước & Phát hành Hóa đơn VietQR</strong>
              <p class="text-slate-300">Hàng tháng vào mục <strong>Chỉ số điện nước</strong> để nhập nhanh chỉ số. Hệ thống tự tạo hóa đơn kèm VietQR chuyển khoản gạch nợ tự động.</p>
            </div>
          </div>
          <div class="flex justify-end pt-2">
            <button @click="activeModal = null" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl">
              Hiểu Rồi & Đóng
            </button>
          </div>
        </template>

        <!-- Security Modal -->
        <template v-else-if="activeModal === 'security'">
          <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>🔒</span> Chính Sách Bảo Mật Dữ Liệu ISO 27001
            </h3>
            <button @click="activeModal = null" class="text-slate-400 hover:text-white text-xl">✕</button>
          </div>
          <div class="space-y-3 text-xs text-slate-300 leading-relaxed">
            <p><strong>1. Mã Hóa Dữ Liệu:</strong> Toàn bộ dữ liệu khách thuê, hợp đồng và hóa đơn được mã hóa chuẩn <strong>AES-256</strong> khi lưu trữ và <strong>TLS 1.3</strong> khi truyền tải.</p>
            <p><strong>2. Multi-Tenant Isolation:</strong> Mỗi chủ nhà sở hữu một không gian dữ liệu cô lập tuyệt đối, không chia sẻ với bất kỳ tài khoản nào khác.</p>
            <p><strong>3. Sao Lưu Tự Động 24/7:</strong> Dữ liệu được backup định kỳ tự động qua hệ thống Google Cloud Storage an toàn cao.</p>
          </div>
          <div class="flex justify-end pt-2">
            <button @click="activeModal = null" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs rounded-xl">
              Đóng
            </button>
          </div>
        </template>

        <!-- Terms Modal -->
        <template v-else-if="activeModal === 'terms'">
          <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>📜</span> Điều Khoản Sử Dụng Dịch Vụ SaaS RentOps
            </h3>
            <button @click="activeModal = null" class="text-slate-400 hover:text-white text-xl">✕</button>
          </div>
          <div class="space-y-3 text-xs text-slate-300 leading-relaxed">
            <p><strong>1. Cam kết Uptime 99.9%:</strong> RentOps cam kết duy trì hệ thống hoạt động ổn định và liên tục 24/7.</p>
            <p><strong>2. Bảo lưu quyền sở hữu dữ liệu:</strong> Toàn bộ danh sách phòng, hợp đồng và doanh thu thuộc quyền sở hữu độc quyền của Chủ nhà.</p>
            <p><strong>3. Hỗ trợ kỹ thuật:</strong> Đội ngũ tư vấn sẵn sàng hỗ trợ trực tuyến qua Hotline và Zalo Official trong thời gian vận hành.</p>
          </div>
          <div class="flex justify-end pt-2">
            <button @click="activeModal = null" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs rounded-xl">
              Đóng
            </button>
          </div>
        </template>

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
const activeModal = ref(null)

import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const subscribeNewsletter = () => {
  if (emailInput.value) {
    toastStore.success('Đã đăng ký nhận bản tin RentOps thành công!')
    subscribedMsg.value = '✓ Cảm ơn bạn! Đã đăng ký nhận bản tin thành công.'
    emailInput.value = ''
    setTimeout(() => { subscribedMsg.value = '' }, 4000)
  }
}

const notifyChannel = (name) => {
  toastStore.info(`Đang chuyển hướng tới kênh chính thức ${name} của RentOps!`)
}

const downloadContractTemplate = () => {
  const content = `HỢP ĐỒNG THUÊ PHÒNG TRỌ CHUẨN 2026\n\nBên A (Chủ nhà): RentOps Landlord\nBên B (Khách thuê): ...\n\nĐiều 1: Phòng thuê đầy đủ tiện ích...\nĐiều 2: Giá thuê thanh toán VietQR hàng tháng.`
  const blob = new Blob([content], { type: 'text/plain;charset=utf-8' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = 'Mau_Hop_Dong_Thue_Phong_Tro_2026.txt'
  a.click()
  URL.revokeObjectURL(url)
}

const demoAccess = async () => {
  await authStore.login('demo@rentops.vn')
  router.push('/')
}
</script>
