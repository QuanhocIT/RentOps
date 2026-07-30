<template>
  <div class="home-page">
    <header class="home-header">
      <div class="home-container home-header-inner">
        <button class="home-brand" type="button" @click="scrollToTop">
          <span class="home-brand-mark">R</span>
          <span>Rentalio</span>
        </button>

        <nav class="home-nav" aria-label="Điều hướng chính">
          <a href="#home">Trang chủ</a>
          <a href="#search">Tìm phòng</a>
          <a href="#areas">Khu vực</a>
          <a href="#categories">Loại phòng</a>
          <a href="#amenities">Tiện ích</a>
          <a href="#featured">Blog</a>
          <a href="#about">Về chúng tôi</a>
        </nav>

        <div class="home-actions">
          <button class="favorite-action" type="button" @click="toggleFavorite">♡ Yêu thích</button>
          <button class="bell-action" type="button" aria-label="Thông báo">♧</button>
          <RouterLink class="home-login" to="/login">Đăng nhập</RouterLink>
          <button class="home-listing" type="button" @click="notify('Tính năng đăng tin phòng đang được chuẩn bị')">Đăng tin phòng +</button>
        </div>
      </div>
    </header>

    <main id="home">
      <section class="hero-section">
        <div class="home-container hero-layout">
          <div class="hero-copy">
            <span class="hero-kicker"><b>✦</b> KHÔNG GIAN SỐNG HIỆN ĐẠI</span>
            <h1>Không gian lý tưởng<br />cho cuộc sống<br /><em>bạn mơ ước</em></h1>
            <p>Hàng ngàn phòng trọ, căn hộ, homestay chất lượng với giá cả hợp lý tại các khu vực yêu thích.</p>
            <div class="hero-benefits">
              <span v-for="item in heroBenefits" :key="item.title"><b>{{ item.icon }}</b><strong>{{ item.title }}</strong><small>{{ item.desc }}</small></span>
            </div>
          </div>
          <div class="hero-visual">
            <img :src="heroImage" alt="" aria-hidden="true" class="hero-image-sharp" />
            <img :src="heroImage" alt="Không gian căn hộ hiện đại" class="hero-image-blurred" />
            <div class="hero-visual-badge"><b>✦</b><span><strong>Không gian đáng sống</strong><small>Đã có {{ dashboardStats.total_rooms || '1.000+' }} căn hộ</small></span></div>
            <div class="hero-visual-dots"><i></i><i></i><i></i></div>
          </div>
        </div>
      </section>

      <section id="search" class="search-section">
        <div class="home-container">
          <form class="search-card" @submit.prevent="searchRooms">
            <label class="search-field search-location"><span>Tìm kiếm</span><input v-model="searchTerm" type="text" placeholder="Nhập khu vực, tên đường..." /><b>⌖</b></label>
            <label class="search-field"><span>Loại phòng</span><select v-model="roomType"><option>Tất cả loại phòng</option><option>Phòng trọ</option><option>Căn hộ dịch vụ</option><option>Homestay</option></select><b>⌄</b></label>
            <label class="search-field"><span>Khoảng giá</span><select v-model="priceRange"><option>0đ - Không giới hạn</option><option>Dưới 3 triệu</option><option>3 - 7 triệu</option><option>Trên 7 triệu</option></select><b>⌄</b></label>
            <label class="search-field"><span>Tiện ích</span><select v-model="amenity"><option>Chọn tiện ích</option><option>Wi-Fi miễn phí</option><option>Máy giặt</option><option>Bãi đỗ xe</option></select><b>⌄</b></label>
            <button class="search-button" type="submit">⌕ <span>Tìm kiếm</span></button>
          </form>
        </div>
      </section>

      <section id="categories" class="home-container category-section">
        <div class="category-list">
          <button v-for="category in categories" :key="category.title" class="category-card" type="button" @click="notify(`Đang tìm ${category.title.toLowerCase()}`)">
            <img :src="category.image" :alt="category.title" /><span class="category-icon">{{ category.icon }}</span><span class="category-copy"><strong>{{ category.title }}</strong><small>{{ category.price }}</small></span>
          </button>
        </div>
      </section>

      <section id="featured" class="home-container home-section featured-section">
        <div class="section-title"><div><h2>Phòng nổi bật</h2><span class="title-note"><i>✓</i> Được xem nhiều nhất</span></div><button type="button" @click="notify('Đã hiển thị tất cả phòng nổi bật')">Xem tất cả →</button></div>
        <div class="featured-grid">
          <article v-for="room in featuredRooms" :key="room.id" class="featured-card" @click="goToRoomDetail(room)">
            <div class="featured-image"><img :src="room.image" :alt="room.title" /><span v-if="room.badge" class="room-badge">{{ room.badge }}</span><button class="card-heart" type="button" aria-label="Lưu phòng" @click.stop="toggleFavorite">♡</button><span class="room-image-count">◉ {{ room.photos }}</span></div>
            <div class="featured-body"><h3>{{ room.title }}</h3><p>{{ room.location }}</p><strong class="featured-price">{{ room.price }}</strong><div class="room-tags"><span v-for="tag in room.tags" :key="tag">{{ tag }}</span></div><div class="room-meta"><span>★ {{ room.rating }} <small>({{ room.reviews }})</small></span><span>{{ room.area }}</span><span>{{ room.shortAmenity }}</span></div></div>
          </article>
        </div>
      </section>

      <section id="areas" class="home-container home-section areas-section">
        <div class="section-title"><h2>Khu vực phổ biến</h2><button type="button" @click="notify('Đã hiển thị tất cả khu vực')">Xem tất cả →</button></div>
        <div class="area-grid"><button v-for="area in areas" :key="area.name" class="area-card" type="button" @click="notify(`Đang tìm phòng tại ${area.name}`)"><img :src="area.image" :alt="area.name" /><span class="area-overlay"></span><span class="area-copy"><strong>⌖ {{ area.name }}</strong><small>{{ area.rooms }} phòng</small></span></button></div>
      </section>

      <section id="amenities" class="home-container why-section">
        <h2>Vì sao chọn <em>Rentalio?</em></h2>
        <div class="why-grid"><article v-for="item in whyItems" :key="item.title"><span>{{ item.icon }}</span><strong>{{ item.title }}</strong><small>{{ item.desc }}</small></article></div>
      </section>

      <section class="home-container steps-section">
        <h2>Tìm phòng chỉ với 3 bước đơn giản</h2>
        <div class="steps-grid"><template v-for="(step, index) in steps" :key="step.title"><article class="step-card"><span class="step-number">{{ index + 1 }}</span><b>{{ step.icon }}</b><strong>{{ step.title }}</strong><small>{{ step.desc }}</small></article><i v-if="index < steps.length - 1" class="step-arrow">→</i></template></div>
      </section>

      <section class="home-container reviews-section">
        <h2>Khách hàng nói gì về chúng tôi?</h2>
        <div class="reviews-grid"><button class="review-arrow" type="button" aria-label="Đánh giá trước">‹</button><article v-for="review in reviews" :key="review.name"><div class="review-user"><img :src="review.avatar" :alt="review.name" /><span><strong>{{ review.name }}</strong><small>{{ review.role }}</small><b>★★★★★</b></span></div><p>“{{ review.comment }}”</p></article><button class="review-arrow" type="button" aria-label="Đánh giá tiếp">›</button></div>
      </section>

      <section class="home-container listing-cta"><div><h2>Đăng tin cho thuê phòng ngay hôm nay!</h2><p>Tiếp cận hàng ngàn người tìm thuê mỗi ngày.</p><button type="button" @click="notify('Tính năng đăng tin phòng đang được chuẩn bị')">Đăng tin miễn phí <span>→</span></button></div><div class="cta-room-art"><img src="/images/rooms/living.png" alt="Không gian cho thuê" /><span>⌂</span></div></section>

      <footer class="home-footer">
        <div class="home-container footer-grid">
          <div class="footer-intro"><button class="home-brand" type="button" @click="scrollToTop"><span class="home-brand-mark">R</span><span>Rentalio</span></button><p>Nền tảng kết nối người thuê và chủ nhà đáng tin cậy, giúp bạn tìm không gian sống lý tưởng.</p><div class="footer-social"><button type="button">f</button><button type="button">◎</button><button type="button">▶</button><button type="button">◉</button></div></div>
          <div v-for="column in footerColumns" :key="column.title" class="footer-column"><h3>{{ column.title }}</h3><button v-for="item in column.items" :key="item" type="button" @click="notify(item)">{{ item }}</button></div>
        </div>
        <div class="home-container footer-copyright">© 2024 Rentalio. Tất cả quyền được bảo lưu.<button type="button" @click="scrollToTop">↑</button></div>
      </footer>
    </main>

    <div v-if="toastMessage" class="home-toast">✓ {{ toastMessage }}</div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'

