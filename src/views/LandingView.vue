<template>
  <div class="home-page">
    <header class="home-header">
      <div class="home-container home-header-inner">
        <button class="home-brand" type="button" @click="scrollToTop">
          <span class="home-brand-mark">R</span>
          <span>RentOps</span>
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
          <button class="bell-action" type="button" aria-label="Thông báo" @click="notify('Bạn chưa có thông báo mới')">♧</button>
          <RouterLink class="home-login" to="/login">Đăng nhập</RouterLink>
          <button class="home-listing" type="button" @click="showPostRoomModal = true">Đăng tin phòng +</button>
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
            <label class="search-field search-location"><span>Tìm kiếm</span><input v-model="searchTerm" type="text" placeholder="Nhập khu vực, tên đường..." /></label>
            <label class="search-field"><span>Loại phòng</span><select v-model="roomType"><option>Tất cả loại phòng</option><option>Phòng trọ</option><option>Căn hộ mini</option><option>Căn hộ dịch vụ</option><option>Homestay</option><option>Ở ghép</option></select></label>
            <label class="search-field"><span>Khoảng giá</span><select v-model="priceRange"><option>0đ - Không giới hạn</option><option>Dưới 3 triệu</option><option>3 - 7 triệu</option><option>Trên 7 triệu</option></select></label>
            <label class="search-field"><span>Tiện ích</span><select v-model="amenity"><option>Chọn tiện ích</option><option>Điều hòa</option><option>Máy giặt</option><option>Wi-Fi</option><option>Ban công</option><option>Nội thất</option></select></label>
            <button class="search-button" type="submit">⌕ <span>Tìm kiếm</span></button>
          </form>
        </div>
      </section>

      <section id="categories" class="home-container category-section">
        <div class="category-list">
          <button
            v-for="category in categories"
            :key="category.title"
            class="category-card"
            :class="{ active: selectedCategory === category.title }"
            type="button"
            @click="selectCategory(category.title)"
          >
            <div class="category-thumb">
              <img :src="category.image" :alt="category.title" />
              <span class="category-badge" v-html="category.svg"></span>
            </div>
            <div class="category-copy">
              <strong>{{ category.title }}</strong>
              <small>{{ category.price }}</small>
            </div>
          </button>
        </div>
      </section>

      <section id="featured" class="home-container home-section featured-section">
        <div class="section-title">
          <div>
            <h2>Phòng nổi bật {{ activeFilterTag ? `(${activeFilterTag})` : '' }}</h2>
            <span class="title-note"><i>✓</i> {{ filteredRoomsList.length }} phòng khả dụng</span>
          </div>
          <button type="button" @click="resetFilters">Xem tất cả phòng →</button>
        </div>
        <div v-if="filteredRoomsList.length === 0" class="p-8 text-center bg-white rounded-2xl border border-slate-200 text-slate-500">
          Không tìm thấy phòng phù hợp với tiêu chí của bạn. <button @click="resetFilters" class="text-indigo-600 font-bold underline ml-1">Xóa bộ lọc</button>
        </div>
        <div v-else class="featured-grid">
          <article v-for="room in filteredRoomsList" :key="room.id" class="featured-card" @click="goToRoomDetail(room)">
            <div class="featured-image"><img :src="room.image" :alt="room.title" /><span v-if="room.badge" class="room-badge">{{ room.badge }}</span><button class="card-heart" type="button" aria-label="Lưu phòng" @click.stop="toggleFavorite">♡</button><span class="room-image-count">◉ {{ room.photos }}</span></div>
            <div class="featured-body"><h3>{{ room.title }}</h3><p>{{ room.location }}</p><strong class="featured-price">{{ room.price }}</strong><div class="room-tags"><span v-for="tag in room.tags" :key="tag">{{ tag }}</span></div><div class="room-meta"><span>★ {{ room.rating }} <small>({{ room.reviews }})</small></span><span>{{ room.area }}</span><span>{{ room.shortAmenity }}</span></div></div>
          </article>
        </div>
      </section>

      <section id="areas" class="home-container home-section areas-section">
        <div class="section-title"><h2>Khu vực phổ biến</h2><button type="button" @click="resetFilters">Tất cả khu vực →</button></div>
        <div class="area-grid">
          <button
            v-for="area in areas"
            :key="area.name"
            class="area-card"
            :class="{ active: selectedArea === area.name }"
            type="button"
            @click="selectArea(area.name)"
          >
            <img :src="area.image" :alt="area.name" />
            <span class="area-overlay"></span>
            <span class="area-copy"><strong>⌖ {{ area.name }}</strong><small>{{ area.rooms }} phòng</small></span>
          </button>
        </div>
      </section>

      <section id="amenities" class="home-container why-section">
        <h2>Vì sao chọn <em>RentOps?</em></h2>
        <div class="why-grid">
          <article v-for="item in whyItems" :key="item.title">
            <span v-html="item.icon"></span>
            <strong>{{ item.title }}</strong>
            <small>{{ item.desc }}</small>
          </article>
        </div>
      </section>

      <section class="home-container steps-section">
        <h2>Tìm phòng chỉ với 3 bước đơn giản</h2>
        <div class="steps-grid">
          <template v-for="(step, index) in steps" :key="step.title">
            <article class="step-card">
              <div class="step-top">
                <span class="step-number">{{ index + 1 }}</span>
                <span class="step-icon-circle" v-html="step.icon"></span>
              </div>
              <strong>{{ step.title }}</strong>
              <small>{{ step.desc }}</small>
            </article>
            <div v-if="index < steps.length - 1" class="step-divider">
              <svg width="76" height="14" viewBox="0 0 76 14" fill="none">
                <path d="M2 7H68" stroke="#C5C9FA" stroke-width="1.5" stroke-dasharray="3 3"/>
                <path d="M66 2L72 7L66 12" stroke="#C5C9FA" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </template>
        </div>
      </section>

      <section class="home-container reviews-section">
        <h2>Khách hàng nói gì về chúng tôi?</h2>
        <div class="reviews-grid">
          <button class="review-arrow" type="button" aria-label="Đánh giá trước" @click="prevReview">‹</button>
          <article v-for="review in visibleReviews" :key="review.name">
            <div class="review-user">
              <img :src="review.avatar" :alt="review.name" />
              <span><strong>{{ review.name }}</strong><small>{{ review.role }}</small><b>★★★★★</b></span>
            </div>
            <p>“{{ review.comment }}”</p>
          </article>
          <button class="review-arrow" type="button" aria-label="Đánh giá tiếp" @click="nextReview">›</button>
        </div>
      </section>

      <section class="home-container listing-cta">
        <div>
          <h2>Đăng tin cho thuê phòng ngay hôm nay!</h2>
          <p>Tiếp cận hàng ngàn người tìm thuê mỗi ngày.</p>
          <button type="button" @click="showPostRoomModal = true">Đăng tin miễn phí <span>→</span></button>
        </div>
        <div class="cta-room-art"><img src="/images/rooms/living.png" alt="Không gian cho thuê" /><span>⌂</span></div>
      </section>

      <footer class="home-footer">
        <div class="home-container footer-grid">
          <div class="footer-intro"><button class="home-brand" type="button" @click="scrollToTop"><span class="home-brand-mark">R</span><span>RentOps</span></button><p>Nền tảng kết nối người thuê và chủ nhà đáng tin cậy, giúp bạn tìm không gian sống lý tưởng.</p><div class="footer-social"><button type="button" @click="notify('Kênh Facebook RentOps')">f</button><button type="button" @click="notify('Kênh Instagram RentOps')">◎</button><button type="button" @click="notify('Kênh YouTube RentOps')">▶</button><button type="button" @click="notify('Kênh Zalo RentOps')">◉</button></div></div>
          <div v-for="column in footerColumns" :key="column.title" class="footer-column"><h3>{{ column.title }}</h3><button v-for="item in column.items" :key="item" type="button" @click="notify(item)">{{ item }}</button></div>
        </div>
        <div class="home-container footer-copyright">© 2024 RentOps. Tất cả quyền được bảo lưu.<button type="button" @click="scrollToTop">↑</button></div>
      </footer>
    </main>

    <!-- Post Room Listing Modal -->
    <div v-if="showPostRoomModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-2xl max-w-lg w-full p-6 text-slate-900 shadow-2xl space-y-4">
        <div class="flex items-center justify-between border-b border-slate-100 pb-3">
          <h3 class="text-lg font-bold text-slate-900 flex items-center gap-2"><span>🏠</span> Đăng Tin Cho Thuê Phòng Mới</h3>
          <button @click="showPostRoomModal = false" class="text-slate-400 hover:text-slate-600 text-lg">✕</button>
        </div>
        <form @submit.prevent="submitNewListing" class="space-y-3 text-xs">
          <div>
            <label class="block font-bold text-slate-700 uppercase mb-1">Tiêu đề tin đăng *</label>
            <input v-model="postForm.title" required type="text" placeholder="vd: Phòng trọ cao cấp ban công Quận 1" class="w-full px-3 py-2 border border-slate-300 rounded-xl font-medium focus:outline-none focus:border-indigo-500" />
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Loại phòng *</label>
              <select v-model="postForm.type" class="w-full px-3 py-2 border border-slate-300 rounded-xl">
                <option>Phòng trọ</option>
                <option>Căn hộ mini</option>
                <option>Căn hộ dịch vụ</option>
                <option>Homestay</option>
                <option>Ở ghép</option>
              </select>
            </div>
            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Giá thuê hàng tháng *</label>
              <input v-model="postForm.price" required type="text" placeholder="vd: 4.5 triệu/tháng" class="w-full px-3 py-2 border border-slate-300 rounded-xl" />
            </div>
          </div>
          <div>
            <label class="block font-bold text-slate-700 uppercase mb-1">Địa chỉ phòng *</label>
            <input v-model="postForm.location" required type="text" placeholder="vd: 123 Nguyễn Thị Minh Khai, Quận 1, TP. HCM" class="w-full px-3 py-2 border border-slate-300 rounded-xl" />
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Diện tích (m²)</label>
              <input v-model="postForm.area" type="text" placeholder="25m²" class="w-full px-3 py-2 border border-slate-300 rounded-xl" />
            </div>
            <div>
              <label class="block font-bold text-slate-700 uppercase mb-1">Số điện thoại liên hệ *</label>
              <input v-model="postForm.phone" required type="tel" placeholder="0901234567" class="w-full px-3 py-2 border border-slate-300 rounded-xl" />
            </div>
          </div>
          <div class="flex justify-end gap-3 pt-3 border-t border-slate-100">
            <button type="button" @click="showPostRoomModal = false" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl">Hủy</button>
            <button type="submit" class="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-md">Đăng Tin Ngay</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="toastMessage" class="home-toast">✓ {{ toastMessage }}</div>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'

