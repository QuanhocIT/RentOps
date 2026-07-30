<template>
  <div class="min-h-screen bg-[#f6f7fb] text-slate-900">
    <div class="grid min-h-screen lg:grid-cols-2">
      <section class="relative overflow-hidden bg-slate-900 text-white">
        <img
          :src="isRegister ? registerHero : loginHero"
          alt="RentOps hero"
          class="absolute inset-0 h-full w-full object-cover"
        />
        <div class="absolute inset-0 bg-slate-950/55"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-slate-950/70 via-slate-950/35 to-transparent"></div>

        <div class="relative z-10 flex min-h-screen flex-col justify-between px-6 py-6 sm:px-10 lg:px-12">
          <button class="flex items-center gap-3 self-start" @click="$router.push('/landing')">
            <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-500 via-blue-500 to-violet-500 text-white shadow-lg shadow-indigo-500/25">
              <span class="text-lg font-black">R</span>
            </div>
            <div class="text-left">
              <div class="text-xl font-black tracking-tight text-white">RentOps</div>
            </div>
          </button>

          <div class="max-w-xl pb-10 pt-12 lg:pb-16">
            <div class="inline-flex rounded-full border border-white/15 bg-white/10 px-4 py-2 text-xs font-bold uppercase tracking-[0.22em] text-white/90 backdrop-blur">
              SaaS Multi-tenant cho chủ trọ
            </div>

            <h1 class="mt-6 max-w-lg text-4xl font-black leading-tight sm:text-5xl">
              {{ isRegister ? 'Đăng ký tài khoản để trải nghiệm ngay' : 'Chào mừng trở lại.' }}
            </h1>
            <p class="mt-4 max-w-lg text-base leading-8 text-white/75">
              {{ isRegister ? 'Quản lý phòng trọ, hợp đồng, hóa đơn VietQR và bảo trì trên cùng một nền tảng.' : 'Đăng nhập để tiếp tục theo dõi dữ liệu vận hành, công nợ và phòng trống.' }}
            </p>

            <div class="mt-8 space-y-4 max-w-md">
              <div v-for="item in leftHighlights" :key="item.title" class="flex gap-3 rounded-2xl bg-white/10 p-4 backdrop-blur-md ring-1 ring-white/10">
                <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-indigo-500/20 text-xl">{{ item.icon }}</div>
                <div>
                  <div class="text-sm font-bold text-white">{{ item.title }}</div>
                  <div class="mt-1 text-sm leading-6 text-white/70">{{ item.desc }}</div>
                </div>
              </div>
            </div>

            <div class="mt-8 max-w-md rounded-3xl bg-white/95 p-4 text-slate-900 shadow-[0_18px_50px_rgba(15,23,42,0.18)]">
              <div class="flex items-center gap-3">
                <div class="flex -space-x-2">
                  <img v-for="avatar in avatars" :key="avatar" :src="avatar" class="h-10 w-10 rounded-full border-2 border-white object-cover" alt="avatar" />
                </div>
                <div>
                  <div class="text-sm font-bold">Hơn 2.000+ người dùng</div>
                  <div class="text-xs text-slate-500">đã dùng RentOps để quản lý hệ thống</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="flex items-center justify-center px-4 py-10 sm:px-6 lg:px-8">
        <div class="w-full max-w-xl">
          <div class="mb-4 text-right text-sm">
            <span class="text-slate-500">{{ isRegister ? 'Đã có tài khoản?' : 'Chưa có tài khoản?' }}</span>
            <button class="ml-1 font-semibold text-indigo-600 hover:text-indigo-700" @click="toggleMode">
              {{ isRegister ? 'Đăng nhập' : 'Đăng ký' }}
            </button>
          </div>

          <div class="rounded-[2rem] bg-white p-6 shadow-[0_22px_70px_rgba(15,23,42,0.12)] ring-1 ring-slate-100 sm:p-8">
            <div class="mb-6 flex items-center justify-between gap-4">
              <div>
                <h2 class="text-3xl font-black text-slate-900">{{ isRegister ? 'Tạo tài khoản' : 'Đăng nhập' }}</h2>
                <p class="mt-1 text-sm text-slate-500">{{ isRegister ? 'Nhanh chóng và dễ dàng' : 'Chào mừng bạn trở lại' }}</p>
              </div>
              <span class="hidden rounded-full bg-indigo-50 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-indigo-600 sm:inline-flex">
                RentOps
              </span>
            </div>

            <form v-if="!isRegister" class="space-y-4" @submit.prevent="loginDemo">
              <div class="space-y-2">
                <label class="text-sm font-semibold text-slate-700">Email hoặc số điện thoại</label>
                <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                  <span class="mr-3 text-slate-400">✉</span>
                  <input
                    v-model="email"
                    type="text"
                    required
                    class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                    placeholder="Nhập email hoặc số điện thoại"
                  />
                </div>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-slate-700">Mật khẩu</label>
                <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                  <span class="mr-3 text-slate-400">🔒</span>
                  <input
                    v-model="password"
                    :type="showPassword ? 'text' : 'password'"
                    class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                    placeholder="Nhập mật khẩu"
                  />
                  <button type="button" class="ml-3 text-slate-400 hover:text-slate-600" @click="showPassword = !showPassword">
                    {{ showPassword ? 'Ẩn' : 'Hiện' }}
                  </button>
                </div>
              </div>

              <div class="flex items-center justify-between text-sm">
                <label class="flex items-center gap-2 text-slate-600">
                  <input v-model="rememberMe" type="checkbox" class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" />
                  Ghi nhớ đăng nhập
                </label>
                <button type="button" class="font-semibold text-indigo-600 hover:text-indigo-700">Quên mật khẩu?</button>
              </div>

              <button
                type="submit"
                class="w-full rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 px-4 py-3.5 font-bold text-white shadow-lg shadow-indigo-500/25 transition hover:opacity-95 disabled:opacity-70"
                :disabled="loading"
              >
                {{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
              </button>

              <div class="relative py-2 text-center text-xs uppercase tracking-[0.24em] text-slate-400">
                <span class="bg-white px-3">hoặc đăng nhập với</span>
              </div>

              <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Google</button>
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Facebook</button>
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Apple</button>
              </div>

              <button
                type="button"
                class="mt-2 w-full rounded-2xl border border-indigo-100 bg-indigo-50 px-4 py-3 font-semibold text-indigo-700 transition hover:bg-indigo-100"
                @click="loginDemo"
                :disabled="loading"
              >
                Dùng demo nhanh
              </button>
            </form>

            <form v-else class="space-y-4" @submit.prevent="registerAccount" autocomplete="off">
              <div class="grid gap-4 sm:grid-cols-2">
                <div class="space-y-2 sm:col-span-2">
                  <label class="text-sm font-semibold text-slate-700">Họ và tên</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">👤</span>
                    <input
                      v-model="registerForm.full_name"
                      type="text"
                      required
                      class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                      placeholder="Nhập họ và tên của bạn"
                    />
                  </div>
                </div>

                <div class="space-y-2 sm:col-span-2">
                  <label class="text-sm font-semibold text-slate-700">Email</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">✉</span>
                    <input
                      v-model="registerForm.email"
                      type="email"
                      required
                      class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                      placeholder="Nhập email của bạn"
                    />
                  </div>
                </div>

                <div class="space-y-2">
                  <label class="text-sm font-semibold text-slate-700">Số điện thoại</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">📞</span>
                    <input
                      v-model="registerForm.phone"
                      type="text"
                      class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                      placeholder="Nhập số điện thoại"
                    />
                  </div>
                </div>

                <div class="space-y-2">
                  <label class="text-sm font-semibold text-slate-700">Vai trò</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">⌂</span>
                    <select v-model="registerForm.role" class="w-full bg-transparent text-sm outline-none">
                      <option value="landlord">Chủ trọ / Quản lý tòa nhà</option>
                      <option value="tenant">Khách thuê (cư dân)</option>
                    </select>
                  </div>
                </div>

                <div v-if="registerForm.role === 'landlord'" class="space-y-2 sm:col-span-2">
                  <label class="text-sm font-semibold text-slate-700">Tên tòa nhà / dãy trọ</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">🏢</span>
                    <input
                      v-model="registerForm.tenant_name"
                      type="text"
                      class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                      placeholder="VD: Tòa Nhà Demo RentOps"
                    />
                  </div>
                </div>

                <div class="space-y-2 sm:col-span-2">
                  <label class="text-sm font-semibold text-slate-700">Mật khẩu</label>
                  <div class="flex items-center rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
                    <span class="mr-3 text-slate-400">🔒</span>
                    <input
                      v-model="registerForm.password"
                      :type="showPassword ? 'text' : 'password'"
                      required
                      class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                      placeholder="Tạo mật khẩu"
                    />
                  </div>
                </div>
              </div>

              <label class="flex items-start gap-2 rounded-2xl bg-slate-50 px-4 py-3 text-sm text-slate-600">
                <input v-model="acceptTerms" type="checkbox" class="mt-1 h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" />
                <span>
                  Tôi đồng ý với <span class="font-semibold text-indigo-600">Điều khoản sử dụng</span> và <span class="font-semibold text-indigo-600">Chính sách bảo mật</span>.
                </span>
              </label>

              <button
                type="submit"
                class="w-full rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 px-4 py-3.5 font-bold text-white shadow-lg shadow-indigo-500/25 transition hover:opacity-95 disabled:opacity-70"
                :disabled="loading"
              >
                {{ loading ? 'Đang tạo tài khoản...' : 'Đăng ký' }}
              </button>

              <div class="relative py-2 text-center text-xs uppercase tracking-[0.24em] text-slate-400">
                <span class="bg-white px-3">hoặc đăng ký với</span>
              </div>

              <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Google</button>
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Facebook</button>
                <button type="button" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 shadow-sm">Apple</button>
              </div>
            </form>
          </div>
        </div>
      </section>
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
const showPassword = ref(false)
const rememberMe = ref(true)
const acceptTerms = ref(true)

const loginHero = '/images/rooms/main.png'
const registerHero = '/images/rooms/living.png'
const avatars = ['/images/rooms/main.png', '/images/rooms/living.png', '/images/rooms/kitchen.png']

const leftHighlights = [
  {
    icon: '⌂',
    title: 'Lưu ý thích',
    desc: 'Lưu lại phòng, tòa nhà và tin nhắn bạn quan tâm.'
  },
  {
    icon: '✦',
    title: 'Quản lý dễ dàng',
    desc: 'Theo dõi hợp đồng, hóa đơn, sự cố và công nợ tập trung.'
  },
  {
    icon: '⌕',
    title: 'Trải nghiệm cá nhân hóa',
    desc: 'Gợi ý phù hợp với nhu cầu thuê hoặc mô hình vận hành của bạn.'
  }
]

const registerForm = ref({
  role: 'landlord',
  full_name: '',
  email: '',
  phone: '',
  tenant_name: '',
  password: ''
})

const toggleMode = () => {
  isRegister.value = !isRegister.value
}

const loginDemo = async () => {
  loading.value = true

  const inputEmail = email.value || 'admin@rentops.vn'
  const isSuperAdminEmail = inputEmail.toLowerCase().includes('superadmin')
  const isRenterEmail = inputEmail.toLowerCase().includes('renter') || inputEmail.toLowerCase().includes('khach')

  const defaultUser = {
    id: isSuperAdminEmail ? 999 : isRenterEmail ? 102 : 1,
    email: inputEmail,
    full_name: isSuperAdminEmail ? 'Super Admin Hệ Thống' : isRenterEmail ? 'Khách Thuê (Cư Dân)' : 'Quản trị viên RentOps',
    role: isSuperAdminEmail ? 'super_admin' : isRenterEmail ? 'renter' : 'owner'
  }

  const defaultTenant = isSuperAdminEmail
    ? null
    : {
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
  } catch {
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
  if (!acceptTerms.value) {
    alert('Vui lòng đồng ý với điều khoản trước khi đăng ký.')
    return
  }

  loading.value = true
  try {
    const res = await fetch('/api/v1/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(registerForm.value)
    })

    const json = await res.json()
    if (res.ok && json.success) {
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
  } catch {
    alert('Lỗi kết nối khi đăng ký tài khoản')
  } finally {
    loading.value = false
  }
}
</script>