const router = useRouter()
const searchTerm = ref('')
const roomType = ref('Tất cả loại phòng')
const priceRange = ref('0đ - Không giới hạn')
const amenity = ref('Chọn tiện ích')
const toastMessage = ref('')
const isFavorite = ref(false)
let toastTimer

const heroImage = '/images/rooms/main.png'
const dashboardStats = ref({ total_rooms: 0, occupied_rooms: 0, vacant_rooms: 0, occupancy_rate: 0, pending_maintenance_count: 0 })
const heroBenefits = [
  { icon: '⌂', title: '10.000+', desc: 'Phòng đa dạng' },
  { icon: '▣', title: 'Xác thực', desc: '100% tin đăng' },
  { icon: '♙', title: 'Hỗ trợ 24/7', desc: 'Nhanh chóng' },
  { icon: '▤', title: 'Thanh toán', desc: 'An toàn' }
]
const categories = [
  { title: 'Phòng trọ', price: 'Giá từ 1 triệu', image: '/images/rooms/living.png', icon: '⌂' },
  { title: 'Căn hộ mini', price: 'Giá từ 3 triệu', image: '/images/suite.png', icon: '▣' },
  { title: 'Căn hộ dịch vụ', price: 'Giá từ 5 triệu', image: '/images/rooms/main.png', icon: '▦' },
  { title: 'Homestay', price: 'Giá từ 500k/đêm', image: '/images/rooms/kitchen.png', icon: '⌾' },
  { title: 'Ở ghép', price: 'Giá từ 800k/người', image: '/images/studio.png', icon: '♧' }
]
const featuredRooms = [
  { id: 101, title: 'Phòng trọ cao cấp Full nội thất', location: 'Quận 1, TP. Hồ Chí Minh', price: '4.5 triệu/tháng', image: '/images/suite.png', tags: ['Điều hòa', 'Máy giặt', 'Wi-Fi'], rating: '4.8', reviews: 120, badge: 'VIP', photos: 8, area: '25m²', shortAmenity: 'Đầy đủ nội thất' },
  { id: 102, title: 'Căn hộ mini ban công thoáng mát', location: 'Bình Thạnh, TP. Hồ Chí Minh', price: '5.8 triệu/tháng', image: '/images/studio.png', tags: ['Ban công', 'Bếp riêng', 'Máy giặt'], rating: '4.9', reviews: 98, photos: 6, area: '32m²', shortAmenity: 'Có ban công' },
  { id: 401, title: 'Căn hộ dịch vụ cao cấp', location: 'Phú Nhuận, TP. Hồ Chí Minh', price: '8.5 triệu/tháng', image: '/images/bedroom.png', tags: ['Nội thất', 'Hồ bơi', 'Gym'], rating: '4.8', reviews: 76, badge: 'VIP', photos: 10, area: '45m²', shortAmenity: 'Gym & hồ bơi' },
  { id: 301, title: 'Homestay xinh xắn Đà Lạt', location: 'Đà Lạt, Lâm Đồng', price: '600k/đêm', image: '/images/rooms/bathroom.png', tags: ['View đẹp', 'Bếp chung', 'Yên tĩnh'], rating: '4.9', reviews: 56, photos: 12, area: '20m²', shortAmenity: 'View đẹp' }
]
const areas = [
  { name: 'Quận 1', rooms: '1.234', image: '/images/rooms/main.png' },
  { name: 'Bình Thạnh', rooms: '2.345', image: '/images/rooms/living.png' },
  { name: 'Phú Nhuận', rooms: '1.876', image: '/images/rooms/kitchen.png' },
  { name: 'Thủ Đức', rooms: '2.125', image: '/images/hero_banner.png' },
  { name: 'Gò Vấp', rooms: '1.654', image: '/images/bedroom.png' },
  { name: 'Đà Lạt', rooms: '987', image: '/images/studio.png' }
]
const amenityCards = [
  { icon: '⌂', title: 'Phòng đầy đủ nội thất', desc: 'Dọn vào ở ngay' },
  { icon: '⌁', title: 'Không gian yên tĩnh', desc: 'Phù hợp làm việc' },
  { icon: '◉', title: 'An ninh đảm bảo', desc: 'Hỗ trợ 24/7' },
  { icon: '♧', title: 'Vị trí thuận tiện', desc: 'Gần trung tâm' }
]
const whyItems = [
  { icon: '♧', title: 'Tin đăng xác thực', desc: '100% tin đăng được kiểm duyệt, thông tin rõ ràng.' },
  { icon: '⌂', title: 'Giá cả minh bạch', desc: 'Giá thuê rõ ràng, không phát sinh chi phí.' },
  { icon: '⌕', title: 'Tìm kiếm dễ dàng', desc: 'Bộ lọc thông minh giúp bạn tìm phòng nhanh chóng.' },
  { icon: '♙', title: 'Hỗ trợ tận tâm', desc: 'Đội ngũ hỗ trợ 24/7 giải đáp mọi thắc mắc.' },
  { icon: '▤', title: 'Thanh toán an toàn', desc: 'Hỗ trợ thanh toán online an toàn, bảo mật.' }
]
const steps = [
  { icon: '⌕', title: 'Tìm kiếm', desc: 'Nhập nhu cầu của bạn và lọc kết quả phù hợp.' },
  { icon: '♡', title: 'Liên hệ', desc: 'Trao đổi trực tiếp với chủ phòng hoặc người đăng.' },
  { icon: '⌂', title: 'Đặt phòng', desc: 'Thỏa thuận và dọn vào ngôi nhà yêu thích.' }
]
const reviews = [
  { name: 'Nguyễn Minh Anh', role: 'Sinh viên', avatar: '/images/rooms/main.png', comment: 'Tìm được phòng ưng ý chỉ trong 1 ngày! Giao diện dễ dùng, thông tin rõ ràng và chủ phòng rất nhiệt tình.' },
  { name: 'Trần Hoàng Nam', role: 'Nhân viên văn phòng', avatar: '/images/rooms/living.png', comment: 'Rất hài lòng với dịch vụ của Rentalio. Hỗ trợ nhanh chóng và nhiều lựa chọn phòng chất lượng.' },
  { name: 'Lê Thu Trang', role: 'Freelancer', avatar: '/images/rooms/kitchen.png', comment: 'Homestay ở Đà Lạt rất xinh và sạch sẽ. Giá cả hợp lý, sẽ tiếp tục ủng hộ Rentalio!' }
]
const footerColumns = [
  { title: 'Về chúng tôi', items: ['Giới thiệu', 'Cách hoạt động', 'Tin tức', 'Tuyển dụng', 'Liên hệ'] },
  { title: 'Hỗ trợ', items: ['Trung tâm trợ giúp', 'Quy định sử dụng', 'Chính sách bảo mật', 'Liên hệ hỗ trợ'] },
  { title: 'Danh mục', items: ['Phòng trọ', 'Căn hộ mini', 'Căn hộ dịch vụ', 'Homestay', 'Ở ghép'] },
  { title: 'Liên hệ', items: ['1900 1234', 'support@rentalio.vn', '123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh'] }
]