const router = useRouter()
const searchTerm = ref('')
const roomType = ref('Tất cả loại phòng')
const priceRange = ref('0đ - Không giới hạn')
const amenity = ref('Chọn tiện ích')
const selectedCategory = ref('')
const selectedArea = ref('')
const toastMessage = ref('')
const isFavorite = ref(false)
const showPostRoomModal = ref(false)
const activeReviewIndex = ref(0)
let toastTimer

const postForm = ref({
  title: '',
  type: 'Phòng trọ',
  price: '',
  location: '',
  area: '25m²',
  phone: ''
})

const heroImage = '/images/rooms/main.png'
const dashboardStats = ref({ total_rooms: 0, occupied_rooms: 0, vacant_rooms: 0, occupancy_rate: 0, pending_maintenance_count: 0 })
const heroBenefits = [
  { icon: '⌂', title: '10.000+', desc: 'Phòng đa dạng' },
  { icon: '▣', title: 'Xác thực', desc: '100% tin đăng' },
  { icon: '♙', title: 'Hỗ trợ 24/7', desc: 'Nhanh chóng' },
  { icon: '▤', title: 'Thanh toán', desc: 'An toàn' }
]
const categories = [
  { title: 'Phòng trọ', price: 'Giá từ 1 triệu', image: '/images/rooms/living.png', svg: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#23214a" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5L12 3l9 6.5V20a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9.5z"/><polyline points="9 21 9 12 15 12 15 21"/></svg>` },
  { title: 'Căn hộ mini', price: 'Giá từ 3 triệu', image: '/images/suite.png', svg: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#23214a" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="2"/><line x1="9" y1="6" x2="9.01" y2="6"/><line x1="15" y1="6" x2="15.01" y2="6"/><line x1="9" y1="10" x2="9.01" y2="10"/><line x1="15" y1="10" x2="15.01" y2="10"/><line x1="9" y1="14" x2="9.01" y2="14"/><line x1="15" y1="14" x2="15.01" y2="14"/><line x1="9" y1="18" x2="15" y2="18"/></svg>` },
  { title: 'Căn hộ dịch vụ', price: 'Giá từ 5 triệu', image: '/images/rooms/main.png', svg: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#23214a" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="2"/><line x1="9" y1="6" x2="9.01" y2="6"/><line x1="15" y1="6" x2="15.01" y2="6"/><line x1="9" y1="10" x2="9.01" y2="10"/><line x1="15" y1="10" x2="15.01" y2="10"/><line x1="9" y1="14" x2="9.01" y2="14"/><line x1="15" y1="14" x2="15.01" y2="14"/><line x1="9" y1="18" x2="15" y2="18"/></svg>` },
  { title: 'Homestay', price: 'Giá từ 500k/đêm', image: '/images/rooms/kitchen.png', svg: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#23214a" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5L12 3l9 6.5V20a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9.5z"/><path d="M12 11.5c-1.3 0-2.2.8-2.2 1.8 0 1.5 2.2 3.2 2.2 3.2s2.2-1.7 2.2-3.2c0-1-1-1.8-2.2-1.8z" fill="#23214a"/></svg>` },
  { title: 'Ở ghép', price: 'Giá từ 800k/người', image: '/images/studio.png', svg: `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#23214a" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>` }
]
const initialFeaturedRooms = [
  { id: 101, title: 'Phòng trọ cao cấp Full nội thất', location: 'Quận 1, TP. Hồ Chí Minh', price: '4.5 triệu/tháng', image: '/images/suite.png', tags: ['Điều hòa', 'Máy giặt', 'Wi-Fi'], rating: '4.8', reviews: 120, badge: 'VIP', photos: 8, area: '25m²', shortAmenity: 'Đầy đủ nội thất', category: 'Phòng trọ' },
  { id: 102, title: 'Căn hộ mini ban công thoáng mát', location: 'Bình Thạnh, TP. Hồ Chí Minh', price: '5.8 triệu/tháng', image: '/images/studio.png', tags: ['Ban công', 'Bếp riêng', 'Máy giặt'], rating: '4.9', reviews: 98, photos: 6, area: '32m²', shortAmenity: 'Có ban công', category: 'Căn hộ mini' },
  { id: 401, title: 'Căn hộ dịch vụ cao cấp', location: 'Phú Nhuận, TP. Hồ Chí Minh', price: '8.5 triệu/tháng', image: '/images/bedroom.png', tags: ['Nội thất', 'Hồ bơi', 'Gym'], rating: '4.8', reviews: 76, badge: 'VIP', photos: 10, area: '45m²', shortAmenity: 'Gym & hồ bơi', category: 'Căn hộ dịch vụ' },
  { id: 301, title: 'Homestay xinh xắn Đà Lạt', location: 'Đà Lạt, Lâm Đồng', price: '600k/đêm', image: '/images/rooms/bathroom.png', tags: ['View đẹp', 'Bếp chung', 'Yên tĩnh'], rating: '4.9', reviews: 56, photos: 12, area: '20m²', shortAmenity: 'View đẹp', category: 'Homestay' }
]

const featuredRooms = ref([...initialFeaturedRooms])

const areas = [
  { name: 'Quận 1', rooms: '1.234', image: '/images/rooms/main.png' },
  { name: 'Bình Thạnh', rooms: '2.345', image: '/images/rooms/living.png' },
  { name: 'Phú Nhuận', rooms: '1.876', image: '/images/rooms/kitchen.png' },
  { name: 'Thủ Đức', rooms: '2.125', image: '/images/hero_banner.png' },
  { name: 'Gò Vấp', rooms: '1.654', image: '/images/bedroom.png' },
  { name: 'Đà Lạt', rooms: '987', image: '/images/studio.png' }
]
const whyItems = [
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><path d="M9 12l2 2 4-4"></path></svg>', title: 'Tin đăng xác thực', desc: '100% tin đăng được kiểm duyệt thông tin rõ ràng.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><rect x="9" y="12" width="6" height="7" rx="1"></rect></svg>', title: 'Giá cả minh bạch', desc: 'Giá thuê rõ ràng, không phát sinh chi phí ẩn.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>', title: 'Tìm kiếm dễ dàng', desc: 'Bộ lọc thông minh giúp bạn tìm phòng nhanh chóng.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><path d="M12 8a3 3 0 0 0-3 3c0 1.5 1 2.5 3 4.5 2-2 3-3 3-4.5a3 3 0 0 0-3-3z"></path></svg>', title: 'Hỗ trợ tận tâm', desc: 'Đội ngũ hỗ trợ 24/7 giải đáp mọi thắc mắc của bạn.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><rect x="10" y="12" width="6" height="5" rx="1"></rect></svg>', title: 'Thanh toán an toàn', desc: 'Hỗ trợ thanh toán online an toàn, bảo mật thông tin.' }
]
const steps = [
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>', title: 'Tìm kiếm', desc: 'Nhập nhu cầu của bạn và lọc kết quả phù hợp.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path><circle cx="9" cy="10" r="1"></circle><circle cx="12" cy="10" r="1"></circle><circle cx="15" cy="10" r="1"></circle></svg>', title: 'Liên hệ', desc: 'Trao đổi trực tiếp với chủ phòng hoặc người đăng.' },
  { icon: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>', title: 'Đặt phòng', desc: 'Thỏa thuận và dọn vào ở ngay thôi!' }
]
const reviews = [
  { name: 'Nguyễn Minh Anh', role: 'Sinh viên', avatar: '/images/rooms/main.png', comment: 'Tìm được phòng ưng ý chỉ trong 1 ngày! Giao diện dễ dùng, thông tin rõ ràng và chủ phòng rất nhiệt tình.' },
  { name: 'Trần Hoàng Nam', role: 'Nhân viên văn phòng', avatar: '/images/rooms/living.png', comment: 'Rất hài lòng với dịch vụ của RentOps. Hỗ trợ nhanh chóng và nhiều lựa chọn phòng chất lượng.' },
  { name: 'Lê Thu Trang', role: 'Freelancer', avatar: '/images/rooms/kitchen.png', comment: 'Homestay ở Đà Lạt rất xinh và sạch sẽ. Giá cả hợp lý, sẽ tiếp tục ủng hộ RentOps!' },
  { name: 'Phạm Đăng Khoa', role: 'Kỹ sư CNTT', avatar: '/images/suite.png', comment: 'Thanh toán qua VietQR gạch nợ tự động 24/7 vô cùng tiện lợi. Không còn lo trễ hạn đóng tiền nhà.' },
  { name: 'Vũ Ngọc Khánh', role: 'Chủ chuỗi trọ Quận 7', avatar: '/images/studio.png', comment: 'Phần mềm giúp tôi quản lý 30 phòng dễ dàng. Hóa đơn và nhắc nợ ZNS tự động siêu tiết kiệm thời gian.' }
]
const footerColumns = [
  { title: 'Về chúng tôi', items: ['Giới thiệu', 'Cách hoạt động', 'Tin tức', 'Tuyển dụng', 'Liên hệ'] },
  { title: 'Hỗ trợ', items: ['Trung tâm trợ giúp', 'Quy định sử dụng', 'Chính sách bảo mật', 'Liên hệ hỗ trợ'] },
  { title: 'Danh mục', items: ['Phòng trọ', 'Căn hộ mini', 'Căn hộ dịch vụ', 'Homestay', 'Ở ghép'] },
  { title: 'Liên hệ', items: ['1900 1234', 'support@rentops.vn', '123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh'] }
]

const visibleReviews = computed(() => {
  const count = reviews.length
  return [
    reviews[activeReviewIndex.value % count],
    reviews[(activeReviewIndex.value + 1) % count],
    reviews[(activeReviewIndex.value + 2) % count]
  ]
})

const nextReview = () => {
  activeReviewIndex.value = (activeReviewIndex.value + 1) % reviews.length
}

const prevReview = () => {
  activeReviewIndex.value = (activeReviewIndex.value - 1 + reviews.length) % reviews.length
}

const activeFilterTag = computed(() => {
  if (selectedCategory.value) return selectedCategory.value
  if (selectedArea.value) return selectedArea.value
  if (roomType.value !== 'Tất cả loại phòng') return roomType.value
  return ''
})

const filteredRoomsList = computed(() => {
  return featuredRooms.value.filter(room => {
    if (searchTerm.value && !room.title.toLowerCase().includes(searchTerm.value.toLowerCase()) && !room.location.toLowerCase().includes(searchTerm.value.toLowerCase())) {
      return false
    }
    if (roomType.value !== 'Tất cả loại phòng' && room.category && room.category !== roomType.value && !room.title.includes(roomType.value)) {
      return false
    }
    if (selectedCategory.value && room.category !== selectedCategory.value && !room.title.includes(selectedCategory.value)) {
      return false
    }
    if (selectedArea.value && !room.location.includes(selectedArea.value)) {
      return false
    }
    if (amenity.value !== 'Chọn tiện ích' && !room.tags.some(t => t.includes(amenity.value)) && !room.shortAmenity.includes(amenity.value)) {
      return false
    }
    return true
  })
})

const selectCategory = (title) => {
  if (selectedCategory.value === title) {
    selectedCategory.value = ''
  } else {
    selectedCategory.value = title
    selectedArea.value = ''
  }
  notify(`Đã lọc danh sách theo danh mục: ${title}`)
}

const selectArea = (name) => {
  if (selectedArea.value === name) {
    selectedArea.value = ''
  } else {
    selectedArea.value = name
    selectedCategory.value = ''
  }
  notify(`Đã lọc danh sách theo khu vực: ${name}`)
}

const resetFilters = () => {
  searchTerm.value = ''
  roomType.value = 'Tất cả loại phòng'
  priceRange.value = '0đ - Không giới hạn'
  amenity.value = 'Chọn tiện ích'
  selectedCategory.value = ''
  selectedArea.value = ''
  notify('Đã hiển thị tất cả danh sách phòng')
}

const searchRooms = () => {
  notify(searchTerm.value ? `Đã tìm thấy ${filteredRoomsList.value.length} phòng tại "${searchTerm.value}"` : 'Đã lọc theo bộ lọc được chọn')
}

const submitNewListing = () => {
  const newId = Date.now()
  featuredRooms.value.unshift({
    id: newId,
    title: postForm.value.title,
    location: postForm.value.location,
    price: postForm.value.price,
    image: '/images/rooms/main.png',
    tags: ['Mới đăng', 'Chính chủ', 'Wi-Fi'],
    rating: '5.0',
    reviews: 1,
    badge: 'MỚI',
    photos: 5,
    area: postForm.value.area || '25m²',
    shortAmenity: 'Nội thất cơ bản',
    category: postForm.value.type
  })
  showPostRoomModal.value = false
  postForm.value = { title: '', type: 'Phòng trọ', price: '', location: '', area: '25m²', phone: '' }
  notify('Đã đăng tin phòng thành công! Tin đăng của bạn đang hiển thị ở danh mục nổi bật.')
}

const notify = (message) => {
  toastMessage.value = message
  window.clearTimeout(toastTimer)
  toastTimer = window.setTimeout(() => { toastMessage.value = '' }, 2600)
}

const goToRoomDetail = (room) => router.push(`/room-detail/${room.id}`)
const toggleFavorite = () => { isFavorite.value = !isFavorite.value; notify(isFavorite.value ? 'Đã lưu vào danh sách yêu thích' : 'Đã bỏ lưu') }
const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' })

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
    // Fallback
  }
}

onMounted(loadDashboardStats)
</script>

<style scoped>
:global(*) { box-sizing: border-box; }
:global(body) { margin: 0; background: #f8f9fc; }
button, input, select { font: inherit; }
.home-page { min-height: 100vh; overflow: hidden; color: #273147; background: #f8f9fc; font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif; }
.home-container { width: min(1280px, calc(100% - 64px)); margin: 0 auto; }
.home-header { position: sticky; z-index: 20; top: 0; height: 76px; border-bottom: 1px solid #eef0f5; background: rgba(255,255,255,.96); backdrop-filter: blur(14px); }
.home-header-inner { display: flex; align-items: center; justify-content: space-between; height: 100%; }
.home-brand { display: flex; align-items: center; gap: 10px; color: #172033; border: 0; background: transparent; cursor: pointer; font-size: 22px; font-weight: 800; white-space: nowrap; }
.home-brand-mark { display: grid; place-items: center; width: 44px; height: 44px; color: #fff; border-radius: 16px; background: linear-gradient(135deg,#5e87f5,#5545e8); box-shadow: 0 8px 16px rgba(79,70,229,.22); font-size: 20px; }
.home-nav { display: flex; align-items: center; gap: 30px; margin-left: auto; margin-right: 28px; white-space: nowrap; }
.home-nav a, .favorite-action { color: #4f5b70; border: 0; background: transparent; cursor: pointer; font-size: 15px; font-weight: 700; text-decoration: none; }
.home-nav a:hover, .favorite-action:hover { color: #5147db; }
.home-actions { display: flex; align-items: center; gap: 13px; white-space: nowrap; }
.favorite-action { display: inline-flex; align-items: center; }.bell-action { padding: 0 2px; color: #566177; border: 0; background: transparent; cursor: pointer; font-size: 20px; }
.home-login, .home-listing { display: inline-flex; align-items: center; justify-content: center; height: 45px; border-radius: 16px; cursor: pointer; font-size: 15px; font-weight: 700; text-decoration: none; }
.home-login { width: 128px; color: #5549e8; border: 1px solid #c9c9fb; background: #fff; }.home-login:hover { background: #f8f7ff; }
.home-listing { width: 175px; color: #fff; border: 0; background: linear-gradient(100deg,#4e43de,#873be7); box-shadow: 0 9px 17px rgba(94,63,224,.23); }.home-listing:hover { filter: brightness(.96); }
.hero-section { position: relative; overflow: hidden; background: linear-gradient(115deg,#fff 8%,#f6f8ff 52%,#edf2ff); }
.hero-layout { position: relative; display: grid; grid-template-columns: .84fr 1.16fr; align-items: stretch; min-height: 490px; gap: 0; padding: 0; }
.hero-copy { position: relative; z-index: 3; align-self: center; padding: 30px 22px 45px 40px; }.hero-kicker { display: none; }
.hero-copy h1 { margin: 0; color: #151d35; font-size: clamp(38px, 4.4vw, 60px); line-height: 1.07; letter-spacing: -.045em; }.hero-copy h1 em { color: #6352e6; font-style: normal; }.hero-copy p { max-width: 480px; margin: 19px 0 21px; color: #667287; font-size: 16px; line-height: 1.6; }
.hero-benefits { display: grid; grid-template-columns: repeat(4, 1fr); max-width: 560px; gap: 8px; }.hero-benefits > span { display: grid; grid-template-columns: 32px 1fr; grid-template-rows: 1fr 1fr; align-items: center; column-gap: 7px; min-width: 0; }.hero-benefits b { grid-row: 1 / 3; display: grid; place-items: center; width: 32px; height: 32px; color: #584ddb; border-radius: 8px; background: #e9ebff; font-size: 16px; }.hero-benefits strong { overflow: hidden; color: #425068; font-size: 13px; text-overflow: ellipsis; white-space: nowrap; }.hero-benefits small { overflow: hidden; color: #8e98a9; font-size: 12px; text-overflow: ellipsis; white-space: nowrap; }
.hero-visual { position: relative; z-index: 1; height: 490px; overflow: hidden; border-radius: 0; box-shadow: none; contain: paint; }.hero-visual > img { position: absolute; inset: 0; display: block; width: 108%; height: 108%; margin: -4% 0 0 -4%; object-fit: cover; object-position: center; transform: scale(1.04); }.hero-image-sharp { z-index: 0; }.hero-image-blurred { z-index: 1; filter: blur(10px); opacity: .9; -webkit-mask-image: linear-gradient(90deg, #000 0%, #000 42%, rgba(0,0,0,.75) 53%, transparent 72%); mask-image: linear-gradient(90deg, #000 0%, #000 42%, rgba(0,0,0,.75) 53%, transparent 72%); }.hero-visual::after { position: absolute; z-index: 2; inset: 0; pointer-events: none; content: ''; background: linear-gradient(90deg, rgba(246,248,255,.995) 0%, rgba(246,248,255,.94) 18%, rgba(246,248,255,.68) 34%, rgba(246,248,255,.25) 52%, rgba(246,248,255,.04) 66%, transparent 77%); }
.hero-visual-badge, .hero-visual-dots { display: none; }
.search-section { position: relative; z-index: 3; margin-top: -55px; }.search-section > .home-container { width: min(1120px, calc(100% - 64px)); max-width: 1120px; margin: 0 auto; padding: 0; }.search-card { display: grid; grid-template-columns: 1.35fr 1fr 1fr 1fr auto; align-items: end; gap: 14px; padding: 22px 26px; border: 1px solid #eef0f6; border-radius: 20px; background: #fff; box-shadow: 0 16px 36px rgba(35,44,75,.15); }.search-field { position: relative; display: flex; flex-direction: column; gap: 8px; min-width: 0; padding: 0 10px; }.search-field span { color: #3f4b60; font-size: 15px; font-weight: 800; }.search-field input, .search-field select { width: 100%; height: 40px; padding: 0 22px 0 0; overflow: hidden; color: #8d97a7; border: 0; outline: 0; background: transparent; font-size: 15px; text-overflow: ellipsis; white-space: nowrap; }.search-field select { appearance: none; cursor: pointer; }.search-field b { position: absolute; right: 12px; bottom: 9px; color: #7c86a0; font-size: 16px; }.search-button { display: flex; align-items: center; justify-content: center; gap: 6px; height: 52px; min-width: 130px; padding: 0 24px; color: #fff; border: 0; border-radius: 13px; background: linear-gradient(100deg,#5148dd,#6b4be5); box-shadow: 0 8px 18px rgba(86,75,221,.28); cursor: pointer; font-size: 16px; font-weight: 800; }.search-button:hover { filter: brightness(.96); }
.category-section { margin-top: 42px; }.category-list { display: grid; grid-template-columns: repeat(5, 1fr); gap: 16px; }.category-card { position: relative; display: flex; align-items: center; gap: 16px; min-width: 0; padding: 16px 20px; text-align: left; border: 1px solid #f0f2f7; border-radius: 22px; background: #ffffff; box-shadow: 0 8px 24px rgba(23,32,53,.04); cursor: pointer; transition: all .2s ease; }.category-card:hover { border-color: #dcd9fd; box-shadow: 0 10px 28px rgba(79,70,229,.1); transform: translateY(-2px); }.category-thumb { position: relative; width: 72px; height: 72px; flex: 0 0 72px; }.category-thumb img { display: block; width: 100%; height: 100%; object-fit: cover; border-radius: 18px; }.category-badge { position: absolute; right: -10px; bottom: -8px; display: grid; place-items: center; width: 34px; height: 34px; border-radius: 50%; background: #ffffff; box-shadow: 0 4px 12px rgba(27,34,60,.12); }.category-copy { display: flex; flex-direction: column; gap: 4px; min-width: 0; }.category-copy strong { overflow: hidden; color: #172033; font-size: 16px; font-weight: 800; text-overflow: ellipsis; white-space: nowrap; }.category-copy small { color: #69758a; font-size: 14px; white-space: nowrap; }
.home-section { padding-top: 45px; }.section-title { display: flex; align-items: center; justify-content: space-between; gap: 15px; margin-bottom: 17px; }.section-title h2 { display: inline-block; margin: 0; color: #273147; font-size: 24px; letter-spacing: -.02em; }.section-title button { padding: 0; color: #554bdc; border: 0; background: transparent; cursor: pointer; font-size: 15px; font-weight: 800; }.title-note { display: inline-flex; align-items: center; gap: 4px; margin-left: 8px; color: #788398; font-size: 13px; }.title-note i { display: grid; place-items: center; width: 15px; height: 15px; color: #fff; border-radius: 50%; background: #5d53df; font-style: normal; font-size: 10px; }
.featured-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; }.featured-card { overflow: hidden; border: 1px solid #e7eaf0; border-radius: 11px; background: #fff; box-shadow: 0 6px 16px rgba(30,42,70,.06); cursor: pointer; transition: transform .15s, box-shadow .15s; }.featured-card:hover { box-shadow: 0 12px 25px rgba(30,42,70,.12); transform: translateY(-2px); }.featured-image { position: relative; height: 175px; overflow: hidden; }.featured-image > img { display: block; width: 100%; height: 100%; object-fit: cover; }.room-badge { position: absolute; top: 9px; left: 9px; padding: 4px 7px; color: #fff; border-radius: 5px; background: #f4a719; font-size: 12px; font-weight: 800; }.card-heart { position: absolute; top: 8px; right: 8px; display: grid; place-items: center; width: 26px; height: 26px; color: #697488; border: 0; border-radius: 50%; background: rgba(255,255,255,.9); cursor: pointer; font-size: 16px; }.card-heart:hover { color: #554bdc; }.room-image-count { position: absolute; right: 7px; bottom: 7px; padding: 4px 7px; color: #fff; border-radius: 5px; background: rgba(24,32,49,.54); font-size: 12px; }.featured-body { padding: 12px 12px 14px; }.featured-body h3 { overflow: hidden; margin: 0; color: #344054; font-size: 16px; text-overflow: ellipsis; white-space: nowrap; }.featured-body p { overflow: hidden; margin: 5px 0 8px; color: #8d97a6; font-size: 14px; text-overflow: ellipsis; white-space: nowrap; }.featured-price { display: block; color: #5147dc; font-size: 16px; font-weight: 800; }.room-tags { display: flex; gap: 5px; margin-top: 9px; overflow: hidden; }.room-tags span { padding: 4px 7px; color: #7e899a; border-radius: 4px; background: #f5f6fa; font-size: 12px; white-space: nowrap; }.room-meta { display: flex; align-items: center; justify-content: space-between; gap: 5px; margin-top: 10px; color: #788396; font-size: 13px; }.room-meta span:first-child { color: #eaa716; }.room-meta small { color: #919aa9; font-size: 12px; }
.areas-section { padding-top: 42px; }.area-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 11px; }.area-card { position: relative; height: 220px; overflow: hidden; padding: 0; border: 0; border-radius: 12px; background: #1c273d; cursor: pointer; }.area-card img { display: block; width: 100%; height: 100%; object-fit: cover; opacity: .85; transition: transform .2s; }.area-card:hover img { transform: scale(1.05); }.area-overlay { position: absolute; inset: 0; background: linear-gradient(180deg,transparent 37%,rgba(20,28,45,.82)); }.area-copy { position: absolute; right: 12px; bottom: 14px; left: 12px; display: flex; flex-direction: column; gap: 4px; align-items: flex-start; color: #fff; text-align: left; }.area-copy strong { font-size: 16px; }.area-copy small { font-size: 13px; opacity: .86; }
.amenities-home { padding-bottom: 50px; }.amenity-home-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 13px; }.amenity-home-grid > div { display: grid; grid-template-columns: 35px 1fr; grid-template-rows: auto auto; align-items: center; column-gap: 9px; padding: 13px; border: 1px solid #e7eaf1; border-radius: 11px; background: #fff; }.amenity-home-grid span { grid-row: 1 / 3; display: grid; place-items: center; width: 35px; height: 35px; color: #574cde; border-radius: 10px; background: #edeeff; font-size: 18px; }.amenity-home-grid strong { color: #3d475b; font-size: 15px; }.amenity-home-grid small { margin-top: 4px; color: #919aaa; font-size: 13px; }
.about-section { display: grid; grid-template-columns: .85fr 1fr; align-items: center; gap: 40px; margin-top: 20px; padding: 35px; border-radius: 20px; background: linear-gradient(120deg,#eceeff,#f7f7ff); }.about-kicker { color: #5a50df; font-size: 14px; font-weight: 800; letter-spacing: .23em; }.about-section h2 { margin: 10px 0; color: #202b45; font-size: 32px; line-height: 1.12; }.about-section h2 em { color: #6252df; font-style: normal; }.about-section p { max-width: 420px; color: #6d788d; font-size: 16px; line-height: 1.6; }.about-section button { margin-top: 5px; padding: 10px 18px; color: #fff; border: 0; border-radius: 9px; background: #584ddd; cursor: pointer; font-size: 14px; font-weight: 700; }.about-section img { width: 100%; height: 185px; object-fit: cover; border-radius: 14px; }
.why-section { margin-top: 48px; padding: 42px 30px 48px; border-radius: 22px; background: #fff; border: 1px solid #edf0f7; box-shadow: 0 10px 30px rgba(35,45,75,.04); }.why-section h2, .steps-section h2, .reviews-section h2 { margin: 0 0 36px; color: #172033; text-align: center; font-size: 27px; font-weight: 800; }.why-section h2 em { color: #554bdc; font-style: normal; }.why-grid { display: grid; grid-template-columns: repeat(5, 1fr); align-items: start; }.why-grid article { display: flex; flex-direction: column; align-items: center; padding: 0 16px; text-align: center; border-right: 1px solid #eceef5; }.why-grid article:last-child { border-right: 0; }.why-grid span { display: grid; place-items: center; width: 50px; height: 50px; margin-bottom: 18px; color: #554bdc; border-radius: 50%; background: #f2f3ff; }.why-grid strong { margin-bottom: 8px; color: #172033; font-size: 16px; font-weight: 800; }.why-grid small { color: #69758a; font-size: 14px; line-height: 1.5; max-width: 195px; }
.steps-section { padding-top: 55px; }.steps-grid { display: flex; align-items: flex-start; justify-content: space-between; max-width: 960px; margin: 0 auto; }.step-card { display: flex; flex-direction: column; align-items: center; text-align: center; flex: 1; }.step-top { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }.step-number { display: grid; place-items: center; width: 38px; height: 38px; color: #554bdc; border: 1.5px solid #d5d7ff; border-radius: 50%; background: #fff; font-size: 16px; font-weight: 700; }.step-icon-circle { display: grid; place-items: center; width: 52px; height: 52px; color: #554bdc; border-radius: 50%; background: #f2f3ff; }.step-card strong { margin-bottom: 8px; color: #172033; font-size: 17px; font-weight: 800; }.step-card small { color: #69758a; font-size: 14px; line-height: 1.5; max-width: 215px; }.step-divider { display: grid; place-items: center; align-self: flex-start; margin-top: 19px; }
.reviews-section { padding-top: 55px; }.reviews-grid { position: relative; display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; max-width: 1120px; margin: auto; }.reviews-grid article { min-height: 165px; padding: 19px; border: 1px solid #ebedf3; border-radius: 13px; background: #fff; box-shadow: 0 7px 20px rgba(30,42,70,.06); }.review-user { display: flex; align-items: center; gap: 11px; }.review-user img { width: 45px; height: 45px; object-fit: cover; border-radius: 50%; }.review-user span { display: flex; flex-direction: column; gap: 3px; }.review-user strong { color: #3c4659; font-size: 16px; }.review-user small { color: #8d97a6; font-size: 13px; }.review-user b { color: #f0ae1a; font-size: 13px; letter-spacing: 1px; }.reviews-grid article p { margin: 17px 0 0; color: #69758a; font-size: 15px; line-height: 1.65; }.review-arrow { position: absolute; z-index: 2; top: 50%; display: grid; place-items: center; width: 35px; height: 35px; color: #5b51dc; border: 1px solid #e3e4f2; border-radius: 50%; background: #fff; box-shadow: 0 3px 8px rgba(34,42,72,.08); cursor: pointer; transform: translateY(-50%); font-size: 18px; }.review-arrow:first-child { left: -17px; }.review-arrow:last-child { right: -17px; }.listing-cta { display: flex; align-items: center; justify-content: space-between; min-height: 170px; margin-top: 42px; padding: 30px 38px; overflow: hidden; color: #fff; border-radius: 16px; background: linear-gradient(105deg,#4d45db,#7161e7); box-shadow: 0 12px 25px rgba(78,70,210,.2); }.listing-cta h2 { margin: 0; font-size: 28px; }.listing-cta p { margin: 9px 0 16px; color: rgba(255,255,255,.78); font-size: 16px; }.listing-cta button { padding: 11px 20px; color: #554bdc; border: 0; border-radius: 7px; background: #fff; cursor: pointer; font-size: 15px; font-weight: 700; }.listing-cta button span { margin-left: 7px; font-size: 16px; }.cta-room-art { position: relative; width: 300px; height: 145px; margin-right: 8px; overflow: hidden; border-radius: 11px; }.cta-room-art img { width: 100%; height: 100%; object-fit: cover; opacity: .75; mix-blend-mode: screen; }.cta-room-art span { position: absolute; right: 27px; bottom: 14px; color: #fff; font-size: 52px; opacity: .75; }
.home-footer { margin-top: 32px; padding-top: 25px; background: #fff; border-top: 1px solid #edf0f4; }.footer-grid { display: grid; grid-template-columns: 1.5fr repeat(4, 1fr); gap: 35px; padding-bottom: 21px; }.footer-intro .home-brand { font-size: 18px; }.footer-intro .home-brand-mark { width: 32px; height: 32px; border-radius: 9px; font-size: 15px; }.footer-intro p { max-width: 240px; margin: 11px 0; color: #8b95a4; font-size: 14px; line-height: 1.55; }.footer-social { display: flex; gap: 7px; }.footer-social button { display: grid; place-items: center; width: 24px; height: 24px; padding: 0; color: #687387; border: 0; border-radius: 50%; background: #f0f2f7; cursor: pointer; font-size: 12px; }.footer-column { display: flex; flex-direction: column; align-items: flex-start; gap: 8px; }.footer-column h3 { margin: 2px 0 5px; color: #354055; font-size: 15px; font-weight: 700; }.footer-column button { padding: 0; color: #8993a2; border: 0; background: transparent; cursor: pointer; text-align: left; font-size: 14px; }.footer-column button:hover { color: #554bdc; }.footer-copyright { display: flex; align-items: center; justify-content: center; min-height: 36px; color: #9ca4b1; border-top: 1px solid #f0f1f5; font-size: 13px; }.footer-copyright button { position: absolute; right: 24px; display: grid; place-items: center; width: 26px; height: 26px; color: #5b51dc; border: 0; border-radius: 50%; background: #e9e9ff; cursor: pointer; font-size: 15px; }
.home-toast { position: fixed; z-index: 50; right: 22px; bottom: 22px; padding: 11px 15px; color: #fff; border-radius: 9px; background: #273147; box-shadow: 0 10px 24px rgba(22,32,53,.2); font-size: 15px; }
@media (min-width: 1345px) { .hero-visual { position: absolute; top: 0; right: auto; bottom: 0; left: 50%; width: calc(100vw + 80px); height: auto; margin: 0; transform: translateX(-50%); } }
@media (max-width: 1100px) { .home-nav { gap: 17px; margin-right: 15px; }.home-actions { gap: 8px; }.home-login { width: 110px; }.home-listing { width: 155px; }.hero-layout { gap: 22px; }.hero-copy h1 { font-size: 44px; }.category-list { gap: 8px; }.area-grid { gap: 8px; } }
@media (max-width: 850px) { .home-container { width: min(100% - 32px, 720px); }.home-header { height: 68px; }.home-nav { display: none; }.home-actions { margin-left: auto; }.favorite-action { display: block; }.bell-action { display: none; }.home-login { width: 100px; height: 39px; font-size: 13px; }.home-listing { display: none; }.hero-layout { grid-template-columns: 1fr; padding-top: 28px; }.hero-copy { padding-left: 0; }.hero-copy h1 { font-size: clamp(34px, 8vw, 48px); }.hero-copy p { max-width: 520px; }.hero-visual { position: relative; top: auto; right: auto; bottom: auto; left: auto; width: auto; height: min(55vw, 390px); min-height: 260px; margin: 0; transform: none; }.search-section { margin-top: -12px; }.search-section > .home-container { padding: 0 16px; }.search-card { grid-template-columns: repeat(2, 1fr); }.search-button { width: 100%; }.category-list { grid-template-columns: repeat(3, 1fr); }.featured-grid { grid-template-columns: repeat(2, 1fr); }.area-grid { grid-template-columns: repeat(3, 1fr); }.amenity-home-grid { grid-template-columns: repeat(2, 1fr); }.about-section { grid-template-columns: 1fr; }.why-grid { grid-template-columns: repeat(3, 1fr); row-gap: 18px; }.why-grid article:nth-child(3) { border-right: 0; }.steps-grid { grid-template-columns: 1fr 28px 1fr 28px 1fr; }.listing-cta { padding: 21px; }.cta-room-art { width: 190px; } .footer-grid { grid-template-columns: repeat(2, 1fr); gap: 22px; }.footer-intro { grid-column: 1 / -1; } }
@media (max-width: 520px) { .home-container { width: calc(100% - 24px); }.home-brand { font-size: 18px; }.home-brand-mark { width: 38px; height: 38px; border-radius: 13px; font-size: 16px; }.favorite-action { font-size: 12px; }.hero-copy h1 { font-size: 36px; }.hero-kicker { font-size: 10px; letter-spacing: .13em; }.hero-benefits { grid-template-columns: repeat(2, 1fr); gap: 12px; }.hero-visual { height: 275px; }.search-section { margin-top: -10px; }.search-section > .home-container { padding: 0 12px; }.search-card { grid-template-columns: 1fr; padding: 13px; }.search-field { min-height: 39px; border-bottom: 1px solid #f0f1f5; }.search-button { height: 42px; }.category-list { grid-template-columns: repeat(2, 1fr); }.category-card:last-child { grid-column: 1 / -1; }.featured-grid { gap: 9px; }.featured-image { height: 135px; }.featured-body { padding: 9px 8px; }.featured-body h3 { font-size: 13px; }.room-tags { display: none; }.room-meta { margin-top: 8px; font-size: 10px; }.area-grid { grid-template-columns: repeat(2, 1fr); }.area-card { height: 175px; }.amenity-home-grid { grid-template-columns: 1fr; }.about-section { padding: 23px; }.about-section h2 { font-size: 26px; }.why-section { margin-top: 22px; }.why-grid { grid-template-columns: repeat(2, 1fr); }.why-grid article:nth-child(2), .why-grid article:nth-child(4) { border-right: 0; }.why-grid article:nth-child(3) { border-right: 1px solid #eceef5; }.steps-grid { grid-template-columns: 1fr; gap: 13px; }.step-arrow { display: none; }.reviews-grid { grid-template-columns: 1fr; margin-right: 7px; margin-left: 7px; }.review-arrow { display: none; }.listing-cta { display: block; }.cta-room-art { width: 100%; height: 95px; margin-top: 15px; }.footer-grid { grid-template-columns: repeat(2, 1fr); gap: 18px 12px; }.footer-copyright { justify-content: flex-start; padding-right: 34px; }.footer-copyright button { right: 12px; }.home-toast { right: 12px; bottom: 12px; left: 12px; text-align: center; } }
</style>
