<template>
  <div class="min-h-screen bg-slate-900 text-slate-100 font-sans flex flex-col justify-between">
    <!-- Navbar -->
    <header class="bg-slate-900/90 backdrop-blur border-b border-slate-800 sticky top-0 z-40 px-6 py-4">
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="flex items-center gap-3 cursor-pointer" @click="$router.push('/landing')">
          <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-blue-600 flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/30">
            R
          </div>
          <div>
            <h1 class="font-bold text-xl text-white tracking-wide leading-tight">RentOps</h1>
            <p class="text-xs text-indigo-400 font-medium">Platform Quản Lý & Cho Thuê Phòng Trọ</p>
          </div>
        </div>

        <div class="flex items-center space-x-4">
          <RouterLink to="/landing#rooms" class="text-xs font-semibold text-slate-300 hover:text-white transition">
            ⬅️ Xem danh sách phòng
          </RouterLink>
          <button @click="demoAccess" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 font-semibold text-xs rounded-xl border border-slate-700 transition">
            🚀 Trải Nghiệm Demo
          </button>
          <RouterLink to="/login" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition">
            🔑 Đăng Nhập
          </RouterLink>
        </div>
      </div>
    </header>

    <!-- Main Content Container -->
    <main class="max-w-7xl mx-auto px-6 py-10 w-full space-y-8 flex-1">
      <!-- Breadcrumb Navigation -->
      <nav class="flex items-center gap-2 text-xs text-slate-400 font-medium">
        <RouterLink to="/landing" class="hover:text-indigo-400">Trang chủ</RouterLink>
        <span>/</span>
        <RouterLink to="/landing#rooms" class="hover:text-indigo-400">Danh sách phòng cho thuê</RouterLink>
        <span>/</span>
        <span class="text-slate-200 font-semibold">Phòng {{ room.room_number || roomId }}</span>
      </nav>

      <!-- Banner Header Section -->
      <div class="bg-gradient-to-r from-indigo-950 via-slate-800 to-slate-900 border border-slate-700/80 rounded-3xl p-8 relative overflow-hidden shadow-2xl space-y-4">
        <div class="flex flex-wrap items-center gap-3">
          <span :class="room.status === 0 || room.status === 'vacant' ? 'bg-emerald-500/20 text-emerald-400 border-emerald-500/30' : 'bg-rose-500/20 text-rose-400 border-rose-500/30'" class="px-3.5 py-1 text-xs font-bold rounded-xl border">
            {{ room.status === 0 || room.status === 'vacant' ? '🟢 Phòng Trống (Sẵn sàng dọn vào ở)' : '🔴 Phòng Đang Có Khách Thuê' }}
          </span>
          <span class="bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 text-xs font-bold px-3 py-1 rounded-xl">
            📐 Tầng {{ room.floor || 1 }}
          </span>
          <span class="bg-slate-800 text-slate-300 border border-slate-700 text-xs font-bold px-3 py-1 rounded-xl">
            📏 Diện tích {{ room.area || 28 }} m²
          </span>
        </div>

        <div>
          <p class="text-sm font-semibold text-indigo-400">{{ room.property_name }}</p>
          <h1 class="text-3xl md:text-5xl font-black text-white tracking-tight mt-1">
            Chi Tiết Căn Hộ / Phòng {{ room.room_number }}
          </h1>
          <p class="text-slate-300 text-sm mt-2 flex items-center gap-1.5">
            <span>📍</span> Địa chỉ: <strong>{{ room.property_name }} - Khu vực trung tâm thành phố, an ninh khóa vân tay 24/7, giờ giấc tự do không chung chủ.</strong>
          </p>
        </div>
      </div>

      <!-- Detail Grid: Content Left vs Action Panel Right -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left Column: Image Gallery, Specs, Amenities, Utility Fees -->
        <div class="lg:col-span-2 space-y-8">
          <!-- Image Gallery Showcase Section (1 Main Photo + 3 Secondary Thumbnails) -->
          <div class="bg-slate-800/80 rounded-3xl p-5 border border-slate-700/80 shadow-2xl space-y-4">
            <div class="flex items-center justify-between px-1">
              <h3 class="text-base font-bold text-white flex items-center gap-2">
                <span>🖼️</span> Không Gian Phòng Thực Tế
              </h3>
              <span class="text-xs text-indigo-400 font-semibold bg-indigo-500/10 border border-indigo-500/20 px-3 py-1 rounded-full">
                Click ảnh phụ bên dưới để thay thế ảnh trong khung
              </span>
            </div>

            <!-- Main Photo Display Frame -->
            <div class="relative w-full h-[300px] sm:h-[400px] rounded-2xl overflow-hidden bg-slate-950 border border-slate-700/60 group shadow-inner">
              <img
                :src="activePhoto.url"
                :alt="activePhoto.title"
                class="w-full h-full object-cover transition-all duration-300 group-hover:scale-105"
              />
              
              <!-- Gradient Overlay Banner -->
              <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-black/30 pointer-events-none"></div>

              <!-- Photo Info Badge -->
              <div class="absolute top-4 left-4 bg-slate-900/85 backdrop-blur-md px-3.5 py-1.5 rounded-xl border border-slate-700/80 text-xs font-bold text-slate-100 flex items-center gap-2 shadow-lg">
                <span>📸</span>
                <span>{{ activePhoto.title }} ({{ activePhotoIndex + 1 }}/{{ roomPhotos.length }})</span>
              </div>

              <!-- Real Photo Verified Tag -->
              <div class="absolute top-4 right-4 bg-emerald-500/20 backdrop-blur-md text-emerald-300 border border-emerald-500/40 px-3 py-1 rounded-xl text-xs font-black shadow-md flex items-center gap-1">
                <span>✓</span> Ảnh thực tế 100%
              </div>

              <!-- Prev / Next Navigation Buttons -->
              <button
                @click="prevPhoto"
                class="absolute left-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-slate-900/70 hover:bg-slate-900 text-white flex items-center justify-center font-bold text-lg backdrop-blur-md border border-slate-700 transition opacity-80 hover:opacity-100"
                title="Ảnh trước"
              >
                ❮
              </button>
              <button
                @click="nextPhoto"
                class="absolute right-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-slate-900/70 hover:bg-slate-900 text-white flex items-center justify-center font-bold text-lg backdrop-blur-md border border-slate-700 transition opacity-80 hover:opacity-100"
                title="Ảnh tiếp theo"
              >
                ❯
              </button>
            </div>

            <!-- Thumbnail Selector Grid (1 Main + 3 Secondary Photos) -->
            <div class="grid grid-cols-4 gap-3">
              <div
                v-for="(photo, index) in roomPhotos"
                :key="index"
                @click="selectPhoto(index)"
                :class="[
                  'relative h-20 sm:h-24 rounded-xl overflow-hidden cursor-pointer border-2 transition-all duration-200 group',
                  activePhotoIndex === index
                    ? 'border-indigo-500 ring-2 ring-indigo-500/50 shadow-lg shadow-indigo-500/30 scale-[1.03]'
                    : 'border-slate-700/60 opacity-60 hover:opacity-100 hover:border-slate-500'
                ]"
              >
                <img :src="photo.url" :alt="photo.title" class="w-full h-full object-cover group-hover:scale-110 transition duration-300" />
                <div class="absolute inset-0 bg-slate-950/20 group-hover:bg-transparent transition"></div>
                <div v-if="activePhotoIndex === index" class="absolute bottom-1 left-1 bg-indigo-600 text-white text-[10px] font-extrabold px-1.5 py-0.5 rounded shadow">
                  Đang xem
                </div>
              </div>
            </div>
          </div>
          <!-- Quick Specs Cards -->
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700 shadow-md">
              <span class="text-xs uppercase font-bold text-slate-400">Giá Thuê / Tháng</span>
              <div class="text-2xl font-black text-emerald-400 font-mono mt-1.5">{{ formatCurrency(room.price) }}</div>
              <p class="text-[11px] text-slate-400 mt-1">Thanh toán định kỳ hàng tháng</p>
            </div>

            <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700 shadow-md">
              <span class="text-xs uppercase font-bold text-slate-400">Tiền Đặt Cọc</span>
              <div class="text-2xl font-black text-amber-400 font-mono mt-1.5">{{ formatCurrency(room.price) }}</div>
              <p class="text-[11px] text-slate-400 mt-1">Hoàn trả 100% khi hết hợp đồng</p>
            </div>

            <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700 shadow-md">
              <span class="text-xs uppercase font-bold text-slate-400">Diện Tích Phòng</span>
              <div class="text-2xl font-black text-slate-100 font-mono mt-1.5">{{ room.area || 28 }} m²</div>
              <p class="text-[11px] text-slate-400 mt-1">Cửa sổ thoáng mát, ánh sáng tự nhiên</p>
            </div>

            <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700 shadow-md">
              <span class="text-xs uppercase font-bold text-slate-400">Vị Trí Tòa Nhà</span>
              <div class="text-2xl font-black text-indigo-300 font-mono mt-1.5">Tầng {{ room.floor || 1 }}</div>
              <p class="text-[11px] text-slate-400 mt-1">Có thang máy tải trọng lớn 24/7</p>
            </div>
          </div>

          <!-- Full Amenities Section -->
          <div class="bg-slate-800/60 rounded-3xl p-6 border border-slate-700/80 shadow-lg space-y-4">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>🛋️</span> Danh Sách Nội Thất & Tiện Nghi Trang Bị
            </h3>
            <p class="text-xs text-slate-400">Phòng được chuẩn bị đầy đủ thiết bị gia dụng hiện đại, chỉ cần xách vali vào ở ngay:</p>

            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3 pt-2">
              <div
                v-for="(item, idx) in (room.amenities || defaultAmenities)"
                :key="idx"
                class="px-4 py-3 bg-slate-900/90 rounded-2xl border border-slate-700/60 text-xs font-bold text-slate-200 flex items-center space-x-2 shadow-sm"
              >
                <span class="text-emerald-400 font-extrabold text-base">✓</span>
                <span>{{ item }}</span>
              </div>
            </div>
          </div>

          <!-- Services & Utility Price Rates -->
          <div class="bg-indigo-950/40 rounded-3xl p-6 border border-indigo-500/30 shadow-lg space-y-4">
            <h3 class="text-lg font-bold text-white flex items-center gap-2">
              <span>⚡</span> Bảng Niêm Yết Giá Điện Nước & Phí Dịch Vụ Minh Bạch
            </h3>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 font-mono text-sm">
              <div class="bg-slate-900/80 p-4 rounded-2xl border border-slate-800">
                <div class="text-xs font-sans text-slate-400">⚡ Giá Điện Sinh Hoạt</div>
                <div class="text-lg font-black text-emerald-400 mt-1">3.800 đ / kWh</div>
                <div class="text-[10px] font-sans text-slate-500">Đồng hồ công tơ riêng từng phòng</div>
              </div>

              <div class="bg-slate-900/80 p-4 rounded-2xl border border-slate-800">
                <div class="text-xs font-sans text-slate-400">💧 Giá Nước Sạch</div>
                <div class="text-lg font-black text-emerald-400 mt-1">30.000 đ / m³</div>
                <div class="text-[10px] font-sans text-slate-500">Hoặc tính theo đầu người 100k/người</div>
              </div>

              <div class="bg-slate-900/80 p-4 rounded-2xl border border-slate-800">
                <div class="text-xs font-sans text-slate-400">🌐 Phí Dịch Vụ Chung</div>
                <div class="text-lg font-black text-emerald-400 mt-1">150.000 đ / tháng</div>
                <div class="text-[10px] font-sans text-slate-500">Bao gồm Wifi 200Mbps, Rác & Vệ sinh</div>
              </div>
            </div>
          </div>

          <!-- Building Regulations & Rules -->
          <div class="bg-slate-800/40 rounded-3xl p-6 border border-slate-700/60 space-y-3 text-xs text-slate-300">
            <h3 class="text-base font-bold text-white flex items-center gap-2">
              <span>📋</span> Quy Định & Điều Khoản Thuê Phòng
            </h3>
            <ul class="list-disc list-inside space-y-2 text-slate-300 leading-relaxed">
              <li>Hợp đồng cho thuê linh hoạt tối thiểu từ <strong>06 tháng đến 12 tháng</strong>.</li>
              <li>Giờ giấc đi lại hoàn toàn tự do 24/24h nhờ hệ thống cổng khóa vân tay bảo mật.</li>
              <li>Hỗ trợ đăng ký tạm trú tạm vắng chính thức với công an địa phương.</li>
              <li>Thanh toán tiền nhà và hóa đơn điện nước định kỳ từ ngày 01 đến ngày 05 hàng tháng bằng mã thanh toán <strong>VietQR tự động</strong>.</li>
            </ul>
          </div>
        </div>

        <!-- Right Column: Booking Form & Direct Contact Panel -->
        <div class="space-y-6">
          <!-- Online Booking & Hotline Card -->
          <div class="bg-gradient-to-br from-indigo-900 to-slate-900 rounded-3xl p-6 border border-indigo-500/40 shadow-2xl space-y-4">
            <h3 class="text-lg font-black text-white">📞 Liên Hệ & Đặt Cọc Online</h3>
            <p class="text-xs text-slate-300">Quý khách có thể đặt cọc giữ phòng trực tuyến 24/7 bằng mã VietQR tự động hoặc gọi điện trực tiếp:</p>

            <button
              @click="showBookingModal = true"
              class="w-full py-3.5 bg-gradient-to-r from-amber-500 to-emerald-500 hover:from-amber-600 hover:to-emerald-600 text-slate-950 font-black text-sm rounded-2xl shadow-xl shadow-amber-500/20 flex items-center justify-center space-x-2 transition"
            >
              <span>⚡</span> <span>Đặt Cọc Giữ Phòng VietQR 24/7</span>
            </button>

            <a href="tel:0901234567" class="w-full py-3 bg-emerald-600/90 hover:bg-emerald-600 text-white font-extrabold text-xs rounded-2xl shadow-md flex items-center justify-center space-x-2 transition">
              <span>📞</span> <span>Hotline: 0901 234 567</span>
            </a>

            <button @click="openZalo" class="w-full py-2.5 bg-blue-600/80 hover:bg-blue-600 text-white font-bold text-xs rounded-2xl shadow-sm transition flex items-center justify-center space-x-2">
              <span>💬</span> <span>Nhắn Zalo Nhận Video Phòng</span>
            </button>
          </div>

          <!-- Schedule Appointment Form -->
          <form @submit.prevent="submitAppointment" class="bg-slate-800/80 rounded-3xl p-6 border border-slate-700 shadow-xl space-y-4">
            <h3 class="text-base font-bold text-white border-b border-slate-700 pb-3">
              📅 Đăng Ký Hẹn Lịch Xem Phòng
            </h3>

            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1 uppercase">Họ và tên của bạn</label>
              <input v-model="form.fullName" required placeholder="Nguyễn Văn A" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1 uppercase">Số điện thoại / Zalo</label>
              <input v-model="form.phone" required type="tel" placeholder="0988777666" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1 uppercase">Ngày & Giờ muốn xem phòng</label>
              <input v-model="form.datetime" required type="datetime-local" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1 uppercase">Ghi chú thêm</label>
              <textarea v-model="form.note" rows="2" placeholder="Ví dụ: Muốn chuyển vào ở ngay trong tuần này..." class="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500"></textarea>
            </div>

            <button class="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition">
              ✨ Gửi Đăng Ký Xem Phòng
            </button>

            <p v-if="successMsg" class="text-xs bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded-xl p-3 text-center font-medium">
              {{ successMsg }}
            </p>
          </form>

          <!-- System Demo Button -->
          <div class="bg-slate-900/90 rounded-3xl p-6 border border-slate-800 space-y-3 text-center">
            <h4 class="text-sm font-bold text-white">Bạn là Chủ Nhà Trọ / Quản Lý Bất Động Sản?</h4>
            <p class="text-xs text-slate-400">Trải nghiệm ngay phần mềm RentOps để tự động hóa gạch nợ VietQR, tính tiền điện nước và quản lý hợp đồng:</p>
            <button @click="demoAccess" class="w-full py-2.5 bg-slate-800 hover:bg-slate-700 text-indigo-300 font-bold text-xs rounded-xl border border-slate-700 transition">
              🚀 Trải Nghiệm Quản Lý Demo Admin
            </button>
          </div>
        </div>
      </div>
    </main>

    <!-- Detailed App Footer -->
    <AppFooter />

    <!-- Booking Modal VietQR -->
    <BookingModal
      v-if="showBookingModal"
      :room="room"
      @close="showBookingModal = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'
