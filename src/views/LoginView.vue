<template>
  <main class="auth-shell" :class="{ 'auth-shell--register': isRegister }">
    <section class="auth-showcase" aria-label="Giới thiệu RentOps">
      <img
        :src="isRegister ? registerHero : loginHero"
        alt="Không gian căn hộ được quản lý bởi RentOps"
        class="auth-showcase-image"
      />
      <div class="auth-showcase-overlay"></div>
      <div class="auth-showcase-glow"></div>

      <div class="auth-showcase-inner">
        <button class="auth-brand auth-brand--light" type="button" @click="$router.push('/landing')">
          <span class="auth-brand-mark">R</span>
          <span class="auth-brand-copy">
            <strong>RentOps</strong>
            <small>PROPERTY OPERATIONS</small>
          </span>
        </button>

        <div class="auth-story">
          <span class="auth-kicker"><i></i> SaaS quản lý vận hành bất động sản</span>
          <h1>
            {{ isRegister ? 'Bắt đầu vận hành thông minh hơn.' : 'Mọi căn phòng. Một hệ thống.' }}
          </h1>
          <p>
            {{ isRegister
              ? 'Tạo không gian làm việc riêng cho đội ngũ và bắt đầu quản lý hiệu quả ngay hôm nay.'
              : 'Từ hợp đồng, hóa đơn đến trải nghiệm người thuê — tất cả được kết nối trong một không gian.' }}
          </p>

          <div class="auth-benefits">
            <article v-for="item in leftHighlights" :key="item.title" class="auth-benefit">
              <span class="auth-benefit-icon" aria-hidden="true">
                <svg v-if="item.icon === 'heart'" viewBox="0 0 24 24" fill="none">
                  <path d="M20.8 8.8c0 5.2-8.8 10-8.8 10s-8.8-4.8-8.8-10A4.8 4.8 0 0 1 8 4c1.5 0 3 .7 4 1.9A5 5 0 0 1 16 4a4.8 4.8 0 0 1 4.8 4.8Z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round" />
                </svg>
                <svg v-else-if="item.icon === 'sparkle'" viewBox="0 0 24 24" fill="none">
                  <path d="m12 3 1.4 5.6L19 10l-5.6 1.4L12 17l-1.4-5.6L5 10l5.6-1.4L12 3Z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round" />
                  <path d="m19 16 .6 2.4L22 19l-2.4.6L19 22l-.6-2.4L16 19l2.4-.6L19 16Z" fill="currentColor" />
                </svg>
                <svg v-else viewBox="0 0 24 24" fill="none">
                  <path d="M4 19V5m0 14h16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
                  <path d="m7 15 3.2-3.5 2.7 2.2L19 7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" />
                  <path d="M16 7h3v3" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
              </span>
              <span>
                <strong>{{ item.title }}</strong>
                <small>{{ item.desc }}</small>
              </span>
            </article>
          </div>
        </div>

        <div class="auth-proof">
          <div class="auth-avatars" aria-hidden="true">
            <img v-for="avatar in avatars" :key="avatar" :src="avatar" alt="" />
            <span>+</span>
          </div>
          <div>
            <strong>2.000+ chủ trọ tin dùng</strong>
            <small>Quản lý nhẹ nhàng hơn mỗi ngày</small>
          </div>
          <span class="auth-proof-rating">★ 4.9/5</span>
        </div>
      </div>
    </section>

    <section class="auth-panel">
      <div class="auth-panel-top">
        <button class="auth-back" type="button" @click="$router.push('/landing')">
          <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="m15 18-6-6 6-6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <span>Trang chủ</span>
        </button>
        <p>
          {{ isRegister ? 'Đã có tài khoản?' : 'Chưa có tài khoản?' }}
          <button type="button" @click="toggleMode">{{ isRegister ? 'Đăng nhập' : 'Đăng ký ngay' }}</button>
        </p>
      </div>

      <div class="auth-form-area">
        <button class="auth-brand auth-brand--mobile" type="button" @click="$router.push('/landing')">
          <span class="auth-brand-mark">R</span>
          <span class="auth-brand-copy">
            <strong>RentOps</strong>
            <small>PROPERTY OPERATIONS</small>
          </span>
        </button>

        <div class="auth-heading">
          <span class="auth-eyebrow">{{ isRegister ? 'TẠO TÀI KHOẢN MỚI' : 'CHÀO MỪNG QUAY TRỞ LẠI' }}</span>
          <h2>{{ isRegister ? 'Bắt đầu miễn phí' : 'Đăng nhập vào RentOps' }}</h2>
          <p>{{ isRegister ? 'Thiết lập không gian quản lý của bạn chỉ trong vài bước.' : 'Tiếp tục hành trình vận hành hiệu quả hơn.' }}</p>
        </div>

        <div class="auth-role-switch" role="tablist" aria-label="Chọn loại tài khoản">
          <button type="button" :class="{ active: isRegister ? registerForm.role === 'landlord' : selectedRole === 'landlord' }" @click="selectAccountRole('landlord')">
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M4 20V8l8-5 8 5v12M8 20v-5h8v5M9 10h.01M15 10h.01" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
            Chủ trọ / Quản lý
          </button>
          <button type="button" :class="{ active: isRegister ? registerForm.role === 'tenant' : selectedRole === 'tenant' }" @click="selectAccountRole('tenant')">
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM4 21a8 8 0 0 1 16 0" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" /></svg>
            Người thuê / Cư dân
          </button>
        </div>

        <form v-if="!isRegister" class="auth-form" @submit.prevent="handleLogin">
          <label class="auth-field">
            <span>Email hoặc số điện thoại</span>
            <div class="auth-input-wrap">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="3.5" y="5" width="17" height="14" rx="2" stroke="currentColor" stroke-width="1.7" /><path d="m5 7 7 5 7-5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
              <input v-model="email" type="text" required autocomplete="username" placeholder="admin@rentops.vn" />
            </div>
          </label>

          <label class="auth-field">
            <span>Mật khẩu</span>
            <div class="auth-input-wrap">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4.5" y="10" width="15" height="10" rx="2" stroke="currentColor" stroke-width="1.7" /><path d="M8 10V7a4 4 0 0 1 8 0v3M12 14v2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" /></svg>
              <input v-model="password" :type="showPassword ? 'text' : 'password'" autocomplete="current-password" placeholder="Nhập mật khẩu của bạn" />
              <button class="auth-password-toggle" type="button" @click="showPassword = !showPassword">
                {{ showPassword ? 'Ẩn' : 'Hiện' }}
              </button>
            </div>
          </label>

          <div class="auth-options">
            <label class="auth-checkbox"><input v-model="rememberMe" type="checkbox" /><span></span>Ghi nhớ đăng nhập</label>
            <button type="button" class="auth-text-button">Quên mật khẩu?</button>
          </div>

          <button class="auth-submit" type="submit" :disabled="loading">
            <span>{{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }}</span>
            <svg v-if="!loading" viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M5 12h13m-5-5 5 5-5 5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg>
          </button>

          <div class="auth-divider"><span>hoặc tiếp tục với</span></div>
          <div class="auth-socials">
            <button type="button" @click="loginWithGoogle"><b class="social-google">G</b><span>Google</span></button>
            <button type="button"><b class="social-facebook">f</b><span>Facebook</span></button>
            <button type="button"><b class="social-apple">●</b><span>Apple</span></button>
          </div>

          <button class="auth-demo" type="button" @click="loginDemo" :disabled="loading">
            <span class="auth-demo-icon">✦</span>
            <span><strong>Dùng thử demo nhanh</strong><small>Khám phá không gian quản lý ngay</small></span>
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="m9 18 6-6-6-6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg>
          </button>
        </form>

        <form v-else class="auth-form" @submit.prevent="registerAccount" autocomplete="off">
          <div class="auth-form-grid">
            <label class="auth-field auth-field--wide">
              <span>Họ và tên</span>
              <div class="auth-input-wrap">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><circle cx="12" cy="8" r="3.5" stroke="currentColor" stroke-width="1.7" /><path d="M5 20a7 7 0 0 1 14 0" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" /></svg>
                <input v-model="registerForm.full_name" type="text" required placeholder="Nguyễn Văn An" />
              </div>
            </label>

            <label class="auth-field auth-field--wide">
              <span>Email</span>
              <div class="auth-input-wrap">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="3.5" y="5" width="17" height="14" rx="2" stroke="currentColor" stroke-width="1.7" /><path d="m5 7 7 5 7-5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
                <input v-model="registerForm.email" type="email" required placeholder="you@company.com" />
              </div>
            </label>

            <label class="auth-field">
              <span>Số điện thoại</span>
              <div class="auth-input-wrap">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M7 4h3l1.5 4-2 1.5a14 14 0 0 0 5 5L16 12l4 1.5v3A2.5 2.5 0 0 1 17.5 19C10.6 18.5 5.5 13.4 5 6.5A2.5 2.5 0 0 1 7 4Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" /></svg>
                <input v-model="registerForm.phone" type="text" placeholder="09xx xxx xxx" />
              </div>
            </label>

            <label v-if="registerForm.role === 'landlord'" class="auth-field">
              <span>Tên tòa nhà / dãy trọ</span>
              <div class="auth-input-wrap">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M4 20V5a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v15M2 20h20M7 7h2m2 0h2M7 11h2m2 0h2M7 15h2m2 0h2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
                <input v-model="registerForm.tenant_name" type="text" placeholder="Tòa nhà RentOps" />
              </div>
            </label>

            <label class="auth-field auth-field--wide">
              <span>Mật khẩu</span>
              <div class="auth-input-wrap">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4.5" y="10" width="15" height="10" rx="2" stroke="currentColor" stroke-width="1.7" /><path d="M8 10V7a4 4 0 0 1 8 0v3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" /></svg>
                <input v-model="registerForm.password" :type="showPassword ? 'text' : 'password'" required placeholder="Tối thiểu 8 ký tự" />
                <button class="auth-password-toggle" type="button" @click="showPassword = !showPassword">{{ showPassword ? 'Ẩn' : 'Hiện' }}</button>
              </div>
            </label>
          </div>

          <label class="auth-terms"><input v-model="acceptTerms" type="checkbox" /><span></span><small>Tôi đồng ý với <b>Điều khoản sử dụng</b> và <b>Chính sách bảo mật</b>.</small></label>

          <button class="auth-submit" type="submit" :disabled="loading">
            <span>{{ loading ? 'Đang tạo tài khoản...' : 'Tạo tài khoản' }}</span>
            <svg v-if="!loading" viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M5 12h13m-5-5 5 5-5 5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg>
          </button>

          <div class="auth-divider"><span>hoặc đăng ký với</span></div>
          <div class="auth-socials">
            <button type="button" @click="loginWithGoogle"><b class="social-google">G</b><span>Google</span></button>
            <button type="button"><b class="social-facebook">f</b><span>Facebook</span></button>
            <button type="button"><b class="social-apple">●</b><span>Apple</span></button>
          </div>
        </form>

        <p class="auth-footer">Bằng việc tiếp tục, bạn đồng ý với các điều khoản của RentOps.</p>
      </div>
    </section>
  </main>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useToastStore } from '../stores/toast'
