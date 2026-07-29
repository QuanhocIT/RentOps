<template>
  <div class="min-h-screen bg-slate-100 flex flex-col md:flex-row font-sans text-slate-800">
    <!-- Sidebar for Desktop -->
    <aside class="w-full md:w-64 bg-slate-900 text-slate-200 flex-shrink-0 flex flex-col justify-between shadow-xl">
      <div>
        <!-- Logo & App Header -->
        <div class="p-5 border-b border-slate-800 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-blue-600 flex items-center justify-center text-white font-black text-xl shadow-lg shadow-indigo-500/30">
              R
            </div>
            <div>
              <h1 class="font-bold text-lg text-white tracking-wide leading-tight">RentOps</h1>
              <p class="text-xs text-indigo-400 font-medium">SaaS Quản Lý Phòng Trọ</p>
            </div>
          </div>
        </div>

        <!-- Tenant info banner -->
        <div class="px-4 py-3 mx-3 my-4 bg-slate-800/80 rounded-xl border border-slate-700/60">
          <div class="text-[11px] uppercase tracking-wider text-slate-400 font-semibold">Tòa nhà / Tenant</div>
          <div class="text-sm font-semibold text-white truncate mt-0.5">
            {{ authStore.currentTenant?.name || 'Tòa Nhà Demo RentOps' }}
          </div>
        </div>

        <!-- Navigation items -->
        <nav class="px-3 space-y-1">
          <RouterLink
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            :class="[
              'flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium transition-all duration-200',
              route.path === item.path
                ? 'bg-gradient-to-r from-indigo-600 to-blue-600 text-white shadow-md shadow-indigo-600/30'
                : 'text-slate-300 hover:bg-slate-800 hover:text-white'
            ]"
          >
            <span class="text-lg">{{ item.icon }}</span>
            <span>{{ item.name }}</span>
          </RouterLink>
        </nav>
      </div>

      <!-- User footer -->
      <div class="p-4 border-t border-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-3 overflow-hidden">
          <div class="w-9 h-9 rounded-full bg-indigo-500/20 text-indigo-300 flex items-center justify-center font-bold text-sm border border-indigo-500/30">
            {{ authStore.currentUser?.full_name?.charAt(0) || 'A' }}
          </div>
          <div class="overflow-hidden">
            <div class="text-xs font-semibold text-white truncate">{{ authStore.currentUser?.full_name || 'Quản trị viên' }}</div>
            <div class="text-[11px] text-slate-400 truncate">{{ authStore.currentUser?.email || 'admin@rentops.vn' }}</div>
          </div>
        </div>
        <button
          @click="logout"
          title="Đăng xuất"
          class="p-2 text-slate-400 hover:text-rose-400 hover:bg-slate-800 rounded-lg transition"
        >
          🚪
        </button>
      </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0">
      <!-- Top header bar -->
      <header class="bg-white border-b border-slate-200 px-6 py-4 flex items-center justify-between sticky top-0 z-10 shadow-sm">
        <div class="flex items-center gap-3">
          <h2 class="text-xl font-bold text-slate-900">
            {{ currentRouteName }}
          </h2>
        </div>

        <div class="flex items-center gap-4">
          <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse mr-1.5"></span>
            Hệ thống Multi-Tenant Active
          </span>
        </div>
      </header>

      <!-- Main view slot -->
      <main class="flex-1 p-4 md:p-8 overflow-y-auto">
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

const navItems = [
  { name: 'Sơ đồ phòng', path: '/', icon: '🏢' },
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
  { name: 'Chi phí vận hành', path: '/expenses', icon: '📊' },
  { name: 'Báo cáo tài chính', path: '/reports', icon: '📈' },
  { name: 'Cấu hình VietQR', path: '/settings', icon: '⚙️' },
  { name: 'Nhật ký thao tác', path: '/audit-logs', icon: '📜' }
]

const currentRouteName = computed(() => {
  const item = navItems.find((i) => i.path === route.path)
  return item ? item.name : 'RentOps Dashboard'
})

const logout = () => {
  authStore.logout()
  router.push('/login')
}
</script>
