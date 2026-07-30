<template>
  <div class="about-page min-h-screen bg-[#f7f8fc] text-[#161b36] font-sans antialiased selection:bg-[#5b46e0] selection:text-white">
    <PublicHeader active="about" @notify="router.push('/landing')" />

    <!-- Main Content Container -->
    <main class="max-w-[1240px] mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-7">
      <!-- Breadcrumb -->
      <div class="flex items-center gap-1.5 text-[14px] font-medium text-[#8d95ab] mb-6">
        <RouterLink to="/landing" class="hover:text-[#5b46e0] transition-colors">Trang chủ</RouterLink>
        <svg class="w-3.5 h-3.5 text-[#c4c9d8]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path d="m9 18 6-6-6-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
        <span class="text-[#6d7690] font-semibold">Về chúng tôi</span>
      </div>

      <!-- Hero Section Grid -->
      <section class="grid grid-cols-1 lg:grid-cols-12 gap-6 lg:gap-7 items-center mb-14 lg:mb-18">
        <!-- Left Title & Actions (4 cols) -->
        <div class="lg:col-span-4 space-y-4">
          <div>
            <h1 class="text-3xl sm:text-4xl lg:text-[42px] font-extrabold text-[#161b36] leading-[1.16] tracking-tight">
              Lan tỏa giá trị sống tốt hơn qua công nghệ cho thuê
            </h1>
            <div class="w-11 h-[3px] bg-[#5b46e0] rounded-full mt-2.5"></div>
          </div>

          <p class="text-[#6d7690] text-[15px] leading-relaxed font-normal my-5">
            Rentalio được xây dựng với sứ mệnh đem lại trải nghiệm tìm kiếm, quản lý và cho thuê phòng, căn hộ trở nên đơn giản, nhanh chóng và hiệu quả hơn cho mọi người.
          </p>

          <div class="flex flex-wrap gap-3 pt-1">
            <RouterLink
              to="/landing"
              class="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-[#5b46e0] hover:bg-[#4d3abf] text-white font-bold text-[14px] rounded-xl shadow-[0_6px_16px_rgba(91,70,224,0.25)] hover:-translate-y-0.5 transition-all duration-200"
            >
              <span>Khám phá nền tảng</span>
              <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M5 12h14m-6-6 6 6-6 6" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </RouterLink>

            <a
              href="#contact"
              @click.prevent="contactUs"
              class="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-white hover:bg-[#eeeaff]/50 text-[#5b46e0] font-bold text-[14px] rounded-xl border-[1.5px] border-[#5b46e0] hover:-translate-y-0.5 transition-all duration-200"
            >
              <span>Liên hệ ngay</span>
              <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M5 12h14m-6-6 6 6-6 6" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </a>
          </div>
        </div>

        <!-- Center Hero Image (5 cols) -->
        <div class="lg:col-span-5">
          <div class="relative rounded-3xl overflow-hidden shadow-[0_12px_32px_rgba(22,27,54,0.08)] border border-white/80 group">
            <img
              src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1000&auto=format&fit=crop&q=80"
              @error="$event.target.src = '/images/suite.png'"
              alt="Không gian sống hiện đại do Rentalio kết nối"
              class="w-full h-[280px] sm:h-[330px] lg:h-[350px] object-cover group-hover:scale-105 transition-transform duration-700"
            />
          </div>
        </div>

        <!-- Right Feature Sidebar Card (3 cols) -->
        <div class="lg:col-span-3 lg:self-start">
          <div class="bg-[#f7f8ff] border border-[#ebedfa] rounded-3xl p-5 shadow-[0_4px_16px_rgba(22,27,54,0.02)] space-y-5">
            <!-- Feature 1 -->
            <div class="flex items-start gap-3">
              <div class="w-10 h-10 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-[#161b36] text-[15px]">Sứ mệnh rõ ràng</h3>
                <p class="text-[13px] text-[#7c849b] font-normal leading-snug mt-0.5">Mang đến trải nghiệm thuê nhà tốt hơn cho mọi người.</p>
              </div>
            </div>

            <!-- Feature 2 -->
            <div class="flex items-start gap-3">
              <div class="w-10 h-10 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-[#161b36] text-[15px]">Kết nối minh bạch</h3>
                <p class="text-[13px] text-[#7c849b] font-normal leading-snug mt-0.5">Giúp chủ nhà và người thuê kết nối dễ dàng, an toàn.</p>
              </div>
            </div>

            <!-- Feature 3 -->
            <div class="flex items-start gap-3">
              <div class="w-10 h-10 shrink-0 rounded-xl bg-[#e6f9f0] text-[#10b981] flex items-center justify-center">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-[#161b36] text-[15px]">Đổi mới bền vững</h3>
                <p class="text-[13px] text-[#7c849b] font-normal leading-snug mt-0.5">Ứng dụng công nghệ để kiến tạo thị trường cho thuê hiện đại.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Core Values Section -->
      <section class="my-12 sm:my-16" aria-labelledby="values-title">
        <div class="text-center mb-7">
          <h2 id="values-title" class="text-3xl sm:text-[32px] font-extrabold text-[#161b36] tracking-tight">
            Giá trị cốt lõi
          </h2>
          <div class="w-9 h-[3px] bg-[#5b46e0] rounded-full mx-auto mt-2"></div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          <!-- Card 1 -->
          <div class="bg-white rounded-2xl p-6 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] hover:shadow-md hover:border-[#eeeaff] hover:-translate-y-1 transition-all duration-300 flex flex-col items-center text-center group">
            <div class="w-12 h-12 shrink-0 rounded-full bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-3.5 group-hover:scale-110 transition-all p-2.5">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[16px] mb-1">Chính trực</h3>
            <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed max-w-[220px]">Minh bạch, trung thực với khách hàng và đối tác</p>
          </div>

          <!-- Card 2 -->
          <div class="bg-white rounded-2xl p-6 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] hover:shadow-md hover:border-[#eeeaff] hover:-translate-y-1 transition-all duration-300 flex flex-col items-center text-center group">
            <div class="w-12 h-12 shrink-0 rounded-full bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-3.5 group-hover:scale-110 transition-all p-2.5">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 01-2 2h-0a2 2 0 01-2-2v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[16px] mb-1">Sáng tạo</h3>
            <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed max-w-[220px]">Luôn đổi mới để tạo nên trải nghiệm tốt hơn</p>
          </div>

          <!-- Card 3 -->
          <div class="bg-white rounded-2xl p-6 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] hover:shadow-md hover:border-[#eeeaff] hover:-translate-y-1 transition-all duration-300 flex flex-col items-center text-center group">
            <div class="w-12 h-12 shrink-0 rounded-full bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-3.5 group-hover:scale-110 transition-all p-2.5">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[16px] mb-1">Lấy khách hàng làm trọng tâm</h3>
            <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed max-w-[220px]">Đặt lợi ích người dùng lên hàng đầu</p>
          </div>

          <!-- Card 4 -->
          <div class="bg-white rounded-2xl p-6 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] hover:shadow-md hover:border-[#eeeaff] hover:-translate-y-1 transition-all duration-300 flex flex-col items-center text-center group">
            <div class="w-12 h-12 shrink-0 rounded-full bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-3.5 group-hover:scale-110 transition-all p-2.5">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[16px] mb-1">Phát triển bền vững</h3>
            <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed max-w-[220px]">Cùng cộng đồng xây dựng thị trường cho thuê minh bạch</p>
          </div>
        </div>
      </section>

      <!-- Section: Development Timeline & Impressive Numbers Grid -->
      <section class="my-14 sm:my-18">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-7 items-start">
          <!-- Left: Timeline Section (5 cols) -->
          <div class="lg:col-span-5 space-y-5">
            <div>
          <h2 class="text-3xl sm:text-[32px] font-extrabold text-[#161b36] tracking-tight">Hành trình phát triển</h2>
              <div class="w-9 h-[3px] bg-[#5b46e0] rounded-full mt-2"></div>
            </div>

            <!-- Vertical Timeline Container -->
            <div class="relative pl-6 space-y-5 before:absolute before:left-2 before:top-3 before:bottom-3 before:w-0.5 before:bg-[#e2e5f5]">
              <!-- Timeline Item 2022 -->
              <div class="relative group">
                <div class="absolute -left-[23px] top-1.5 w-3 h-3 rounded-full bg-[#5b46e0] ring-4 ring-[#eeeaff]"></div>
                <div class="flex items-center gap-3 mb-1">
                  <span class="px-2.5 py-0.5 bg-[#eeeaff] text-[#5b46e0] font-extrabold text-[11px] rounded-full">2022</span>
                  <h3 class="font-extrabold text-[#161b36] text-[15px]">Ra mắt sản phẩm</h3>
                </div>
                <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed">
                  Rentalio chính thức đi vào hoạt động với nền tảng cho thuê phòng, căn hộ.
                </p>
              </div>

              <!-- Timeline Item 2023 -->
              <div class="relative group">
                <div class="absolute -left-[23px] top-1.5 w-3 h-3 rounded-full bg-[#5b46e0] ring-4 ring-[#eeeaff]"></div>
                <div class="flex items-center gap-3 mb-1">
                  <span class="px-2.5 py-0.5 bg-[#eeeaff] text-[#5b46e0] font-extrabold text-[11px] rounded-full">2023</span>
                  <h3 class="font-extrabold text-[#161b36] text-[15px]">Mở rộng thị trường</h3>
                </div>
                <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed">
                  Phủ sóng trên 12 tỉnh thành với hàng nghìn chủ nhà và người thuê tin tưởng.
                </p>
              </div>

              <!-- Timeline Item 2024 -->
              <div class="relative group">
                <div class="absolute -left-[23px] top-1.5 w-3 h-3 rounded-full bg-[#5b46e0] ring-4 ring-[#eeeaff]"></div>
                <div class="flex items-center gap-3 mb-1">
                  <span class="px-2.5 py-0.5 bg-[#eeeaff] text-[#5b46e0] font-extrabold text-[11px] rounded-full">2024</span>
                  <h3 class="font-extrabold text-[#161b36] text-[15px]">Công cụ quản lý thông minh</h3>
                </div>
                <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed">
                  Ra mắt trọn bộ công cụ quản lý hợp đồng, thanh toán và vận hành cho chủ nhà.
                </p>
              </div>

              <!-- Timeline Item 2025+ -->
              <div class="relative group">
                <div class="absolute -left-[23px] top-1.5 w-3 h-3 rounded-full bg-[#5b46e0] ring-4 ring-[#eeeaff]"></div>
                <div class="flex items-center gap-3 mb-1">
                  <span class="px-2.5 py-0.5 bg-[#eeeaff] text-[#5b46e0] font-extrabold text-[11px] rounded-full">2025+</span>
                  <h3 class="font-extrabold text-[#161b36] text-[15px]">Nền tảng dẫn đầu</h3>
                </div>
                <p class="text-[13.5px] text-[#7c849b] font-normal leading-relaxed">
                  Trở thành hệ sinh thái bất động sản cho thuê số 1 tại Việt Nam.
                </p>
              </div>
            </div>
          </div>

          <!-- Right: Impressive Numbers Card (7 cols) -->
          <div class="lg:col-span-7">
            <div class="bg-white rounded-3xl p-6 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] space-y-5">
              <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-center">
                <!-- Image Side (5 cols) -->
                <div class="md:col-span-5">
                  <div class="rounded-2xl overflow-hidden shadow-sm h-48 sm:h-56">
                    <img
                      src="https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&auto=format&fit=crop&q=80"
                      alt="Những con số ấn tượng"
                      class="w-full h-full object-cover"
                    />
                  </div>
                </div>

                <!-- Stats Side (7 cols) -->
                <div class="md:col-span-7 space-y-3.5">
              <h3 class="text-2xl sm:text-[24px] font-extrabold text-[#161b36]">Những con số ấn tượng</h3>

                  <div class="grid grid-cols-2 gap-3">
                    <!-- Stat 1 -->
                    <div class="bg-[#f7f8ff] border border-[#ebedfa] rounded-2xl p-3.5 flex flex-col justify-center">
                      <div class="w-8 h-8 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-1.5">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </div>
                      <span class="text-xl sm:text-[20px] font-black text-[#161b36] leading-none">12.000+</span>
                      <span class="text-[13px] text-[#7c849b] font-medium mt-1">Căn hộ / phòng cho thuê</span>
                    </div>

                    <!-- Stat 2 -->
                    <div class="bg-[#f7f8ff] border border-[#ebedfa] rounded-2xl p-3.5 flex flex-col justify-center">
                      <div class="w-8 h-8 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-1.5">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </div>
                      <span class="text-xl sm:text-[20px] font-black text-[#161b36] leading-none">8.500+</span>
                      <span class="text-[13px] text-[#7c849b] font-medium mt-1">Chủ nhà tin tưởng</span>
                    </div>

                    <!-- Stat 3 -->
                    <div class="bg-[#f7f8ff] border border-[#ebedfa] rounded-2xl p-3.5 flex flex-col justify-center">
                      <div class="w-8 h-8 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-1.5">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </div>
                      <span class="text-xl sm:text-[20px] font-black text-[#161b36] leading-none">50.000+</span>
                      <span class="text-[13px] text-[#7c849b] font-medium mt-1">Người thuê sử dụng</span>
                    </div>

                    <!-- Stat 4 -->
                    <div class="bg-[#f7f8ff] border border-[#ebedfa] rounded-2xl p-3.5 flex flex-col justify-center">
                      <div class="w-8 h-8 shrink-0 rounded-xl bg-[#eeeaff] text-[#5b46e0] flex items-center justify-center mb-1.5">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </div>
                      <span class="text-xl sm:text-[20px] font-black text-[#161b36] leading-none">99%</span>
                      <span class="text-[13px] text-[#7c849b] font-medium mt-1">Hài lòng với dịch vụ</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Section: Our Team -->
      <section class="my-14 sm:my-18">
        <div class="mb-7">
          <h2 class="text-3xl sm:text-[32px] font-extrabold text-[#161b36] tracking-tight">Đội ngũ của chúng tôi</h2>
          <div class="w-9 h-[3px] bg-[#5b46e0] rounded-full mt-2"></div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          <!-- Member 1 -->
          <div class="bg-white rounded-2xl p-5 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] flex flex-col items-center text-center group hover:shadow-md hover:-translate-y-1 transition-all duration-300">
            <div class="w-20 h-20 rounded-full overflow-hidden mb-3 border-2 border-slate-100 shrink-0">
              <img
                src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80"
                alt="Trần Minh Tuấn"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[15px]">Trần Minh Tuấn</h3>
            <span class="text-[13px] font-bold text-[#8d95ab] mt-0.5">CEO & Founder</span>
            <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed mt-2 line-clamp-2">
              10+ năm kinh nghiệm trong lĩnh vực công nghệ.
            </p>
            <a href="#" class="mt-4 text-[#5b46e0] hover:text-[#4d3abf] transition-colors p-1" aria-label="LinkedIn">
              <svg class="w-4 h-4 fill-current" viewBox="0 0 24 24">
                <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"/>
              </svg>
            </a>
          </div>

          <!-- Member 2 -->
          <div class="bg-white rounded-2xl p-5 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] flex flex-col items-center text-center group hover:shadow-md hover:-translate-y-1 transition-all duration-300">
            <div class="w-20 h-20 rounded-full overflow-hidden mb-3 border-2 border-slate-100 shrink-0">
              <img
                src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80"
                alt="Nguyễn Thu Hà"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[15px]">Nguyễn Thu Hà</h3>
            <span class="text-[13px] font-bold text-[#8d95ab] mt-0.5">COO & Co-founder</span>
            <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed mt-2 line-clamp-2">
              Giúp vận hành và phát triển sản phẩm bền vững.
            </p>
            <a href="#" class="mt-4 text-[#5b46e0] hover:text-[#4d3abf] transition-colors p-1" aria-label="LinkedIn">
              <svg class="w-4 h-4 fill-current" viewBox="0 0 24 24">
                <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"/>
              </svg>
            </a>
          </div>

          <!-- Member 3 -->
          <div class="bg-white rounded-2xl p-5 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] flex flex-col items-center text-center group hover:shadow-md hover:-translate-y-1 transition-all duration-300">
            <div class="w-20 h-20 rounded-full overflow-hidden mb-3 border-2 border-slate-100 shrink-0">
              <img
                src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80"
                alt="Lê Hoàng Nam"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[15px]">Lê Hoàng Nam</h3>
            <span class="text-[13px] font-bold text-[#8d95ab] mt-0.5">CTO</span>
            <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed mt-2 line-clamp-2">
              Kỹ sư công nghệ với 8+ năm kinh nghiệm về hệ thống đám mây.
            </p>
            <a href="#" class="mt-4 text-[#5b46e0] hover:text-[#4d3abf] transition-colors p-1" aria-label="LinkedIn">
              <svg class="w-4 h-4 fill-current" viewBox="0 0 24 24">
                <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"/>
              </svg>
            </a>
          </div>

          <!-- Member 4 -->
          <div class="bg-white rounded-2xl p-5 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] flex flex-col items-center text-center group hover:shadow-md hover:-translate-y-1 transition-all duration-300">
            <div class="w-20 h-20 rounded-full overflow-hidden mb-3 border-2 border-slate-100 shrink-0">
              <img
                src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80"
                alt="Phạm Quốc Bảo"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[15px]">Phạm Quốc Bảo</h3>
            <span class="text-[13px] font-bold text-[#8d95ab] mt-0.5">Head of Product</span>
            <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed mt-2 line-clamp-2">
              Dẫn dắt định hướng sản phẩm.
            </p>
            <a href="#" class="mt-4 text-[#5b46e0] hover:text-[#4d3abf] transition-colors p-1" aria-label="LinkedIn">
              <svg class="w-4 h-4 fill-current" viewBox="0 0 24 24">
                <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"/>
              </svg>
            </a>
          </div>

          <!-- Member 5 -->
          <div class="bg-white rounded-2xl p-5 border border-[#eff1f8] shadow-[0_4px_16px_rgba(22,27,54,0.03)] flex flex-col items-center text-center group hover:shadow-md hover:-translate-y-1 transition-all duration-300">
            <div class="w-20 h-20 rounded-full overflow-hidden mb-3 border-2 border-slate-100 shrink-0">
              <img
                src="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80"
                alt="Hoàng Bảo Trân"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </div>
            <h3 class="font-extrabold text-[#161b36] text-[15px]">Hoàng Bảo Trân</h3>
            <span class="text-[13px] font-bold text-[#8d95ab] mt-0.5">Head of Marketing</span>
            <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed mt-2 line-clamp-2">
              Chuyên gia marketing với chiến lược tăng trưởng cộng đồng.
            </p>
            <a href="#" class="mt-4 text-[#5b46e0] hover:text-[#4d3abf] transition-colors p-1" aria-label="LinkedIn">
              <svg class="w-4 h-4 fill-current" viewBox="0 0 24 24">
                <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"/>
              </svg>
            </a>
          </div>
        </div>
      </section>

      <!-- Section: Customer Reviews -->
      <section class="my-14 sm:my-18">
        <div class="mb-7">
          <h2 class="text-3xl sm:text-[32px] font-extrabold text-[#161b36] tracking-tight">Đánh giá từ khách hàng</h2>
          <div class="w-9 h-[3px] bg-[#5b46e0] rounded-full mt-2"></div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-stretch">
          <!-- Rating Summary Box (4 cols) -->
          <div class="lg:col-span-4 h-full bg-[#f7f8ff] border border-[#ebedfa] rounded-3xl p-6 flex items-center gap-5 shadow-[0_4px_16px_rgba(22,27,54,0.02)]">
            <div class="flex flex-col items-center justify-center shrink-0">
              <div class="text-4xl sm:text-[40px] font-black text-[#161b36] leading-none">4.8<span class="text-[#8d95ab] text-lg font-bold">/5</span></div>
              <div class="flex text-[#f59e0b] gap-1 my-3">
                <svg v-for="i in 5" :key="i" class="w-5 h-5 fill-current" viewBox="0 0 20 20">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                </svg>
              </div>
              <span class="text-[13px] text-[#8d95ab] font-semibold">(76 đánh giá)</span>
            </div>

            <!-- Rating Bars -->
            <div class="flex-1 space-y-3 text-[13px] text-[#7c849b] font-semibold">
              <div class="flex items-center gap-3">
                <span class="w-4">5</span>
                <span class="text-[#f59e0b]">★</span>
                <div class="flex-1 h-2 bg-[#e2e5f5] rounded-full overflow-hidden">
                  <div class="h-full bg-[#5b46e0] rounded-full w-[85%]"></div>
                </div>
                <span class="w-5 text-right">68</span>
              </div>
              <div class="flex items-center gap-3">
                <span class="w-4">4</span>
                <span class="text-[#f59e0b]">★</span>
                <div class="flex-1 h-2 bg-[#e2e5f5] rounded-full overflow-hidden">
                  <div class="h-full bg-[#5b46e0] rounded-full w-[15%]"></div>
                </div>
                <span class="w-5 text-right">6</span>
              </div>
              <div class="flex items-center gap-3">
                <span class="w-4">3</span>
                <span class="text-[#f59e0b]">★</span>
                <div class="flex-1 h-2 bg-[#e2e5f5] rounded-full overflow-hidden">
                  <div class="h-full bg-[#5b46e0] rounded-full w-[5%]"></div>
                </div>
                <span class="w-5 text-right">2</span>
              </div>
              <div class="flex items-center gap-3">
                <span class="w-4">2</span>
                <span class="text-[#f59e0b]">★</span>
                <div class="flex-1 h-2 bg-[#e2e5f5] rounded-full overflow-hidden">
                  <div class="h-full bg-[#5b46e0] rounded-full w-[2%]"></div>
                </div>
                <span class="w-5 text-right">1</span>
              </div>
              <div class="flex items-center gap-3">
                <span class="w-4">1</span>
                <span class="text-[#f59e0b]">★</span>
                <div class="flex-1 h-2 bg-[#e2e5f5] rounded-full overflow-hidden">
                  <div class="h-full bg-[#5b46e0] rounded-full w-[0%]"></div>
                </div>
                <span class="w-5 text-right">0</span>
              </div>
            </div>
          </div>

          <!-- Reviews Carousel List (8 cols) -->
          <div class="lg:col-span-8 bg-white border border-[#eff1f8] rounded-3xl p-5 sm:p-6 shadow-[0_4px_16px_rgba(22,27,54,0.03)] relative">
            <!-- Nav buttons -->
            <button class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-white border border-slate-200 text-slate-600 hover:bg-slate-50 shadow-xs flex items-center justify-center z-10 transition-colors">
              <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M15 19l-7-7 7-7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <button class="absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-white border border-slate-200 text-slate-600 hover:bg-slate-50 shadow-xs flex items-center justify-center z-10 transition-colors">
              <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path d="M9 5l7 7-7 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>

            <div class="px-5 space-y-3.5">
              <!-- Review 1 -->
              <div class="flex items-center gap-3 py-2 border-b border-[#eff1f8] last:border-0">
                <img
                  src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80"
                  alt="Trần Minh Tuấn"
                  class="w-9 h-9 rounded-full object-cover shrink-0"
                />
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2">
                    <h4 class="font-extrabold text-[#161b36] text-[14px]">Trần Minh Tuấn</h4>
                    <div class="flex text-[#f59e0b] text-[13px]">★★★★★</div>
                  </div>
                  <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed truncate mt-0.5">
                    Nền tảng rất dễ sử dụng, giao diện thân thiện, hoạt động ổn định.
                  </p>
                </div>
              </div>

              <!-- Review 2 -->
              <div class="flex items-center gap-3 py-2 border-b border-[#eff1f8] last:border-0">
                <img
                  src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=100&auto=format&fit=crop&q=80"
                  alt="Nguyễn Thu Hà"
                  class="w-9 h-9 rounded-full object-cover shrink-0"
                />
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2">
                    <h4 class="font-extrabold text-[#161b36] text-[14px]">Nguyễn Thu Hà</h4>
                    <div class="flex text-[#f59e0b] text-[13px]">★★★★★</div>
                  </div>
                  <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed truncate mt-0.5">
                    Tôi đã tìm được căn hộ ưng ý rất nhanh, thủ tục đơn giản.
                  </p>
                </div>
              </div>

              <!-- Review 3 -->
              <div class="flex items-center gap-3 py-2 border-b border-[#eff1f8] last:border-0">
                <img
                  src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80"
                  alt="Lê Hoàng Nam"
                  class="w-9 h-9 rounded-full object-cover shrink-0"
                />
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2">
                    <h4 class="font-extrabold text-[#161b36] text-[14px]">Lê Hoàng Nam</h4>
                    <div class="flex text-[#f59e0b] text-[13px]">★★★★★</div>
                  </div>
                  <p class="text-[13px] text-[#7c849b] font-normal leading-relaxed truncate mt-0.5">
                    Công cụ quản lý thông minh, giúp tôi tiết kiệm rất nhiều thời gian.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Section: Questions Support Banner -->
      <section id="contact" class="support-cta">
        <span class="support-cta-orb support-cta-orb-one" aria-hidden="true"></span>
        <span class="support-cta-orb support-cta-orb-two" aria-hidden="true"></span>

        <div class="support-cta-content">
          <div class="support-cta-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M6.5 11.5a5.5 5.5 0 0 1 11 0v1.2a2.3 2.3 0 0 1-2.3 2.3h-.7v-4.2h.7c.4 0 .8.1 1.1.3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M6.5 15h-.2A2.3 2.3 0 0 1 4 12.7v-.9a2.3 2.3 0 0 1 2.3-2.3H7v5.5M7 15.2c.4 2.1 2.2 3.6 4.5 3.6h1.2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M13.8 18.8h-1.3a1.2 1.2 0 0 0 0 2.4h1.3a1.2 1.2 0 0 0 0-2.4Z" stroke="currentColor" stroke-width="1.7"/>
            </svg>
          </div>

          <div class="support-cta-copy">
            <span class="support-cta-eyebrow">ĐỒNG HÀNH CÙNG BẠN</span>
            <h2>Cần hỗ trợ? RentOps luôn ở đây.</h2>
            <p>Đội ngũ của chúng tôi sẵn sàng giải đáp mọi thắc mắc, từ tìm phòng, đặt chỗ đến quản lý tin đăng — nhanh chóng và tận tâm 24/7.</p>
            <div class="support-cta-details">
              <span><i></i>Phản hồi trong 15 phút</span>
              <span><i></i>Hỗ trợ mỗi ngày</span>
            </div>
          </div>
        </div>

        <div class="support-cta-action">
          <span>Chúng tôi sẵn sàng lắng nghe</span>
          <a href="mailto:support@rentops.vn">
            <span>Liên hệ đội ngũ</span>
            <svg fill="none" viewBox="0 0 24 24" aria-hidden="true">
              <path d="M5 12h14m-6-6 6 6-6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </a>
        </div>
      </section>
    </main>

    <PublicFooter @notify="router.push('/landing')" />

    <!-- Legacy footer kept out of the DOM while the shared footer is used. -->
    <footer v-if="false" class="bg-white border-t border-[#eff1f8] pt-10 pb-6 text-[#7c849b] text-[11.5px]">
      <div class="max-w-[1240px] mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-12 gap-7 pb-8 border-b border-[#eff1f8]">
          <!-- Column 1: Brand (4 cols) -->
          <div class="md:col-span-4 space-y-3">
            <RouterLink to="/landing" class="flex items-center gap-2.5 shrink-0">
              <div class="w-8 h-8 shrink-0 rounded-xl bg-[#5b46e0] p-1.5 flex items-center justify-center text-white">
                <svg viewBox="0 0 38 38" fill="none" class="w-5 h-5 shrink-0">
                  <path d="M5.5 17.4 19 5l13.5 12.4v13.1a2 2 0 0 1-2 2h-23a2 2 0 0 1-2-2V17.4Z" fill="currentColor" opacity="0.9" />
                  <path d="m19 5 13.5 12.4-4.1 3.7L19 13.8l-9.4 7.3-4.1-3.7L19 5Z" fill="#ffffff" />
                </svg>
              </div>
              <span class="font-extrabold text-[#161b36] text-[16px] tracking-tight">Rentalio</span>
            </RouterLink>
            <p class="text-[#8d95ab] text-[11px] leading-relaxed max-w-xs font-normal">
              SaaS Rental Platform – Kết nối người thuê và chủ nhà tốt hơn mỗi ngày.
            </p>
            <div class="flex items-center gap-2.5 text-[#8d95ab] pt-1">
              <a href="#" class="w-7 h-7 shrink-0 rounded-lg bg-[#f4f6fb] flex items-center justify-center hover:bg-[#eeeaff] hover:text-[#5b46e0] transition-colors">
                <svg class="w-3.5 h-3.5 fill-current" viewBox="0 0 24 24"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H7.5v-3H10V9.69c0-2.47 1.47-3.83 3.72-3.83 1.08 0 2.2.19 2.2.19v2.42h-1.24c-1.23 0-1.62.76-1.62 1.54V12h2.73l-.44 3h-2.29v6.8c4.56-.93 8-4.96 8-9.8z"/></svg>
              </a>
              <a href="#" class="w-7 h-7 shrink-0 rounded-lg bg-[#f4f6fb] flex items-center justify-center hover:bg-[#eeeaff] hover:text-[#5b46e0] transition-colors">
                <svg class="w-3.5 h-3.5 fill-current" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/></svg>
              </a>
              <a href="#" class="w-7 h-7 shrink-0 rounded-lg bg-[#f4f6fb] flex items-center justify-center hover:bg-[#eeeaff] hover:text-[#5b46e0] transition-colors">
                <svg class="w-3.5 h-3.5 fill-current" viewBox="0 0 24 24"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64c.29 0 .56.04.83.1v-3.6a6.5 6.5 0 0 0-5.75 6.44 6.51 6.51 0 0 0 11.66 3.9v-7.14a8.3 8.3 0 0 0 4.95 1.62V10.4a4.85 4.85 0 0 1-1.58-.31z"/></svg>
              </a>
              <a href="#" class="w-7 h-7 shrink-0 rounded-lg bg-[#f4f6fb] flex items-center justify-center hover:bg-[#eeeaff] hover:text-[#5b46e0] transition-colors">
                <svg class="w-3.5 h-3.5 fill-current" viewBox="0 0 24 24"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
              </a>
            </div>
          </div>

          <!-- Column 2: Về chúng tôi (2 cols) -->
          <div class="md:col-span-2 space-y-2.5">
            <h4 class="font-extrabold text-[#161b36] text-[12px]">Về chúng tôi</h4>
            <ul class="space-y-1.5 text-[11px] text-[#7c849b] font-medium">
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Giới thiệu</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Tin tức</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Blog</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Chính sách bảo mật</a></li>
            </ul>
          </div>

          <!-- Column 3: Hỗ trợ (2 cols) -->
          <div class="md:col-span-2 space-y-2.5">
            <h4 class="font-extrabold text-[#161b36] text-[12px]">Hỗ trợ</h4>
            <ul class="space-y-1.5 text-[11px] text-[#7c849b] font-medium">
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Trung tâm trợ giúp</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Câu hỏi thường gặp</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Hướng dẫn sử dụng</a></li>
              <li><a href="#contact" class="hover:text-[#5b46e0] transition-colors">Liên hệ</a></li>
            </ul>
          </div>

          <!-- Column 4: Dành cho đối tác (2 cols) -->
          <div class="md:col-span-2 space-y-2.5">
            <h4 class="font-extrabold text-[#161b36] text-[12px]">Dành cho đối tác</h4>
            <ul class="space-y-1.5 text-[11px] text-[#7c849b] font-medium">
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Chương trình API</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Đối tác phát triển</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Affiliate</a></li>
              <li><a href="#" class="hover:text-[#5b46e0] transition-colors">Doanh nghiệp</a></li>
            </ul>
          </div>

          <!-- Column 5: Liên hệ (2 cols) -->
          <div class="md:col-span-2 space-y-2.5">
            <h4 class="font-extrabold text-[#161b36] text-[12px]">Liên hệ</h4>
            <ul class="space-y-1.5 text-[11px] text-[#7c849b] font-medium">
              <li class="flex items-center gap-1.5">
                <svg class="w-3.5 h-3.5 text-[#8d95ab] shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
                <span>1900 1234</span>
              </li>
              <li class="flex items-center gap-1.5">
                <svg class="w-3.5 h-3.5 text-[#8d95ab] shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 002-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
                <span class="truncate">support@rentalio.vn</span>
              </li>
              <li class="flex items-start gap-1.5">
                <svg class="w-3.5 h-3.5 text-[#8d95ab] shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/><path d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
                <span>123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh</span>
              </li>
            </ul>
          </div>
        </div>

        <div class="pt-5 flex flex-col sm:flex-row items-center justify-between text-[11px] text-[#8d95ab]">
          <p>© 2024 Rentalio. Tất cả quyền được bảo lưu.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import PublicHeader from '../components/PublicHeader.vue'
import PublicFooter from '../components/PublicFooter.vue'

const router = useRouter()
const searchTerm = ref('')
const isMenuOpen = ref(false)
const isProfileOpen = ref(false)

const closeMenu = () => {
  isMenuOpen.value = false
}

const handleSearch = () => {
  if (searchTerm.value.trim()) {
    router.push({ path: '/landing', query: { query: searchTerm.value.trim() }, hash: '#search' })
  }
}

const contactUs = () => {
  document.querySelector('#contact')?.scrollIntoView({ behavior: 'smooth' })
  closeMenu()
}
</script>

<style scoped>
:global(*) { box-sizing: border-box; }
:global(body) { margin: 0; }

.about-page {
  padding-top: 60px;
  font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
}

.home-container {
  width: min(1280px, calc(100% - 64px));
  margin: 0 auto;
}

.home-header {
  position: fixed;
  z-index: 50;
  top: 0;
  right: 0;
  left: 0;
  height: 60px;
  border-bottom: 1px solid #eef0f5;
  background: rgba(255, 255, 255, .96);
  box-shadow: 0 4px 18px rgba(28, 38, 67, .06);
  backdrop-filter: blur(14px);
}

.home-header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.home-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #172033;
  border: 0;
  background: transparent;
  cursor: pointer;
  font-size: 22px;
  font-weight: 800;
  text-decoration: none;
  white-space: nowrap;
}