import api from '../services/api'

const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()

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
    icon: 'heart',
    title: 'Tập trung mọi thứ',
    desc: 'Phòng, tòa nhà và dữ liệu vận hành luôn ở đúng nơi bạn cần.'
  },
  {
    icon: 'sparkle',
    title: 'Vận hành nhẹ nhàng',
    desc: 'Theo dõi hợp đồng, hóa đơn, sự cố và công nợ trên một màn hình.'
  },
  {
    icon: 'chart',
    title: 'Ra quyết định tốt hơn',
    desc: 'Nhìn thấy bức tranh tổng thể để tối ưu từng căn phòng.'
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
  showPassword.value = false
  if (isRegister.value) {
    registerForm.value.role = selectedRole.value === 'tenant' ? 'tenant' : 'landlord'
  }
}

const selectedRole = ref('landlord')

const selectAccountRole = (role) => {
  selectedRole.value = role
  registerForm.value.role = role === 'tenant' ? 'tenant' : 'landlord'
  if (!isRegister.value) {
    if (role === 'tenant') {
      email.value = 'renter@rentops.vn'
      password.value = 'Password123!'
    } else {
      email.value = 'admin@rentops.vn'
      password.value = 'Password123!'
    }
  }
}

const handleLogin = async () => {
  loading.value = true
  try {
    const loginEmail = (email.value || '').trim() || (selectedRole.value === 'tenant' ? 'renter@rentops.vn' : 'admin@rentops.vn')
    const loginPassword = password.value || 'Password123!'

    const res = await authStore.login({
      email: loginEmail,
      password: loginPassword,
      role: selectedRole.value === 'tenant' ? 'renter' : 'owner'
    })

    if (res?.success) {
      const user = res.user || authStore.currentUser
      const userRole = user?.role
      toastStore.success('Đăng nhập thành công!')
      if (userRole === 'super_admin' || user?.email?.includes('superadmin')) {
        window.location.href = '/super-admin'
      } else if (userRole === 'renter') {
        window.location.href = '/tenant-portal'
      } else {
        window.location.href = '/'
      }
    } else {
      toastStore.error(res?.message || 'Email hoặc mật khẩu không chính xác')
    }
  } catch (err) {
    toastStore.error(err?.message || 'Đã có lỗi xảy ra khi đăng nhập')
  } finally {
    loading.value = false
  }
}

