<template>
  <div class="min-h-screen flex items-center justify-center px-4 bg-slate-950 text-white">
    <div class="w-full max-w-md rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl p-8 shadow-2xl">
      <div class="mb-8">
        <p class="text-sm uppercase tracking-[0.3em] text-indigo-300">RentOps</p>
        <h1 class="mt-3 text-3xl font-bold">Đăng nhập hệ thống</h1>
        <p class="mt-2 text-sm text-slate-300">
          Dùng tài khoản demo hoặc email bất kỳ để lấy token khởi tạo.
        </p>
      </div>

      <form class="space-y-4" @submit.prevent="handleLogin">
        <div>
          <label class="mb-2 block text-sm font-medium text-slate-200">Email</label>
          <input
            v-model="email"
            type="email"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none ring-0 placeholder:text-slate-500 focus:border-indigo-400"
            placeholder="admin@rentops.vn"
          />
        </div>

        <div>
          <label class="mb-2 block text-sm font-medium text-slate-200">Mật khẩu</label>
          <input
            v-model="password"
            type="password"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none ring-0 placeholder:text-slate-500 focus:border-indigo-400"
            placeholder="••••••••"
          />
        </div>

        <button
          type="submit"
          class="w-full rounded-xl bg-indigo-500 px-4 py-3 font-semibold text-white transition hover:bg-indigo-400 disabled:cursor-not-allowed disabled:opacity-70"
          :disabled="loading"
        >
          {{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
        </button>

        <button
          type="button"
          class="w-full rounded-xl border border-white/10 bg-white/5 px-4 py-3 font-semibold text-slate-100 transition hover:bg-white/10"
          @click="loginDemo"
          :disabled="loading"
        >
          Đăng nhập demo nhanh
        </button>

        <p v-if="error" class="rounded-xl bg-rose-500/10 px-4 py-3 text-sm text-rose-200">
          {{ error }}
        </p>
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
const error = ref('')

const loginDemo = async () => {
  loading.value = true
  error.value = ''

  try {
    const res = await api.post('/auth/login', {
      email: email.value,
      password: password.value
    })

    authStore.setAuthData({
      user: res.user,
      tenant: res.tenant,
      token: res.token
    })

    await router.push('/')
  } catch (err) {
    error.value = err?.message || 'Không thể đăng nhập vào hệ thống.'
  } finally {
    loading.value = false
  }
}

const handleLogin = loginDemo
</script>
