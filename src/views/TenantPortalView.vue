<template>
  <div class="tenant-shell">
    <aside class="tenant-sidebar">
      <div class="brand">
        <div class="brand-mark">⌂</div>
        <div class="brand-name">Rentalio</div>
      </div>

      <nav class="side-nav">
        <button v-for="item in navItems" :key="item.name" class="nav-item" :class="{ active: item.active }">
          <span class="nav-icon">{{ item.icon }}</span>
          <span>{{ item.name }}</span>
        </button>
      </nav>

      <div class="reward-card">
        <div class="reward-title">Giới thiệu &amp; nhận thưởng</div>
        <p>Giới thiệu bạn bè và nhận ngay 500.000đ vào tài khoản</p>
        <div class="reward-bottom">
          <button>Giới thiệu ngay</button>
          <span>🎁</span>
        </div>
      </div>
    </aside>

    <div class="tenant-main">
      <header class="topbar">
        <div class="search-box">
          <span>⌕</span>
          <input v-model="searchQuery" placeholder="Bạn muốn tìm phòng ở đâu?" />
          <span>⌕</span>
        </div>

        <div class="top-actions">
          <button class="top-link"><span>♡</span> Yêu thích</button>
          <button class="top-link has-badge"><span>▣</span> Tin nhắn <b>2</b></button>
          <button class="bell">♧<b>3</b></button>
          <div class="profile">
            <img :src="avatar" alt="avatar" />
            <strong>{{ tenantName }}</strong>
            <span>⌄</span>
          </div>
        </div>
      </header>

      <div class="content-grid">
        <main class="center-column">
          <section class="hero-panel">
            <img :src="heroImage" alt="Không gian phòng" />
            <div class="hero-overlay"></div>
            <h1>Tìm không gian sống lý tưởng<br />cho cuộc sống của bạn</h1>

            <div class="hero-search">
              <div class="search-tabs">
                <button class="selected">Tìm kiếm</button>
                <button>Tìm theo bản đồ</button>
              </div>
              <div class="search-fields">
                <div v-for="field in searchFields" :key="field.label" class="search-field">
                  <strong>{{ field.label }}</strong>
                  <span>{{ field.placeholder }}</span>
                </div>
                <button class="search-submit">⌕ Tìm kiếm</button>
              </div>
            </div>
          </section>

          <section class="section-block">
            <h2>Khám phá theo nhu cầu</h2>
            <div class="category-row">
              <article v-for="item in categories" :key="item.title" class="category-card">
                <div class="category-icon" :class="item.color">{{ item.icon }}</div>
                <div>
                  <strong>{{ item.title }}</strong>
                  <span>{{ item.price }}</span>
                </div>
              </article>
            </div>
          </section>

          <section class="section-block">
            <div class="section-head">
              <h2>Phòng nổi bật dành cho bạn</h2>
              <a href="#">Xem tất cả</a>
            </div>
            <div class="room-grid">
              <article v-for="room in featuredRooms" :key="room.title" class="room-card">
                <div class="room-photo">
                  <img :src="room.image" :alt="room.title" />
                  <span v-if="room.badge" class="vip">VIP</span>
                  <button>♡</button>
                  <small>▣ {{ room.photos }}</small>
                </div>
                <div class="room-body">
                  <h3>{{ room.title }}</h3>
                  <p>⌾ {{ room.location }}</p>
                  <strong>{{ room.price }}</strong>
                  <div class="room-tags">
                    <span v-for="tag in room.tags" :key="tag">{{ tag }}</span>
                  </div>
                  <div class="rating">★ <span>{{ room.rating }}</span></div>
                </div>
              </article>
            </div>
          </section>

          <section class="bottom-grid">
            <div class="section-block">
              <div class="section-head">
                <h2>Khu vực phổ biến</h2>
                <a href="#">Xem tất cả</a>
              </div>
              <div class="area-grid">
                <article v-for="area in areas" :key="area.name" class="area-card">
                  <img :src="area.image" :alt="area.name" />
                  <div>
                    <strong>{{ area.name }}</strong>
                    <span>{{ area.rooms }} phòng</span>
                  </div>
                </article>
              </div>
            </div>

            <div class="section-block">
              <div class="section-head">
                <h2>Bạn có thể quan tâm</h2>
                <a href="#">Xem tất cả</a>
              </div>
              <div class="interest-row">
                <article v-for="item in interestItems" :key="item.title" class="interest-card">
                  <img :src="item.image" :alt="item.title" />
                  <div>
                    <strong>{{ item.title }}</strong>
                    <span>{{ item.subtitle }}</span>
                    <b>{{ item.price }}</b>
                  </div>
                </article>
              </div>
            </div>
          </section>
        </main>

        <aside class="right-panel">
          <section class="user-card">
            <div class="user-row">
              <img :src="avatar" alt="avatar" />
              <div>
                <span>Chào buổi sáng! 👋</span>
                <strong>{{ tenantName }}</strong>
              </div>
            </div>
            <div class="member-progress">
              <div>
                <span>◇ Thành viên Bạc</span>
                <strong>2.350 điểm</strong>
              </div>
              <div class="progress-track"><i></i></div>
              <small>Còn 650 điểm để lên hạng Vàng</small>
            </div>
          </section>

          <section class="wallet-card">
            <h2>Ví của tôi</h2>
            <div class="wallet-balance">
              <div>
                <span>Số dư hiện tại</span>
                <strong>2.350.000 đ</strong>
              </div>
              <button>Nạp tiền</button>
            </div>
            <button class="wallet-link">▤ Lịch sử giao dịch <span>›</span></button>
            <button class="wallet-link">▭ Phương thức thanh toán <span>›</span></button>
          </section>

          <section class="offer-card">
            <h2>Ưu đãi dành riêng cho bạn</h2>
            <article v-for="offer in offers" :key="offer.title">
              <div>
                <strong>{{ offer.title }}</strong>
                <p>{{ offer.desc }}</p>
                <span>HSD: {{ offer.expiry }}</span>
              </div>
              <button>Lưu mã</button>
            </article>
            <a href="#">Xem tất cả ưu đãi ›</a>
          </section>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const searchQuery = ref('')

