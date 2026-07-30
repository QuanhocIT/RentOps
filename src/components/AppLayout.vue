<template>
  <div class="min-h-screen bg-[#f6f7fb] text-slate-900 overflow-hidden">
    <aside class="hidden lg:flex fixed inset-y-0 left-0 w-[300px] shrink-0 border-r border-slate-200 bg-white/95 backdrop-blur-xl flex-col z-40 overflow-hidden">
      <div class="shrink-0">
        <div class="p-5 border-b border-slate-100 flex items-center gap-3">
          <div class="w-11 h-11 rounded-2xl gradient-brand flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/20">R</div>
          <div>
            <div class="font-black text-xl tracking-tight text-slate-900">RentOps</div>
            <div class="text-[11px] font-bold uppercase tracking-[0.22em] text-indigo-600">SaaS Quản lý Phòng trọ</div>
          </div>
        </div>
      </div>

      <nav class="flex-1 min-h-0 px-3 py-4 space-y-1.5 overflow-y-auto">
          <RouterLink
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold transition"
            :class="route.path === item.path ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-500/20' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900'"
          >
            <span class="text-lg">{{ item.icon }}</span>
            <span class="truncate">{{ item.name }}</span>
            <span v-if="item.badge" class="ml-auto rounded-full bg-white/15 px-2 py-0.5 text-[10px] font-black uppercase tracking-wider">{{ item.badge }}</span>
          </RouterLink>
        </nav>

      <div class="shrink-0 p-4 border-t border-slate-200 space-y-4 bg-white/95">
        <div class="rounded-[1.5rem] bg-gradient-to-br from-[#4f46e5] to-[#6d5efc] p-4 text-white shadow-[0_18px_40px_rgba(79,70,229,0.28)]">
          <div class="text-sm font-black">Nâng cấp gói dịch vụ</div>
          <div class="mt-1 text-xs text-white/80">Mở rộng tính năng và tăng hiệu quả quản lý doanh nghiệp</div>
          <button class="mt-4 rounded-2xl bg-white px-4 py-2 text-sm font-semibold text-indigo-600 shadow-sm">Nâng cấp ngay</button>
        </div>
        <button
          class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-left text-sm font-semibold text-slate-700 shadow-sm hover:bg-slate-50"
          @click="logout"
        >
          Đăng xuất
        </button>
        <div class="text-xs text-slate-400">© 2024 Rentalio</div>
      </div>
    </aside>

    <div class="min-h-screen lg:pl-[300px] flex flex-col">
      <header class="fixed top-0 right-0 left-0 lg:left-[300px] z-30 border-b border-slate-200 bg-white/90 backdrop-blur-xl">
        <div class="flex items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
          <div class="flex items-center gap-3">
            <button class="lg:hidden flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-200 bg-white shadow-sm">☰</button>
            <div>
              <div class="text-lg font-black text-slate-900">{{ currentRouteName }}</div>
              <div class="text-xs text-slate-500">{{ subtitle }}</div>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <button class="hidden sm:flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm text-slate-500 shadow-sm">
              <span>🔔</span>
              <span class="relative inline-flex h-5 w-5 items-center justify-center rounded-full bg-rose-500 text-[10px] font-black text-white">3</span>
            </button>
            <button class="hidden sm:flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm text-slate-500 shadow-sm">
              <span>💬</span>
            </button>
            <div class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-3 py-2 shadow-sm">
              <img :src="propertyImage" alt="Property" class="h-10 w-10 rounded-xl object-cover" />
              <div class="min-w-0">
                <div class="truncate text-sm font-bold text-slate-900">{{ propertyLabel }}</div>
                <div class="text-[11px] text-slate-500">{{ roleLabel }}</div>
              </div>
              <span class="text-slate-400">⌄</span>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 px-4 pt-[88px] pb-5 sm:px-6 lg:px-8 overflow-y-auto overflow-x-hidden">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const isSuperAdmin = computed(() => authStore.currentUser?.role === 'super_admin' || authStore.currentUser?.email?.toLowerCase().includes('superadmin'))
const isRenter = computed(() => authStore.currentUser?.role === 'renter')

const landlordNavItems = [
  { name: 'Tổng quan', path: '/', icon: '⌂' },
  { name: 'Phòng & Bất động sản', path: '/properties', icon: '🏢' },
  { name: 'Trợ lý AI & Phân tích', path: '/ai-advisor', icon: '🤖', badge: 'AI' },
  { name: 'Đặt phòng', path: '/contracts', icon: '📄' },
  { name: 'Lịch', path: '/rooms', icon: '📅' },
  { name: 'Khách hàng', path: '/renters', icon: '👥' },
  { name: 'Đánh giá', path: '/maintenance', icon: '♡' },
  { name: 'Doanh thu', path: '/reports', icon: '📈' },
  { name: 'Chi phí', path: '/expenses', icon: '🪙' },
  { name: 'Chỉ số điện nước', path: '/utility-readings', icon: '⚡' },
  { name: 'Dịch vụ & Tiện ích', path: '/services', icon: '💡' },
  { name: 'Tiện ích phòng', path: '/amenities', icon: '🛋️' },
  { name: 'Tài sản', path: '/assets', icon: '📦' },
  { name: 'Thông báo', path: '/notifications', icon: '🔔' },
  { name: 'Tin nhắn', path: '/tenant-portal', icon: '💬' },
  { name: 'Báo cáo', path: '/bills', icon: '🧾' },
  { name: 'Cổng cư dân', path: '/tenant-portal', icon: '📱' },
  { name: 'Cài đặt', path: '/settings', icon: '⚙' },
  { name: 'Nhật ký thao tác', path: '/audit-logs', icon: '📝' },
  { name: 'Thùng rác', path: '/trash', icon: '♻️' }
]

const renterNavItems = [
  { name: 'Cổng cư dân', path: '/tenant-portal', icon: '📱', badge: 'Me' },
  { name: 'Khám phá phòng', path: '/landing', icon: '⌕' }
]

const superAdminNavItems = [
  { name: 'Quản trị SaaS', path: '/super-admin', icon: '👑' },
  { name: 'Nhật ký hệ thống', path: '/audit-logs', icon: '📝' }
]

const navItems = computed(() => {
  if (isSuperAdmin.value) return superAdminNavItems
  if (isRenter.value) return renterNavItems
  return landlordNavItems
})

const roleLabel = computed(() => {
  if (isSuperAdmin.value) return 'Super Admin'
  if (isRenter.value) return 'Khách thuê'
  return 'Chủ doanh nghiệp'
})
const propertyLabel = computed(() => authStore.currentTenant?.name || 'Minh House')
const propertyImage = '/images/rooms/living.png'
const currentRouteName = computed(() => navItems.value.find((i) => i.path === route.path)?.name || 'Tổng quan')
const subtitle = computed(() => 'Cập nhật tình hình kinh doanh hôm nay')

const logout = () => {
  authStore.logout()
  router.push('/login')
}
</script>
