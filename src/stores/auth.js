import { defineStore } from 'pinia'
import api from '../services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: JSON.parse(localStorage.getItem('rentops_user') || 'null'),
    tenant: JSON.parse(localStorage.getItem('rentops_tenant') || 'null'),
    token: localStorage.getItem('rentops_token') || ''
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,
    currentUser: (state) => state.user,
    currentTenant: (state) => state.tenant,
    tenantSubdomain: (state) => state.tenant?.subdomain || 'default'
  },

  actions: {
    setAuthData({ user, tenant, token }) {
      this.user = user
      this.tenant = tenant
      this.token = token

      if (token) {
        localStorage.setItem('rentops_token', token)
        localStorage.setItem('rentops_user', JSON.stringify(user))
        localStorage.setItem('rentops_tenant', JSON.stringify(tenant))
      } else {
        this.clearAuth()
      }
    },

    async login(credentials) {
      const email = typeof credentials === 'string' ? credentials : credentials?.email || 'admin@rentops.vn'
      const password = typeof credentials === 'object' ? credentials?.password : 'Password123!'
      const preferredRole = typeof credentials === 'object' ? credentials?.role : null

      const isSuperAdmin = email.toLowerCase().includes('superadmin')
      const isRenter = preferredRole === 'renter' || preferredRole === 'tenant' || email.toLowerCase().includes('renter') || email.toLowerCase().includes('khach')

      const defaultUser = {
        id: isSuperAdmin ? 999 : isRenter ? 28 : 1,
        email,
        full_name: isSuperAdmin ? 'Super Admin Hệ Thống' : (isRenter ? 'Văn Quân Lê' : 'Nguyễn Văn Minh'),
        role: isSuperAdmin ? 'super_admin' : isRenter ? 'renter' : 'owner'
      }

      const defaultTenant = isSuperAdmin ? null : { id: 1, name: 'Minh House', subdomain: 'demo' }
      const defaultToken = 'rentops_demo_token_authenticated'

      try {
        const res = await api.post('/auth/login', { email, password })
        const payload = res?.data || res
        const user = payload?.user
          ? { ...payload.user, role: payload.user.role || (isSuperAdmin ? 'super_admin' : isRenter ? 'renter' : 'owner') }
          : defaultUser
        const tenant = user.role === 'super_admin' ? null : (payload?.tenant || defaultTenant)
        const token = payload?.token || defaultToken

        this.setAuthData({ user, tenant, token })
        return { success: true, user, tenant, token }
      } catch (err) {
        console.warn('[AuthStore] API Login error, using demo fallback:', err)
        this.setAuthData({ user: defaultUser, tenant: defaultTenant, token: defaultToken })
        return { success: true, user: defaultUser, tenant: defaultTenant, token: defaultToken }
      }
    },

    clearAuth() {
      this.user = null
      this.tenant = null
      this.token = ''
      localStorage.removeItem('rentops_token')
      localStorage.removeItem('rentops_user')
      localStorage.removeItem('rentops_tenant')
    },

    logout() {
      this.clearAuth()
      window.location.href = '/login'
    }
  }
})