.home-brand-mark {
  display: grid;
  width: 44px;
  height: 44px;
  place-items: center;
  color: #fff;
  border-radius: 16px;
  background: linear-gradient(135deg, #5e87f5, #5545e8);
  box-shadow: 0 8px 16px rgba(79, 70, 229, .22);
  font-size: 20px;
}

.home-nav {
  display: flex;
  align-items: center;
  gap: 30px;
  margin-right: 28px;
  margin-left: auto;
  white-space: nowrap;
}

.home-nav a,
.favorite-action {
  color: #4f5b70;
  border: 0;
  background: transparent;
  cursor: pointer;
  font-size: 15px;
  font-weight: 700;
  text-decoration: none;
}

.home-nav a:hover,
.home-nav a.is-active,
.favorite-action:hover {
  color: #5147db;
}

.home-actions {
  display: flex;
  align-items: center;
  gap: 13px;
  white-space: nowrap;
}

.favorite-action {
  display: inline-flex;
  align-items: center;
}

.bell-action {
  padding: 0 2px;
  color: #566177;
  border: 0;
  background: transparent;
  cursor: pointer;
  font-size: 20px;
}

.home-login,
.home-listing {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 45px;
  border-radius: 16px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 700;
  text-decoration: none;
}

.home-login {
  width: 128px;
  color: #5549e8;
  border: 1px solid #c9c9fb;
  background: #fff;
}

.home-login:hover { background: #f8f7ff; }

.home-listing {
  width: 175px;
  color: #fff;
  border: 0;
  background: linear-gradient(100deg, #4e43de, #873be7);
  box-shadow: 0 9px 17px rgba(94, 63, 224, .23);
}

.home-listing:hover { filter: brightness(.96); }

@media (max-width: 1100px) {
  .home-nav { gap: 17px; margin-right: 15px; }
  .home-actions { gap: 8px; }
  .home-login { width: 110px; }
  .home-listing { width: 155px; }
}

@media (max-width: 850px) {
  .about-page { padding-top: 60px; }
  .home-container { width: min(100% - 32px, 720px); }
  .home-header { height: 60px; }
  .home-nav { display: none; }
  .home-actions { margin-left: auto; }
  .favorite-action { display: block; }
  .bell-action { display: none; }
  .home-login { width: 100px; height: 39px; font-size: 13px; }
  .home-listing { display: none; }
}

@media (max-width: 520px) {
  .home-container { width: calc(100% - 24px); }
  .home-brand { font-size: 18px; }
  .home-brand-mark { width: 38px; height: 38px; border-radius: 13px; font-size: 16px; }
  .favorite-action { font-size: 12px; }
}

.support-cta {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 34px;
  overflow: hidden;
  margin: 64px 0;
  padding: 30px 34px;
  border: 1px solid #e4defd;
  border-radius: 28px;
  background: linear-gradient(115deg, #f0edff 0%, #f8f6ff 58%, #f2efff 100%);
  box-shadow: 0 16px 36px rgba(86, 73, 184, .09);
}

.support-cta::after {
  position: absolute;
  top: -90px;
  right: 24%;
  width: 320px;
  height: 220px;
  border: 1px solid rgba(121, 102, 226, .11);
  border-radius: 50%;
  content: '';
  transform: rotate(-18deg);
}

.support-cta-orb {
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
}

.support-cta-orb-one {
  top: -84px;
  left: 30%;
  width: 170px;
  height: 170px;
  background: rgba(213, 204, 255, .35);
}

.support-cta-orb-two {
  right: 5%;
  bottom: -110px;
  width: 210px;
  height: 210px;
  border: 1px solid rgba(123, 102, 222, .13);
}

.support-cta-content,
.support-cta-action {
  position: relative;
  z-index: 1;
}

.support-cta-content {
  display: flex;
  align-items: flex-start;
  gap: 18px;
  min-width: 0;
}

.support-cta-icon {
  display: grid;
  width: 58px;
  height: 58px;
  flex: 0 0 58px;
  place-items: center;
  color: #5b46e0;
  border: 1px solid rgba(113, 91, 225, .16);
  border-radius: 19px;
  background: linear-gradient(145deg, #e8e2ff, #f5f2ff);
  box-shadow: 0 8px 18px rgba(91, 70, 224, .1);
}

.support-cta-icon svg { width: 28px; height: 28px; }

.support-cta-copy { max-width: 690px; }

.support-cta-eyebrow {
  display: block;
  margin-bottom: 6px;
  color: #6956dc;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: .16em;
}

.support-cta-copy h2 {
  margin: 0;
  color: #151b36;
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -.04em;
  line-height: 1.15;
}

.support-cta-copy p {
  max-width: 660px;
  margin: 8px 0 12px;
  color: #737d98;
  font-size: 14px;
  line-height: 1.6;
}

.support-cta-details {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  color: #73709c;
  font-size: 12px;
  font-weight: 700;
}

.support-cta-details span { display: inline-flex; align-items: center; gap: 7px; }
.support-cta-details i { width: 7px; height: 7px; border-radius: 50%; background: #6c57e5; box-shadow: 0 0 0 4px rgba(108, 87, 229, .1); }

.support-cta-action {
  display: flex;
  align-items: flex-end;
  flex: 0 0 auto;
  flex-direction: column;
  gap: 12px;
}

.support-cta-action > span { color: #817da8; font-size: 11px; font-weight: 700; }

.support-cta-action a {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 13px 17px 13px 20px;
  color: #fff;
  border-radius: 14px;
  background: linear-gradient(135deg, #5748df, #8436e7);
  box-shadow: 0 10px 20px rgba(91, 70, 224, .24);
  font-size: 14px;
  font-weight: 800;
  text-decoration: none;
  transition: transform .2s ease, box-shadow .2s ease;
}

.support-cta-action a:hover { box-shadow: 0 13px 25px rgba(91, 70, 224, .3); transform: translateY(-2px); }
.support-cta-action a svg { width: 16px; height: 16px; }

@media (max-width: 850px) {
  .support-cta { align-items: flex-start; flex-direction: column; gap: 22px; margin: 46px 0; padding: 25px; }
  .support-cta-action { align-items: flex-start; }
}

@media (max-width: 520px) {
  .support-cta { margin: 36px 0; padding: 21px 18px; border-radius: 23px; }
  .support-cta-content { gap: 13px; }
  .support-cta-icon { width: 48px; height: 48px; flex-basis: 48px; border-radius: 15px; }
  .support-cta-icon svg { width: 23px; height: 23px; }
  .support-cta-copy h2 { font-size: 21px; }
  .support-cta-copy p { font-size: 13px; }
  .support-cta-details { gap: 9px 14px; font-size: 11px; }
  .support-cta-action { width: 100%; }
  .support-cta-action a { justify-content: center; width: 100%; }
}

.about-main { position: relative; padding-top: 36px; padding-bottom: 34px; }

.about-breadcrumb {
  display: inline-flex;
  padding: 8px 13px;
  border: 1px solid #eaecf5;
  border-radius: 999px;
  background: rgba(255, 255, 255, .7);
  box-shadow: 0 5px 15px rgba(36, 44, 78, .03);
}

.about-hero {
  position: relative;
  margin-top: 24px;
  margin-bottom: 92px !important;
}

.about-hero-copy { position: relative; z-index: 1; }

.about-hero-eyebrow {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #6756dc;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: .16em;
}

.about-hero-eyebrow span {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #6756dc;
  box-shadow: 0 0 0 5px rgba(103, 86, 220, .1);
}

.about-hero-eyebrow b { color: #b0a9d9; font-size: 14px; }

.about-hero-copy h1 {
  max-width: 520px;
  margin-top: 17px;
  color: #141a35;
  font-size: clamp(40px, 4.15vw, 54px);
  letter-spacing: -.065em;
  line-height: 1.04;
}

.about-hero-copy h1 + div {
  width: 54px;
  height: 4px;
  margin-top: 18px;
  box-shadow: 0 4px 10px rgba(91, 70, 224, .22);
}

.about-hero-copy > p {
  max-width: 475px;
  margin-top: 23px;
  color: #6d7891;
  font-size: 15px;
  line-height: 1.75;
}

.about-hero-copy a { min-height: 49px; padding-right: 19px; padding-left: 19px; border-radius: 15px; }
.about-hero-copy a:first-child { box-shadow: 0 12px 22px rgba(91, 70, 224, .2); }

.about-hero-media-wrap { position: relative; }

.about-hero-media {
  min-height: 380px;
  border: 6px solid rgba(255, 255, 255, .76) !important;
  border-radius: 30px !important;
  background: #dfe5f2;
  box-shadow: 0 24px 48px rgba(32, 40, 73, .14) !important;
}

.about-hero-media::before {
  position: absolute;
  z-index: 1;
  inset: 0;
  pointer-events: none;
  background: linear-gradient(145deg, rgba(23, 31, 62, .05), transparent 48%, rgba(37, 28, 87, .25));
  content: '';
}

.about-hero-media img {
  height: 380px !important;
  filter: saturate(.92) contrast(1.03);
}

.about-hero-image-badge {
  position: absolute;
  z-index: 2;
  right: 18px;
  bottom: 18px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 13px 10px 10px;
  color: #fff;
  border: 1px solid rgba(255, 255, 255, .25);
  border-radius: 15px;
  background: rgba(23, 29, 54, .58);
  box-shadow: 0 8px 22px rgba(12, 18, 38, .2);
  backdrop-filter: blur(12px);
}

.about-hero-image-badge > span {
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  color: #6e5be7;
  border-radius: 10px;
  background: #efedff;
  font-size: 15px;
}

.about-hero-image-badge div { display: flex; flex-direction: column; gap: 2px; }
.about-hero-image-badge strong { font-size: 11px; font-weight: 800; }
.about-hero-image-badge small { color: rgba(255, 255, 255, .72); font-size: 10px; }

.about-mission-wrap { position: relative; }

.about-mission-card {
  position: relative;
  overflow: hidden;
  padding: 22px !important;
  border: 1px solid #e3e5f6 !important;
  border-radius: 27px !important;
  background: linear-gradient(160deg, #fbfbff, #f1f1ff) !important;
  box-shadow: 0 18px 38px rgba(44, 45, 104, .09) !important;
}

.about-mission-card::after {
  position: absolute;
  top: -60px;
  right: -55px;
  width: 150px;
  height: 150px;
  border: 1px solid rgba(103, 86, 220, .12);
  border-radius: 50%;
  content: '';
}

.about-mission-heading { position: relative; z-index: 1; padding-bottom: 14px; border-bottom: 1px solid #e8e9f6; }
.about-mission-heading span { display: block; margin-bottom: 5px; color: #7463dd; font-size: 9px; font-weight: 800; letter-spacing: .17em; }
.about-mission-heading strong { display: block; color: #202744; font-size: 16px; font-weight: 800; }
.about-mission-heading small { display: block; margin-top: 4px; color: #8b93aa; font-size: 11px; line-height: 1.5; }

.about-mission-item { position: relative; z-index: 1; padding-top: 2px; }
.about-mission-item + .about-mission-item { padding-top: 17px; border-top: 1px solid #e8e9f6; }
.about-mission-icon { width: 42px !important; height: 42px !important; border-radius: 14px !important; box-shadow: 0 5px 12px rgba(103, 86, 220, .08); }
.about-mission-item h3 { font-size: 14px; }
.about-mission-item p { font-size: 12px; line-height: 1.55; }

.about-values { position: relative; }
.about-values > div:first-child { position: relative; margin-bottom: 30px; }
.about-values > div:first-child::before {
  position: absolute;
  top: 50%;
  left: 0;
  width: 100%;
  height: 1px;
  background: #e9eaf4;
  content: '';
}

.about-values > div:first-child h2,
.about-values > div:first-child > div { position: relative; z-index: 1; background: #f7f8fc; }
.about-values > div:first-child h2 { display: inline-block; padding: 0 18px; font-size: 31px; }
.about-values > div:first-child > div { width: 42px; margin-right: auto; margin-left: auto; }
.about-values-grid { gap: 16px !important; }

.about-value-card {
  position: relative;
  min-height: 210px;
  overflow: hidden;
  padding: 29px 22px !important;
  border: 1px solid #e8eaf3 !important;
  border-radius: 24px !important;
  background: linear-gradient(160deg, #fff 10%, #fbfbff 100%);
  box-shadow: 0 10px 25px rgba(32, 41, 74, .045) !important;
}

.about-value-card::before {
  position: absolute;
  top: -34px;
  right: -34px;
  width: 110px;
  height: 110px;
  border: 1px solid rgba(106, 86, 225, .1);
  border-radius: 50%;
  content: '';
}

.about-value-icon {
  position: relative;
  z-index: 1;
  width: 58px !important;
  height: 58px !important;
  margin-bottom: 18px !important;
  border: 1px solid #e4defe;
  background: linear-gradient(145deg, #eeeaff, #f8f6ff) !important;
  box-shadow: 0 8px 18px rgba(91, 70, 224, .11);
}

.about-value-icon svg { width: 22px !important; height: 22px !important; }
.about-value-card h3 { position: relative; z-index: 1; font-size: 15px; }
.about-value-card p { position: relative; z-index: 1; font-size: 12.5px; }

@media (max-width: 1024px) {
  .about-hero-copy h1 { font-size: 40px; }
  .about-hero-media, .about-hero-media img { height: 340px !important; min-height: 340px; }
}

@media (max-width: 640px) {
  .about-main { padding-top: 21px; }
  .about-hero { margin-top: 16px; margin-bottom: 55px !important; }
  .about-hero-copy h1 { font-size: 38px; }
  .about-hero-media, .about-hero-media img { height: 285px !important; min-height: 285px; }
  .about-hero-image-badge { right: 12px; bottom: 12px; }
  .about-values > div:first-child h2 { padding: 0 10px; font-size: 27px; }
}
</style>