const notify = (message) => {
  toastMessage.value = message
  window.clearTimeout(toastTimer)
  toastTimer = window.setTimeout(() => { toastMessage.value = '' }, 2600)
}
const goToRoomDetail = (room) => router.push(`/room-detail/${room.id}`)
const toggleFavorite = () => { isFavorite.value = !isFavorite.value; notify(isFavorite.value ? 'Đã lưu vào danh sách yêu thích' : 'Đã bỏ lưu') }
const searchRooms = () => notify(searchTerm.value ? `Đang tìm phòng tại ${searchTerm.value}` : 'Hãy nhập khu vực bạn muốn tìm')
const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' })
const scrollToSearch = () => document.querySelector('#search')?.scrollIntoView({ behavior: 'smooth' })

const loadDashboardStats = async () => {
  try {
    const res = await api.get('/dashboard/summary')
    const counters = res?.counters || {}
    dashboardStats.value = {
      total_rooms: counters.total_rooms ?? 0,
      occupied_rooms: counters.occupied_rooms ?? 0,
      vacant_rooms: counters.vacant_rooms ?? 0,
      occupancy_rate: counters.occupancy_rate ?? 0,
      pending_maintenance_count: counters.pending_maintenance_count ?? 0
    }
  } catch {
    // Keep the showcase fallback content when the API is unavailable.
  }
}

