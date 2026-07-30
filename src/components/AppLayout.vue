<template>
  <div class="app-shell" :class="{ 'app-shell--menu-open': sidebarOpen }">
    <ToastContainer />

    <button v-if="sidebarOpen" class="app-overlay" type="button" aria-label="Đóng menu" @click="sidebarOpen = false"></button>

    <aside class="app-sidebar">
      <div class="app-sidebar-top">
        <button class="app-brand" type="button" @click="$router.push('/')">
          <span class="app-brand-mark">R</span>
          <span class="app-brand-copy">
            <strong>RentOps</strong>
            <small>PROPERTY OPERATIONS</small>
          </span>
        </button>

        <button class="app-sidebar-close" type="button" aria-label="Đóng menu" @click="sidebarOpen = false">×</button>

        <button class="app-profile" type="button" @click="$router.push('/settings')">
          <img :src="profileImage" alt="Ảnh đại diện" />
          <span>
            <strong>{{ profileName }}</strong>
            <small>{{ roleLabel }}</small>
            <em>{{ propertyLabel }}</em>
          </span>
        </button>
      </div>

      <nav class="app-nav" aria-label="Điều hướng chính">
        <RouterLink
          v-for="item in navItems"
          :key="`${item.path}-${item.name}`"
          :to="item.path"
          class="app-nav-link"
          :class="{ active: route.path === item.path }"
          @click="sidebarOpen = false"
        >
          <span class="app-nav-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" v-html="iconSvg(item.icon)"></svg></span>
          <span class="app-nav-label">{{ item.name }}</span>
          <span v-if="item.badge" class="app-nav-badge">{{ item.badge }}</span>
        </RouterLink>
      </nav>

      <div class="app-sidebar-bottom">
        <div class="app-upgrade-card">
          <strong>Nâng cấp gói dịch vụ</strong>
          <p>Mở rộng tính năng và tăng hiệu quả quản lý doanh nghiệp</p>
          <button type="button" @click="$router.push('/settings')">Nâng cấp ngay</button>
          <span class="app-upgrade-sparkle">◇</span>
        </div>
        <button class="app-logout" type="button" @click="logout">
          <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M10 4H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h5M14 8l4 4-4 4M9 12h9" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
          Đăng xuất
        </button>
        <small class="app-copyright">© 2024 RentOps</small>
      </div>
    </aside>

    <div class="app-main">
      <header class="app-header">
        <div class="app-header-inner">
          <div class="app-header-title">
            <button class="app-menu-button" type="button" aria-label="Mở menu" @click="sidebarOpen = true">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" /></svg>
            </button>
            <div>
              <strong>{{ currentRouteName }}</strong>
              <span>{{ subtitle }}</span>
            </div>
          </div>

          <div class="app-header-actions">
            <button class="app-header-action app-notification" type="button" aria-label="Thông báo" @click="$router.push('/notifications')">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9ZM10 21h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
              <span v-if="unreadCount > 0">{{ unreadCount }}</span>
            </button>
            <button v-if="isRenter" class="app-header-action" type="button" aria-label="Tin nhắn" @click="$router.push('/tenant-portal')">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M5 6.5A3.5 3.5 0 0 1 8.5 3h7A3.5 3.5 0 0 1 19 6.5v5a3.5 3.5 0 0 1-3.5 3.5H12l-4 3v-3.5A3.5 3.5 0 0 1 5 11.5v-5Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" /><path d="M9 8.5h6M9 11h3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" /></svg>
            </button>
            <button class="app-property-switcher" type="button" @click="$router.push('/settings')">
              <img :src="propertyImage" alt="Ảnh bất động sản" />
              <span>
                <strong>{{ propertyLabel }}</strong>
                <small>{{ roleLabel }}</small>
              </span>
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="m7 10 5 5 5-5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
            </button>
          </div>
        </div>
      </header>

      <main class="app-content">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import ToastContainer from './ToastContainer.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const dataStore = useDataStore()
const sidebarOpen = ref(false)

const unreadCount = computed(() => dataStore.unreadNotificationsCount)

const isSuperAdmin = computed(() => authStore.currentUser?.role === 'super_admin' || authStore.currentUser?.email?.toLowerCase().includes('superadmin'))
const isRenter = computed(() => authStore.currentUser?.role === 'renter')

