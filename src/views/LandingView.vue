<template>
  <div class="min-h-screen bg-slate-900 text-slate-100 font-sans flex flex-col justify-between">
    <!-- Navbar -->
    <header class="bg-slate-900/90 backdrop-blur border-b border-slate-800 sticky top-0 z-40 px-6 py-4">
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="flex items-center gap-3 cursor-pointer" @click="$router.push('/')">
          <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-blue-600 flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/30">
            R
          </div>
          <div>
            <h1 class="font-bold text-xl text-white tracking-wide leading-tight">RentOps</h1>
            <p class="text-xs text-indigo-400 font-medium">Platform Quản Lý & Cho Thuê Phòng Trọ</p>
          </div>
        </div>

        <div class="hidden md:flex items-center space-x-8 text-sm font-semibold text-slate-300">
          <a href="#rooms" class="hover:text-indigo-400 transition">🔑 Khám Phá Phòng Trọ</a>
          <a href="#features" class="hover:text-indigo-400 transition">⚡ Tính Năng SaaS</a>
          <a href="#pricing" class="hover:text-indigo-400 transition">💳 Bảng Giá Gói Cước</a>
        </div>

        <div class="flex items-center space-x-3">
          <button @click="demoAccess" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 font-semibold text-xs rounded-xl border border-slate-700 transition">
            🚀 Trải Nghiệm Demo
          </button>
          <RouterLink to="/login" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition">
            🔑 Đăng Nhập / Đăng Ký
          </RouterLink>
        </div>
      </div>
    </header>

    <!-- Hero Section -->
    <section class="relative px-6 py-16 md:py-24 bg-gradient-to-b from-slate-900 via-indigo-950/40 to-slate-900 overflow-hidden">
      <div class="max-w-5xl mx-auto text-center space-y-6 relative z-10">
        <span class="px-4 py-1.5 bg-indigo-500/20 text-indigo-300 font-bold text-xs rounded-full border border-indigo-500/30 uppercase tracking-widest">
          Nền Tảng Quản Lý & Cho Thuê Bất Động Sản Hàng Đầu
        </span>
        <h1 class="text-4xl md:text-6xl font-black text-white leading-tight tracking-tight">
          Tìm Phòng Ương Ý • Quản Lý Trọ <span class="bg-gradient-to-r from-indigo-400 via-teal-300 to-emerald-400 bg-clip-text text-transparent">Thông Minh & Tự Động</span>
        </h1>
        <p class="text-slate-300 text-base md:text-lg max-w-3xl mx-auto font-light">
          Trải nghiệm hệ thống quản lý phòng trọ Multi-tenant thế hệ mới. Tự động hóa gạch nợ VietQR 24/7, hợp đồng điện tử chữ ký số, cổng tự phục vụ khách thuê và báo cáo tài chính chuyên sâu.
        </p>

        <div class="flex justify-center items-center gap-4 pt-4">
          <a href="#rooms" class="px-6 py-3.5 bg-gradient-to-r from-indigo-500 to-blue-600 hover:from-indigo-600 hover:to-blue-700 font-bold text-white rounded-2xl shadow-xl shadow-indigo-500/30 transition text-sm flex items-center space-x-2">
            <span>🔑 Khám Phá Phòng Cho Thuê</span>
          </a>
          <button @click="demoAccess" class="px-6 py-3.5 bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold rounded-2xl border border-slate-700 transition text-sm">
            ⚡ Thử Nghiệm Hệ Thống Demo
          </button>
        </div>
      </div>
    </section>

    <!-- Public Rooms Showcase Section -->
    <section id="rooms" class="px-6 py-16 bg-slate-900 border-t border-slate-800">
      <div class="max-w-7xl mx-auto space-y-8">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end gap-4">
          <div>
            <h2 class="text-3xl font-black text-white">🏠 Danh Sách Phòng Đang Cho Thuê</h2>
            <p class="text-slate-400 text-sm mt-1">Trải nghiệm xem các phòng trọ/căn hộ dịch vụ thực tế đang có sẵn trên hệ thống</p>
          </div>

          <!-- Search & Filter Controls -->
          <div class="flex flex-wrap gap-3">
            <input
              v-model="searchFilter"
              class="bg-slate-800 border border-slate-700 rounded-xl px-4 py-2 text-sm text-white focus:outline-none focus:border-indigo-500 w-64"
              placeholder="Tìm theo số phòng, tòa nhà..."
            />
            <select v-model="statusFilter" class="bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-sm text-white">
              <option value="all">Tất cả trạng thái</option>
              <option value="vacant">Chỉ phòng trống</option>
            </select>
          </div>
        </div>

        <!-- Room Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6">
          <div
            v-for="room in filteredRooms"
            :key="room.id"
            class="bg-slate-800/80 rounded-2xl border border-slate-700/60 overflow-hidden shadow-xl hover:border-indigo-500/50 transition flex flex-col justify-between"
          >
            <div>
              <div class="h-40 bg-gradient-to-br from-indigo-900/60 to-slate-800 p-4 relative flex flex-col justify-between">
                <span :class="room.status === 0 || room.status === 'vacant' ? 'bg-emerald-500/20 text-emerald-400 border-emerald-500/30' : 'bg-rose-500/20 text-rose-400 border-rose-500/30'" class="px-2.5 py-1 text-xs font-bold rounded-lg border w-fit">
                  {{ room.status === 0 || room.status === 'vacant' ? '🟢 Phòng Trống' : '🔴 Đang Thuê' }}
                </span>
                <div>
                  <p class="text-xs text-indigo-300 font-semibold">{{ room.property_name }}</p>
                  <h3 class="text-2xl font-black text-white">Phòng {{ room.room_number }}</h3>
                </div>
              </div>

              <div class="p-5 space-y-3">
                <div class="flex justify-between items-center">
                  <span class="text-xs text-slate-400">Giá thuê hàng tháng:</span>
                  <span class="text-lg font-black text-emerald-400 font-mono">{{ formatCurrency(room.price) }}</span>
                </div>
                <div class="flex justify-between items-center text-xs text-slate-400">
                  <span>Diện tích: <strong class="text-slate-200">{{ room.area || 25 }} m²</strong></span>
                  <span>Tầng: <strong class="text-slate-200">Tầng {{ room.floor || 1 }}</strong></span>
                </div>

                <div class="pt-2 border-t border-slate-700/60">
                  <p class="text-xs text-slate-400 mb-1.5">Tiện nghi có sẵn:</p>
                  <div class="flex flex-wrap gap-1.5">
                    <span v-for="(amenity, idx) in room.amenities" :key="idx" class="px-2 py-0.5 bg-slate-700 text-slate-300 text-[11px] rounded-md font-medium">
                      ✓ {{ amenity }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div class="p-5 pt-0">
              <button @click="openContactModal(room)" class="w-full py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md transition">
                📞 Liên Hệ Xem Phòng / Đặt Cọc
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Highlight Section -->
    <section id="features" class="px-6 py-16 bg-slate-950 border-t border-slate-800">
      <div class="max-w-7xl mx-auto space-y-12">
        <div class="text-center space-y-3">
          <h2 class="text-3xl font-black text-white">⚡ Tính Năng SaaS Đột Phá Của RentOps</h2>
          <p class="text-slate-400 text-sm max-w-2xl mx-auto">Tối ưu toàn diện trải nghiệm quản lý nhà trọ từ quy mô nhỏ đến chuỗi bất động sản cho thuê lớn</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">💳</div>
            <h3 class="text-lg font-bold text-white">VietQR Auto-Payment 24/7</h3>
            <p class="text-xs text-slate-400 leading-relaxed">Tự động tạo mã VietQR động NAPAS chứa đúng số tiền và cú pháp chuyển khoản. Ngân hàng gửi Webhook gạch nợ hóa đơn ngay lập tức.</p>
          </div>

          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">✍️</div>
            <h3 class="text-lg font-bold text-white">Chữ Ký Số Hợp Đồng Online</h3>
            <p class="text-xs text-slate-400 leading-relaxed">Ký hợp đồng thuê nhà trực tiếp trên điện thoại/máy tính bằng bảng vẽ chữ ký điện tử. Trích xuất file hợp đồng đầy đủ chữ ký 2 bên.</p>
          </div>

          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">📱</div>
            <h3 class="text-lg font-bold text-white">Cổng Khách Thuê Self-Service</h3>
            <p class="text-xs text-slate-400 leading-relaxed">Khách thuê tự tra cứu hóa đơn, theo dõi lịch sử tiền điện nước, gửi phiếu báo hỏng sự cố cho ban quản lý bất kỳ lúc nào.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-slate-950 border-t border-slate-800 py-8 px-6 text-center text-xs text-slate-500">
      <p>© 2026 RentOps Multi-Tenant SaaS Platform. Tất cả các quyền được bảo lưu.</p>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const rooms = ref([])
const searchFilter = ref('')
const statusFilter = ref('all')

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const fetchPublicRooms = async () => {
  try {
    const res = await fetch('/api/v1/public/rooms')
    if (res.ok) {
      const json = await res.json()
      rooms.value = json.data || []
    }
  } catch (err) {
    console.error(err)
  }
}

const filteredRooms = computed(() => {
  return rooms.value.filter(r => {
    const matchSearch = searchFilter.value === '' ||
      r.room_number.toLowerCase().includes(searchFilter.value.toLowerCase()) ||
      r.property_name.toLowerCase().includes(searchFilter.value.toLowerCase())

    const matchStatus = statusFilter.value === 'all' ||
      (statusFilter.value === 'vacant' && (r.status === 0 || r.status === 'vacant'))

    return matchSearch && matchStatus
  })
})

const demoAccess = async () => {
  await authStore.login('demo@rentops.vn')
  router.push('/')
}

const openContactModal = (room) => {
  alert(`Cảm ơn bạn đã quan tâm Phòng ${room.room_number} tại ${room.property_name}.\n\nVui lòng gọi Hotline Ban Quản Lý: 0901 234 567 hoặc Bấm "Trải Nghiệm Demo" để đăng ký!`)
}

onMounted(fetchPublicRooms)
</script>