onMounted(loadDashboardStats)
</script>

<style scoped>
:global(*) { box-sizing: border-box; }
:global(body) { margin: 0; background: #f8f9fc; }
button, input, select { font: inherit; }
.home-page { min-height: 100vh; overflow: hidden; color: #273147; background: #f8f9fc; font-family: "Times New Roman", Times, serif; }
.home-container { width: min(1280px, calc(100% - 64px)); margin: 0 auto; }
.home-header { position: sticky; z-index: 20; top: 0; height: 76px; border-bottom: 1px solid #eef0f5; background: rgba(255,255,255,.96); backdrop-filter: blur(14px); }
.home-header-inner { display: flex; align-items: center; justify-content: space-between; height: 100%; }
.home-brand { display: flex; align-items: center; gap: 10px; color: #172033; border: 0; background: transparent; cursor: pointer; font-size: 20px; font-weight: 800; white-space: nowrap; }
.home-brand-mark { display: grid; place-items: center; width: 44px; height: 44px; color: #fff; border-radius: 16px; background: linear-gradient(135deg,#5e87f5,#5545e8); box-shadow: 0 8px 16px rgba(79,70,229,.22); font-size: 18px; }
.home-nav { display: flex; align-items: center; gap: 30px; margin-left: auto; margin-right: 28px; white-space: nowrap; }
.home-nav a, .favorite-action { color: #4f5b70; border: 0; background: transparent; cursor: pointer; font-size: 13px; font-weight: 700; text-decoration: none; }
.home-nav a:hover, .favorite-action:hover { color: #5147db; }
.home-actions { display: flex; align-items: center; gap: 13px; white-space: nowrap; }
.favorite-action { display: inline-flex; align-items: center; }.bell-action { padding: 0 2px; color: #566177; border: 0; background: transparent; cursor: pointer; font-size: 18px; }
.home-login, .home-listing { display: inline-flex; align-items: center; justify-content: center; height: 45px; border-radius: 16px; cursor: pointer; font-size: 13px; font-weight: 700; text-decoration: none; }
.home-login { width: 122px; color: #5549e8; border: 1px solid #c9c9fb; background: #fff; }.home-login:hover { background: #f8f7ff; }
.home-listing { width: 164px; color: #fff; border: 0; background: linear-gradient(100deg,#4e43de,#873be7); box-shadow: 0 9px 17px rgba(94,63,224,.23); }.home-listing:hover { filter: brightness(.96); }
.hero-section { position: relative; overflow: hidden; background: linear-gradient(115deg,#fff 8%,#f6f8ff 52%,#edf2ff); }
.hero-layout { position: relative; display: grid; grid-template-columns: .84fr 1.16fr; align-items: stretch; min-height: 390px; gap: 0; padding: 0; }
.hero-copy { position: relative; z-index: 3; align-self: center; padding: 18px 22px 35px 40px; }.hero-kicker { display: none; }
.hero-copy h1 { margin: 0; color: #151d35; font-size: clamp(35px, 4.1vw, 56px); line-height: 1.07; letter-spacing: -.045em; }.hero-copy h1 em { color: #6352e6; font-style: normal; }.hero-copy p { max-width: 425px; margin: 19px 0 21px; color: #667287; font-size: 12px; line-height: 1.7; }
.hero-benefits { display: grid; grid-template-columns: repeat(4, 1fr); max-width: 510px; gap: 8px; }.hero-benefits > span { display: grid; grid-template-columns: 26px 1fr; grid-template-rows: 1fr 1fr; align-items: center; column-gap: 7px; min-width: 0; }.hero-benefits b { grid-row: 1 / 3; display: grid; place-items: center; width: 26px; height: 26px; color: #584ddb; border-radius: 8px; background: #e9ebff; font-size: 14px; }.hero-benefits strong { overflow: hidden; color: #425068; font-size: 9px; text-overflow: ellipsis; white-space: nowrap; }.hero-benefits small { overflow: hidden; color: #8e98a9; font-size: 8px; text-overflow: ellipsis; white-space: nowrap; }
.hero-visual { position: relative; z-index: 1; height: 390px; overflow: hidden; border-radius: 0; box-shadow: none; contain: paint; }.hero-visual > img { position: absolute; inset: 0; display: block; width: 108%; height: 108%; margin: -4% 0 0 -4%; object-fit: cover; object-position: center; transform: scale(1.04); }.hero-image-sharp { z-index: 0; }.hero-image-blurred { z-index: 1; filter: blur(10px); opacity: .9; -webkit-mask-image: linear-gradient(90deg, #000 0%, #000 42%, rgba(0,0,0,.75) 53%, transparent 72%); mask-image: linear-gradient(90deg, #000 0%, #000 42%, rgba(0,0,0,.75) 53%, transparent 72%); }.hero-visual::after { position: absolute; z-index: 2; inset: 0; pointer-events: none; content: ''; background: linear-gradient(90deg, rgba(246,248,255,.995) 0%, rgba(246,248,255,.94) 18%, rgba(246,248,255,.68) 34%, rgba(246,248,255,.25) 52%, rgba(246,248,255,.04) 66%, transparent 77%), linear-gradient(180deg, rgba(255,255,255,.04), transparent 55%, rgba(25,31,48,.15)); }
.hero-visual-badge, .hero-visual-dots { display: none; }
.search-section { position: relative; z-index: 3; margin-top: -20px; }.search-section > .home-container { width: 100%; max-width: none; padding: 0 38px; }.search-card { display: grid; grid-template-columns: 1.35fr 1fr 1fr 1fr auto; align-items: end; gap: 10px; padding: 15px 17px; border: 1px solid #eef0f6; border-radius: 18px; background: #fff; box-shadow: 0 12px 28px rgba(41,50,83,.13); }.search-field { position: relative; display: flex; flex-direction: column; gap: 7px; min-width: 0; padding: 0 10px; }.search-field span { color: #3f4b60; font-size: 10px; font-weight: 800; }.search-field input, .search-field select { width: 100%; height: 30px; padding: 0 22px 0 0; overflow: hidden; color: #8d97a7; border: 0; outline: 0; background: transparent; font-size: 10px; text-overflow: ellipsis; white-space: nowrap; }.search-field select { appearance: none; cursor: pointer; }.search-field b { position: absolute; right: 12px; bottom: 7px; color: #7c86a0; font-size: 13px; }.search-button { display: flex; align-items: center; justify-content: center; gap: 5px; height: 42px; min-width: 104px; padding: 0 17px; color: #fff; border: 0; border-radius: 11px; background: linear-gradient(100deg,#5148dd,#6b4be5); box-shadow: 0 6px 14px rgba(86,75,221,.24); cursor: pointer; font-size: 11px; font-weight: 800; }.search-button:hover { filter: brightness(.96); }
.category-section { margin-top: 23px; }.category-list { display: grid; grid-template-columns: repeat(5, 1fr); gap: 13px; }.category-card { position: relative; display: flex; align-items: center; gap: 9px; min-width: 0; padding: 9px; text-align: left; border: 1px solid #e9ebf1; border-radius: 11px; background: #fff; box-shadow: 0 5px 13px rgba(32,43,70,.06); cursor: pointer; }.category-card:hover { border-color: #c8c5f5; transform: translateY(-1px); }.category-card img { width: 48px; height: 48px; flex: 0 0 48px; object-fit: cover; border-radius: 8px; }.category-icon { display: grid; place-items: center; width: 22px; height: 22px; margin-left: -21px; align-self: flex-end; color: #554bd9; border: 2px solid #fff; border-radius: 50%; background: #e7e7ff; font-size: 10px; }.category-copy { display: flex; min-width: 0; flex-direction: column; gap: 4px; }.category-copy strong { overflow: hidden; color: #354054; font-size: 10px; text-overflow: ellipsis; white-space: nowrap; }.category-copy small { color: #8993a2; font-size: 8px; white-space: nowrap; }
.home-section { padding-top: 45px; }.section-title { display: flex; align-items: center; justify-content: space-between; gap: 15px; margin-bottom: 17px; }.section-title h2 { display: inline-block; margin: 0; color: #273147; font-size: 17px; letter-spacing: -.02em; }.section-title button { padding: 0; color: #554bdc; border: 0; background: transparent; cursor: pointer; font-size: 10px; font-weight: 800; }.title-note { display: inline-flex; align-items: center; gap: 4px; margin-left: 8px; color: #788398; font-size: 8px; }.title-note i { display: grid; place-items: center; width: 12px; height: 12px; color: #fff; border-radius: 50%; background: #5d53df; font-style: normal; }
.featured-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; }.featured-card { overflow: hidden; border: 1px solid #e7eaf0; border-radius: 11px; background: #fff; box-shadow: 0 6px 16px rgba(30,42,70,.06); cursor: pointer; transition: transform .15s, box-shadow .15s; }.featured-card:hover { box-shadow: 0 12px 25px rgba(30,42,70,.12); transform: translateY(-2px); }.featured-image { position: relative; height: 160px; overflow: hidden; }.featured-image > img { display: block; width: 100%; height: 100%; object-fit: cover; }.room-badge { position: absolute; top: 9px; left: 9px; padding: 4px 6px; color: #fff; border-radius: 5px; background: #f4a719; font-size: 8px; font-weight: 800; }.card-heart { position: absolute; top: 8px; right: 8px; display: grid; place-items: center; width: 23px; height: 23px; color: #697488; border: 0; border-radius: 50%; background: rgba(255,255,255,.9); cursor: pointer; font-size: 15px; }.card-heart:hover { color: #554bdc; }.room-image-count { position: absolute; right: 7px; bottom: 7px; padding: 4px 6px; color: #fff; border-radius: 5px; background: rgba(24,32,49,.54); font-size: 8px; }.featured-body { padding: 11px 10px 12px; }.featured-body h3 { overflow: hidden; margin: 0; color: #344054; font-size: 11px; text-overflow: ellipsis; white-space: nowrap; }.featured-body p { overflow: hidden; margin: 5px 0 8px; color: #8d97a6; font-size: 9px; text-overflow: ellipsis; white-space: nowrap; }.featured-price { display: block; color: #5147dc; font-size: 11px; }.room-tags { display: flex; gap: 5px; margin-top: 9px; overflow: hidden; }.room-tags span { padding: 3px 5px; color: #7e899a; border-radius: 4px; background: #f5f6fa; font-size: 8px; white-space: nowrap; }.room-meta { display: flex; align-items: center; justify-content: space-between; gap: 5px; margin-top: 10px; color: #788396; font-size: 8px; }.room-meta span:first-child { color: #eaa716; }.room-meta small { color: #919aa9; font-size: 8px; }
.areas-section { padding-top: 42px; }.area-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 11px; }.area-card { position: relative; height: 136px; overflow: hidden; padding: 0; border: 0; border-radius: 9px; background: #1c273d; cursor: pointer; }.area-card img { display: block; width: 100%; height: 100%; object-fit: cover; opacity: .85; transition: transform .2s; }.area-card:hover img { transform: scale(1.05); }.area-overlay { position: absolute; inset: 0; background: linear-gradient(180deg,transparent 37%,rgba(20,28,45,.82)); }.area-copy { position: absolute; right: 10px; bottom: 10px; left: 10px; display: flex; flex-direction: column; gap: 4px; align-items: flex-start; color: #fff; text-align: left; }.area-copy strong { font-size: 10px; }.area-copy small { font-size: 9px; opacity: .86; }
.amenities-home { padding-bottom: 50px; }.amenity-home-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 13px; }.amenity-home-grid > div { display: grid; grid-template-columns: 35px 1fr; grid-template-rows: auto auto; align-items: center; column-gap: 9px; padding: 13px; border: 1px solid #e7eaf1; border-radius: 11px; background: #fff; }.amenity-home-grid span { grid-row: 1 / 3; display: grid; place-items: center; width: 35px; height: 35px; color: #574cde; border-radius: 10px; background: #edeeff; font-size: 18px; }.amenity-home-grid strong { color: #3d475b; font-size: 11px; }.amenity-home-grid small { margin-top: 4px; color: #919aaa; font-size: 9px; }
.about-section { display: grid; grid-template-columns: .85fr 1fr; align-items: center; gap: 40px; margin-top: 20px; padding: 35px; border-radius: 20px; background: linear-gradient(120deg,#eceeff,#f7f7ff); }.about-kicker { color: #5a50df; font-size: 10px; font-weight: 800; letter-spacing: .23em; }.about-section h2 { margin: 10px 0; color: #202b45; font-size: 28px; line-height: 1.12; }.about-section h2 em { color: #6252df; font-style: normal; }.about-section p { max-width: 370px; color: #6d788d; font-size: 12px; line-height: 1.7; }.about-section button { margin-top: 5px; padding: 10px 15px; color: #fff; border: 0; border-radius: 9px; background: #584ddd; cursor: pointer; font-size: 10px; font-weight: 700; }.about-section img { width: 100%; height: 185px; object-fit: cover; border-radius: 14px; }
.why-section { margin-top: 42px; padding: 26px 23px 35px; border-radius: 16px; background: linear-gradient(110deg,#fff,#fbfbff); }.why-section h2, .steps-section h2, .reviews-section h2 { margin: 0 0 30px; color: #283247; text-align: center; font-size: 23px; }.why-section h2 em { color: #554bdc; font-style: normal; }.why-grid { display: grid; grid-template-columns: repeat(5, 1fr); }.why-grid article { display: flex; flex-direction: column; align-items: center; min-height: 135px; padding: 5px 25px; text-align: center; border-right: 1px solid #eceef5; }.why-grid article:last-child { border-right: 0; }.why-grid span { display: grid; place-items: center; width: 42px; height: 42px; margin-bottom: 14px; color: #554bdc; border: 1px solid #dcdcff; border-radius: 50%; background: #f8f8ff; font-size: 18px; }.why-grid strong { color: #3d475b; font-size: 13px; }.why-grid small { max-width: 205px; margin-top: 8px; color: #8b95a4; font-size: 11px; line-height: 1.55; }
.steps-section { padding-top: 50px; }.steps-grid { display: grid; grid-template-columns: 1fr 90px 1fr 90px 1fr; align-items: start; max-width: 1040px; margin: auto; }.step-card { display: flex; flex-direction: column; align-items: center; text-align: center; }.step-number { display: grid; place-items: center; width: 36px; height: 36px; margin-bottom: 12px; color: #554bdc; border: 1px solid #cfd0ff; border-radius: 50%; background: #fff; font-size: 14px; font-weight: 700; }.step-card > b { display: grid; place-items: center; width: 44px; height: 44px; margin-bottom: 9px; color: #6358df; border-radius: 11px; background: #f0f0ff; font-size: 19px; }.step-card strong { color: #465168; font-size: 13px; }.step-card small { max-width: 210px; margin-top: 7px; color: #8d97a6; font-size: 10px; line-height: 1.55; }.step-arrow { align-self: center; color: #a9a8e9; font-size: 28px; font-style: normal; text-align: center; }
.reviews-section { padding-top: 55px; }.reviews-grid { position: relative; display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; max-width: 1120px; margin: auto; }.reviews-grid article { min-height: 165px; padding: 19px; border: 1px solid #ebedf3; border-radius: 13px; background: #fff; box-shadow: 0 7px 20px rgba(30,42,70,.06); }.review-user { display: flex; align-items: center; gap: 11px; }.review-user img { width: 43px; height: 43px; object-fit: cover; border-radius: 50%; }.review-user span { display: flex; flex-direction: column; gap: 3px; }.review-user strong { color: #3c4659; font-size: 12px; }.review-user small { color: #8d97a6; font-size: 10px; }.review-user b { color: #f0ae1a; font-size: 10px; letter-spacing: 1px; }.reviews-grid article p { margin: 17px 0 0; color: #69758a; font-size: 11px; line-height: 1.65; }.review-arrow { position: absolute; z-index: 2; top: 50%; display: grid; place-items: center; width: 31px; height: 31px; color: #5b51dc; border: 1px solid #e3e4f2; border-radius: 50%; background: #fff; box-shadow: 0 3px 8px rgba(34,42,72,.08); cursor: pointer; transform: translateY(-50%); }.review-arrow:first-child { left: -17px; }.review-arrow:last-child { right: -17px; }.listing-cta { display: flex; align-items: center; justify-content: space-between; min-height: 170px; margin-top: 42px; padding: 30px 38px; overflow: hidden; color: #fff; border-radius: 16px; background: linear-gradient(105deg,#4d45db,#7161e7); box-shadow: 0 12px 25px rgba(78,70,210,.2); }.listing-cta h2 { margin: 0; font-size: 23px; }.listing-cta p { margin: 9px 0 16px; color: rgba(255,255,255,.78); font-size: 12px; }.listing-cta button { padding: 10px 17px; color: #554bdc; border: 0; border-radius: 7px; background: #fff; cursor: pointer; font-size: 11px; font-weight: 700; }.listing-cta button span { margin-left: 7px; font-size: 15px; }.cta-room-art { position: relative; width: 300px; height: 145px; margin-right: 8px; overflow: hidden; border-radius: 11px; }.cta-room-art img { width: 100%; height: 100%; object-fit: cover; opacity: .75; mix-blend-mode: screen; }.cta-room-art span { position: absolute; right: 27px; bottom: 14px; color: #fff; font-size: 52px; opacity: .75; }
.home-footer { margin-top: 32px; padding-top: 25px; background: #fff; border-top: 1px solid #edf0f4; }.footer-grid { display: grid; grid-template-columns: 1.5fr repeat(4, 1fr); gap: 35px; padding-bottom: 21px; }.footer-intro .home-brand { font-size: 15px; }.footer-intro .home-brand-mark { width: 27px; height: 27px; border-radius: 9px; font-size: 13px; }.footer-intro p { max-width: 190px; margin: 11px 0; color: #8b95a4; font-size: 9px; line-height: 1.55; }.footer-social { display: flex; gap: 7px; }.footer-social button { display: grid; place-items: center; width: 18px; height: 18px; padding: 0; color: #687387; border: 0; border-radius: 50%; background: #f0f2f7; cursor: pointer; font-size: 9px; }.footer-column { display: flex; flex-direction: column; align-items: flex-start; gap: 8px; }.footer-column h3 { margin: 2px 0 5px; color: #354055; font-size: 9px; }.footer-column button { padding: 0; color: #8993a2; border: 0; background: transparent; cursor: pointer; text-align: left; font-size: 8px; }.footer-column button:hover { color: #554bdc; }.footer-copyright { display: flex; align-items: center; justify-content: center; min-height: 28px; color: #9ca4b1; border-top: 1px solid #f0f1f5; font-size: 8px; }.footer-copyright button { position: absolute; right: 24px; display: grid; place-items: center; width: 23px; height: 23px; color: #5b51dc; border: 0; border-radius: 50%; background: #e9e9ff; cursor: pointer; font-size: 14px; }
.home-toast { position: fixed; z-index: 50; right: 22px; bottom: 22px; padding: 11px 15px; color: #fff; border-radius: 9px; background: #273147; box-shadow: 0 10px 24px rgba(22,32,53,.2); font-size: 12px; }
@media (min-width: 1345px) { .hero-visual { position: absolute; top: 0; right: auto; bottom: 0; left: 50%; width: calc(100vw + 80px); height: auto; margin: 0; transform: translateX(-50%); } }
@media (max-width: 1100px) { .home-nav { gap: 17px; margin-right: 15px; }.home-actions { gap: 8px; }.home-login { width: 100px; }.home-listing { width: 145px; }.hero-layout { gap: 22px; }.hero-copy h1 { font-size: 44px; }.category-list { gap: 8px; }.area-grid { gap: 8px; } }
@media (max-width: 850px) { .home-container { width: min(100% - 32px, 720px); }.home-header { height: 68px; }.home-nav { display: none; }.home-actions { margin-left: auto; }.favorite-action { display: block; }.bell-action { display: none; }.home-login { width: 92px; height: 39px; font-size: 11px; }.home-listing { display: none; }.hero-layout { grid-template-columns: 1fr; padding-top: 28px; }.hero-copy { padding-left: 0; }.hero-copy h1 { font-size: clamp(34px, 8vw, 48px); }.hero-copy p { max-width: 520px; }.hero-visual { position: relative; top: auto; right: auto; bottom: auto; left: auto; width: auto; height: min(55vw, 390px); min-height: 260px; margin: 0; transform: none; }.search-section { margin-top: -12px; }.search-section > .home-container { padding: 0 16px; }.search-card { grid-template-columns: repeat(2, 1fr); }.search-button { width: 100%; }.category-list { grid-template-columns: repeat(3, 1fr); }.featured-grid { grid-template-columns: repeat(2, 1fr); }.area-grid { grid-template-columns: repeat(3, 1fr); }.amenity-home-grid { grid-template-columns: repeat(2, 1fr); }.about-section { grid-template-columns: 1fr; }.why-grid { grid-template-columns: repeat(3, 1fr); row-gap: 18px; }.why-grid article:nth-child(3) { border-right: 0; }.steps-grid { grid-template-columns: 1fr 28px 1fr 28px 1fr; }.listing-cta { padding: 21px; }.cta-room-art { width: 190px; } .footer-grid { grid-template-columns: repeat(2, 1fr); gap: 22px; }.footer-intro { grid-column: 1 / -1; } }
@media (max-width: 520px) { .home-container { width: calc(100% - 24px); }.home-brand { font-size: 17px; }.home-brand-mark { width: 38px; height: 38px; border-radius: 13px; font-size: 16px; }.favorite-action { font-size: 11px; }.hero-copy h1 { font-size: 36px; }.hero-kicker { font-size: 9px; letter-spacing: .13em; }.hero-benefits { grid-template-columns: repeat(2, 1fr); gap: 12px; }.hero-visual { height: 275px; }.search-section { margin-top: -10px; }.search-section > .home-container { padding: 0 12px; }.search-card { grid-template-columns: 1fr; padding: 13px; }.search-field { min-height: 39px; border-bottom: 1px solid #f0f1f5; }.search-button { height: 40px; }.category-list { grid-template-columns: repeat(2, 1fr); }.category-card:last-child { grid-column: 1 / -1; }.featured-grid { gap: 9px; }.featured-image { height: 125px; }.featured-body { padding: 9px 8px; }.featured-body h3 { font-size: 10px; }.room-tags { display: none; }.room-meta { margin-top: 8px; font-size: 7px; }.area-grid { grid-template-columns: repeat(2, 1fr); }.area-card { height: 125px; }.amenity-home-grid { grid-template-columns: 1fr; }.about-section { padding: 23px; }.about-section h2 { font-size: 24px; }.why-section { margin-top: 22px; }.why-grid { grid-template-columns: repeat(2, 1fr); }.why-grid article:nth-child(2), .why-grid article:nth-child(4) { border-right: 0; }.why-grid article:nth-child(3) { border-right: 1px solid #eceef5; }.steps-grid { grid-template-columns: 1fr; gap: 13px; }.step-arrow { display: none; }.reviews-grid { grid-template-columns: 1fr; margin-right: 7px; margin-left: 7px; }.review-arrow { display: none; }.listing-cta { display: block; }.cta-room-art { width: 100%; height: 95px; margin-top: 15px; }.footer-grid { grid-template-columns: repeat(2, 1fr); gap: 18px 12px; }.footer-copyright { justify-content: flex-start; padding-right: 34px; }.footer-copyright button { right: 12px; }.home-toast { right: 12px; bottom: 12px; left: 12px; text-align: center; } }
</style>
