<template>
  <div class="min-h-screen bg-slate-950 flex flex-col md:flex-row font-sans text-slate-800 antialiased selection:bg-indigo-500 selection:text-white">
    <!-- Sidebar for Desktop -->
    <aside class="w-full md:w-64 bg-slate-950 text-slate-200 flex-shrink-0 flex flex-col justify-between shadow-2xl z-20 border-r border-slate-800/80">
      <div>
        <!-- Logo & App Header -->
        <div class="p-5 border-b border-slate-800/70 flex items-center justify-between bg-slate-900/50">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl gradient-brand flex items-center justify-center text-white font-black text-xl shadow-md">
              R
            </div>
            <div>
              <h1 class="font-black text-lg text-white tracking-wide leading-tight bg-gradient-to-r from-white via-slate-100 to-indigo-200 bg-clip-text text-transparent">RentOps</h1>
              <p class="text-[10px] text-indigo-400 font-bold tracking-widest uppercase">SaaS Quản Lý Phòng Trọ</p>
            </div>
          </div>
          <span class="flex h-2.5 w-2.5 relative">
            <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
          </span>
        </div>

        <!-- Tenant info banner -->
        <div class="px-4 py-3 mx-3 my-3 bg-slate-900/80 rounded-xl border border-slate-800/90 shadow-inner group">
          <div class="text-[10px] uppercase tracking-widest text-slate-400 font-bold flex items-center justify-between">
            <span class="flex items-center gap-1.5">
              <span class="w-1.5 h-1.5 rounded-full" :class="isSuperAdmin ? 'bg-amber-400' : (isRenter ? 'bg-emerald-400' : 'bg-indigo-400')"></span>
              {{ isSuperAdmin ? 'Hệ thống SaaS' : (isRenter ? 'Khách Thuê / Cư Dân' : 'Tòa nhà / Tenant') }}
            </span>
            <span class="text-[9px] px-1.5 py-0.5 rounded font-semibold border" :class="isSuperAdmin ? 'bg-amber-500/20 text-amber-300 border-amber-500/30' : (isRenter ? 'bg-emerald-500/20 text-emerald-300 border-emerald-500/30' : 'bg-indigo-500/20 text-indigo-300 border-indigo-500/30')">
              {{ isSuperAdmin ? 'SUPER ADMIN' : (isRenter ? 'CƯ DÂN' : 'CHỦ TRỌ') }}
            </span>
          </div>
          <div class="text-xs font-bold text-white truncate mt-1">
            {{ isSuperAdmin ? 'Platform Control Center' : (isRenter ? (authStore.currentUser?.full_name || 'Khách thuê trọ') : (authStore.currentTenant?.name || 'Tòa Nhà Demo RentOps')) }}
          </div>
        </div>

        <!-- Navigation items -->
        <nav class="px-3 space-y-1 max-h-[calc(100vh-220px)] overflow-y-auto pr-1">
          <RouterLink
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            :class="[
              'group relative flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold',
              route.path === item.path
                ? 'bg-indigo-600 text-white shadow-md font-bold'
                : 'text-slate-400 hover:bg-slate-900 hover:text-slate-100'
            ]"
          >
            <!-- Active Indicator Pill -->
            <div
              v-if="route.path === item.path"
              class="absolute left-0 top-2 bottom-2 w-1 bg-white rounded-r-full shadow-sm"
            ></div>
            
            <span class="text-base">{{ item.icon }}</span>
            <span class="truncate">{{ item.name }}</span>

            <span
              v-if="item.badge"
              class="ml-auto px-1.5 py-0.5 text-[10px] font-extrabold rounded-md bg-amber-500/20 text-amber-300 border border-amber-500/30"
            >
              {{ item.badge }}
            </span>
          </RouterLink>
        </nav>
      </div>

      <!-- User footer -->
      <div class="p-3.5 border-t border-slate-800/80 bg-slate-950 flex items-center justify-between">
        <div class="flex items-center gap-2.5 overflow-hidden">
          <div class="w-9 h-9 rounded-xl gradient-brand flex items-center justify-center text-white font-black text-sm border border-indigo-400/30 shadow-inner">
            {{ authStore.currentUser?.full_name?.charAt(0) || 'A' }}
          </div>
          <div class="overflow-hidden">
            <div class="text-xs font-bold text-slate-100 truncate leading-snug">{{ authStore.currentUser?.full_name || 'Quản trị viên' }}</div>
            <div class="text-[10px] text-slate-400 truncate">{{ authStore.currentUser?.email || 'superadmin@rentops.vn' }}</div>
          </div>
        </div>
        <button
          @click="logout"
          title="Đăng xuất"
          class="p-2 text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 border border-transparent rounded-xl"
        >
          🚪
        </button>
      </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 bg-slate-100 min-h-screen">
      <!-- Top header bar -->
      <header class="glass-header border-b border-slate-200/80 px-6 py-3.5 flex items-center justify-between sticky top-0 z-30 shadow-sm">
        <div class="flex items-center gap-3">
          <div class="w-9 h-9 rounded-xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xl font-bold shadow-xs">
            {{ currentNavIcon }}
          </div>
          <div>
            <h2 class="text-lg font-extrabold text-slate-900 tracking-tight leading-none">
              {{ currentRouteName }}
            </h2>
            <p class="text-[11px] text-slate-500 font-medium mt-1 flex items-center gap-1.5">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
              {{ isSuperAdmin ? 'RentOps SaaS Engine • Platform Administrator' : 'RentOps Workspace • Synchronized Real-time' }}
            </p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <!-- Global Search Preview / Shortcut Button -->
          <button
            @click="isPaletteOpen = true"
            class="hidden sm:flex items-center bg-slate-100 hover:bg-slate-200/80 border border-slate-200 rounded-xl px-3 py-1.5 text-xs text-slate-500 shadow-2xs transition cursor-pointer"
          >
            <span class="mr-2">🔍</span>
            <span class="font-medium">Tìm nhanh...</span>
            <kbd class="ml-3 px-1.5 py-0.5 text-[10px] font-mono bg-white border border-slate-200 rounded text-slate-500 font-semibold">Ctrl K</kbd>
          </button>

          <!-- Theme Mode Switcher -->
          <button
            @click="toggleTheme"
            class="p-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl border border-slate-200 transition text-sm"
            :title="isDark ? 'Chuyển sang giao diện Sáng' : 'Chuyển sang giao diện Tối'"
          >
            {{ isDark ? '🌙' : '☀️' }}
          </button>

          <!-- Multi-Tenant Status Badge -->
          <span
            class="inline-flex items-center px-3.5 py-1.5 rounded-xl text-xs font-extrabold shadow-2xs"
            :class="isSuperAdmin ? 'bg-amber-50 text-amber-800 border border-amber-200/90' : 'bg-emerald-50 text-emerald-700 border border-emerald-200/90'"
          >
            <span class="w-2 h-2 rounded-full mr-2" :class="isSuperAdmin ? 'bg-amber-500' : 'bg-emerald-500'"></span>
            {{ isSuperAdmin ? 'Super Admin Mode' : 'Multi-Tenant Active' }}
          </span>
        </div>
      </header>

      <!-- Main View Slot -->
      <main class="flex-1 p-4 md:p-6 lg:p-8 overflow-y-auto max-w-7xl mx-auto w-full">
        <slot />
      </main>
    </div>

    <!-- Toast Notifications Container -->
    <ToastContainer />

    <!-- Command Palette (Ctrl + K) -->
    <CommandPalette
      :is-open="isPaletteOpen"
      @close="isPaletteOpen = false"
      @open="isPaletteOpen = true"
    />
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import ToastContainer from './ToastContainer.vue'
import CommandPalette from './CommandPalette.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const isPaletteOpen = ref(false)
const isDark = ref(localStorage.getItem('rentops_theme') === 'dark')

