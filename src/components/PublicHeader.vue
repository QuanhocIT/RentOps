<template>
  <header class="home-header">
    <div class="home-container home-header-inner">
      <RouterLink class="home-brand" to="/landing" aria-label="RentOps - Trang chủ" @click="handleBrandClick">
        <span class="home-brand-mark">R</span>
        <span>RentOps</span>
      </RouterLink>

      <nav class="home-nav" aria-label="Điều hướng chính">
        <a
          v-for="item in navItems"
          :key="item.key"
          :href="item.href"
          :class="{ 'is-active': active === item.key }"
        >
          {{ item.label }}
        </a>
      </nav>

      <div class="home-actions">
        <RouterLink class="home-login" to="/login">Đăng nhập</RouterLink>
      </div>
    </div>
  </header>
</template>

<script setup>
import { RouterLink } from 'vue-router'

defineProps({
  active: { type: String, default: '' }
})

defineEmits(['notify'])

const navItems = [
  { key: 'landing', label: 'Trang chủ', href: '/landing#home' },
  { key: 'search', label: 'Tìm phòng', href: '/landing#search' },
  { key: 'areas', label: 'Khu vực', href: '/landing#areas' },
  { key: 'categories', label: 'Loại phòng', href: '/landing#categories' },
  { key: 'amenities', label: 'Tiện ích', href: '/landing#amenities' },
  { key: 'featured', label: 'Blog', href: '/landing#featured' },
  { key: 'about', label: 'Về chúng tôi', href: '/about' }
]

const handleBrandClick = (event) => {
  if (window.location.pathname === '/landing') {
    event.preventDefault()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}
</script>

<style scoped>
.home-header {
  position: fixed;
  z-index: 20;
  top: 0;
  right: 0;
  left: 0;
  height: 60px;
  border-bottom: 1px solid #eef0f5;
  background: rgba(255, 255, 255, 0.96);
  box-shadow: 0 4px 18px rgba(28, 38, 67, 0.06);
  backdrop-filter: blur(14px);
}

.home-container {
  width: min(1280px, calc(100% - 64px));
  margin: 0 auto;
}

.home-header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.home-brand {
  display: inline-flex;
  align-items: center;
  flex-shrink: 0;
  gap: 10px;
  color: #17203b;
  border: 0;
  background: transparent;
  font-size: 24px;
  font-weight: 800;
  letter-spacing: -0.04em;
  text-decoration: none;
  cursor: pointer;
}

.home-brand-mark {
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  color: #fff;
  border-radius: 13px;
  background: linear-gradient(135deg, #6371f7, #5241df);
  box-shadow: 0 10px 20px rgba(88, 73, 225, 0.2);
  font-size: 19px;
  font-weight: 800;
  letter-spacing: 0;
}

.home-nav {
  min-width: 0;
  flex: 1 1 auto;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 30px;
  margin-left: auto;
  margin-right: 28px;
}

.home-nav a {
  position: relative;
  flex-shrink: 0;
  padding: 20px 0 18px;
  color: #4d5870;
  font-size: 15px;
  font-weight: 700;
  text-decoration: none;
  white-space: nowrap;
}

.home-nav a::after {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: 3px;
  background: #5748e6;
  content: '';
  opacity: 0;
  transform: scaleX(0.55);
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.home-nav a:hover,
.home-nav a.is-active {
  color: #5748e6;
}

.home-nav a.is-active::after {
  opacity: 1;
  transform: scaleX(1);
}

.home-actions {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 12px;
}

.home-login,
.home-listing {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 42px;
  border-radius: 13px;
  font-size: 15px;
  font-weight: 800;
  text-decoration: none;
  white-space: nowrap;
}

.home-login {
  width: 136px;
  color: #5748e6;
  border: 1px solid #cfcaff;
  background: #fff;
}

.home-listing {
  width: 194px;
  padding: 0;
  color: #fff;
  border: 0;
  background: linear-gradient(105deg, #5748e6, #8933e8);
  box-shadow: 0 10px 20px rgba(90, 67, 224, 0.2);
  cursor: pointer;
}

@media (max-width: 1180px) {
  .home-nav { gap: 17px; margin-right: 20px; }
  .home-nav a { font-size: 14px; }
  .home-login { width: 124px; }
  .home-listing { width: 176px; }
}

@media (max-width: 1040px) {
  .home-nav { display: none; }
  .home-actions { margin-left: auto; }
}

@media (max-width: 520px) {
  .home-container { width: calc(100% - 24px); }
  .home-brand { gap: 9px; font-size: 21px; }
  .home-brand-mark { width: 44px; height: 44px; border-radius: 14px; font-size: 20px; }
  .home-actions { gap: 8px; }
  .home-login { width: 104px; height: 42px; border-radius: 13px; font-size: 13px; }
  .home-listing { display: none; }
}
</style>
