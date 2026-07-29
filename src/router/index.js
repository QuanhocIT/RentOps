import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import DashboardGrid from '../views/DashboardGrid.vue'
import RoomsView from '../views/RoomsView.vue'
import PropertiesView from '../views/PropertiesView.vue'
import ContractsView from '../views/ContractsView.vue'
import BillsView from '../views/BillsView.vue'
import UtilityReadingsView from '../views/UtilityReadingsView.vue'
import ServicesView from '../views/ServicesView.vue'
import ExpensesView from '../views/ExpensesView.vue'
import RentersView from '../views/RentersView.vue'
import ReportsView from '../views/ReportsView.vue'
import MaintenanceView from '../views/MaintenanceView.vue'
import AmenitiesView from '../views/AmenitiesView.vue'
import AuditLogsView from '../views/AuditLogsView.vue'
import SettingsView from '../views/SettingsView.vue'
import NotificationsView from '../views/NotificationsView.vue'
import AssetsView from '../views/AssetsView.vue'
import TenantPortalView from '../views/TenantPortalView.vue'
import SuperAdminView from '../views/SuperAdminView.vue'
import TrashView from '../views/TrashView.vue'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginView
  },
  {
    path: '/',
    name: 'Dashboard',
    component: DashboardGrid
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
  routes
})

router.beforeEach((to) => {
  const authStore = useAuthStore()
  if (to.name !== 'Login' && !authStore.isAuthenticated) {
    return { name: 'Login' }
  }

  if (to.name === 'Login' && authStore.isAuthenticated) {
    return { name: 'Dashboard' }
  }
})

export default router
