<template>
  <div class="min-h-screen flex items-center justify-center px-4 bg-slate-950 text-white font-sans relative overflow-hidden">
    <!-- Ambient Blur Background -->
    <div class="absolute -top-32 -left-32 w-96 h-96 bg-indigo-600/20 rounded-full blur-3xl"></div>
    <div class="absolute -bottom-32 -right-32 w-96 h-96 bg-emerald-600/20 rounded-full blur-3xl"></div>

    <div class="w-full max-w-md rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl p-8 shadow-2xl relative z-10">
      <div class="mb-6 text-center">
        <div class="inline-flex w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-500 to-blue-600 items-center justify-center text-white font-black text-2xl mb-3 shadow-lg shadow-indigo-500/30 cursor-pointer" @click="$router.push('/landing')">
          R
        </div>
        <p class="text-xs font-bold uppercase tracking-[0.3em] text-indigo-400">RentOps SaaS Platform</p>
        <h1 class="mt-2 text-2xl font-black text-white">
          {{ isRegister ? 'Đăng Ký Tài Khoản Mới' : 'Đăng Nhập Hệ Thống' }}
        </h1>
        <p class="mt-1 text-xs text-slate-400">
          {{ isRegister ? 'Tạo tài khoản quản lý trọ hoặc cư dân ngay' : 'Đăng nhập vào hệ thống quản lý bất động sản RentOps' }}
        </p>
      </div>

      <!-- Tab Switcher -->
      <div class="flex bg-slate-900/80 p-1 rounded-2xl border border-white/10 mb-6">
        <button
          type="button"
          @click="isRegister = false"
          :class="!isRegister ? 'bg-indigo-600 text-white font-bold shadow-md' : 'text-slate-400 hover:text-white font-semibold'"
          class="w-1/2 py-2 text-xs rounded-xl transition"
        >
          🔑 Đăng Nhập
        </button>
        <button
          type="button"
          @click="isRegister = true"
          :class="isRegister ? 'bg-indigo-600 text-white font-bold shadow-md' : 'text-slate-400 hover:text-white font-semibold'"
          class="w-1/2 py-2 text-xs rounded-xl transition"
        >
          📝 Đăng Ký Tài Khoản
        </button>
      </div>

      <!-- LOGIN FORM -->
      <form v-if="!isRegister" class="space-y-4" @submit.prevent="loginDemo">
        <div>
          <label class="mb-1.5 block text-xs font-semibold uppercase text-slate-300">Email tài khoản</label>
          <input
            v-model="email"
            type="email"
            required
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 text-sm"
            placeholder="admin@rentops.vn"
          />
        </div>

        <div>
          <label class="mb-1.5 block text-xs font-semibold uppercase text-slate-300">Mật khẩu</label>
          <input
            v-model="password"
            type="password"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 text-sm"
            placeholder="Nhập mật khẩu bất kỳ (hoặc để trống demo)"
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

      <!-- REGISTER FORM -->
      <form v-else class="space-y-3.5" @submit.prevent="registerAccount">
        <div>
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Bạn là:</label>
          <select v-model="registerForm.role" class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm">
            <option value="landlord">Chủ Trọ / Quản Lý Tòa Nhà</option>
            <option value="tenant">Khách Thuê (Cư dân)</option>
          </select>
        </div>

        <div>
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Họ và tên *</label>
          <input
            v-model="registerForm.full_name"
            type="text"
            required
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm"
            placeholder="vd: Nguyễn Văn Minh"
          />
        </div>

        <div>
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Email *</label>
          <input
            v-model="registerForm.email"
            type="email"
            required
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm"
            placeholder="minh@gmail.com"
          />
        </div>

        <div>
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Số điện thoại</label>
          <input
            v-model="registerForm.phone"
            type="text"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm font-mono"
            placeholder="0987 654 321"
          />
        </div>

        <div v-if="registerForm.role === 'landlord'">
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Tên Tòa Nhà / Dãy Trọ</label>
          <input
            v-model="registerForm.tenant_name"
            type="text"
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm"
            placeholder="vd: Căn Hộ Landmark Residence"
          />
        </div>

        <div>
          <label class="mb-1 block text-xs font-semibold uppercase text-slate-300">Mật khẩu *</label>
          <input
            v-model="registerForm.password"
            type="password"
            required
            class="w-full rounded-xl border border-white/10 bg-slate-900/80 px-4 py-2.5 text-white outline-none text-sm"
            placeholder="Nhập mật khẩu của bạn"
          />
        </div>

        <button
          type="submit"
          class="w-full rounded-xl bg-gradient-to-r from-emerald-500 to-teal-600 px-4 py-3 font-bold text-white transition hover:from-emerald-600 hover:to-teal-700 disabled:opacity-70 text-sm shadow-lg mt-2"
          :disabled="loading"
        >
          {{ loading ? 'Đang tạo tài khoản...' : '✓ Tạo Tài Khoản & Bắt Đầu Ngay' }}
        </button>
      </form>

      <!-- Back to Landing Link -->
      <div class="mt-6 text-center">
        <RouterLink to="/landing" class="text-xs text-slate-400 hover:text-indigo-300 transition">
          ← Quay lại Trang Chủ Khám Phá Phòng Trọ
        </RouterLink>
      </div>
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
const isRegister = ref(false)
const email = ref('admin@rentops.vn')
const password = ref('')
const loading = ref(false)

