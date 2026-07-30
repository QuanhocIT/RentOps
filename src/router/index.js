import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

// Code-Splitting & Lazy Loading Routes
const LandingView = () => import('../views/LandingView.vue')
const AboutView = () => import('../views/AboutView.vue')
const RoomDetailView = () => import('../views/RoomDetailView.vue')
const LoginView = () => import('../views/LoginView.vue')
const DashboardGrid = () => import('../views/DashboardGrid.vue')
const RoomsView = () => import('../views/RoomsView.vue')
const PropertiesView = () => import('../views/PropertiesView.vue')
const ContractsView = () => import('../views/ContractsView.vue')
const BillsView = () => import('../views/BillsView.vue')
const UtilityReadingsView = () => import('../views/UtilityReadingsView.vue')
const ServicesView = () => import('../views/ServicesView.vue')
const ExpensesView = () => import('../views/ExpensesView.vue')
const RentersView = () => import('../views/RentersView.vue')
const ReportsView = () => import('../views/ReportsView.vue')
const MaintenanceView = () => import('../views/MaintenanceView.vue')
const AmenitiesView = () => import('../views/AmenitiesView.vue')
const AuditLogsView = () => import('../views/AuditLogsView.vue')
const SettingsView = () => import('../views/SettingsView.vue')
const NotificationsView = () => import('../views/NotificationsView.vue')
const AssetsView = () => import('../views/AssetsView.vue')
const TenantPortalView = () => import('../views/TenantPortalView.vue')
const SuperAdminView = () => import('../views/SuperAdminView.vue')
const TrashView = () => import('../views/TrashView.vue')
const AiAdvisorView = () => import('../views/AiAdvisorView.vue')

const routes = [
  {
    path: '/landing',
    name: 'Landing',
    component: LandingView,
    meta: { public: true }
  },
  {
    path: '/about',
    name: 'About',
    component: AboutView,
    meta: { public: true }
  },
  {
    path: '/room-detail/:id',
    name: 'RoomDetail',
    component: RoomDetailView,
    meta: { public: true }
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
    meta: { public: true }
  },
  {
    path: '/',
    name: 'Dashboard',
    component: DashboardGrid
  },
  {
    path: '/ai-advisor',
    name: 'AiAdvisor',
    component: AiAdvisorView
  },
  {
    path: '/rooms',
    name: 'Rooms',
    component: RoomsView
  },
  {
    path: '/properties',
    name: 'Properties',
    component: PropertiesView
  },
  {
    path: '/renters',
    name: 'Renters',
    component: RentersView
  },
  {
    path: '/contracts',
    name: 'Contracts',
    component: ContractsView
  },
  {
    path: '/utility-readings',
    name: 'UtilityReadings',
    component: UtilityReadingsView
  },
  {
    path: '/services',
    name: 'Services',
    component: ServicesView
  },
  {
    path: '/bills',
    name: 'Bills',
    component: BillsView
  },
  {
    path: '/notifications',
    name: 'Notifications',
    component: NotificationsView
  },
  {
    path: '/maintenance',
    name: 'Maintenance',
    component: MaintenanceView
  },
  {
    path: '/amenities',
    name: 'Amenities',
    component: AmenitiesView
  },
  {
    path: '/assets',
    name: 'Assets',
    component: AssetsView
  },
  {
    path: '/tenant-portal',
    name: 'TenantPortal',
    component: TenantPortalView
  },
  {
    path: '/super-admin',
    name: 'SuperAdmin',
    component: SuperAdminView
  },
  {
    path: '/trash',
    name: 'Trash',
    component: TrashView
  },
  {
    path: '/expenses',
    name: 'Expenses',
    component: ExpensesView
  },
  {
    path: '/reports',
    name: 'Reports',
    component: ReportsView
  },
  {
    path: '/settings',
    name: 'Settings',
    component: SettingsView
  },
  {
    path: '/audit-logs',
    name: 'AuditLogs',
    component: AuditLogsView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (to.hash) {
      return { el: to.hash, behavior: 'smooth' }
    }
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0, left: 0, behavior: 'instant' }
  }
})

router.beforeEach((to) => {
  const authStore = useAuthStore()
  const isPublic = to.meta?.public || to.name === 'Login' || to.name === 'Landing'

  if (!isPublic && !authStore.isAuthenticated) {
    return { name: 'Landing' }
  }

  const isSuperAdminUser = authStore.currentUser?.role === 'super_admin' || authStore.currentUser?.email?.toLowerCase().includes('superadmin')
  const isRenterUser = authStore.currentUser?.role === 'renter'

  if (authStore.isAuthenticated && to.name === 'TenantPortal' && !isRenterUser) {
    return { name: 'Dashboard' }
  }

  if (authStore.isAuthenticated) {
    if (isSuperAdminUser && to.path === '/') {
      return { name: 'SuperAdmin' }
    }
    if (isRenterUser && to.name !== 'TenantPortal' && !to.meta?.public) {
      return { name: 'TenantPortal' }
    }
  }

  if ((to.name === 'Login' || to.name === 'Landing') && authStore.isAuthenticated) {
    if (isSuperAdminUser) {
      return { name: 'SuperAdmin' }
    } else if (isRenterUser) {
      return { name: 'TenantPortal' }
    }
    return { name: 'Dashboard' }
  }
})

export default router