const currentUser = computed(() => authStore.currentUser || {})
const tenantName = computed(() => currentUser.value.full_name || 'Nguyễn Văn A')
const avatar = '/images/rooms/main.png'
const heroImage = '/images/hero_banner.png'

const navItems = [
  { name: 'Trang chủ', icon: '⌂', active: true },
  { name: 'Tìm phòng', icon: '⌕' },
  { name: 'Phòng yêu thích', icon: '♡' },
  { name: 'Lịch sử tìm kiếm', icon: '◷' },
  { name: 'Đặt phòng của tôi', icon: '▣' },
  { name: 'Hợp đồng của tôi', icon: '▤' },
  { name: 'Thanh toán', icon: '▭' },
  { name: 'Thông báo', icon: '♧' },
  { name: 'Tin nhắn', icon: '▣' },
  { name: 'Đánh giá của tôi', icon: '☆' },
  { name: 'Hỗ trợ', icon: '?' }
]

const searchFields = [
  { label: 'Địa điểm', placeholder: 'Nhập khu vực, quận, phường' },
  { label: 'Ngày nhận phòng', placeholder: 'Chọn ngày' },
  { label: 'Ngày trả phòng', placeholder: 'Chọn ngày' },
  { label: 'Ngân sách', placeholder: 'Chọn khoảng giá' },
  { label: 'Bộ lọc', placeholder: 'Tiện nghi, loại phòng...' }
]

const categories = [
  { title: 'Phòng trọ', price: 'Giá từ 1 triệu', icon: '▥', color: 'orange' },
  { title: 'Căn hộ mini', price: 'Giá từ 3 triệu', icon: '▣', color: 'violet' },
  { title: 'Căn hộ dịch vụ', price: 'Giá từ 5 triệu', icon: '▤', color: 'pink' },
  { title: 'Homestay', price: 'Giá từ 500k/đêm', icon: '⌂', color: 'blue' },
  { title: 'Ở ghép', price: 'Giá từ 800k/người', icon: '●●', color: 'red' }
]

