<template>
  <div class="min-h-screen bg-slate-950 text-slate-100 font-sans flex flex-col justify-between selection:bg-indigo-500 selection:text-white relative overflow-x-hidden">
    <!-- Navbar -->
    <header class="bg-slate-950/90 backdrop-blur-xl border-b border-slate-800/80 sticky top-0 z-40 px-6 py-4 shadow-xl">
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="flex items-center gap-3 cursor-pointer group" @click="$router.push('/')">
          <div class="w-10 h-10 rounded-xl gradient-brand flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/30">
            R
          </div>
          <div>
            <h1 class="font-black text-xl text-white tracking-wide leading-tight bg-gradient-to-r from-white via-slate-100 to-indigo-200 bg-clip-text text-transparent">RentOps</h1>
            <p class="text-[10px] text-indigo-400 font-bold tracking-widest uppercase">Platform Quản Lý & Cho Thuê Phòng Trọ</p>
          </div>
        </div>

        <div class="hidden md:flex items-center space-x-8 text-xs font-bold text-slate-300">
          <a href="#gallery" class="hover:text-indigo-400 transition">📸 Bố Cục Phòng</a>
          <a href="#rooms" class="hover:text-indigo-400 transition">🔑 Phòng Cho Thuê</a>
          <a href="#features" class="hover:text-indigo-400 transition">⚡ Tính Năng SaaS</a>
        </div>

        <div class="flex items-center space-x-3">
          <button @click="demoAccess" class="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-slate-200 font-bold text-xs rounded-xl border border-slate-700/80 transition shadow-sm">
            🚀 Trải Nghiệm Demo
          </button>
          <RouterLink to="/login" class="px-4.5 py-2 bg-gradient-to-r from-indigo-600 via-indigo-500 to-blue-600 hover:from-indigo-500 hover:to-blue-500 text-white font-black text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition">
            🔑 Đăng Nhập / Đăng Ký
          </RouterLink>
        </div>
      </div>
    </header>

    <!-- Hero Section (Original Hero Restored) -->
    <section class="relative px-6 py-20 md:py-28 bg-gradient-to-b from-slate-950 via-slate-900 to-slate-950 overflow-hidden border-b border-slate-800">
      <div class="max-w-5xl mx-auto text-center space-y-7 relative z-10">
        <span class="inline-flex items-center gap-2 px-4 py-1.5 bg-indigo-500/15 text-indigo-300 font-extrabold text-xs rounded-full border border-indigo-500/30 uppercase tracking-widest shadow-inner">
          <span class="w-2 h-2 rounded-full bg-indigo-400"></span>
          Nền Tảng Quản Lý & Cho Thuê Bất Động Sản Hàng Đầu
        </span>
        <h1 class="text-4xl md:text-6xl font-black text-white leading-tight tracking-tight">
          Tìm Phòng Ương Ý • Quản Lý Trọ <span class="bg-gradient-to-r from-indigo-400 via-cyan-300 to-emerald-400 bg-clip-text text-transparent">Thông Minh & Tự Động</span>
        </h1>
        <p class="text-slate-300 text-base md:text-lg max-w-3xl mx-auto font-normal leading-relaxed">
          Trải nghiệm hệ thống quản lý phòng trọ Multi-tenant thế thế hệ mới. Tự động hóa gạch nợ VietQR 24/7, hợp đồng điện tử chữ ký số, cổng tự phục vụ khách thuê và báo cáo tài chính chuyên sâu.
        </p>

        <div class="flex justify-center items-center gap-4 pt-4">
          <a href="#rooms" class="px-7 py-3.5 bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-500 hover:to-blue-500 font-extrabold text-white rounded-2xl shadow-xl shadow-indigo-600/35 transition text-sm flex items-center space-x-2">
            <span>🔑 Khám Phá Phòng Cho Thuê</span>
          </a>
          <button @click="demoAccess" class="px-7 py-3.5 bg-slate-900 hover:bg-slate-800 text-slate-200 font-extrabold rounded-2xl border border-slate-700/80 transition text-sm">
            ⚡ Thử Nghiệm Hệ Thống Demo
          </button>
        </div>
      </div>
    </section>

    <!-- Creative Room Photo Bento-Grid Showcase Section -->
    <section id="gallery" class="px-6 py-16 bg-slate-950 border-b border-slate-800">
      <div class="max-w-7xl mx-auto space-y-10">
        <div class="text-center space-y-3">
          <span class="px-3.5 py-1 bg-indigo-500/20 text-indigo-300 font-black text-xs rounded-full border border-indigo-500/30 uppercase tracking-widest">
            Bố Cục Không Gian Sáng Tạo
          </span>
          <h2 class="text-3xl md:text-4xl font-black text-white">📸 Không Gian Căn Hộ Thực Tế Cho Thuê</h2>
          <p class="text-slate-400 text-xs max-w-2xl mx-auto font-medium">Khám phá kiến trúc nội thất hiện đại được tối ưu hóa cho phong cách sống năng động</p>
        </div>

        <!-- Asymmetric Bento Photo Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <!-- Big Feature Card (Spans 2 columns on desktop) -->
          <div class="md:col-span-2 relative rounded-3xl overflow-hidden border border-slate-800 group h-[380px]">
            <img src="/images/hero_banner.png" alt="Căn hộ Studio Luxury" class="w-full h-full object-cover" />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent"></div>
            <div class="absolute bottom-6 left-6 right-6 flex items-end justify-between">
              <div>
                <span class="px-3 py-1 bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 text-xs font-black rounded-lg">🟢 Studio Ban Công View Phố</span>
                <h3 class="text-2xl font-black text-white mt-2">Căn Hộ Dịch Vụ RentOps Penthouse</h3>
                <p class="text-slate-300 text-xs mt-1">Diện tích 45m² • Điều hòa Inverter • Full Nội Thất Sồi</p>
              </div>
              <span class="text-xl font-black text-emerald-400 font-mono bg-slate-950/90 px-3.5 py-2 rounded-xl border border-emerald-500/30">6.8tr/tháng</span>
            </div>
          </div>

          <!-- Secondary Grid Item 1 -->
          <div class="relative rounded-3xl overflow-hidden border border-slate-800 group h-[380px]">
            <img src="/images/studio.png" alt="Phòng Trọ Smart Studio" class="w-full h-full object-cover" />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent"></div>
            <div class="absolute bottom-6 left-6 right-6">
              <span class="px-3 py-1 bg-indigo-500/20 text-indigo-300 border border-indigo-500/40 text-xs font-black rounded-lg">✨ Smart Studio 28m²</span>
              <h3 class="text-xl font-black text-white mt-2">Phòng Trọ Khép Kín Hiện Đại</h3>
              <p class="text-emerald-400 font-black font-mono mt-1 text-base">4.200.000 đ/tháng</p>
            </div>
          </div>

          <!-- Secondary Grid Item 2 -->
          <div class="relative rounded-3xl overflow-hidden border border-slate-800 group h-[280px]">
            <img src="/images/suite.png" alt="Căn Hộ Suite Đôi" class="w-full h-full object-cover" />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent"></div>
            <div class="absolute bottom-5 left-5 right-5">
              <span class="px-2.5 py-1 bg-amber-500/20 text-amber-300 border border-amber-500/40 text-xs font-black rounded-lg">🛋️ Full Sofa TV 50 inch</span>
              <h3 class="text-lg font-black text-white mt-1.5">Suite 1 Phòng Ngủ</h3>
              <p class="text-emerald-400 font-black font-mono text-sm">5.500.000 đ/tháng</p>
            </div>
          </div>

          <!-- Secondary Grid Item 3 (Spans 2 cols) -->
          <div class="md:col-span-2 relative rounded-3xl overflow-hidden border border-slate-800 group h-[280px]">
            <img src="/images/bedroom.png" alt="Phòng Ngủ Minimalist" class="w-full h-full object-cover" />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent"></div>
            <div class="absolute bottom-5 left-6 right-6 flex items-center justify-between">
              <div>
                <span class="px-2.5 py-1 bg-blue-500/20 text-blue-300 border border-blue-500/40 text-xs font-black rounded-lg">🌿 Minimalist Bedroom Decor</span>
                <h3 class="text-xl font-black text-white mt-1.5">Phòng Ngủ Decor Phong Cách Tối Giản</h3>
              </div>
              <span class="text-lg font-black text-emerald-400 font-mono bg-slate-950/90 px-3.5 py-1.5 rounded-xl border border-emerald-500/30">3.8tr/tháng</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Public Rooms Showcase Section with Real Room Photos & Property Tabs -->
    <section id="rooms" class="px-4 sm:px-6 py-20 bg-slate-950 border-b border-slate-800/80 relative overflow-hidden">
      <!-- Ambient Gradient Glow Effects -->
      <div class="absolute top-1/3 left-1/2 -translate-x-1/2 w-[900px] h-[400px] bg-gradient-to-tr from-indigo-600/10 via-purple-600/10 to-emerald-500/10 blur-[140px] pointer-events-none rounded-full"></div>

      <div class="max-w-7xl mx-auto space-y-10 relative z-10">
        <!-- Header Controls -->
        <div class="flex flex-col lg:flex-row lg:items-end justify-between gap-6">
          <div>
            <div class="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-xs font-bold uppercase tracking-wider mb-3">
              <span class="relative flex h-2 w-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                <span class="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
              </span>
              Bộ Sưu Tập Bất Động Sản Cho Thuê
            </div>
            <h2 class="text-3xl sm:text-4xl font-black text-white tracking-tight">
              Khám Phá Căn Hộ & Phòng Trọ <span class="bg-clip-text text-transparent bg-gradient-to-r from-indigo-400 via-purple-300 to-emerald-400">Cao Cấp</span>
            </h2>
            <p class="text-slate-400 text-xs sm:text-sm mt-2 max-w-2xl font-normal leading-relaxed">
              Trải nghiệm không gian sống hiện đại, tiện nghi vượt trội với quy trình thuê minh bạch và tự động hóa 100%.
            </p>
          </div>

          <!-- Right Side Controls: Search Box & View Mode Toggle -->
          <div class="flex flex-wrap items-center gap-3 w-full lg:w-auto">
            <div class="relative flex-1 sm:w-72">
              <input
                v-model="searchFilter"
                class="w-full bg-slate-900/90 border border-slate-800 focus:border-indigo-500/70 rounded-2xl px-4 py-3 pl-10 text-xs text-white placeholder-slate-500 transition-all outline-none shadow-xl focus:ring-2 focus:ring-indigo-500/20"
                placeholder="Tìm số phòng, tòa nhà, tiện ích..."
              />
              <span class="absolute left-3.5 top-3.5 text-slate-500 text-sm">🔍</span>
            </div>

            <!-- View Mode Switcher: Grid vs List -->
            <div class="flex bg-slate-900/90 p-1 rounded-2xl border border-slate-800 shadow-xl backdrop-blur-md">
              <button
                @click="viewMode = 'grid'"
                :class="viewMode === 'grid' ? 'bg-gradient-to-r from-indigo-600 to-blue-600 text-white font-bold shadow-md shadow-indigo-600/30' : 'text-slate-400 hover:text-white font-semibold'"
                class="px-3.5 py-2 rounded-xl text-xs transition flex items-center gap-1.5"
                title="Chế độ Lưới Thẻ"
              >
                <span>❖</span> <span class="hidden sm:inline">Lưới Thẻ</span>
              </button>
              <button
                @click="viewMode = 'list'"
                :class="viewMode === 'list' ? 'bg-gradient-to-r from-indigo-600 to-blue-600 text-white font-bold shadow-md shadow-indigo-600/30' : 'text-slate-400 hover:text-white font-semibold'"
                class="px-3.5 py-2 rounded-xl text-xs transition flex items-center gap-1.5"
                title="Chế độ Danh Sách"
              >
                <span>☰</span> <span class="hidden sm:inline">Danh Sách</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Filter Bar: Property Building Tabs + Status Tabs -->
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 bg-slate-900/60 p-2.5 sm:p-3 rounded-2xl border border-slate-800/80 backdrop-blur-md">
          <!-- Property Tabs -->
          <div class="flex items-center gap-2 overflow-x-auto w-full sm:w-auto pb-1 sm:pb-0 scrollbar-none">
            <button
              @click="selectedPropertyTab = 'all'"
              :class="['px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap', selectedPropertyTab === 'all' ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/25 border border-indigo-400/30' : 'bg-slate-900/80 text-slate-400 hover:text-white hover:bg-slate-800 border border-slate-800']"
            >
              🏢 Tất Cả Tòa Nhà
            </button>
            <button
              @click="selectedPropertyTab = 'Tòa Nhà RentOps A'"
              :class="['px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap', selectedPropertyTab === 'Tòa Nhà RentOps A' ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/25 border border-indigo-400/30' : 'bg-slate-900/80 text-slate-400 hover:text-white hover:bg-slate-800 border border-slate-800']"
            >
              🏛️ Tòa RentOps A (Nam Từ Liêm)
            </button>
            <button
              @click="selectedPropertyTab = 'Tòa Nhà RentOps B'"
              :class="['px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap', selectedPropertyTab === 'Tòa Nhà RentOps B' ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/25 border border-indigo-400/30' : 'bg-slate-900/80 text-slate-400 hover:text-white hover:bg-slate-800 border border-slate-800']"
            >
              🏬 Tòa RentOps B (Cầu Giấy)
            </button>
            <button
              @click="selectedPropertyTab = 'Căn Hộ Dịch Vụ RentOps C'"
              :class="['px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap', selectedPropertyTab === 'Căn Hộ Dịch Vụ RentOps C' ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/25 border border-indigo-400/30' : 'bg-slate-900/80 text-slate-400 hover:text-white hover:bg-slate-800 border border-slate-800']"
            >
              ⭐ Căn Hộ RentOps C (Đống Đa)
            </button>
          </div>

          <!-- Status Filter -->
          <div class="flex items-center gap-2 self-end sm:self-auto">
            <button
              @click="statusFilter = 'all'"
              :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition', statusFilter === 'all' ? 'bg-slate-800 text-white border border-slate-700' : 'text-slate-400 hover:text-white']"
            >
              Tất cả
            </button>
            <button
              @click="statusFilter = 'vacant'"
              :class="['px-3.5 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1.5', statusFilter === 'vacant' ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 shadow-sm' : 'text-slate-400 hover:text-emerald-400']"
            >
              <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
              Chỉ phòng trống
            </button>
          </div>
        </div>

        <!-- 1. GRID VIEW MODE -->
        <div v-if="viewMode === 'grid'" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-7">
          <div
            v-for="room in visibleRooms"
            :key="room.id"
            class="group bg-slate-900/80 hover:bg-slate-900 rounded-3xl border border-slate-800/90 hover:border-indigo-500/40 overflow-hidden shadow-xl hover:shadow-2xl hover:shadow-indigo-500/10 flex flex-col justify-between transition-all duration-500 hover:-translate-y-1.5 backdrop-blur-xl"
          >
            <div>
              <!-- Image Container -->
              <div class="h-60 relative overflow-hidden bg-slate-950">
                <img
                  :src="getRoomPhoto(room)"
                  :alt="room.room_number"
                  class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700 ease-out"
                />
                <!-- Subtle Gradient Overlays -->
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/20 to-black/40"></div>

                <!-- Status Badge (Floating Glassmorphism) -->
                <div class="absolute top-3.5 left-3.5 flex items-center gap-1.5">
                  <span
                    :class="room.status === 0 || room.status === 'vacant' ? 'bg-emerald-950/80 border-emerald-500/40 text-emerald-300' : 'bg-rose-950/80 border-rose-500/40 text-rose-300'"
                    class="px-3 py-1.5 text-[11px] font-extrabold rounded-xl border backdrop-blur-md shadow-lg flex items-center gap-1.5"
                  >
                    <span
                      v-if="room.status === 0 || room.status === 'vacant'"
                      class="relative flex h-2 w-2"
                    >
                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                      <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                    </span>
                    <span>{{ room.status === 0 || room.status === 'vacant' ? 'Còn Trống' : 'Đang Thuê' }}</span>
                  </span>
                </div>

                <!-- Price Tag (Luxury Gold/Emerald Accent) -->
                <div class="absolute top-3.5 right-3.5">
                  <div class="bg-slate-950/85 backdrop-blur-md px-3.5 py-1.5 rounded-xl border border-emerald-500/30 shadow-xl flex items-baseline gap-1">
                    <span class="text-emerald-400 font-extrabold text-sm tracking-tight font-mono">{{ formatCurrency(room.price) }}</span>
                    <span class="text-[10px] text-slate-400 font-medium">/tháng</span>
                  </div>
                </div>

                <!-- Building & Floor Badge on Image Bottom -->
                <div class="absolute bottom-3 left-3.5 right-3.5 flex items-center justify-between">
                  <span class="bg-slate-950/80 backdrop-blur-md text-indigo-300 font-bold text-[11px] px-3 py-1 rounded-xl border border-indigo-500/30 truncate max-w-[70%]">
                    🏢 {{ room.property_name }}
                  </span>
                  <span class="bg-slate-950/80 backdrop-blur-md text-slate-300 font-medium text-[11px] px-2.5 py-1 rounded-xl border border-slate-700/60">
                    Tầng {{ room.floor || 1 }}
                  </span>
                </div>
              </div>

              <!-- Body Details -->
              <div class="p-6 space-y-4">
                <!-- Type Tag & Area -->
                <div class="flex items-center justify-between text-xs">
                  <span class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider bg-indigo-500/10 text-indigo-300 border border-indigo-500/20">
                    {{ room.property_type_label || 'Bất Động Sản Cho Thuê' }}
                  </span>
                  <span class="font-bold text-slate-300 bg-slate-800/80 px-2.5 py-1 rounded-lg border border-slate-700/50 flex items-center gap-1">
                    <span>📐</span> {{ room.area || 25 }} m²
                  </span>
                </div>

                <!-- Title & Type -->
                <div class="flex justify-between items-baseline pt-1">
                  <h3 class="text-2xl font-black text-white group-hover:text-indigo-300 transition-colors">
                    Phòng {{ room.room_number }}
                  </h3>
                  <span class="text-xs font-semibold text-emerald-400 bg-emerald-500/10 px-2.5 py-0.5 rounded-md border border-emerald-500/20">
                    {{ room.room_type_label || 'Phòng khép kín' }}
                  </span>
                </div>

                <!-- Key Specs Ribbon (PN, PK, WC, Ban Công) -->
                <div class="flex flex-wrap gap-2 text-xs font-medium text-slate-300 bg-slate-950/50 p-2.5 rounded-xl border border-slate-800/60">
                  <span class="flex items-center gap-1 text-slate-300">
                    <span>🛏️</span> <strong>{{ room.bedrooms_count || 1 }}</strong> PN
                  </span>
                  <span class="text-slate-600">•</span>
                  <span v-if="room.living_rooms_count > 0" class="flex items-center gap-1 text-slate-300">
                    <span>🛋️</span> <strong>{{ room.living_rooms_count }}</strong> PK
                  </span>
                  <span v-if="room.living_rooms_count > 0" class="text-slate-600">•</span>
                  <span class="flex items-center gap-1 text-slate-300">
                    <span>🚿</span> <strong>{{ room.bathrooms_count || 1 }}</strong> WC
                  </span>
                  <span v-if="room.has_balcony" class="text-slate-600">•</span>
                  <span v-if="room.has_balcony" class="flex items-center gap-1 text-cyan-300 font-semibold">
                    <span>🌅</span> Ban công
                  </span>
                </div>

                <!-- Amenities Pill Tags -->
                <div>
                  <p class="text-[10px] text-slate-400 mb-2 font-bold uppercase tracking-wider">Tiện nghi nổi bật:</p>
                  <div class="flex flex-wrap gap-1.5">
                    <span v-for="(amenity, idx) in (room.amenities || []).slice(0, 3)" :key="idx" class="px-2.5 py-1 bg-slate-800/80 text-slate-300 text-[11px] rounded-lg font-medium border border-slate-700/60">
                      ✓ {{ amenity }}
                    </span>
                    <span v-if="(room.amenities || []).length > 3" class="px-2 py-1 bg-indigo-500/10 text-indigo-300 text-[10px] rounded-lg font-bold border border-indigo-500/20">
                      +{{ room.amenities.length - 3 }} tiện ích
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Footer Button -->
            <div class="p-6 pt-0">
              <button
                @click="openRoomDetail(room)"
                class="w-full py-3 bg-gradient-to-r from-indigo-600 via-indigo-600 to-blue-600 hover:from-indigo-500 hover:to-blue-500 text-white font-extrabold text-xs rounded-2xl shadow-lg shadow-indigo-600/25 transition-all flex items-center justify-center gap-2 group/btn"
              >
                <span>Xem Chi Tiết & Đặt Lịch</span>
                <span class="group-hover/btn:translate-x-1 transition-transform">➔</span>
              </button>
            </div>
          </div>
        </div>

        <!-- 2. LIST VIEW MODE -->
        <div v-else class="space-y-4">
          <div
            v-for="room in visibleRooms"
            :key="room.id"
            class="group bg-slate-900/80 hover:bg-slate-900 rounded-3xl border border-slate-800/80 hover:border-indigo-500/40 p-4 sm:p-5 flex flex-col md:flex-row items-center justify-between gap-6 transition-all duration-300 hover:shadow-2xl hover:shadow-indigo-500/10 backdrop-blur-xl"
          >
            <!-- Left Thumbnail -->
            <div class="w-full md:w-56 h-40 rounded-2xl overflow-hidden relative bg-slate-950 flex-shrink-0">
              <img :src="getRoomPhoto(room)" :alt="room.room_number" class="w-full h-full object-cover group-hover:scale-108 transition-transform duration-500" />
              <div class="absolute top-2 left-2">
                <span
                  :class="room.status === 0 || room.status === 'vacant' ? 'bg-emerald-950/90 text-emerald-300 border-emerald-500/40' : 'bg-rose-950/90 text-rose-300 border-rose-500/40'"
                  class="px-2.5 py-1 text-[10px] font-extrabold rounded-lg border backdrop-blur"
                >
                  {{ room.status === 0 || room.status === 'vacant' ? 'Còn Trống' : 'Đang Thuê' }}
                </span>
              </div>
            </div>

            <!-- Middle Info -->
            <div class="flex-1 space-y-2.5 text-left w-full">
              <div class="flex items-center gap-2">
                <span class="text-[10px] font-bold uppercase tracking-wider bg-indigo-500/10 text-indigo-300 px-2.5 py-0.5 rounded border border-indigo-500/20">
                  {{ room.property_name }}
                </span>
                <span class="text-xs text-slate-400 font-medium">• Tầng {{ room.floor || 1 }}</span>
              </div>

              <h3 class="text-2xl font-black text-white group-hover:text-indigo-300 transition-colors">
                Phòng {{ room.room_number }} <span class="text-sm font-normal text-slate-400">({{ room.room_type_label || 'Khép kín' }})</span>
              </h3>

              <div class="flex flex-wrap items-center gap-3 text-xs text-slate-300 font-medium">
                <span class="flex items-center gap-1 bg-slate-950/60 px-2.5 py-1 rounded-lg border border-slate-800">
                  📐 {{ room.area || 25 }} m²
                </span>
                <span class="flex items-center gap-1 bg-slate-950/60 px-2.5 py-1 rounded-lg border border-slate-800">
                  🛏️ {{ room.bedrooms_count || 1 }} PN
                </span>
                <span class="flex items-center gap-1 bg-slate-950/60 px-2.5 py-1 rounded-lg border border-slate-800">
                  🚿 {{ room.bathrooms_count || 1 }} WC
                </span>
              </div>

              <!-- Amenities list inline -->
              <div class="flex flex-wrap gap-1.5 pt-1">
                <span v-for="(amenity, idx) in (room.amenities || []).slice(0, 4)" :key="idx" class="text-[11px] text-slate-400 bg-slate-800/60 px-2 py-0.5 rounded font-medium">
                  ✓ {{ amenity }}
                </span>
              </div>
            </div>

            <!-- Right Price & CTA -->
            <div class="w-full md:w-56 flex flex-row md:flex-col items-center md:items-end justify-between md:justify-center gap-3 border-t md:border-t-0 md:border-l border-slate-800 pt-3 md:pt-0 md:pl-6">
              <div class="text-left md:text-right">
                <p class="text-[10px] text-slate-400 uppercase font-bold tracking-wider">Giá Thuê Niêm Yết</p>
                <p class="text-xl font-black text-emerald-400 font-mono tracking-tight">{{ formatCurrency(room.price) }}</p>
                <p class="text-[10px] text-slate-400 font-medium">/tháng</p>
              </div>

              <button
                @click="openRoomDetail(room)"
                class="px-5 py-3 bg-indigo-600 hover:bg-indigo-500 text-white font-extrabold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition-all flex items-center gap-2 whitespace-nowrap"
              >
                <span>Xem Chi Tiết</span>
                <span>➔</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Load More / Collapse Button -->
        <div v-if="filteredRooms.length > 6" class="flex justify-center pt-6">
          <button
            @click="showAllRooms = !showAllRooms"
            class="px-8 py-3.5 bg-slate-900/90 hover:bg-slate-800 text-indigo-300 font-extrabold text-xs rounded-2xl border border-indigo-500/40 shadow-xl transition-all flex items-center gap-2 group hover:border-indigo-400 backdrop-blur-md"
          >
            <span v-if="!showAllRooms">✨ Xem Thêm {{ filteredRooms.length - 6 }} Phòng Khác Khắp Hà Nội <span class="group-hover:translate-x-1 transition-transform inline-block">➔</span></span>
            <span v-else>▲ Thu Gọn Danh Sách Phòng</span>
          </button>
        </div>
      </div>
    </section>

    <!-- Customer Testimonials & Tenant Reviews Section -->
    <section id="reviews" class="px-6 py-16 bg-slate-950 border-b border-slate-800/80 relative">
      <div class="max-w-7xl mx-auto space-y-10">
        <!-- Header with Aggregate Score -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end gap-6 bg-gradient-to-r from-slate-900 via-indigo-950/40 to-slate-900 p-8 rounded-3xl border border-slate-800">
          <div class="space-y-2">
            <span class="px-3.5 py-1 bg-amber-500/20 text-amber-300 font-black text-xs rounded-full border border-amber-500/40 uppercase tracking-widest">
              💬 Trải Nghiệm Khách Thuê
            </span>
            <h2 class="text-3xl md:text-4xl font-black text-white">Bình Luận & Phản Hồi Từ Cư Dân</h2>
            <p class="text-slate-400 text-xs max-w-xl font-medium">Hơn 98% khách thuê đánh giá 5 sao về chất lượng phòng trọ và dịch vụ quản lý hỗ trợ 24/7</p>
          </div>

          <div class="flex items-center gap-4 bg-slate-950/80 px-6 py-4 rounded-2xl border border-slate-800">
            <div class="text-3xl font-black text-amber-400 font-mono">4.9/5.0</div>
            <div class="text-left">
              <div class="text-amber-400 text-sm">⭐⭐⭐⭐⭐</div>
              <p class="text-[11px] text-slate-400 font-bold">150+ Đánh Giá Xác Thực</p>
            </div>
            <button
              @click="showReviewModal = true"
              class="ml-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-500 text-white font-extrabold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition"
            >
              ✍️ Gửi Đánh Giá
            </button>
          </div>
        </div>

        <!-- Reviews Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div
            v-for="review in tenantReviews"
            :key="review.id"
            class="bg-slate-900/90 p-6 rounded-2xl border border-slate-800 space-y-4 hover:border-slate-700 transition"
          >
            <!-- Review Header -->
            <div class="flex justify-between items-start">
              <div class="flex items-center gap-3">
                <div :class="['w-11 h-11 rounded-xl flex items-center justify-center text-white font-black text-base shadow-md', review.avatarColor || 'bg-indigo-600']">
                  {{ review.name.charAt(0) }}
                </div>
                <div>
                  <h4 class="font-extrabold text-white text-sm flex items-center gap-2">
                    {{ review.name }}
                    <span class="px-2 py-0.5 bg-emerald-500/20 text-emerald-400 text-[10px] rounded-md font-bold border border-emerald-500/30">
                      ✓ Đã Thuê
                    </span>
                  </h4>
                  <p class="text-[11px] text-indigo-300 font-medium">{{ review.room }} • {{ review.property }}</p>
                </div>
              </div>

              <div class="text-right">
                <div class="text-amber-400 text-xs">⭐⭐⭐⭐⭐</div>
                <span class="text-[10px] text-slate-500 font-bold">{{ review.stayDuration }}</span>
              </div>
            </div>

            <!-- Review Comment -->
            <p class="text-xs text-slate-300 leading-relaxed font-medium bg-slate-950/60 p-4 rounded-xl border border-slate-800/60 italic">
              "{{ review.comment }}"
            </p>

            <div class="flex justify-between items-center text-[10px] text-slate-500 font-bold pt-1">
              <span>📅 Đăng ngày {{ review.date }}</span>
              <span class="text-indigo-400">👍 Đã xác minh cư dân RentOps</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Interactive Submit Review Modal -->
    <div v-if="showReviewModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
      <div class="bg-slate-900 border border-slate-800 rounded-3xl p-6 md:p-8 max-w-lg w-full space-y-5 shadow-2xl relative">
        <div class="flex justify-between items-center border-b border-slate-800 pb-4">
          <h3 class="text-xl font-black text-white flex items-center gap-2">
            <span>✍️</span> Gửi Đánh Giá Căn Hộ
          </h3>
          <button @click="showReviewModal = false" class="text-slate-400 hover:text-white text-xl font-bold">✕</button>
        </div>

        <form @submit.prevent="submitReview" class="space-y-4">
          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1">Họ và tên cư dân / Khách xem phòng</label>
            <input
              v-model="newReview.name"
              required
              class="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500"
              placeholder="VD: Nguyễn Văn Anh"
            />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-bold text-slate-300 mb-1">Số phòng</label>
              <input
                v-model="newReview.room"
                required
                class="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500"
                placeholder="VD: Phòng 302"
              />
            </div>
            <div>
              <label class="block text-xs font-bold text-slate-300 mb-1">Đánh giá sao</label>
              <select
                v-model="newReview.rating"
                class="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2.5 text-xs font-bold text-amber-400 focus:outline-none focus:border-indigo-500"
              >
                <option :value="5">⭐⭐⭐⭐⭐ (5/5 Xuất sắc)</option>
                <option :value="4">⭐⭐⭐⭐ (4/5 Rất tốt)</option>
                <option :value="3">⭐⭐⭐ (3/5 Tốt)</option>
              </select>
            </div>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1">Nội dung đánh giá & nhận xét</label>
            <textarea
              v-model="newReview.comment"
              required
              rows="3"
              class="w-full bg-slate-950 border border-slate-800 rounded-xl p-3 text-xs text-white focus:outline-none focus:border-indigo-500"
              placeholder="Chia sẻ trải nghiệm của bạn về không gian sống, an ninh, tiện ích..."
            ></textarea>
          </div>

          <div class="flex gap-3 pt-2">
            <button
              type="button"
              @click="showReviewModal = false"
              class="flex-1 py-3 bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold text-xs rounded-xl"
            >
              Hủy
            </button>
            <button
              type="submit"
              class="flex-1 py-3 bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-500 hover:to-blue-500 text-white font-extrabold text-xs rounded-xl shadow-lg"
            >
              Gửi Đánh Giá Ngay
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Features Highlight Section -->
    <section id="features" class="px-6 py-16 bg-slate-950 border-t border-slate-800/80">
      <div class="max-w-7xl mx-auto space-y-12">
        <div class="text-center space-y-3">
          <h2 class="text-3xl font-black text-white flex items-center justify-center gap-2">
            <span>⚡</span> Tính Năng SaaS Đột Phá Của RentOps
          </h2>
          <p class="text-slate-400 text-xs max-w-2xl mx-auto font-medium">Tối ưu toàn diện trải nghiệm quản lý nhà trọ từ quy mô nhỏ đến chuỗi bất động sản cho thuê lớn</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">💳</div>
            <h3 class="text-lg font-extrabold text-white">VietQR Auto-Payment 24/7</h3>
            <p class="text-xs text-slate-400 leading-relaxed font-normal">Tự động tạo mã VietQR động NAPAS chứa đúng số tiền và cú pháp chuyển khoản. Ngân hàng gửi Webhook gạch nợ hóa đơn ngay lập tức.</p>
          </div>

          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">✍️</div>
            <h3 class="text-lg font-extrabold text-white">Chữ Ký Số Hợp Đồng Online</h3>
            <p class="text-xs text-slate-400 leading-relaxed font-normal">Ký hợp đồng thuê nhà trực tiếp trên điện thoại/máy tính bằng bảng vẽ chữ ký điện tử. Trích xuất file hợp đồng đầy đủ chữ ký 2 bên.</p>
          </div>

          <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 space-y-3">
            <div class="text-3xl">📱</div>
            <h3 class="text-lg font-extrabold text-white">Cổng Khách Thuê Self-Service</h3>
            <p class="text-xs text-slate-400 leading-relaxed font-normal">Khách thuê tự tra cứu hóa đơn, theo dõi lịch sử tiền điện nước, gửi phiếu báo hỏng sự cố cho ban quản lý bất kỳ lúc nào.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Detailed App Footer -->
    <AppFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'
