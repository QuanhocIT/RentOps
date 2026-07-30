<template>
  <footer class="public-footer">
    <div class="public-footer-container footer-grid">
      <div class="footer-intro">
        <RouterLink class="footer-brand" to="/landing">
          <span class="footer-brand-mark">R</span>
          <span>RentOps</span>
        </RouterLink>
        <p>Nền tảng kết nối người thuê và chủ nhà đáng tin cậy, giúp bạn tìm không gian sống lý tưởng.</p>
        <div class="footer-social" aria-label="Mạng xã hội">
          <button type="button" aria-label="Facebook" @click="$emit('notify', 'Kênh Facebook RentOps')">f</button>
          <button type="button" aria-label="Instagram" @click="$emit('notify', 'Kênh Instagram RentOps')">◎</button>
          <button type="button" aria-label="TikTok" @click="$emit('notify', 'Kênh TikTok RentOps')">♪</button>
          <button type="button" aria-label="YouTube" @click="$emit('notify', 'Kênh YouTube RentOps')">▶</button>
        </div>
      </div>

      <div v-for="column in footerColumns" :key="column.title" class="footer-column">
        <h3>{{ column.title }}</h3>
        <a v-for="item in column.items" :key="item.label" :href="item.href || '#'" @click="item.href ? undefined : notify(item.label)">
          {{ item.label }}
        </a>
      </div>
    </div>

    <div class="public-footer-container footer-copyright">
      <span>© 2024 RentOps. Tất cả quyền được bảo lưu.</span>
      <button type="button" aria-label="Lên đầu trang" @click="scrollToTop">↑</button>
    </div>
  </footer>
</template>

<script setup>
import { RouterLink } from 'vue-router'

const emit = defineEmits(['notify'])

const footerColumns = [
  {
    title: 'Về chúng tôi',
    items: [
      { label: 'Giới thiệu', href: '/about' },
      { label: 'Tin tức' },
      { label: 'Blog' },
      { label: 'Chính sách bảo mật' }
    ]
  },
  {
    title: 'Hỗ trợ',
    items: [
      { label: 'Trung tâm trợ giúp' },
      { label: 'Câu hỏi thường gặp' },
      { label: 'Hướng dẫn sử dụng' },
      { label: 'Liên hệ', href: '/landing#contact' }
    ]
  },
  {
    title: 'Dành cho đối tác',
    items: [
      { label: 'Chương trình API' },
      { label: 'Đối tác phát triển' },
      { label: 'Affiliate' },
      { label: 'Doanh nghiệp' }
    ]
  },
  {
    title: 'Liên hệ',
    items: [
      { label: '1900 1234', href: 'tel:19001234' },
      { label: 'support@rentops.vn', href: 'mailto:support@rentops.vn' },
      { label: '123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh' }
    ]
  }
]

const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' })
const notify = (message) => {
  // The event is forwarded to the page so each screen can keep its own toast system.
  emit('notify', message)
}
</script>

<style scoped>
.public-footer {
  margin-top: 32px;
  padding-top: 42px;
  color: #7c849b;
  border-top: 1px solid #edf0f4;
  background: #fff;
}

.public-footer-container {
  width: min(1280px, calc(100% - 64px));
  margin: 0 auto;
}

.footer-grid {
  display: grid;
  grid-template-columns: 1.5fr repeat(4, 1fr);
  gap: 35px;
  padding-bottom: 30px;
}

.footer-brand {
  display: inline-flex;
  align-items: center;
  gap: 11px;
  color: #17203b;
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.03em;
  text-decoration: none;
}

.footer-brand-mark {
  display: grid;
  width: 40px;
  height: 40px;
  place-items: center;
  color: #fff;
  border-radius: 13px;
  background: linear-gradient(135deg, #6371f7, #5241df);
  font-size: 18px;
  font-weight: 800;
}

.footer-intro p {
  max-width: 280px;
  margin: 14px 0;
  color: #8b95a4;
  font-size: 14px;
  line-height: 1.6;
}

.footer-social {
  display: flex;
  gap: 8px;
}

.footer-social button {
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  padding: 0;
  color: #687387;
  border: 0;
  border-radius: 9px;
  background: #f0f2f7;
  cursor: pointer;
  font-size: 13px;
  font-weight: 700;
}

.footer-column {
  display: flex;
  align-items: flex-start;
  flex-direction: column;
  gap: 10px;
}

.footer-column h3 {
  margin: 2px 0 5px;
  color: #354055;
  font-size: 15px;
  font-weight: 800;
}

.footer-column a {
  color: #8993a2;
  font-size: 14px;
  text-decoration: none;
}

.footer-column a:hover,
.footer-social button:hover {
  color: #554bdc;
}

.footer-copyright {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 58px;
  color: #9ca4b1;
  border-top: 1px solid #f0f1f5;
  font-size: 13px;
}

.footer-copyright button {
  position: absolute;
  right: 0;
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  color: #5b51dc;
  border: 0;
  border-radius: 50%;
  background: #e9e9ff;
  cursor: pointer;
  font-size: 16px;
}

@media (max-width: 850px) {
  .public-footer-container { width: min(100% - 32px, 720px); }
  .footer-grid { grid-template-columns: repeat(2, 1fr); gap: 24px 20px; }
  .footer-intro { grid-column: 1 / -1; }
}

@media (max-width: 520px) {
  .public-footer-container { width: calc(100% - 24px); }
  .footer-grid { gap: 20px 14px; }
  .footer-column h3 { font-size: 13px; }
  .footer-column a { font-size: 12px; }
  .footer-copyright { justify-content: flex-start; padding-right: 38px; font-size: 11px; }
  .footer-copyright button { right: 0; }
}
</style>