import AppFooter from '../components/AppFooter.vue'
import BookingModal from '../components/BookingModal.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const showBookingModal = ref(false)

const roomId = computed(() => route.params.id)

const defaultRoomsList = [
  { id: 101, room_number: "101", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 3500000, status: "vacant", floor: 1, area: 25, amenities: ["Điều hòa Inverter", "Tủ lạnh 2 cánh", "Wifi 200Mbps", "Ban công thoáng", "Bình nóng lạnh", "Giường nệm cao su"] },
  { id: 102, room_number: "102", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 3800000, status: "occupied", floor: 1, area: 28, amenities: ["Điều hòa", "Máy giặt", "Nóng lạnh", "Giường nệm cao su", "Tủ quần áo 3 cánh"] },
  { id: 103, room_number: "103", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 3500000, status: "vacant", floor: 1, area: 25, amenities: ["Điều hòa Inverter", "Tủ quần áo 3 cánh", "Tủ lạnh", "Bếp điện", "Bình nóng lạnh"] },
  { id: 201, room_number: "201", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 4200000, status: "occupied", floor: 2, area: 30, amenities: ["Điều hòa", "Tủ lạnh", "Sàn gỗ tự nhiên", "Ban công rộng", "Wifi tốc độ cao"] },
  { id: 202, room_number: "202", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 4500000, status: "occupied", floor: 2, area: 32, amenities: ["Điều hòa Inverter", "Máy giặt riêng", "Tủ lạnh Inverter", "Sofa cao cấp", "Giường gỗ sồi"] },
  { id: 203, room_number: "203", property_name: "Tòa Nhà RentOps A - Nam Từ Liêm", price: 4000000, status: "vacant", floor: 2, area: 28, amenities: ["Điều hòa", "Wifi tốc độ cao", "Bình nóng lạnh", "Giường nệm gỗ", "Ban công thoáng"] },
  { id: 301, room_number: "301", property_name: "Tòa Nhà RentOps B - Cầu Giấy", price: 5000000, status: "vacant", floor: 3, area: 35, amenities: ["Điều hòa Inverter", "Bếp từ đôi âm", "Máy hút mùi", "Tủ lạnh 250L", "Tủ quần áo gỗ"] },
  { id: 302, room_number: "302", property_name: "Tòa Nhà RentOps B - Cầu Giấy", price: 5200000, status: "occupied", floor: 3, area: 38, amenities: ["Điều hòa", "Tủ lạnh", "Ban công thoáng", "Bàn học/làm việc", "Nóng lạnh Rossi"] },
  { id: 303, room_number: "303", property_name: "Tòa Nhà RentOps B - Cầu Giấy", price: 4800000, status: "vacant", floor: 3, area: 32, amenities: ["Điều hòa Inverter", "Giường gỗ sồi", "Tủ 3 cánh", "Bình nóng lạnh", "Wifi 200Mbps"] },
  { id: 401, room_number: "401 (Studio)", property_name: "Căn Hộ Dịch Vụ RentOps C - Đống Đa", price: 6500000, status: "vacant", floor: 4, area: 42, amenities: ["Full nội thất cao cấp", "Smart TV 50 inch", "Tủ lạnh side-by-side", "Bếp từ đôi", "Máy giặt sấy"] },
  { id: 402, room_number: "402 (Studio)", property_name: "Căn Hộ Dịch Vụ RentOps C - Đống Đa", price: 6800000, status: "occupied", floor: 4, area: 45, amenities: ["Full nội thất cao cấp", "Bồn tắm đứng", "Máy giặt sấy", "Ban công view phố", "Smart TV"] }
]