import AppFooter from '../components/AppFooter.vue'

const router = useRouter()
const authStore = useAuthStore()

const showReviewModal = ref(false)
const newReview = ref({
  name: '',
  room: '',
  rating: 5,
  comment: ''
})

const tenantReviews = ref([
  {
    id: 1,
    name: "Trần Hoàng Nam",
    room: "Phòng 301",
    property: "Tòa RentOps B - Cầu Giấy",
    rating: 5,
    avatarColor: "bg-indigo-600",
    stayDuration: "Đã ở 1 năm 4 tháng",
    comment: "Phòng ốc rất mới và sạch sẽ, ban quản lý hỗ trợ cực kỳ nhiệt tình. Thích nhất là tính năng quét mã VietQR thanh toán tiền phòng tự động, chuyển xong là hệ thống báo đã gạch nợ ngay!",
    date: "15/07/2026"
  },
  {
    id: 2,
    name: "Nguyễn Thị Phương Thảo",
    room: "Phòng 401 (Studio)",
    property: "Căn Hộ RentOps C - Đống Đa",
    rating: 5,
    avatarColor: "bg-emerald-600",
    stayDuration: "Đã ở 8 tháng",
    comment: "Căn hộ Studio full nội thất như khách sạn 4 sao! Wifi 200Mbps học tập làm việc từ xa mượt mà. Hợp đồng ký điện tử trực tiếp trên điện thoại rất tiện lợi.",
    date: "20/07/2026"
  },
  {
    id: 3,
    name: "Lê Minh Tuấn",
    room: "Phòng 202",
    property: "Tòa RentOps A - Nam Từ Liêm",
    rating: 5,
    avatarColor: "bg-cyan-600",
    stayDuration: "Đã ở 2 năm",
    comment: "An ninh ở đây cực tốt, có camera 24/7 và cổng khóa vân tay. Mỗi khi phòng có sự cố bóng đèn hay điện nước chỉ cần gửi phản hồi trên web là kỹ thuật sang sửa ngay trong ngày.",
    date: "22/07/2026"
  },
  {
    id: 4,
    name: "Phạm Hải Đăng",
    room: "Phòng 101",
    property: "Tòa RentOps A - Nam Từ Liêm",
    rating: 5,
    avatarColor: "bg-amber-600",
    stayDuration: "Đã ở 6 tháng",
    comment: "Giá phòng niêm yết minh bạch, chi phí điện nước tính đúng giá công tơ ghi trên hệ thống. Cổng tự phục vụ giúp mình xem lại lịch sử hóa đơn hàng tháng dễ dàng.",
    date: "28/07/2026"
  }
])

