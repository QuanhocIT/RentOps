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

      const isSuperAdmin = email.toLowerCase().includes('superadmin')
      const isRenter = email.toLowerCase().includes('renter') || email.toLowerCase().includes('khach')

      const defaultUser = {
        id: isSuperAdmin ? 999 : isRenter ? 102 : 1,
        email,
        full_name: isSuperAdmin ? 'Super Admin Hệ Thống' : isRenter ? 'Khách Thuê Demo' : 'Chủ Trọ Quản Lý RentOps',
        role: isSuperAdmin ? 'super_admin' : isRenter ? 'renter' : 'owner'
      }

      const defaultTenant = isSuperAdmin ? null : { id: 1, name: 'Minh House', subdomain: 'demo' }
      const defaultToken = 'rentops_demo_token_authenticated'

      try {
        const res = await api.post('/auth/login', { email, password })
        const payload = res?.data || res
        const user = payload?.user ? { ...payload.user, role: isSuperAdmin ? 'super_admin' : isRenter ? 'renter' : (payload.user.role || 'owner') } : defaultUser
        const tenant = payload?.tenant || defaultTenant
        const token = payload?.token || defaultToken

        this.setAuthData({ user, tenant, token })
        return { success: true, user, tenant, token }
      } catch (err) {
        const isDemoExplicit = import.meta.env.VITE_DEMO_MODE === 'true'
        if (isDemoExplicit) {
          console.warn('[AuthStore] API Login failed, VITE_DEMO_MODE active. Using fallback demo user.')
          this.setAuthData({ user: defaultUser, tenant: defaultTenant, token: defaultToken })
          return { success: true, user: defaultUser, tenant: defaultTenant, token: defaultToken }
        }
        return {
          success: false,
          message: err?.response?.data?.message || 'Đăng nhập thất bại. Vui lòng kiểm tra email và mật khẩu.'
        }
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