const toggleTheme = () => {
  isDark.value = !isDark.value
  const theme = isDark.value ? 'dark' : 'light'
  localStorage.setItem('rentops_theme', theme)
  if (isDark.value) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

onMounted(() => {
  if (isDark.value) {
    document.documentElement.classList.add('dark')
  }
})

const isSuperAdmin = computed(() => {
  const u = authStore.currentUser
  return u?.role === 'super_admin' || u?.email?.toLowerCase().includes('superadmin')
})

const isRenter = computed(() => {
  const u = authStore.currentUser
  return u?.role === 'renter'
})

const landlordNavItems = [
  { name: 'Sơ đồ phòng', path: '/', icon: '🏢' },
  { name: 'Trợ lý AI & Phân tích', path: '/ai-advisor', icon: '🤖', badge: 'AI' },
  { name: 'Phòng trọ', path: '/rooms', icon: '🔑' },
  { name: 'Khu trọ / Tòa nhà', path: '/properties', icon: '🏛️' },
  { name: 'Khách thuê (Cư dân)', path: '/renters', icon: '👥' },
  { name: 'Hợp đồng thuê', path: '/contracts', icon: '📄' },
  { name: 'Chỉ số Điện Nước', path: '/utility-readings', icon: '⚡' },
  { name: 'Bảng giá dịch vụ', path: '/services', icon: '💡' },
  { name: 'Hóa đơn & VietQR', path: '/bills', icon: '💳' },
  { name: 'Nhắc nợ ZNS / SMS', path: '/notifications', icon: '📩' },
  { name: 'Sự cố & Bảo trì', path: '/maintenance', icon: '🔧' },
  { name: 'Tiện ích phòng', path: '/amenities', icon: '🛋️' },
  { name: 'Quản lý Tài sản', path: '/assets', icon: '📦' },
  { name: 'Cổng Khách Thuê', path: '/tenant-portal', icon: '📱' },
  { name: 'Chi phí vận hành', path: '/expenses', icon: '📊' },
  { name: 'Báo cáo tài chính', path: '/reports', icon: '📈' },
  { name: 'Cấu hình VietQR', path: '/settings', icon: '⚙️' },
  { name: 'Khôi phục Dữ liệu', path: '/trash', icon: '♻️' },
  { name: 'Nhật ký thao tác', path: '/audit-logs', icon: '📜' }
]

const renterNavItems = [
  { name: 'Cổng Khách Thuê & Hóa Đơn', path: '/tenant-portal', icon: '📱', badge: 'Me' },
  { name: 'Khám Phá & Tìm Phòng Trọ', path: '/landing', icon: '🔍' }
]

const superAdminNavItems = [
  { name: 'Quản trị SaaS (MRR)', path: '/super-admin', icon: '👑', badge: 'System' },
  { name: 'Nhật ký hệ thống', path: '/audit-logs', icon: '📜' },
  { name: 'Thùng rác hệ thống', path: '/trash', icon: '♻️' }
]

const navItems = computed(() => {
  if (isSuperAdmin.value) return superAdminNavItems
  if (isRenter.value) return renterNavItems
  return landlordNavItems
})

const currentRouteName = computed(() => {
  const item = navItems.value.find((i) => i.path === route.path)
  return item ? item.name : 'RentOps Console'
})

const currentNavIcon = computed(() => {
  const item = navItems.value.find((i) => i.path === route.path)
  return item ? item.icon : '⚡'
})

const logout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