const landlordNavItems = [
  { name: 'Tổng quan', path: '/', icon: 'dashboard' },
  { name: 'Bất động sản', path: '/properties', icon: 'building' },
  { name: 'Trợ lý AI', path: '/ai-advisor', icon: 'sparkle', badge: 'AI' },
  { name: 'Hợp đồng', path: '/contracts', icon: 'booking' },
  { name: 'Phòng cho thuê', path: '/rooms', icon: 'calendar' },
  { name: 'Khách thuê', path: '/renters', icon: 'users' },
  { name: 'Bảo trì & Sự cố', path: '/maintenance', icon: 'heart', badge: computed(() => dataStore.pendingMaintenanceCount ? `${dataStore.pendingMaintenanceCount}` : null) },
  { name: 'Hóa đơn & Thanh toán', path: '/bills', icon: 'document' },
  { name: 'Báo cáo doanh thu', path: '/reports', icon: 'chart' },
  { name: 'Chi phí', path: '/expenses', icon: 'wallet' },
  { name: 'Chỉ số điện nước', path: '/utility-readings', icon: 'bolt' },
  { name: 'Dịch vụ & Tiện ích', path: '/services', icon: 'light' },
  { name: 'Tiện ích phòng', path: '/amenities', icon: 'sofa' },
  { name: 'Tài sản', path: '/assets', icon: 'box' },
  { name: 'Thông báo', path: '/notifications', icon: 'bell', badge: computed(() => unreadCount.value ? `${unreadCount.value}` : null) },
  { name: 'Cài đặt', path: '/settings', icon: 'settings' },
  { name: 'Nhật ký thao tác', path: '/audit-logs', icon: 'history' },
  { name: 'Thùng rác', path: '/trash', icon: 'trash', badge: computed(() => dataStore.trash.length ? `${dataStore.trash.length}` : null) }
]

const renterNavItems = [
  { name: 'Cổng cư dân', path: '/tenant-portal', icon: 'phone', badge: 'Me' },
  { name: 'Khám phá phòng', path: '/landing', icon: 'search' }
]