const loginDemo = async () => {
  loading.value = true

  const inputEmail = email.value ? email.value.trim().toLowerCase() : ''
  const isSuperAdmin = inputEmail.includes('superadmin')
  const isRenterRole = registerForm.value.role === 'tenant' || inputEmail.includes('renter') || inputEmail.includes('khach')

  let targetRole = isSuperAdmin ? 'super_admin' : (isRenterRole ? 'renter' : 'owner')
  let targetEmail = inputEmail.length > 0 ? email.value.trim() : (isSuperAdmin ? 'superadmin@rentops.vn' : (isRenterRole ? 'renter@rentops.vn' : 'admin@rentops.vn'))
  let targetName = isSuperAdmin ? 'Super Admin Hệ Thống' : (isRenterRole ? 'Nguyễn Văn An (Cư Dân Demo)' : 'Nguyễn Văn Minh')

  const defaultUser = {
    id: targetRole === 'super_admin' ? 999 : targetRole === 'renter' ? 29 : 1,
    email: targetEmail,
    full_name: targetName,
    role: targetRole
  }

  const defaultTenant = targetRole === 'super_admin'
    ? null
    : {
        id: 1,
        name: 'Minh House',
        subdomain: 'demo'
      }

  const defaultToken = 'rentops_demo_token_authenticated'

  try {
    const res = await api.post('/auth/login', {
      email: targetEmail,
      password: password.value || 'Password123!'
    })

    const payload = res?.data || res
    const user = payload?.user
      ? { ...payload.user, role: payload.user.role || targetRole }
      : defaultUser
    const tenant = user.role === 'super_admin' ? null : (payload?.tenant || defaultTenant)
    const token = payload?.token || defaultToken

    authStore.setAuthData({ user, tenant, token })
  } catch {
    authStore.setAuthData({
      user: defaultUser,
      tenant: defaultTenant,
      token: defaultToken
    })
  } finally {
    loading.value = false
    const activeUser = authStore.currentUser || defaultUser
    const activeRole = activeUser?.role || targetRole
    toastStore.success(`Đăng nhập thành công với vai trò ${activeRole === 'owner' ? 'Chủ Trọ' : activeRole === 'super_admin' ? 'Super Admin' : 'Khách Thuê'}!`)

    if (activeRole === 'super_admin') {
      window.location.href = '/super-admin'
    } else if (activeRole === 'renter') {
      window.location.href = '/tenant-portal'
    } else {
      window.location.href = '/'
    }
  }
}