const submitReview = () => {
  tenantReviews.value.unshift({
    id: Date.now(),
    name: newReview.value.name,
    room: newReview.value.room,
    property: "Tòa RentOps A",
    rating: newReview.value.rating,
    avatarColor: "bg-indigo-600",
    stayDuration: "Khách vừa đánh giá",
    comment: newReview.value.comment,
    date: new Date().toLocaleDateString('vi-VN')
  })
  showReviewModal.value = false
  newReview.value = { name: '', room: '', rating: 5, comment: '' }
  alert('Cảm ơn bạn đã gửi đánh giá! Nhận xét của bạn đã được hiển thị công khai.')
}

const defaultRooms = [
  { id: 101, room_number: "101", property_name: "Tòa Nhà RentOps A", price: 3500000, status: "vacant", floor: 1, area: 25, amenities: ["Điều hòa Inverter", "Tủ lạnh 2 cánh", "Wifi 200Mbps", "Ban công thoáng"] },
  { id: 102, room_number: "102", property_name: "Tòa Nhà RentOps A", price: 3800000, status: "occupied", floor: 1, area: 28, amenities: ["Điều hòa", "Máy giặt", "Nóng lạnh", "Giường nệm cao su"] },
  { id: 103, room_number: "103", property_name: "Tòa Nhà RentOps A", price: 3500000, status: "vacant", floor: 1, area: 25, amenities: ["Điều hòa Inverter", "Tủ quần áo 3 cánh", "Tủ lạnh", "Bếp điện"] },
  { id: 201, room_number: "201", property_name: "Tòa Nhà RentOps A", price: 4200000, status: "occupied", floor: 2, area: 30, amenities: ["Điều hòa", "Tủ lạnh", "Sàn gỗ tự nhiên", "Ban công rộng"] },
  { id: 202, room_number: "202", property_name: "Tòa Nhà RentOps A", price: 4500000, status: "occupied", floor: 2, area: 32, amenities: ["Điều hòa Inverter", "Máy giặt riêng", "Tủ lạnh Inverter", "Sofa cao cấp"] },
  { id: 203, room_number: "203", property_name: "Tòa Nhà RentOps A", price: 4000000, status: "vacant", floor: 2, area: 28, amenities: ["Điều hòa", "Wifi tốc độ cao", "Bình nóng lạnh", "Giường nệm gỗ"] },
  { id: 301, room_number: "301", property_name: "Tòa Nhà RentOps B", price: 5000000, status: "vacant", floor: 3, area: 35, amenities: ["Điều hòa Inverter", "Bếp từ đôi âm", "Máy hút mùi", "Tủ lạnh 250L"] },
  { id: 302, room_number: "302", property_name: "Tòa Nhà RentOps B", price: 5200000, status: "occupied", floor: 3, area: 38, amenities: ["Điều hòa", "Tủ lạnh", "Ban công thoáng", "Bàn học/làm việc"] },
  { id: 303, room_number: "303", property_name: "Tòa Nhà RentOps B", price: 4800000, status: "vacant", floor: 3, area: 32, amenities: ["Điều hòa Inverter", "Giường gỗ sồi", "Tủ 3 cánh", "Bình nóng lạnh"] },
  { id: 401, room_number: "401 (Studio)", property_name: "Căn Hộ Dịch Vụ RentOps C", price: 6500000, status: "vacant", floor: 4, area: 42, amenities: ["Full nội thất cao cấp", "Smart TV 50 inch", "Tủ lạnh side-by-side", "Bếp từ đôi"] },
  { id: 402, room_number: "402 (Studio)", property_name: "Căn Hộ Dịch Vụ RentOps C", price: 6800000, status: "occupied", floor: 4, area: 45, amenities: ["Full nội thất cao cấp", "Bồn tắm đứng", "Máy giặt sấy", "Ban công view phố"] }
]

