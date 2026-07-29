import { defineStore } from 'pinia'

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