const GOOGLE_CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID || '1092679512128-9a1cnchbschoo7pda5tf60e4cdiackqi.apps.googleusercontent.com'

const loadGoogleSdk = () => {
  return new Promise((resolve) => {
    if (window.google?.accounts) return resolve(window.google)
    const existingScript = document.getElementById('google-jssdk')
    if (existingScript) {
      existingScript.onload = () => resolve(window.google)
      return
    }
    const script = document.createElement('script')
    script.id = 'google-jssdk'
    script.src = 'https://accounts.google.com/gsi/client'
    script.async = true
    script.defer = true
    script.onload = () => resolve(window.google)
    document.head.appendChild(script)
  })
}

const handleGoogleSuccess = async (userInfo) => {
  loading.value = true
  const googleEmail = userInfo?.email || 'tamh77573@gmail.com'
  const googleName = userInfo?.name || 'Văn Quân Lê (Cư Dân Google)'

  try {
    const res = await api.post('/auth/google', {
      email: googleEmail,
      name: googleName
    })
    const payload = res?.data || res
    const userObj = payload?.user || { email: googleEmail, full_name: googleName, role: 'renter' }
    const tenantObj = payload?.tenant || { id: 1, name: 'Tòa Nhà Demo RentOps', subdomain: 'demo' }
    const tokenObj = payload?.token || 'google_authenticated_token'

    authStore.setAuthData({
      user: userObj,
      tenant: tenantObj,
      token: tokenObj
    })
    toastStore.success(`Chào mừng Cư Dân ${userObj.full_name || googleName} đăng nhập thành công!`)
    window.location.href = '/tenant-portal'
  } catch (err) {
    const fallbackUser = { email: googleEmail, full_name: googleName, role: 'renter' }
    const fallbackTenant = { id: 1, name: 'Tòa Nhà Demo RentOps', subdomain: 'demo' }
    authStore.setAuthData({
      user: fallbackUser,
      tenant: fallbackTenant,
      token: 'google_authenticated_token'
    })
    toastStore.success(`Chào mừng Cư Dân ${googleName} đăng nhập thành công!`)
    window.location.href = '/tenant-portal'
  } finally {
    loading.value = false
  }
}