const registerForm = ref({
  role: 'landlord',
  full_name: '',
  email: '',
  phone: '',
  tenant_name: '',
  password: ''
})

const loginDemo = async () => {
  loading.value = true

  const inputEmail = email.value || 'admin@rentops.vn'
  const isSuperAdminEmail = inputEmail.toLowerCase().includes('superadmin')
  const isRenterEmail = inputEmail.toLowerCase().includes('renter') || inputEmail.toLowerCase().includes('khach')

  const defaultUser = {
    id: isSuperAdminEmail ? 999 : (isRenterEmail ? 102 : 1),
    email: inputEmail,
    full_name: isSuperAdminEmail ? 'Super Admin Hệ Thống' : (isRenterEmail ? 'Khách Thuê (Cư Dân)' : 'Quản trị viên RentOps'),
    role: isSuperAdminEmail ? 'super_admin' : (isRenterEmail ? 'renter' : 'owner')
  }

  const defaultTenant = isSuperAdminEmail ? null : {
    id: 1,
    name: 'Tòa Nhà Demo RentOps',
    subdomain: 'demo'
  }

  const defaultToken = 'rentops_demo_token_authenticated'

  try {
    const res = await api.post('/auth/login', {
      email: inputEmail,
      password: password.value
    })

    const payload = res?.data || res
    authStore.setAuthData({
      user: payload?.user || defaultUser,
      tenant: payload?.tenant || defaultTenant,
      token: payload?.token || defaultToken
    })
  } catch (err) {
    authStore.setAuthData({
      user: defaultUser,
      tenant: defaultTenant,
      token: defaultToken
    })
  } finally {
    loading.value = false
    const loggedUser = authStore.user
    if (loggedUser?.role === 'super_admin' || loggedUser?.email?.toLowerCase().includes('superadmin')) {
      await router.push('/super-admin')
    } else if (loggedUser?.role === 'renter') {
      await router.push('/tenant-portal')
    } else {
      await router.push('/')
    }
  }
}

const registerAccount = async () => {
  loading.value = true
  try {
    const res = await fetch('/api/v1/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(registerForm.value)
    })

    const json = await res.json()
    if (res.ok && json.success) {
      alert('Đăng ký tài khoản thành công!')
      authStore.setAuthData({
        user: json.data.user,
        tenant: json.data.tenant,
        token: json.data.token
      })
      if (registerForm.value.role === 'tenant') {
        router.push('/tenant-portal')
      } else {
        router.push('/')
      }
    } else {
      alert(json.message || 'Đăng ký không thành công')
    }
  } catch (err) {
    alert('Lỗi kết nối khi đăng ký tài khoản')
  } finally {
    loading.value = false
  }
}
</script>