const featuredRooms = [
  { title: 'Căn hộ dịch vụ cao cấp full nội thất', location: 'Quận 1, TP. Hồ Chí Minh', price: '8.5 triệu/tháng', image: '/images/suite.png', tags: ['40m²', '1 PN', '1 WC', 'Ban công'], badge: true, photos: '1/12', rating: '4.8 (76)' },
  { title: 'Studio ban công thoáng mát gần trung tâm', location: 'Bình Thạnh, TP. Hồ Chí Minh', price: '6.2 triệu/tháng', image: '/images/studio.png', tags: ['30m²', 'Studio', '1 WC', 'Ban công'], badge: true, photos: '1/10', rating: '4.7 (58)' },
  { title: 'Homestay xinh xắn view vườn', location: 'Đà Lạt, Lâm Đồng', price: '600k/đêm', image: '/images/bedroom.png', tags: ['20m²', '1 PN', '1 WC', 'Bếp chung'], badge: false, photos: '1/15', rating: '4.9 (102)' },
  { title: 'Phòng trọ duplex hiện đại ngay trung tâm', location: 'Thủ Đức, TP. Hồ Chí Minh', price: '4.5 triệu/tháng', image: '/images/rooms/living.png', tags: ['25m²', '1 PN', '1 WC', 'Gác lửng'], badge: false, photos: '1/15', rating: '4.6 (34)' }
]

const areas = [
  { name: 'Quận 1', rooms: '1.234', image: '/images/rooms/main.png' },
  { name: 'Bình Thạnh', rooms: '2.345', image: '/images/rooms/living.png' },
  { name: 'Thủ Đức', rooms: '2.125', image: '/images/rooms/kitchen.png' },
  { name: 'Đà Lạt', rooms: '987', image: '/images/bedroom.png' },
  { name: 'Hà Nội', rooms: '3.456', image: '/images/hero_banner.png' }
]

const interestItems = [
  { title: 'Căn hộ mini', subtitle: 'đầy đủ tiện nghi', price: '5.8 triệu/tháng', image: '/images/studio.png' },
  { title: 'Phòng trọ', subtitle: 'sạch sẽ, thoáng mát', price: '3.2 triệu/tháng', image: '/images/rooms/bathroom.png' }
]

const offers = [
  { title: 'Giảm 10%', desc: 'Tối đa 200k cho đơn từ 2 triệu', expiry: '30/06/2024' },
  { title: 'Miễn phí dọn phòng', desc: 'Cho đơn đặt từ 7 ngày trở lên', expiry: '30/06/2024' }
]
</script>

<style scoped>
.tenant-shell {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  background: #f7f8fc;
}

.tenant-sidebar {
  position: sticky;
  top: 0;
  height: 100vh;
  display: flex;
  flex-direction: column;
  border-right: 1px solid #e6eaf2;
  background: #fff;
  padding: 0 18px 18px;
}

