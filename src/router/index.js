import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import DashboardGrid from '../views/DashboardGrid.vue'
import RoomsView from '../views/RoomsView.vue'
import PropertiesView from '../views/PropertiesView.vue'
import ContractsView from '../views/ContractsView.vue'
import BillsView from '../views/BillsView.vue'
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
    path: '/contracts',
    name: 'Contracts',
    component: ContractsView
  },
  {
    path: '/bills',
    name: 'Bills',
    component: BillsView
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
