<template>
  <div class="min-h-screen flex items-center justify-center px-4 bg-slate-950 text-white font-sans">
    <div class="w-full max-w-md rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl p-8 shadow-2xl">
      <div class="mb-8 text-center">
        <div class="inline-flex w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-500 to-blue-600 items-center justify-center text-white font-black text-2xl mb-3 shadow-lg shadow-indigo-500/30">
          R
        </div>
        <p class="text-xs font-bold uppercase tracking-[0.3em] text-indigo-400">RentOps SaaS Platform</p>
        <h1 class="mt-2 text-2xl font-black text-white">Đăng nhập hệ thống</h1>
        <p class="mt-1 text-xs text-slate-400">
          Dùng tài khoản bất kỳ hoặc bấm nút bên dưới để vào hệ thống demo.
        </p>
      </div>

      <form class="space-y-4" @submit.prevent="loginDemo">
        <div>
          <label class="mb-1.5 block text-xs font-semibold uppercase text-slate-300">Email tài khoản</label>
          <input
            v-model="email"
            type="email"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 text-sm"
            placeholder="admin@rentops.vn"
          />
        </div>

        <div>
          <label class="mb-1.5 block text-xs font-semibold uppercase text-slate-300">Mật khẩu (Bất kỳ)</label>
          <input
            v-model="password"
            type="password"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 text-sm"
            placeholder="Nhập mật khẩu bất kỳ (hoặc để trống)"
          />
        </div>

        <button
          type="submit"
          class="w-full rounded-xl bg-indigo-600 px-4 py-3 font-bold text-white transition hover:bg-indigo-500 disabled:cursor-not-allowed disabled:opacity-70 text-sm shadow-lg shadow-indigo-600/30"
          :disabled="loading"
        >
          {{ loading ? 'Đang xác thực...' : 'Đăng nhập vào RentOps' }}
        </button>

        <button
          type="button"
          class="w-full rounded-xl border border-white/10 bg-white/10 px-4 py-3 font-bold text-slate-200 transition hover:bg-white/20 text-sm"
          @click="loginDemo"
          :disabled="loading"
        >
          🚀 Vào nhanh Demo (Không cần mật khẩu)
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

const router = useRouter()
const authStore = useAuthStore()
const email = ref('admin@rentops.vn')
const password = ref('')
const loading = ref(false)

const loginDemo = async () => {
  loading.value = true

  const defaultUser = {
    id: 1,
    email: email.value || 'admin@rentops.vn',
    full_name: 'Quản trị viên RentOps'
  }

  const defaultTenant = {
    id: 1,
    name: 'Tòa Nhà Demo RentOps',
    subdomain: 'demo'
  }

  const defaultToken = 'rentops_demo_token_authenticated'

  try {
    const res = await api.post('/auth/login', {
      email: email.value || 'admin@rentops.vn',
      password: password.value
    })

    const payload = res?.data || res
    authStore.setAuthData({
      user: payload?.user || defaultUser,
      tenant: payload?.tenant || defaultTenant,
      token: payload?.token || defaultToken
    })
  } catch (err) {
    console.warn('Backend API connection failed, logging in via client demo mode.', err)
    authStore.setAuthData({
      user: defaultUser,
      tenant: defaultTenant,
      token: defaultToken
    })
  } finally {
    loading.value = false
    await router.push('/')
  }
}
</script>