const defaultAmenities = ["Điều hòa Inverter", "Tủ lạnh 2 cánh", "Wifi 200Mbps", "Ban công thoáng", "Bình nóng lạnh", "Giường nệm cao su"]

const room = ref({
  id: route.params.id,
  room_number: route.params.id || "203",
  property_name: "Tòa Nhà RentOps A - Nam Từ Liêm",
  price: 4000000,
  status: "vacant",
  floor: 2,
  area: 28,
  amenities: defaultAmenities
})

const roomPhotos = ref([
  { url: '/images/rooms/main.png', title: 'Ảnh Chính: Không Gian Tổng Thể & Giường Ngủ' },
  { url: '/images/rooms/living.png', title: 'Ảnh Phụ 1: Góc Sofa & Bàn Làm Việc' },
  { url: '/images/rooms/kitchen.png', title: 'Ảnh Phụ 2: Khu Bếp Hiện Đại & Tủ Lạnh' },
  { url: '/images/rooms/bathroom.png', title: 'Ảnh Phụ 3: Nhà Vệ Sinh Khép Kín Sạch Sẽ' }
])

const activePhotoIndex = ref(0)
const activePhoto = computed(() => roomPhotos.value[activePhotoIndex.value] || roomPhotos.value[0])

const selectPhoto = (index) => {
  activePhotoIndex.value = index
}