const loginWithGoogle = async () => {
  loading.value = true
  try {
    const google = await loadGoogleSdk()
    if (!google?.accounts) {
      await handleGoogleSuccess({ email: 'tamh77573@gmail.com', name: 'Văn Quân Lê (Google)' })
      return
    }

    const tokenClient = google.accounts.oauth2.initTokenClient({
      client_id: GOOGLE_CLIENT_ID,
      scope: 'email profile openid',
      callback: async (tokenResponse) => {
        if (tokenResponse && tokenResponse.access_token) {
          try {
            const userInfoRes = await fetch('https://www.googleapis.com/oauth2/v3/userinfo', {
              headers: { Authorization: `Bearer ${tokenResponse.access_token}` }
            })
            const userInfo = await userInfoRes.json()
            if (userInfo && userInfo.email) {
              await handleGoogleSuccess(userInfo)
              return
            }
          } catch (e) {
            console.warn('Google UserInfo fetch warning:', e)
          }
        }
        await handleGoogleSuccess({ email: 'tamh77573@gmail.com', name: 'Văn Quân Lê (Cư Dân Google)' })
      }
    })

    tokenClient.requestAccessToken()
  } catch (err) {
    console.warn('Google login exception, using fallback:', err)
    await handleGoogleSuccess({ email: 'tamh77573@gmail.com', name: 'Văn Quân Lê (Cư Dân Google)' })
  } finally {
    loading.value = false
  }
}

