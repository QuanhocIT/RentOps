<template>
  <div class="min-h-screen bg-[#f6f7fb] text-slate-900 relative overflow-hidden">
    <div class="pointer-events-none absolute inset-x-0 top-0 -z-0 h-[720px] bg-[radial-gradient(circle_at_top_left,rgba(99,102,241,0.12),transparent_35%),radial-gradient(circle_at_top_right,rgba(168,85,247,0.12),transparent_30%),linear-gradient(to_bottom,rgba(255,255,255,0.92),rgba(246,247,251,1))]"></div>
    <div class="pointer-events-none absolute left-[-140px] top-40 -z-0 h-72 w-72 rounded-full bg-indigo-300/20 blur-3xl"></div>
    <div class="pointer-events-none absolute right-[-120px] top-[520px] -z-0 h-80 w-80 rounded-full bg-violet-300/20 blur-3xl"></div>

    <header class="sticky top-0 z-50 border-b border-white/70 bg-white/85 backdrop-blur-xl">
      <div class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
        <button class="flex items-center gap-3" @click="$router.push('/landing')">
          <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-500 via-blue-500 to-violet-500 text-white shadow-lg shadow-indigo-500/25">
            <span class="text-lg font-black">R</span>
          </div>
          <div class="text-left">
            <div class="text-xl font-black tracking-tight text-slate-900">Rentalio</div>
          </div>
        </button>

        <nav class="hidden items-center gap-8 text-sm font-semibold text-slate-600 lg:flex">
          <a v-for="item in navItems" :key="item" href="#" class="transition hover:text-indigo-600">{{ item }}</a>
          <a href="#" class="flex items-center gap-2 transition hover:text-indigo-600">♡ Yêu thích</a>
          <RouterLink to="/login" class="rounded-2xl border border-indigo-200 bg-white px-5 py-3 font-semibold text-indigo-600 shadow-sm transition hover:border-indigo-300 hover:bg-indigo-50">
            Đăng nhập
          </RouterLink>
          <button class="rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 px-5 py-3 text-white shadow-lg shadow-indigo-500/25 transition hover:opacity-95">
            Đăng tin phòng +
          </button>
        </nav>
      </div>
    </header>

    <main>
      <section class="relative overflow-hidden bg-gradient-to-r from-white via-[#f6f7fb] to-[#edf2ff]">
        <div class="mx-auto grid max-w-7xl items-center gap-8 px-4 pb-10 pt-10 sm:px-6 lg:grid-cols-2 lg:px-8 lg:pb-24 lg:pt-14">
          <div class="relative z-10 max-w-2xl">
            <div class="mb-6 inline-flex items-center gap-3 rounded-full border border-indigo-100 bg-white px-4 py-2 shadow-sm">
              <span class="flex h-8 w-8 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 to-violet-500 text-white">✦</span>
              <span class="text-xs font-bold uppercase tracking-[0.22em] text-indigo-600">RentOps SaaS Multi-tenant</span>
            </div>
            <p class="mb-4 inline-flex rounded-full bg-indigo-50 px-4 py-2 text-xs font-bold uppercase tracking-[0.24em] text-indigo-600">
              Không gian sống hiện đại
            </p>
            <h1 class="max-w-xl text-4xl font-black leading-tight tracking-tight text-slate-900 sm:text-5xl lg:text-6xl">
              Quản lý phòng trọ
              <span class="block">thông minh cho</span>
              <span class="block text-transparent bg-gradient-to-r from-indigo-600 to-violet-500 bg-clip-text">chủ trọ & cư dân</span>
            </h1>
            <p class="mt-6 max-w-xl text-base leading-8 text-slate-600">
              Nền tảng SaaS giúp chủ nhà quản lý khu trọ, tòa nhà, hợp đồng, hóa đơn VietQR, sự cố bảo trì và cổng khách thuê trên cùng một hệ thống.
            </p>

            <div class="mt-7 grid max-w-xl gap-4 sm:grid-cols-3">
              <div class="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-[0_16px_50px_rgba(15,23,42,0.08)]">
                <div class="text-xs font-semibold text-slate-500">Tổng phòng</div>
                <div class="mt-1 text-2xl font-black text-slate-900">{{ dashboardStats.total_rooms }}</div>
                <div class="mt-1 text-xs text-indigo-500">Từ dashboard RentOps</div>
              </div>
              <div class="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-[0_16px_50px_rgba(15,23,42,0.08)]">
                <div class="text-xs font-semibold text-slate-500">Phòng đang ở</div>
                <div class="mt-1 text-2xl font-black text-slate-900">{{ dashboardStats.occupied_rooms }}</div>
                <div class="mt-1 text-xs text-rose-500">{{ dashboardStats.occupancy_rate }}% lấp đầy</div>
              </div>
              <div class="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-[0_16px_50px_rgba(15,23,42,0.08)]">
                <div class="text-xs font-semibold text-slate-500">Phòng trống</div>
                <div class="mt-1 text-2xl font-black text-slate-900">{{ dashboardStats.vacant_rooms }}</div>
                <div class="mt-1 text-xs text-amber-500">Sẵn sàng cho thuê</div>
              </div>
            </div>

            <div class="mt-8 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
              <div v-for="feature in topFeatures" :key="feature.title" class="rounded-2xl bg-white/90 p-4 shadow-[0_12px_40px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
                <div class="mb-3 flex h-11 w-11 items-center justify-center rounded-2xl bg-indigo-50 text-indigo-600">{{ feature.icon }}</div>
                <div class="text-sm font-bold text-slate-900">{{ feature.title }}</div>
                <div class="mt-1 text-xs leading-5 text-slate-500">{{ feature.desc }}</div>
              </div>
            </div>

            <div class="mt-6 flex flex-wrap items-center gap-3">
              <span class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-xs font-bold text-white shadow-lg shadow-slate-900/15">
                <span>⚡</span> Hợp đồng, hóa đơn, bảo trì
              </span>
              <span class="inline-flex items-center gap-2 rounded-full bg-white px-4 py-2 text-xs font-bold text-slate-700 shadow-sm ring-1 ring-slate-200">
                <span>🧾</span> VietQR và nhắc nợ tự động
              </span>
            </div>
          </div>

          <div class="relative">
            <div class="absolute inset-0 -z-10 rounded-[2rem] bg-gradient-to-br from-indigo-200/40 via-white to-violet-200/30 blur-3xl"></div>
            <div class="overflow-hidden rounded-[2rem] shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-white/80">
              <img :src="heroImage" alt="Phòng mẫu" class="h-[420px] w-full object-cover sm:h-[520px]" />
            </div>
            <div class="absolute -left-4 bottom-8 hidden w-48 rounded-3xl bg-white p-4 shadow-[0_16px_50px_rgba(15,23,42,0.12)] ring-1 ring-slate-100 lg:block">
              <div class="flex items-center gap-3">
                <img :src="floorPlanImage" alt="Bản đồ phòng" class="h-12 w-12 rounded-2xl object-cover" />
                <div>
                  <div class="text-xs font-bold text-slate-900">Tour 360°</div>
                  <div class="text-[11px] text-slate-500">Xem phòng như đang ở thật</div>
                </div>
              </div>
            </div>
            <div class="absolute right-4 top-4 rounded-2xl bg-white/90 px-4 py-3 shadow-[0_16px_50px_rgba(15,23,42,0.10)] ring-1 ring-slate-100">
              <div class="text-[11px] font-bold uppercase tracking-[0.22em] text-indigo-500">Dashboard preview</div>
              <div class="mt-1 text-sm font-black text-slate-900">{{ dashboardStats.pending_maintenance_count }} sự cố chờ xử lý</div>
            </div>
          </div>
        </div>

        <div class="mx-auto -mt-8 max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="grid gap-4 rounded-[2rem] border border-white/80 bg-white p-4 shadow-[0_24px_70px_rgba(15,23,42,0.10)] lg:grid-cols-[1.3fr_1fr_1fr_1fr_auto] lg:items-end lg:gap-5 lg:p-6">
            <div v-for="field in searchFields" :key="field.label" class="space-y-2">
              <label class="text-sm font-bold text-slate-700">{{ field.label }}</label>
              <div class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-400 shadow-sm">
                {{ field.placeholder }}
              </div>
            </div>
            <button class="mt-1 rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 px-6 py-4 font-bold text-white shadow-lg shadow-indigo-500/25 transition hover:scale-[1.01] lg:mt-0">
              Tìm kiếm
            </button>
          </div>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
        <div class="mb-6 overflow-hidden rounded-[2rem] bg-gradient-to-r from-slate-900 via-indigo-900 to-violet-700 p-6 text-white shadow-[0_20px_60px_rgba(15,23,42,0.18)]">
          <div class="grid items-center gap-6 lg:grid-cols-[1.2fr_0.9fr]">
            <div>
              <div class="inline-flex items-center gap-2 rounded-full bg-white/10 px-4 py-2 text-xs font-bold uppercase tracking-[0.22em] text-white/80">
                <span>⚙</span> RentOps overview banner
              </div>
              <h2 class="mt-4 text-3xl font-black leading-tight sm:text-4xl">Tổng quan nhanh hệ thống: phòng, hợp đồng, hóa đơn và bảo trì</h2>
              <p class="mt-3 max-w-2xl text-sm leading-7 text-white/80">Banner này phản ánh đúng mục tiêu của RentOps: quản lý vận hành trọn bộ cho chủ trọ và đội ngũ vận hành.</p>
            </div>
            <div class="grid grid-cols-3 gap-3">
              <div v-for="mini in miniBannerStats" :key="mini.label" class="rounded-2xl bg-white/10 p-4 text-center backdrop-blur-sm">
                <div class="mx-auto mb-2 flex h-10 w-10 items-center justify-center rounded-2xl bg-white/15">{{ mini.icon }}</div>
                <div class="text-lg font-black">{{ mini.value }}</div>
                <div class="text-[11px] text-white/70">{{ mini.label }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
          <div v-for="category in categories" :key="category.title" class="rounded-3xl bg-white p-3 shadow-[0_12px_40px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
            <div class="overflow-hidden rounded-2xl">
              <img :src="category.image" :alt="category.title" class="h-24 w-full object-cover" />
            </div>
            <div class="flex items-center gap-3 px-2 py-3">
              <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-indigo-50 text-indigo-600 shadow-sm">{{ category.icon }}</div>
              <div>
                <div class="text-sm font-bold text-slate-900">{{ category.title }}</div>
                <div class="text-xs text-slate-500">{{ category.price }}</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
        <div class="mb-6 flex items-end justify-between gap-4">
          <div>
            <h2 class="text-3xl font-black text-slate-900">Tài sản nổi bật trong hệ thống</h2>
            <p class="mt-2 text-sm text-slate-500">Một số phòng và tòa nhà mẫu để giới thiệu năng lực vận hành RentOps</p>
          </div>
          <a href="/properties" class="text-sm font-semibold text-indigo-600">Đi tới quản lý tòa nhà →</a>
        </div>

        <div class="grid gap-6 lg:grid-cols-4">
          <article
            v-for="room in featuredRooms"
            :key="room.title"
            class="overflow-hidden rounded-[1.75rem] bg-white shadow-[0_14px_40px_rgba(15,23,42,0.08)] ring-1 ring-slate-100 cursor-pointer transition hover:scale-[1.02]"
            @click="goToRoomDetail(room)"
          >
            <div class="relative h-56">
              <img :src="room.image" :alt="room.title" class="h-full w-full object-cover" />
              <span v-if="room.badge" class="absolute left-4 top-4 rounded-full bg-amber-400 px-3 py-1 text-xs font-black text-white shadow-lg">{{ room.badge }}</span>
              <button class="absolute right-4 top-4 rounded-full bg-white/85 p-2 text-slate-500 shadow-sm" @click.stop>♡</button>
            </div>
            <div class="space-y-3 p-5">
              <h3 class="text-base font-bold text-slate-900">{{ room.title }}</h3>
              <div class="text-sm text-slate-500">{{ room.location }}</div>
              <div class="text-lg font-black text-indigo-600">{{ room.price }}</div>
              <div class="flex flex-wrap gap-2 text-xs text-slate-500">
                <span v-for="tag in room.tags" :key="tag" class="rounded-full bg-slate-50 px-3 py-1 ring-1 ring-slate-200">{{ tag }}</span>
              </div>
              <div class="flex items-center justify-between text-xs text-slate-500">
                <span>⭐ {{ room.rating }}</span>
                <span>{{ room.reviews }} đánh giá</span>
              </div>
            </div>
          </article>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div class="mb-6 flex items-end justify-between gap-4">
            <h2 class="text-3xl font-black text-slate-900">Khu vực có dữ liệu trong hệ thống</h2>
          <a href="/rooms" class="text-sm font-semibold text-indigo-600">Xem danh sách phòng →</a>
        </div>
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-6">
          <article v-for="area in areas" :key="area.name" class="group overflow-hidden rounded-2xl bg-slate-900 shadow-lg">
            <div class="relative h-44">
              <img :src="area.image" :alt="area.name" class="h-full w-full object-cover opacity-85 transition duration-500 group-hover:scale-105" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent"></div>
              <div class="absolute bottom-4 left-4 right-4 text-white">
                <div class="text-sm font-bold">{{ area.name }}</div>
                <div class="text-sm opacity-90">{{ area.rooms }} phòng</div>
              </div>
            </div>
          </article>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-14 sm:px-6 lg:px-8">
        <div class="text-center">
          <h2 class="text-3xl font-black text-slate-900">Vì sao chọn <span class="text-indigo-600">RentOps?</span></h2>
        </div>
        <div class="mt-10 grid gap-4 md:grid-cols-2 xl:grid-cols-5">
          <div v-for="benefit in benefits" :key="benefit.title" class="rounded-[1.5rem] bg-white p-6 text-center shadow-[0_12px_40px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
            <div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl bg-indigo-50 text-indigo-600">{{ benefit.icon }}</div>
            <h3 class="text-base font-bold text-slate-900">{{ benefit.title }}</h3>
            <p class="mt-2 text-sm leading-6 text-slate-500">{{ benefit.desc }}</p>
          </div>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-14 sm:px-6 lg:px-8">
        <div class="text-center">
          <h2 class="text-3xl font-black text-slate-900">Vận hành cho thuê chỉ với 3 bước đơn giản</h2>
        </div>
        <div class="mt-10 grid gap-6 lg:grid-cols-3">
          <div v-for="step in steps" :key="step.title" class="rounded-[1.75rem] border border-slate-200 bg-white p-8 text-center shadow-[0_12px_40px_rgba(15,23,42,0.06)]">
            <div class="mx-auto mb-5 flex h-14 w-14 items-center justify-center rounded-full border-2 border-indigo-200 text-xl font-black text-indigo-600">{{ step.num }}</div>
            <div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl bg-indigo-50 text-indigo-600">{{ step.icon }}</div>
            <h3 class="text-lg font-bold text-slate-900">{{ step.title }}</h3>
            <p class="mt-2 text-sm leading-6 text-slate-500">{{ step.desc }}</p>
          </div>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-4 sm:px-6 lg:px-8">
        <div class="grid gap-4 lg:grid-cols-3">
          <div class="overflow-hidden rounded-[2rem] bg-white shadow-[0_16px_50px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
            <img :src="collageImages[0]" alt="Collage 1" class="h-64 w-full object-cover" />
          </div>
          <div class="grid gap-4">
            <div class="overflow-hidden rounded-[2rem] bg-white shadow-[0_16px_50px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
              <img :src="collageImages[1]" alt="Collage 2" class="h-[124px] w-full object-cover" />
            </div>
            <div class="overflow-hidden rounded-[2rem] bg-white shadow-[0_16px_50px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
              <img :src="collageImages[2]" alt="Collage 3" class="h-[124px] w-full object-cover" />
            </div>
          </div>
          <div class="overflow-hidden rounded-[2rem] bg-white shadow-[0_16px_50px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
            <img :src="collageImages[3]" alt="Collage 4" class="h-64 w-full object-cover" />
          </div>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-14 sm:px-6 lg:px-8">
          <h2 class="text-center text-3xl font-black text-slate-900">Chủ nhà & cư dân nói gì về chúng tôi?</h2>
        <div class="mt-10 grid gap-5 lg:grid-cols-3">
          <article v-for="review in reviews" :key="review.name" class="rounded-[1.5rem] bg-white p-6 shadow-[0_12px_40px_rgba(15,23,42,0.08)] ring-1 ring-slate-100">
            <div class="flex items-start gap-4">
              <img :src="review.avatar" :alt="review.name" class="h-12 w-12 rounded-full object-cover" />
              <div>
                <div class="font-bold text-slate-900">{{ review.name }}</div>
                <div class="text-sm text-slate-500">{{ review.role }}</div>
                <div class="mt-1 text-amber-400">★★★★★</div>
              </div>
            </div>
            <p class="mt-5 text-sm leading-7 text-slate-600">“{{ review.comment }}”</p>
          </article>
        </div>
      </section>

      <section class="mx-auto max-w-7xl px-4 py-4 sm:px-6 lg:px-8">
        <div class="overflow-hidden rounded-[2rem] bg-gradient-to-r from-indigo-600 to-violet-500 px-8 py-10 text-white shadow-[0_24px_70px_rgba(79,70,229,0.28)] lg:flex lg:items-center lg:justify-between lg:px-12">
          <div class="max-w-xl">
            <h2 class="text-3xl font-black">Đăng ký RentOps để quản lý vận hành tập trung ngay hôm nay!</h2>
            <p class="mt-3 text-white/85">Kết nối phòng trọ, hợp đồng, hóa đơn VietQR và bảo trì trên cùng một nền tảng.</p>
            <button class="mt-6 rounded-2xl bg-white px-6 py-3 font-bold text-indigo-600 shadow-lg transition hover:translate-y-[-1px]">
              Khám phá hệ thống →
            </button>
          </div>
          <img :src="ctaImage" alt="CTA" class="mt-8 h-44 w-full max-w-md object-contain lg:mt-0" />
        </div>
      </section>
    </main>

    <footer class="mt-16 border-t border-slate-200 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div class="grid gap-10 lg:grid-cols-[1.3fr_repeat(4,1fr)]">
          <div>
            <div class="flex items-center gap-3">
              <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-500 via-blue-500 to-violet-500 text-white shadow-lg shadow-indigo-500/25">
                <span class="text-lg font-black">R</span>
              </div>
              <div class="text-2xl font-black tracking-tight">Rentalio</div>
            </div>
            <p class="mt-4 max-w-sm text-sm leading-7 text-slate-500">
              Nền tảng SaaS multi-tenant dành cho chủ trọ, quản lý tòa nhà và đội vận hành RentOps.
            </p>
          </div>

          <div v-for="column in footerColumns" :key="column.title">
            <h3 class="text-sm font-bold text-slate-900">{{ column.title }}</h3>
            <ul class="mt-4 space-y-3 text-sm text-slate-500">
              <li v-for="item in column.items" :key="item">{{ item }}</li>
            </ul>
          </div>
        </div>

        <div class="mt-10 border-t border-slate-200 pt-6 text-center text-sm text-slate-500">
          © 2026 RentOps. Tất cả quyền được bảo lưu.
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'

const router = useRouter()

const goToRoomDetail = (room) => {
  router.push(`/room-detail/${room.id || 101}`)
}

const navItems = ['Trang chủ', 'Tìm phòng', 'Khu vực', 'Loại phòng', 'Tiện ích', 'Blog', 'Về chúng tôi']

const heroImage = '/images/rooms/main.png'
const floorPlanImage = '/images/rooms/kitchen.png'
const ctaImage = '/images/bedroom.png'
const collageImages = ['/images/rooms/main.png', '/images/rooms/living.png', '/images/rooms/kitchen.png', '/images/rooms/bathroom.png']
const dashboardStats = ref({
  total_rooms: 0,
  occupied_rooms: 0,
  vacant_rooms: 0,
  occupancy_rate: 0,
  pending_maintenance_count: 0
})

const topFeatures = [
  { icon: '⌂', title: 'Dữ liệu phòng', desc: 'Đồng bộ từ dashboard' },
  { icon: '✓', title: 'Hợp đồng', desc: 'Quản lý vòng đời thuê' },
  { icon: '✦', title: 'Hóa đơn VietQR', desc: 'Thu tiền nhanh gọn' },
  { icon: '◔', title: 'Bảo trì', desc: 'Nhắc việc và xử lý sự cố' }
]

const miniBannerStats = [
  { icon: '⌂', value: '0', label: 'phòng' },
  { icon: '★', value: '0', label: 'hợp đồng' },
  { icon: '⚑', value: '0', label: 'sự cố' }
]

const searchFields = [
  { label: 'Tìm kiếm', placeholder: 'Nhập khu vực, tên đường...' },
  { label: 'Loại phòng', placeholder: 'Tất cả loại phòng' },
  { label: 'Khoảng giá', placeholder: '0đ - Không giới hạn' },
  { label: 'Tiện ích', placeholder: 'Chọn tiện ích' }
]

const categories = [
  { title: 'Phòng trọ', price: 'Quản lý theo phòng', image: '/images/rooms/living.png', icon: '⌂' },
  { title: 'Tòa nhà', price: 'Nhiều tầng, nhiều phòng', image: '/images/rooms/main.png', icon: '▣' },
  { title: 'Căn hộ dịch vụ', price: 'Theo hợp đồng tháng', image: '/images/rooms/kitchen.png', icon: '◫' },
  { title: 'Homestay', price: 'Theo đêm / theo kỳ', image: '/images/rooms/bathroom.png', icon: '⌾' },
  { title: 'Tiện ích', price: 'Điện nước, bảo trì', image: '/images/rooms/living.png', icon: '☰' }
]

const featuredRooms = [
  { id: 101, title: 'Tòa A - Nam Từ Liêm', location: '6 phòng, 4 phòng đang ở', price: 'Từ 3.5 triệu/tháng', image: '/images/rooms/main.png', tags: ['Multi-tenant', 'Hợp đồng', 'VietQR'], rating: '4.8', reviews: 120, badge: 'Đang hoạt động' },
  { id: 102, title: 'Tòa B - Cầu Giấy', location: '8 phòng, 2 phòng trống', price: 'Từ 4.2 triệu/tháng', image: '/images/rooms/living.png', tags: ['Bảo trì', 'Nhắc nợ', 'Kiểm kê'], rating: '4.9', reviews: 98 },
  { id: 401, title: 'Căn hộ dịch vụ C', location: '4 hợp đồng đang hiệu lực', price: 'Từ 6.5 triệu/tháng', image: '/images/bedroom.png', tags: ['Tiện ích', 'Điện nước', 'Cư dân'], rating: '4.8', reviews: 76, badge: 'VIP' },
  { id: 301, title: 'Homestay Đà Lạt', location: 'Quản lý theo ngày/đêm', price: 'Từ 600k/đêm', image: '/images/rooms/kitchen.png', tags: ['Tour 360', 'Đặt lịch', 'Khách thuê'], rating: '4.9', reviews: 56 }
]

const areas = [
  { name: 'Nam Từ Liêm', rooms: '6 phòng', image: '/images/rooms/main.png' },
  { name: 'Cầu Giấy', rooms: '8 phòng', image: '/images/rooms/living.png' },
  { name: 'Đống Đa', rooms: '4 phòng', image: '/images/rooms/kitchen.png' },
  { name: 'TP. Hồ Chí Minh', rooms: '12 phòng', image: '/images/rooms/bathroom.png' },
  { name: 'Đà Lạt', rooms: '3 phòng', image: '/images/bedroom.png' },
  { name: 'Dữ liệu mẫu', rooms: 'Demo', image: '/images/rooms/main.png' }
]

const benefits = [
  { icon: '⌕', title: 'Dữ liệu phòng', desc: 'Đồng bộ từ module Phòng Trọ và Khu Trọ.' },
  { icon: '⌂', title: 'Dữ liệu hợp đồng', desc: 'Theo dõi hợp đồng hoạt động và sắp hết hạn.' },
  { icon: '◌', title: 'Dữ liệu tài chính', desc: 'Gắn với hóa đơn, thu tiền và công nợ.' },
  { icon: '◩', title: 'Dữ liệu vận hành', desc: 'Sự cố bảo trì, nhắc nợ và nhật ký thao tác.' },
  { icon: '✦', title: 'Multi-tenant', desc: 'Phù hợp cho nhiều tòa nhà / chủ trọ trên cùng hệ thống.' }
]

const steps = [
  { num: '1', icon: '⌕', title: 'Kết nối dữ liệu', desc: 'Nhập phòng, tòa nhà và khách thuê vào một nguồn dữ liệu chung.' },
  { num: '2', icon: '✉', title: 'Quản lý vận hành', desc: 'Tạo hợp đồng, sinh hóa đơn VietQR và theo dõi bảo trì.' },
  { num: '3', icon: '⌂', title: 'Theo dõi tập trung', desc: 'Xem dashboard, cảnh báo và công nợ ngay trên hệ thống.' }
]

const reviews = [
  {
    name: 'Nguyễn Minh Anh',
    role: 'Sinh viên',
    avatar: '/images/rooms/main.png',
    comment: 'Mình quản lý được phòng, hợp đồng và hóa đơn trên cùng một hệ thống, đỡ phải thao tác rời rạc như trước.'
  },
  {
    name: 'Trần Hoàng Nam',
    role: 'Nhân viên văn phòng',
    avatar: '/images/rooms/living.png',
    comment: 'Dashboard RentOps giúp mình nhìn ngay được phòng trống, phòng đang ở và các hợp đồng sắp hết hạn.'
  },
  {
    name: 'Lê Thu Trang',
    role: 'Freelancer',
    avatar: '/images/rooms/kitchen.png',
    comment: 'Phần VietQR và nhắc nợ hóa đơn rất tiện. Đội vận hành của mình dùng hằng ngày.'
  }
]

const footerColumns = [
  { title: 'Về RentOps', items: ['Giới thiệu nền tảng', 'Kiến trúc multi-tenant', 'Quy trình vận hành', 'Tuyển dụng', 'Liên hệ'] },
  { title: 'Module chính', items: ['Phòng trọ', 'Khu trọ / Tòa nhà', 'Hợp đồng thuê', 'Hóa đơn & VietQR', 'Bảo trì'] },
  { title: 'Hỗ trợ', items: ['Trung tâm trợ giúp', 'Quy định sử dụng', 'Chính sách bảo mật', 'Điều khoản dịch vụ', 'Nhật ký thao tác'] },
  { title: 'Liên hệ', items: ['1900 1234', 'support@rentops.vn', '123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh'] }
]

const loadDashboardStats = async () => {
  try {
    const res = await api.get('/dashboard/summary')
    const counters = res?.counters || {}
    dashboardStats.value = {
      total_rooms: counters.total_rooms ?? 0,
      occupied_rooms: counters.occupied_rooms ?? 0,
      vacant_rooms: counters.vacant_rooms ?? 0,
      occupancy_rate: counters.occupancy_rate ?? 0,
      pending_maintenance_count: counters.pending_maintenance_count ?? 0
    }
    miniBannerStats.splice(
      0,
      miniBannerStats.length,
      { icon: '⌂', value: String(dashboardStats.value.total_rooms), label: 'phòng' },
      { icon: '★', value: String(counters.expiring_contracts_count ?? 0), label: 'hợp đồng sắp hết hạn' },
      { icon: '⚑', value: String(dashboardStats.value.pending_maintenance_count), label: 'sự cố chờ xử lý' }
    )
  } catch {
    // Keep the static fallback values when API is unavailable.
  }
}

onMounted(() => {
  loadDashboardStats()
})
</script>