const prevPhoto = () => {
  activePhotoIndex.value = (activePhotoIndex.value - 1 + roomPhotos.value.length) % roomPhotos.value.length
}

const nextPhoto = () => {
  activePhotoIndex.value = (activePhotoIndex.value + 1) % roomPhotos.value.length
}

const form = ref({
  fullName: '',
  phone: '',
  datetime: '',
  note: ''
})

const successMsg = ref('')

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const loadRoomDetail = async () => {
  const targetId = route.params.id
  if (!targetId) return

  const found = defaultRoomsList.find(r => r.id.toString() === targetId.toString() || r.room_number.toString() === targetId.toString())
  if (found) {
    room.value = found
  }

  try {
    const res = await api.get('/public/rooms')
    if (res && res.data) {
      const apiFound = res.data.find(r => r.id.toString() === targetId.toString() || r.room_number.toString() === targetId.toString())
      if (apiFound) {
        room.value = apiFound
      }
    }
  } catch (err) {
    console.log('Using local room detail')
  }
}

const submitAppointment = () => {
  successMsg.value = `Cảm ơn ${form.value.fullName}! Ban quản lý tòa nhà đã ghi nhận lịch hẹn xem Phòng ${room.value.room_number} vào lúc ${form.value.datetime}. Chúng tôi sẽ gọi tới SĐT ${form.value.phone} để xác nhận!`
  form.value = { fullName: '', phone: '', datetime: '', note: '' }
}

const openZalo = () => {
  alert(`Vui lòng kết bạn Zalo Hotline: 0901.234.567 để nhận Video/Ảnh quay trực tiếp Phòng ${room.value.room_number}!`)
}

const demoAccess = async () => {
  await authStore.login('demo@rentops.vn')
  router.push('/')
}

onMounted(loadRoomDetail)
</script>