.brand {
  height: 76px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.brand-mark {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border-radius: 10px;
  color: #fff;
  font-size: 22px;
  font-weight: 900;
  background: linear-gradient(135deg, #8175ff, #563ee7);
}

.brand-name {
  color: #121936;
  font-size: 22px;
  font-weight: 900;
}

.side-nav {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 8px;
}

.nav-item {
  height: 44px;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 0;
  border-radius: 8px;
  background: transparent;
  color: #263255;
  cursor: pointer;
  font-size: 14px;
  font-weight: 700;
  padding: 0 14px;
  text-align: left;
}

.nav-item.active {
  color: #fff;
  background: #5a42e8;
  box-shadow: 0 12px 24px rgba(90, 66, 232, 0.22);
}

.nav-icon {
  width: 22px;
  text-align: center;
  font-size: 17px;
}

.reward-card {
  border-radius: 8px;
  background: linear-gradient(135deg, #5a42e8, #6e58f4);
  color: #fff;
  padding: 18px;
}

.reward-title {
  font-size: 15px;
  font-weight: 900;
}

.reward-card p {
  margin: 8px 0 0;
  color: rgba(255, 255, 255, 0.88);
  font-size: 13px;
  font-weight: 600;
  line-height: 1.55;
}

.reward-bottom {
  margin-top: 18px;
  display: flex;
  align-items: end;
  justify-content: space-between;
}

.reward-bottom button {
  border: 0;
  border-radius: 7px;
  background: #fff;
  color: #5a42e8;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
  padding: 10px 14px;
}

.reward-bottom span {
  font-size: 44px;
  line-height: 1;
}

.tenant-main {
  min-width: 0;
}

.topbar {
  height: 76px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  border-bottom: 1px solid #e6eaf2;
  background: rgba(255, 255, 255, 0.94);
  padding: 0 28px;
  position: sticky;
  top: 0;
  z-index: 20;
}

.search-box {
  width: min(486px, 100%);
  height: 44px;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 1px solid #e1e5ef;
  border-radius: 8px;
  background: #fff;
  color: #263255;
  padding: 0 16px;
}

.search-box input {
  min-width: 0;
  flex: 1;
  border: 0;
  outline: 0;
  color: #263255;
  font-size: 13px;
  font-weight: 600;
}

.search-box input::placeholder {
  color: #7d879d;
}

.top-actions {
  display: flex;
  align-items: center;
  gap: 22px;
  white-space: nowrap;
}

.top-link,
.bell {
  position: relative;
  border: 0;
  background: transparent;
  color: #121936;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
}

.top-link {
  display: flex;
  align-items: center;
  gap: 8px;
}

.top-link span,
.bell {
  font-size: 18px;
}

.top-actions b {
  position: absolute;
  min-width: 18px;
  height: 18px;
  display: grid;
  place-items: center;
  border-radius: 999px;
  color: #fff;
  font-size: 10px;
  line-height: 1;
  padding: 0 5px;
  right: -13px;
  top: -12px;
  background: #6a55ee;
}

.bell b {
  background: #ff405b;
}

.profile {
  display: flex;
  align-items: center;
  gap: 11px;
}

.profile img {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  object-fit: cover;
}

.profile strong {
  color: #121936;
  font-size: 13px;
  font-weight: 900;
}

.content-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 294px;
  gap: 18px;
  padding: 18px 22px 24px;
}

.center-column {
  min-width: 0;
}

.hero-panel {
  position: relative;
  height: 266px;
  overflow: visible;
  border-radius: 8px;
  background: #121936;
  box-shadow: 0 18px 40px rgba(18, 25, 54, 0.15);
}

.hero-panel > img {
  width: 100%;
  height: 100%;
  border-radius: 8px;
  object-fit: cover;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  border-radius: 8px;
  background: linear-gradient(90deg, rgba(10, 14, 28, 0.78), rgba(10, 14, 28, 0.3), rgba(10, 14, 28, 0.02));
}

.hero-panel h1 {
  position: absolute;
  left: 38px;
  top: 32px;
  margin: 0;
  color: #fff;
  font-size: 32px;
  font-weight: 900;
  line-height: 1.34;
}

.hero-search {
  position: absolute;
  left: 28px;
  right: 28px;
  bottom: 18px;
  overflow: hidden;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 18px 48px rgba(18, 25, 54, 0.18);
}

.search-tabs {
  display: flex;
  border-bottom: 1px solid #eef1f7;
}

.search-tabs button {
  height: 46px;
  border: 0;
  background: transparent;
  color: #7b849d;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
  padding: 0 26px;
}

.search-tabs .selected {
  color: #5942e9;
  box-shadow: inset 0 -2px #5942e9;
}

.search-fields {
  display: grid;
  grid-template-columns: 1.25fr repeat(4, 1fr) 128px;
  align-items: center;
}

.search-field {
  min-width: 0;
  border-right: 1px solid #eef1f7;
  padding: 15px 22px;
}

.search-field strong {
  display: block;
  color: #303a5f;
  font-size: 13px;
  font-weight: 900;
}

.search-field span {
  display: block;
  overflow: hidden;
  margin-top: 8px;
  color: #7b849d;
  font-size: 13px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.search-submit {
  width: 106px;
  height: 42px;
  justify-self: center;
  border: 0;
  border-radius: 8px;
  background: #5942e9;
  color: #fff;
  cursor: pointer;
  font-size: 13px;
  font-weight: 900;
}

.section-block {
  margin-top: 22px;
}

.section-block h2,
.section-head h2 {
  margin: 0;
  color: #121936;
  font-size: 18px;
  font-weight: 900;
}

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

.section-head a,
.offer-card > a {
  color: #5942e9;
  font-size: 13px;
  font-weight: 900;
  text-decoration: none;
}

.category-row {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 12px;
  margin-top: 14px;
}

.category-card {
  min-width: 0;
  height: 74px;
  display: flex;
  align-items: center;
  gap: 14px;
  border: 1px solid #eef1f7;
  border-radius: 8px;
  background: #fff;
  padding: 0 14px;
  box-shadow: 0 8px 24px rgba(18, 25, 54, 0.04);
}

.category-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  flex: 0 0 auto;
  border: 1px solid #eef1f7;
  border-radius: 50%;
  background: #fff;
  font-size: 20px;
  box-shadow: 0 8px 18px rgba(18, 25, 54, 0.08);
}

.category-icon.orange { color: #ff9416; }
.category-icon.violet { color: #5942e9; }
.category-icon.pink { color: #ff4f9a; }
.category-icon.blue { color: #2188ff; }
.category-icon.red { color: #ff5d5d; }

.category-card strong,
.interest-card strong {
  display: block;
  overflow: hidden;
  color: #121936;
  font-size: 13px;
  font-weight: 900;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.category-card span,
.interest-card span {
  display: block;
  overflow: hidden;
  margin-top: 5px;
  color: #7b849d;
  font-size: 12px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.room-card,
.right-panel section,
.interest-card {
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 8px 24px rgba(18, 25, 54, 0.04);
}

.room-card {
  overflow: hidden;
}

.room-photo {
  position: relative;
  height: 152px;
}

.room-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.room-photo .vip {
  position: absolute;
  left: 12px;
  top: 10px;
  border-radius: 5px;
  background: #ff9f1c;
  color: #fff;
  font-size: 10px;
  font-weight: 900;
  padding: 4px 7px;
}

.room-photo button {
  position: absolute;
  right: 12px;
  top: 10px;
  width: 34px;
  height: 34px;
  border: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  color: #fff;
  cursor: pointer;
  font-size: 20px;
  text-shadow: 0 1px 2px rgba(18, 25, 54, 0.35);
}

.room-photo small {
  position: absolute;
  left: 12px;
  bottom: 10px;
  border-radius: 5px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  font-size: 10px;
  font-weight: 800;
  padding: 4px 7px;
}

.room-body {
  padding: 16px;
}

.room-body h3 {
  min-height: 44px;
  margin: 0;
  color: #121936;
  font-size: 15px;
  font-weight: 900;
  line-height: 1.45;
}

.room-body p {
  overflow: hidden;
  margin: 10px 0 0;
  color: #6d7694;
  font-size: 12px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-body > strong {
  display: block;
  margin-top: 10px;
  color: #5942e9;
  font-size: 15px;
  font-weight: 900;
}

.room-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 12px;
  margin-top: 12px;
}

.room-tags span {
  color: #6d7694;
  font-size: 11px;
  font-weight: 700;
}

.rating {
  margin-top: 14px;
  color: #ffb21a;
  font-size: 13px;
  font-weight: 900;
}

.rating span {
  color: #303a5f;
}

.bottom-grid {
  display: grid;
  grid-template-columns: 1.15fr 0.85fr;
  gap: 26px;
}

.area-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 12px;
}

.area-card {
  position: relative;
  height: 108px;
  overflow: hidden;
  border-radius: 8px;
  background: #121936;
}

.area-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0.9;
}

.area-card::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(0deg, rgba(0, 0, 0, 0.74), rgba(0, 0, 0, 0.08));
}

.area-card div {
  position: absolute;
  left: 12px;
  right: 10px;
  bottom: 10px;
  z-index: 1;
  color: #fff;
}

.area-card strong,
.area-card span {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.area-card strong {
  font-size: 14px;
  font-weight: 900;
}

.area-card span {
  margin-top: 2px;
  color: rgba(255, 255, 255, 0.88);
  font-size: 12px;
  font-weight: 700;
}

.interest-row {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.interest-card {
  height: 100px;
  display: flex;
  gap: 12px;
  padding: 10px;
}

.interest-card img {
  width: 72px;
  height: 100%;
  border-radius: 7px;
  object-fit: cover;
}

.interest-card b {
  display: block;
  margin-top: 12px;
  color: #5942e9;
  font-size: 13px;
  font-weight: 900;
}

.right-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.right-panel section {
  padding: 18px;
}

.user-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-row img {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  object-fit: cover;
}

.user-row span,
.wallet-balance span,
.member-progress small {
  color: #7b849d;
  font-size: 12px;
  font-weight: 600;
}

.user-row strong {
  display: block;
  margin-top: 4px;
  color: #121936;
  font-size: 17px;
  font-weight: 900;
}

.member-progress {
  margin-top: 22px;
}

.member-progress > div:first-child {
  display: flex;
  justify-content: space-between;
  color: #7b849d;
  font-size: 12px;
  font-weight: 700;
}

.member-progress strong {
  color: #303a5f;
  font-weight: 900;
}

.progress-track {
  height: 8px;
  margin: 12px 0 10px;
  overflow: hidden;
  border-radius: 999px;
  background: #e7eaf4;
}

.progress-track i {
  display: block;
  width: 68%;
  height: 100%;
  border-radius: 999px;
  background: #5942e9;
}

.wallet-card h2,
.offer-card h2 {
  margin: 0;
  color: #121936;
  font-size: 17px;
  font-weight: 900;
}

.wallet-balance {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 12px;
  margin-top: 18px;
}

.wallet-balance strong {
  display: block;
  margin-top: 5px;
  color: #121936;
  font-size: 25px;
  font-weight: 900;
}

.wallet-balance button,
.offer-card article button {
  border: 0;
  border-radius: 8px;
  background: #5942e9;
  color: #fff;
  cursor: pointer;
  font-size: 13px;
  font-weight: 900;
  padding: 11px 14px;
}

.wallet-link {
  width: 100%;
  display: flex;
  justify-content: space-between;
  border: 0;
  border-top: 1px solid #eef1f7;
  background: #fff;
  color: #303a5f;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
  padding: 16px 0;
  text-align: left;
}

.wallet-link:first-of-type {
  margin-top: 18px;
}

.offer-card article {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 12px;
  margin-top: 14px;
  border: 1px solid #c7c2ff;
  border-radius: 8px;
  background: #fbfaff;
  padding: 14px;
}

.offer-card article strong {
  color: #5942e9;
  font-size: 14px;
  font-weight: 900;
}

.offer-card article p {
  margin: 8px 0 12px;
  color: #303a5f;
  font-size: 12px;
  font-weight: 600;
}

.offer-card article span {
  color: #7b849d;
  font-size: 12px;
  font-weight: 600;
}

.offer-card article button {
  flex: 0 0 auto;
  border: 1px solid #c7c2ff;
  background: #fff;
  color: #5942e9;
  padding: 8px 12px;
}

.offer-card > a {
  display: block;
  margin-top: 16px;
  text-align: right;
}

@media (max-width: 1279px) {
  .content-grid {
    grid-template-columns: minmax(0, 1fr);
  }

  .right-panel {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 1100px) {
  .tenant-shell {
    grid-template-columns: 1fr;
  }

  .tenant-sidebar {
    display: none;
  }

  .top-actions {
    display: none;
  }

  .search-box {
    width: 100%;
  }

  .room-grid,
  .category-row {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .bottom-grid,
  .right-panel {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .content-grid {
    padding: 14px;
  }

  .hero-panel {
    height: auto;
    min-height: 440px;
    overflow: hidden;
  }

  .hero-panel h1 {
    left: 22px;
    right: 22px;
    top: 26px;
    font-size: 27px;
  }

  .hero-search {
    left: 14px;
    right: 14px;
    bottom: 14px;
  }

  .search-fields {
    grid-template-columns: 1fr;
  }

  .search-field {
    border-right: 0;
    border-bottom: 1px solid #eef1f7;
  }

  .search-submit {
    width: calc(100% - 28px);
    margin: 14px;
  }

  .room-grid,
  .category-row,
  .area-grid,
  .interest-row {
    grid-template-columns: 1fr;
  }
}
</style>