const superAdminNavItems = [
  { name: 'Quản trị SaaS', path: '/super-admin', icon: 'crown' },
  { name: 'Nhật ký hệ thống', path: '/audit-logs', icon: 'history' }
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
const profileName = computed(() => authStore.currentUser?.full_name || 'Nguyễn Văn Minh')
const propertyLabel = computed(() => dataStore.properties[0]?.name || authStore.currentTenant?.name || 'Minh House')
const propertyImage = '/images/rooms/living.png'
const profileImage = '/images/rooms/main.png'
const currentRouteName = computed(() => navItems.value.find((item) => item.path === route.path)?.name || 'Tổng quan')
const subtitle = computed(() => `${dataStore.settings.companyName || 'RentOps'} - Quản lý bất động sản`)

const navIconPaths = {
  dashboard: '<path d="m4 10 8-6 8 6v9a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-9Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M9 20v-6h6v6" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  building: '<path d="M4 20V5a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v15M2 20h20M8 7h2m2 0h2M8 11h2m2 0h2M8 15h2m2 0h2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  sparkle: '<path d="m12 3 1.4 5.6L19 10l-5.6 1.4L12 17l-1.4-5.6L5 10l5.6-1.4L12 3Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="m19 16 .6 2.4L22 19l-2.4.6L19 22l-.6-2.4L16 19l2.4-.6L19 16Z" fill="currentColor"/>',
  booking: '<rect x="4" y="4" width="16" height="16" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M8 8h8M8 12h5M8 16h3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  calendar: '<rect x="4" y="5" width="16" height="15" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M8 3v4M16 3v4M4 10h16M8 14h.01M12 14h.01M16 14h.01M8 17h.01M12 17h.01" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  users: '<path d="M16 20v-1.5a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4V20M9.5 10.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7ZM17 3.8a3.5 3.5 0 0 1 0 6.8M21 20v-1.5a4 4 0 0 0-3-3.9" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  heart: '<path d="M20.8 8.8c0 5.2-8.8 10-8.8 10s-8.8-4.8-8.8-10A4.8 4.8 0 0 1 8 4c1.5 0 3 .7 4 1.9A5 5 0 0 1 16 4a4.8 4.8 0 0 1 4.8 4.8Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  chart: '<path d="M4 19V5m0 14h16" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/><path d="m7 15 3.2-3.5 2.7 2.2L19 7" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  wallet: '<path d="M4 6.5A2.5 2.5 0 0 1 6.5 4H19v16H6.5A2.5 2.5 0 0 1 4 17.5v-11Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M4 7h15M16 13h3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  bolt: '<path d="m13 2-9 12h7l-1 8 9-12h-7l1-8Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  light: '<path d="M9 18h6M10 21h4M8.5 14.5a6 6 0 1 1 7 0c-.8.6-1.5 1.4-1.5 2.5h-5c0-1.1-.7-1.9-1.5-2.5Z" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  sofa: '<path d="M5 11V8a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3M4 17v-4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4M4 17h16v2H4v-2Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  box: '<path d="m4 7 8-4 8 4-8 4-8-4Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M4 7v10l8 4 8-4V7M12 11v10" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  bell: '<path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9ZM10 21h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  message: '<path d="M5 6.5A3.5 3.5 0 0 1 8.5 3h7A3.5 3.5 0 0 1 19 6.5v5a3.5 3.5 0 0 1-3.5 3.5H12l-4 3v-3.5A3.5 3.5 0 0 1 5 11.5v-5Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  document: '<path d="M7 3h8l3 3v15H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M14 3v4h4M9 11h6M9 15h6" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  phone: '<rect x="6" y="3" width="12" height="18" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M10 18h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  settings: '<path d="M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8Z" stroke="currentColor" stroke-width="1.7"/><path d="m19 13 1.5 1.2-1.8 3.1-1.8-.7a7.7 7.7 0 0 1-1.8 1l-.3 1.9h-3.6l-.3-1.9a7.7 7.7 0 0 1-1.8-1l-1.8.7-1.8-3.1L7 13a7.2 7.2 0 0 1 0-2L5.5 9.8l1.8-3.1 1.8.7a7.7 7.7 0 0 1 1.8-1l.3-1.9h3.6l.3 1.9a7.7 7.7 0 0 1 1.8 1l1.8-.7 1.8 3.1L19 11a7.2 7.2 0 0 1 0 2Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>',
  history: '<path d="M4 12a8 8 0 1 0 2.3-5.7L4 8.5M4 4v4.5h4.5M12 8v4l2.5 1.5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  trash: '<path d="M5 7h14M10 11v5M14 11v5M9 7V4h6v3m-9 0 1 14h10l1-14" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  search: '<circle cx="10.8" cy="10.8" r="6.5" stroke="currentColor" stroke-width="1.7"/><path d="m16 16 4 4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  crown: '<path d="m4 7 4 4 4-6 4 6 4-4-2 11H6L4 7Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>'
}

const iconSvg = (icon) => navIconPaths[icon] || navIconPaths.dashboard

const logout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.app-shell {
  --app-ink: #18223d;
  --app-muted: #8993a8;
  --app-line: #e7ebf3;
  --app-purple: #5d48ef;
  position: relative;
  display: flex;
  min-height: 100vh;
  color: var(--app-ink);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background: #f7f8fc;
}

.app-sidebar {
  position: fixed;
  z-index: 50;
  inset: 0 auto 0 0;
  display: flex;
  flex-direction: column;
  width: 248px;
  border-right: 1px solid var(--app-line);
  background: #fff;
}

.app-sidebar-top {
  padding: 24px 20px 16px;
  border-bottom: 1px solid #f0f2f7;
}

.app-brand,
.app-profile,
.app-property-switcher,
.app-menu-button,
.app-header-action,
.app-sidebar-close,
.app-logout {
  border: 0;
  font: inherit;
  background: transparent;
  cursor: pointer;
}

.app-brand {
  display: flex;
  align-items: center;
  gap: 11px;
  padding: 0;
  text-align: left;
}

.app-brand-mark {
  display: grid;
  width: 40px;
  height: 40px;
  place-items: center;
  border-radius: 12px;
  color: #fff;
  font-family: Georgia, serif;
  font-size: 22px;
  font-weight: 700;
  background: linear-gradient(135deg, #765cff, #11a7d8);
  box-shadow: 0 8px 18px rgba(94, 76, 238, 0.2);
}

.app-brand-copy,
.app-profile span,
.app-property-switcher span {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.app-brand-copy strong {
  color: #17213d;
  font-family: Georgia, "Times New Roman", serif;
  font-size: 19px;
  letter-spacing: -0.02em;
  line-height: 1.1;
}

.app-brand-copy small {
  margin-top: 4px;
  color: var(--app-purple);
  font-size: 8px;
  font-weight: 800;
  letter-spacing: 0.16em;
}

.app-sidebar-close {
  display: none;
}

.app-profile {
  display: flex;
  align-items: center;
  gap: 11px;
  width: 100%;
  margin-top: 25px;
  padding: 0;
  text-align: left;
}

.app-profile img {
  width: 42px;
  height: 42px;
  flex: 0 0 auto;
  border: 2px solid #eef0f8;
  border-radius: 50%;
  object-fit: cover;
}

.app-profile strong {
  overflow: hidden;
  color: #26314d;
  font-size: 12px;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.app-profile small {
  width: fit-content;
  margin-top: 4px;
  padding: 3px 7px;
  border-radius: 5px;
  color: #5d48ef;
  font-size: 9px;
  font-weight: 700;
  background: #efedff;
}

.app-profile em {
  overflow: hidden;
  margin-top: 4px;
  color: #8c96a9;
  font-size: 9px;
  font-style: normal;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.app-nav {
  flex: 1;
  min-height: 0;
  padding: 16px 12px;
  overflow-y: auto;
}

.app-nav-link {
  display: flex;
  align-items: center;
  gap: 11px;
  min-height: 38px;
  margin-bottom: 3px;
  padding: 0 12px;
  border-radius: 9px;
  color: #67738b;
  font-size: 11px;
  font-weight: 650;
  text-decoration: none;
  transition: color 0.18s ease, background 0.18s ease, transform 0.18s ease;
}

.app-nav-link:hover {
  color: var(--app-purple);
  background: #f5f3ff;
}

.app-nav-link.active {
  color: #fff;
  background: linear-gradient(100deg, #4f3de6, #6d4df1);
  box-shadow: 0 9px 16px rgba(92, 70, 234, 0.18);
}

.app-nav-icon {
  display: inline-grid;
  width: 18px;
  height: 18px;
  flex: 0 0 auto;
  place-items: center;
}

.app-nav-icon svg {
  width: 17px;
  height: 17px;
}

.app-nav-label {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.app-nav-badge {
  margin-left: auto;
  padding: 3px 5px;
  border-radius: 4px;
  color: #765cff;
  font-size: 8px;
  font-weight: 800;
  background: #f0edff;
}

.app-nav-link.active .app-nav-badge {
  color: #fff;
  background: rgba(255, 255, 255, 0.2);
}

.app-sidebar-bottom {
  padding: 12px 16px 18px;
  border-top: 1px solid #f0f2f7;
  background: #fff;
}

.app-upgrade-card {
  position: relative;
  overflow: hidden;
  padding: 16px;
  border-radius: 15px;
  color: #fff;
  background: linear-gradient(135deg, #5542ea, #7454f4);
  box-shadow: 0 12px 22px rgba(91, 70, 230, 0.2);
}

.app-upgrade-card strong {
  display: block;
  font-size: 11px;
}

.app-upgrade-card p {
  max-width: 155px;
  margin: 6px 0 13px;
  color: rgba(255, 255, 255, 0.74);
  font-size: 9px;
  line-height: 1.5;
}

.app-upgrade-card button {
  padding: 8px 11px;
  border: 0;
  border-radius: 8px;
  color: #6148e7;
  font: inherit;
  font-size: 9px;
  font-weight: 800;
  background: #fff;
  cursor: pointer;
}

.app-upgrade-sparkle {
  position: absolute;
  right: 16px;
  bottom: 13px;
  color: rgba(255, 255, 255, 0.35);
  font-size: 42px;
  transform: rotate(25deg);
}

.app-logout {
  display: flex;
  align-items: center;
  gap: 9px;
  width: 100%;
  margin-top: 12px;
  padding: 10px 12px;
  border: 1px solid var(--app-line);
  border-radius: 9px;
  color: #66728a;
  font-size: 11px;
  font-weight: 700;
  text-align: left;
}

.app-logout:hover {
  color: #ef526e;
  background: #fff7f8;
}

.app-logout svg {
  width: 16px;
  height: 16px;
}

.app-copyright {
  display: block;
  margin-top: 14px;
  color: #a6afbd;
  font-size: 9px;
}

.app-main {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-width: 0;
  min-height: 100vh;
  margin-left: 248px;
}

.app-header {
  position: sticky;
  z-index: 20;
  top: 0;
  height: 76px;
  border-bottom: 1px solid var(--app-line);
  background: rgba(255, 255, 255, 0.93);
  backdrop-filter: blur(16px);
}

.app-header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  gap: 20px;
  padding: 0 34px;
}

.app-header-title,
.app-header-actions,
.app-property-switcher,
.app-menu-button,
.app-header-action {
  display: flex;
  align-items: center;
}

.app-header-title {
  gap: 18px;
}

.app-menu-button {
  display: none;
  width: 34px;
  height: 34px;
  place-items: center;
  border: 1px solid var(--app-line);
  border-radius: 8px;
  color: #77839a;
  background: #fff;
}

.app-menu-button svg {
  width: 17px;
  height: 17px;
}

.app-header-title strong,
.app-header-title span {
  display: block;
}

.app-header-title strong {
  color: #2b3550;
  font-size: 14px;
  font-weight: 800;
}

.app-header-title span {
  margin-top: 4px;
  color: #8993a8;
  font-size: 10px;
}

.app-header-actions {
  gap: 10px;
}

.app-header-action {
  position: relative;
  justify-content: center;
  width: 39px;
  height: 36px;
  border: 1px solid var(--app-line);
  border-radius: 10px;
  color: #6d7890;
  background: #fff;
}

.app-header-action:hover,
.app-property-switcher:hover {
  border-color: #cfc8ff;
  color: var(--app-purple);
}

.app-header-action svg {
  width: 17px;
  height: 17px;
}

.app-notification span {
  position: absolute;
  top: -6px;
  right: -5px;
  display: grid;
  width: 16px;
  height: 16px;
  place-items: center;
  border: 2px solid #fff;
  border-radius: 50%;
  color: #fff;
  font-size: 8px;
  font-weight: 800;
  background: #f45168;
}

.app-property-switcher {
  gap: 10px;
  min-width: 172px;
  margin-left: 8px;
  padding: 5px 10px 5px 6px;
  border: 1px solid var(--app-line);
  border-radius: 11px;
  text-align: left;
  background: #fff;
}

.app-property-switcher img {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  object-fit: cover;
}

.app-property-switcher strong {
  overflow: hidden;
  color: #27324d;
  font-size: 11px;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.app-property-switcher small {
  margin-top: 3px;
  color: #8b95a9;
  font-size: 9px;
}

.app-property-switcher > svg {
  width: 14px;
  height: 14px;
  margin-left: auto;
  color: #8792a7;
}

.app-content {
  flex: 1;
  min-width: 0;
  padding: 26px 34px 38px;
}

.app-overlay {
  position: fixed;
  z-index: 40;
  inset: 0;
  border: 0;
  background: rgba(17, 27, 53, 0.32);
}

@media (max-width: 900px) {
  .app-sidebar {
    transform: translateX(-100%);
    transition: transform 0.22s ease;
  }

  .app-shell--menu-open .app-sidebar {
    transform: translateX(0);
  }

  .app-sidebar-close,
  .app-menu-button {
    display: grid;
    place-items: center;
  }

  .app-sidebar-close {
    position: absolute;
    top: 23px;
    right: 18px;
    color: #96a0b2;
    font-size: 24px;
    line-height: 1;
  }

  .app-main {
    margin-left: 0;
  }

  .app-header-inner {
    padding: 0 22px;
  }

  .app-content {
    padding: 24px 22px 32px;
  }
}

@media (max-width: 560px) {
  .app-header {
    height: 68px;
  }

  .app-header-inner {
    gap: 10px;
    padding: 0 14px;
  }

  .app-header-actions {
    gap: 5px;
  }

  .app-property-switcher {
    min-width: 0;
    width: 38px;
    height: 36px;
    margin-left: 1px;
    padding: 2px;
  }

  .app-property-switcher span,
  .app-property-switcher > svg,
  .app-header-action:not(.app-notification) {
    display: none;
  }

  .app-property-switcher img {
    width: 30px;
    height: 30px;
  }

  .app-header-title span {
    display: none;
  }

  .app-content {
    padding: 20px 14px 28px;
  }
}
</style>