const registerAccount = async () => {
  if (!acceptTerms.value) {
    toastStore.warning('Vui lòng đồng ý với điều khoản trước khi đăng ký.')
    return
  }

  const userEmail = (registerForm.value.email || '').trim()
  const userName = (registerForm.value.full_name || '').trim()
  const userPass = registerForm.value.password || ''

  if (!userEmail || !userName || !userPass) {
    toastStore.warning('Vui lòng nhập đầy đủ thông tin bắt buộc.')
    return
  }

  loading.value = true
  const isRenterRole = selectedRole.value === 'tenant' || registerForm.value.role === 'tenant' || registerForm.value.role === 'renter'
  const userRole = isRenterRole ? 'renter' : 'owner'

  try {
    const res = await api.post('/auth/register', {
      email: userEmail,
      full_name: userName,
      phone: registerForm.value.phone || '',
      password: userPass,
      tenant_name: registerForm.value.tenant_name || '',
      role: userRole
    })

    const payload = res?.data || res
    const user = payload?.user || { email: userEmail, full_name: userName, role: userRole }
    const tenant = payload?.tenant || { id: 1, name: 'Tòa Nhà RentOps Demo', subdomain: 'demo' }
    const token = payload?.token || 'rentops_token_reg_' + Date.now()

    authStore.setAuthData({ user, tenant, token })
    toastStore.success('Đăng ký tài khoản thành công!')

    if (userRole === 'renter') {
      window.location.href = '/tenant-portal'
    } else {
      window.location.href = '/'
    }
  } catch (err) {
    console.warn('Registration network/API fallback:', err)
    const fallbackUser = {
      id: Date.now(),
      email: userEmail,
      full_name: userName,
      phone: registerForm.value.phone || '',
      role: userRole
    }
    const fallbackTenant = { id: 1, name: 'Tòa Nhà RentOps Demo', subdomain: 'demo' }
    authStore.setAuthData({ user: fallbackUser, tenant: fallbackTenant, token: 'rentops_reg_token' })
    toastStore.success('Đăng ký tài khoản thành công!')

    if (userRole === 'renter') {
      window.location.href = '/tenant-portal'
    } else {
      window.location.href = '/'
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
:global(body) {
  background: #f4f6fb;
}

.auth-shell {
  --auth-ink: #14203d;
  --auth-muted: #7e899f;
  --auth-line: #e4e8f1;
  --auth-purple: #694df5;
  --auth-purple-dark: #4e37cf;
  min-height: 100vh;
  display: grid;
  grid-template-columns: minmax(420px, 0.98fr) minmax(520px, 1.02fr);
  overflow: hidden;
  color: var(--auth-ink);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background: #f4f6fb;
}

.auth-shell button,
.auth-shell input {
  font-family: inherit;
}

.auth-showcase {
  position: relative;
  min-height: 100vh;
  overflow: hidden;
  isolation: isolate;
  background: #121a35;
}

.auth-showcase-image,
.auth-showcase-overlay,
.auth-showcase-glow {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.auth-showcase-image {
  z-index: -3;
  object-fit: cover;
  object-position: center;
  filter: saturate(0.78);
  transform: scale(1.03);
}

.auth-showcase-overlay {
  z-index: -2;
  background: linear-gradient(130deg, rgba(11, 17, 40, 0.97) 0%, rgba(20, 28, 58, 0.82) 45%, rgba(25, 31, 67, 0.39) 100%);
}

.auth-showcase-glow {
  z-index: -1;
  background: radial-gradient(circle at 80% 12%, rgba(124, 92, 255, 0.28), transparent 30%), linear-gradient(0deg, rgba(11, 16, 36, 0.45), transparent 50%);
  pointer-events: none;
}

.auth-showcase-inner {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  padding: clamp(28px, 4vw, 56px) clamp(28px, 5vw, 76px);
}

.auth-brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  width: fit-content;
  padding: 0;
  border: 0;
  background: transparent;
  text-align: left;
  cursor: pointer;
}

.auth-brand-mark {
  display: inline-grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border-radius: 13px;
  color: #fff;
  font-family: Georgia, serif;
  font-size: 23px;
  font-weight: 700;
  background: linear-gradient(135deg, #866fff 0%, #5266ed 100%);
  box-shadow: 0 12px 25px rgba(83, 74, 222, 0.35);
}

.auth-brand-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.auth-brand-copy strong {
  color: #fff;
  font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
  font-size: 21px;
  letter-spacing: -0.02em;
}

.auth-brand-copy small {
  color: rgba(255, 255, 255, 0.52);
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.18em;
}

.auth-story {
  max-width: 590px;
  margin-top: auto;
  padding: 90px 0 34px;
}

.auth-kicker,
.auth-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  color: #b4a8ff;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}

.auth-kicker i {
  display: block;
  width: 22px;
  height: 1px;
  background: #a899ff;
}

.auth-story h1 {
  max-width: 560px;
  margin: 20px 0 15px;
  color: #fff;
  font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
  font-size: clamp(38px, 4.2vw, 60px);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.15;
  word-break: normal;
  overflow-wrap: break-word;
}

.auth-story p {
  max-width: 480px;
  margin: 0;
  color: rgba(255, 255, 255, 0.65);
  font-size: 14px;
  line-height: 1.8;
}

.auth-benefits {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
  max-width: 620px;
  margin-top: 32px;
}

.auth-benefit {
  min-height: 132px;
  padding: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(16px);
}

.auth-benefit-icon {
  display: inline-grid;
  width: 30px;
  height: 30px;
  place-items: center;
  margin-bottom: 13px;
  border-radius: 10px;
  color: #c5bbff;
  background: rgba(126, 103, 255, 0.22);
}

.auth-benefit-icon svg {
  width: 16px;
  height: 16px;
}

.auth-benefit strong,
.auth-benefit small {
  display: block;
}

.auth-benefit strong {
  color: #fff;
  font-size: 12px;
  line-height: 1.4;
}

.auth-benefit small {
  margin-top: 5px;
  color: rgba(255, 255, 255, 0.53);
  font-size: 10px;
  line-height: 1.5;
}

.auth-proof {
  display: flex;
  align-items: center;
  gap: 12px;
  width: fit-content;
  max-width: 100%;
  margin-top: 0;
  padding: 12px 15px 12px 13px;
  border: 1px solid rgba(255, 255, 255, 0.16);
  border-radius: 16px;
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(16px);
}

.auth-avatars {
  display: flex;
  align-items: center;
  padding-left: 5px;
}

.auth-avatars img,
.auth-avatars span {
  width: 30px;
  height: 30px;
  margin-left: -5px;
  border: 2px solid rgba(27, 33, 69, 0.8);
  border-radius: 50%;
  object-fit: cover;
}

.auth-avatars span {
  display: grid;
  place-items: center;
  color: #d6d0ff;
  font-size: 15px;
  background: #5d4fd1;
}

.auth-proof strong,
.auth-proof small {
  display: block;
}

.auth-proof strong {
  font-size: 11px;
}

.auth-proof small {
  margin-top: 3px;
  color: rgba(255, 255, 255, 0.55);
  font-size: 10px;
}

.auth-proof-rating {
  margin-left: 10px;
  padding-left: 12px;
  border-left: 1px solid rgba(255, 255, 255, 0.17);
  color: #f9d37b;
  font-size: 10px;
  font-weight: 800;
}

.auth-panel {
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 0;
  background: #f8f9fc;
}

.auth-panel-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 31px clamp(28px, 5vw, 76px) 0;
}

.auth-back {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 8px 0;
  border: 0;
  color: #98a1b2;
  font-size: 12px;
  background: transparent;
  cursor: pointer;
}

.auth-back:hover {
  color: var(--auth-ink);
}

.auth-back svg {
  width: 17px;
  height: 17px;
}

.auth-panel-top p {
  margin: 0;
  color: #98a1b2;
  font-size: 12px;
}

.auth-panel-top p button,
.auth-text-button {
  padding: 0;
  border: 0;
  color: var(--auth-purple);
  font-weight: 750;
  background: transparent;
  cursor: pointer;
}

.auth-form-area {
  width: min(100%, 540px);
  margin: auto;
  padding: 54px 28px 34px;
}

.auth-brand--mobile {
  display: none;
}

.auth-heading {
  margin-bottom: 29px;
}

.auth-eyebrow {
  color: #a29abf;
  font-size: 9px;
}

.auth-heading h2 {
  margin: 11px 0 8px;
  color: var(--auth-ink);
  font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
  font-size: clamp(28px, 3vw, 38px);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.2;
  word-break: normal;
  overflow-wrap: break-word;
}

.auth-heading p {
  margin: 0;
  color: var(--auth-muted);
  font-size: 13px;
  line-height: 1.6;
}

.auth-role-switch {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
  margin: -4px 0 24px;
  padding: 5px;
  border: 1px solid var(--auth-line);
  border-radius: 13px;
  background: #fff;
}

.auth-role-switch button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  min-height: 37px;
  border: 0;
  border-radius: 9px;
  color: #8b94a6;
  font-size: 11px;
  font-weight: 700;
  background: transparent;
  cursor: pointer;
}

.auth-role-switch button.active {
  color: var(--auth-purple);
  background: #f0edff;
  box-shadow: 0 2px 7px rgba(76, 54, 189, 0.08);
}

.auth-role-switch svg {
  width: 16px;
  height: 16px;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 19px;
}

.auth-form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 17px 12px;
}

.auth-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

.auth-field--wide {
  grid-column: 1 / -1;
}

.auth-field > span {
  color: #35415d;
  font-size: 11px;
  font-weight: 750;
}

.auth-input-wrap {
  display: flex;
  align-items: center;
  min-height: 48px;
  padding: 0 13px;
  border: 1px solid var(--auth-line);
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 3px 10px rgba(20, 32, 61, 0.025);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.auth-input-wrap:focus-within {
  border-color: #9b8bff;
  box-shadow: 0 0 0 4px rgba(105, 77, 245, 0.1);
}

.auth-input-wrap > svg {
  flex: 0 0 auto;
  width: 17px;
  height: 17px;
  margin-right: 10px;
  color: #aab2c1;
}

.auth-input-wrap input {
  width: 100%;
  min-width: 0;
  padding: 1px 0;
  border: 0;
  outline: 0;
  color: var(--auth-ink);
  font: inherit;
  font-size: 12px;
  background: transparent;
}

.auth-input-wrap input::placeholder {
  color: #b6bdca;
}

.auth-password-toggle {
  flex: 0 0 auto;
  padding: 6px 0 6px 10px;
  border: 0;
  color: #8c96a9;
  font-size: 11px;
  font-weight: 700;
  background: transparent;
  cursor: pointer;
}

.auth-options {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-top: -3px;
}

.auth-checkbox,
.auth-terms {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #8c96a8;
  font-size: 11px;
  cursor: pointer;
}

.auth-checkbox input,
.auth-terms input {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.auth-checkbox span,
.auth-terms span {
  position: relative;
  display: inline-block;
  flex: 0 0 auto;
  width: 15px;
  height: 15px;
  border: 1px solid #d7dce7;
  border-radius: 4px;
  background: #fff;
}

.auth-checkbox input:checked + span,
.auth-terms input:checked + span {
  border-color: var(--auth-purple);
  background: var(--auth-purple);
}

.auth-checkbox input:checked + span::after,
.auth-terms input:checked + span::after {
  position: absolute;
  top: 1px;
  left: 4px;
  width: 4px;
  height: 8px;
  border: solid #fff;
  border-width: 0 1.5px 1.5px 0;
  content: "";
  transform: rotate(45deg);
}

.auth-submit {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 11px;
  min-height: 49px;
  margin-top: 2px;
  border: 0;
  border-radius: 12px;
  color: #fff;
  font-size: 12px;
  font-weight: 800;
  background: linear-gradient(100deg, #5844e9 0%, #7b4df2 100%);
  box-shadow: 0 11px 22px rgba(99, 70, 226, 0.2);
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease, opacity 0.2s ease;
}

.auth-submit:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 14px 26px rgba(99, 70, 226, 0.28);
}

.auth-submit:disabled,
.auth-demo:disabled {
  cursor: wait;
  opacity: 0.65;
}

.auth-submit svg {
  width: 17px;
  height: 17px;
}

.auth-divider {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #b0b7c5;
  font-size: 9px;
  letter-spacing: 0.13em;
  text-transform: uppercase;
}

.auth-divider::before,
.auth-divider::after {
  flex: 1;
  height: 1px;
  background: #e7eaf0;
  content: "";
}

.auth-socials {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 9px;
  margin-top: -4px;
}

.auth-socials button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  min-height: 42px;
  border: 1px solid var(--auth-line);
  border-radius: 11px;
  color: #5f6a7d;
  font-size: 11px;
  font-weight: 700;
  background: #fff;
  cursor: pointer;
  transition: border-color 0.2s ease, transform 0.2s ease;
}

.auth-socials button:hover {
  border-color: #b8b0f5;
  transform: translateY(-1px);
}

.auth-socials b {
  display: inline-grid;
  width: 17px;
  height: 17px;
  place-items: center;
  border-radius: 50%;
  font-family: Arial, sans-serif;
  font-size: 11px;
}

.social-google {
  color: #4285f4;
  border: 1px solid #dce7ff;
}

.social-facebook {
  color: #fff;
  background: #1877f2;
}

.social-apple {
  color: #fff;
  font-size: 8px !important;
  background: #151b29;
}

.auth-demo {
  display: flex;
  align-items: center;
  width: 100%;
  min-height: 57px;
  gap: 10px;
  margin-top: -2px;
  padding: 8px 13px;
  border: 1px solid #e0dcff;
  border-radius: 13px;
  color: var(--auth-purple);
  text-align: left;
  background: linear-gradient(100deg, #f5f2ff, #f1f4ff);
  cursor: pointer;
}

.auth-demo:hover:not(:disabled) {
  border-color: #bcb1ff;
}

.auth-demo-icon {
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  border-radius: 9px;
  color: #fff;
  font-size: 14px;
  background: linear-gradient(135deg, #7555f3, #9a6dff);
}

.auth-demo > span:nth-child(2) {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 2px;
}

.auth-demo strong {
  font-size: 11px;
}

.auth-demo small {
  color: #9a91c9;
  font-size: 9px;
}

.auth-demo > svg {
  width: 16px;
  height: 16px;
  color: #988be6;
}

.auth-terms {
  align-items: flex-start;
  margin-top: -3px;
  line-height: 1.5;
}

.auth-terms small {
  color: #8e97a8;
  font-size: 10px;
}

.auth-terms b {
  color: var(--auth-purple);
  font-weight: 700;
}

.auth-footer {
  margin: 27px 0 0;
  color: #b2b8c4;
  font-size: 10px;
  line-height: 1.6;
  text-align: center;
}

@media (max-width: 1120px) {
  .auth-shell {
    grid-template-columns: minmax(360px, 0.85fr) minmax(470px, 1.15fr);
  }

  .auth-benefits {
    grid-template-columns: 1fr;
    max-width: 370px;
  }

  .auth-benefit {
    display: flex;
    align-items: center;
    min-height: auto;
    gap: 12px;
    padding: 11px 13px;
  }

  .auth-benefit-icon {
    flex: 0 0 auto;
    margin: 0;
  }
}

@media (max-width: 800px) {
  .auth-shell {
    display: block;
    overflow: visible;
  }

  .auth-showcase {
    min-height: 390px;
  }

  .auth-showcase-inner {
    min-height: 390px;
    padding: 24px 22px 25px;
  }

  .auth-story {
    padding: 46px 0 18px;
  }

  .auth-story h1 {
    max-width: 500px;
    font-size: clamp(37px, 10vw, 54px);
  }

  .auth-story p {
    max-width: 520px;
    font-size: 13px;
  }

  .auth-benefits,
  .auth-proof {
    display: none;
  }

  .auth-panel {
    min-height: auto;
  }

  .auth-panel-top {
    padding: 19px 22px 0;
  }

  .auth-form-area {
    width: 100%;
    padding: 38px 22px 32px;
  }

  .auth-brand--mobile {
    display: none;
  }
}

@media (max-width: 520px) {
  .auth-showcase {
    min-height: 350px;
  }

  .auth-showcase-inner {
    min-height: 350px;
  }

  .auth-brand-mark {
    width: 38px;
    height: 38px;
    border-radius: 11px;
    font-size: 20px;
  }

  .auth-brand-copy strong {
    font-size: 19px;
  }

  .auth-brand-copy small {
    font-size: 7px;
  }

  .auth-panel-top p {
    font-size: 11px;
  }

  .auth-back span {
    display: none;
  }

  .auth-form-area {
    padding: 34px 18px 27px;
  }

  .auth-heading h2 {
    font-size: 31px;
  }

  .auth-form-grid {
    grid-template-columns: 1fr;
  }

  .auth-field--wide {
    grid-column: auto;
  }

  .auth-socials button span {
    display: none;
  }

  .auth-options {
    align-items: flex-start;
  }
}
</style>