const rooms = ref(defaultRooms)
const searchFilter = ref('')
const statusFilter = ref('vacant')
const selectedPropertyTab = ref('all')
const showAllRooms = ref(false)
const viewMode = ref('grid')

const roomPhotosList = [
  '/images/hero_banner.png',
  '/images/studio.png',
  '/images/suite.png',
  '/images/bedroom.png'
]

const getRoomPhoto = (room) => {
  if (room.image) return room.image
  const index = (room.id || 0) % roomPhotosList.length
  return roomPhotosList[index]
}

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const openRoomDetail = (room) => {
  router.push(`/room-detail/${room.id || room.room_number}`)
}

const fetchPublicRooms = async () => {
  try {
    const res = await api.get('/public/rooms')
    if (res && res.data && res.data.length > 0) {
      rooms.value = res.data
    }
  } catch (err) {
    console.log('Using default sample rooms list')
  }
}

const filteredRooms = computed(() => {
  return rooms.value.filter(r => {
    const num = (r.room_number || '').toString().toLowerCase()
    const prop = (r.property_name || '').toString().toLowerCase()
    const query = searchFilter.value.toLowerCase()

    const matchSearch = searchFilter.value === '' || num.includes(query) || prop.includes(query)
    const matchStatus = statusFilter.value === 'all' ||
      (statusFilter.value === 'vacant' && (r.status === 0 || r.status === 'vacant'))

    const matchProperty = selectedPropertyTab.value === 'all' || prop.includes(selectedPropertyTab.value.toLowerCase())

    return matchSearch && matchStatus && matchProperty
  })
})

const visibleRooms = computed(() => {
  if (showAllRooms.value) return filteredRooms.value
  return filteredRooms.value.slice(0, 6)
})

const demoAccess = async () => {
  await authStore.login('demo@rentops.vn')
  router.push('/')
}

onMounted(() => {
  fetchPublicRooms()
})
</script>

