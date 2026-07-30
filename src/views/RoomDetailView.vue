<template>
  <div class="detail-page">
    <header class="home-header">
      <div class="home-container home-header-inner">
        <button class="home-brand" type="button" @click="goBack">
          <span class="home-brand-mark">R</span>
          <span>RentOps</span>
        </button>

        <nav class="home-nav" aria-label="Điều hướng chính">
          <RouterLink to="/landing">Trang chủ</RouterLink>
          <RouterLink to="/landing#search">Tìm phòng</RouterLink>
          <RouterLink to="/landing#areas">Khu vực</RouterLink>
          <RouterLink to="/landing#categories">Loại phòng</RouterLink>
          <RouterLink to="/landing#amenities">Tiện ích</RouterLink>
          <RouterLink to="/landing#about">Về chúng tôi</RouterLink>
          <button class="favorite-action" type="button" @click="toggleFavorite">
            <UiIcon name="heart" :size="15" :fill="isFavorite ? 'currentColor' : 'none'" /> Yêu thích
          </button>
        </nav>

        <div class="home-actions">
          <RouterLink class="home-login" to="/login">Đăng nhập</RouterLink>
          <button class="home-listing" type="button" @click="notify('Tính năng đăng tin phòng đang được chuẩn bị')">Đăng tin phòng +</button>
        </div>
      </div>
    </header>

    <main class="home-container content-shell">
      <div class="breadcrumbs">
        <button type="button" @click="goBack">Khám phá</button>
        <span>/</span>
        <button type="button" @click="goBack">{{ currentRoom.category }}</button>
        <span>/</span>
        <span class="muted">Chi tiết {{ currentRoom.category }}</span>
      </div>

      <section class="title-row">
        <div>
          <div class="eyebrow"><span class="verified-dot"><UiIcon name="check" :size="11" /></span> {{ currentRoom.badge || 'Được yêu thích' }}</div>
          <h1>{{ currentRoom.title }}</h1>
          <div class="property-meta">
            <span class="location"><UiIcon name="pin" :size="16" /> {{ currentRoom.address || currentRoom.location }}</span>
            <span class="dot">·</span>
            <span class="rating"><UiIcon name="star" :size="15" fill="currentColor" /> {{ currentRoom.rating }}</span>
            <button class="review-link" type="button" @click="activeTab = 'reviews'">{{ currentRoom.reviewsCount }} đánh giá</button>
          </div>
        </div>
        <div class="title-actions">
          <button class="round-action" type="button" :class="{ active: isFavorite }" aria-label="Lưu tin" @click="toggleFavorite">
            <UiIcon name="heart" :size="19" :fill="isFavorite ? 'currentColor' : 'none'" />
          </button>
          <button class="round-action" type="button" aria-label="Chia sẻ" @click="shareRoom">
            <UiIcon name="share" :size="18" />
          </button>
        </div>
      </section>

      <section class="main-grid">
        <div class="gallery-column">
          <div class="hero-gallery">
            <img :src="activeImage.src" :alt="activeImage.alt" class="hero-image" />
            <div class="image-shade"></div>
            <span class="gallery-badge"><UiIcon name="spark" :size="12" /> Ảnh nổi bật</span>
            <button class="gallery-arrow previous" type="button" aria-label="Ảnh trước" @click="previousImage">
              <UiIcon name="arrow-left" :size="18" />
            </button>
            <button class="gallery-arrow next" type="button" aria-label="Ảnh tiếp theo" @click="nextImage">
              <UiIcon name="arrow-right" :size="18" />
            </button>
            <button class="photo-count" type="button" @click="showGallery = true">
              <UiIcon name="grid" :size="15" /> 1 / {{ galleryImages.length }} ảnh
            </button>
          </div>

          <div class="thumbnail-row">
            <button
              v-for="(image, index) in galleryImages.slice(0, 5)"
              :key="image.src"
              type="button"
              class="thumbnail"
              :class="{ selected: index === activeImageIndex }"
              @click="activeImageIndex = index"
            >
              <img :src="image.src" :alt="image.alt" />
              <span v-if="index === 4" class="more-photos">+{{ galleryImages.length - 5 }} ảnh</span>
            </button>
          </div>

          <nav class="detail-tabs" aria-label="Thông tin căn hộ">
            <button
              v-for="tab in tabs"
              :key="tab.key"
              type="button"
              :class="{ active: activeTab === tab.key }"
              @click="activeTab = tab.key"
            >{{ tab.label }}</button>
          </nav>

          <div class="tab-content">
            <template v-if="activeTab === 'overview'">
              <section class="intro-section">
                <h2>Giới thiệu về nơi ở</h2>
                <p>{{ currentRoom.description }}</p>
                <button class="read-more" type="button" @click="activeTab = 'rules'">Xem thêm <span>→</span></button>
              </section>

              <section class="feature-strip">
                <div v-for="feature in quickFeatures" :key="feature.label" class="feature-item">
                  <span class="feature-icon"><UiIcon :name="feature.icon" :size="17" /></span>
                  <span><strong>{{ feature.value }}</strong><small>{{ feature.label }}</small></span>
                </div>
              </section>

              <section class="amenity-section">
                <div class="section-heading"><h2>Tiện nghi nổi bật</h2><button type="button" @click="activeTab = 'amenities'">Xem tất cả</button></div>
                <div class="amenity-grid">
                  <div v-for="amenity in amenities.slice(0, 6)" :key="amenity.label" class="amenity-item">
                    <UiIcon :name="amenity.icon" :size="18" />
                    <span>{{ amenity.label }}</span>
                  </div>
                </div>
              </section>
            </template>

            <section v-else-if="activeTab === 'amenities'" class="tab-panel">
              <h2>Tất cả tiện nghi</h2>
              <div class="amenity-grid expanded">
                <div v-for="amenity in amenities" :key="amenity.label" class="amenity-item"><UiIcon :name="amenity.icon" :size="18" /><span>{{ amenity.label }}</span></div>
              </div>
            </section>

            <section v-else-if="activeTab === 'reviews'" class="tab-panel">
              <div class="review-summary"><span class="big-rating">{{ currentRoom.rating }}</span><span><span class="stars">★★★★★</span><small>{{ currentRoom.reviewsCount }} đánh giá từ khách thuê</small></span></div>
              <div class="review-list">
                <article v-for="review in reviews" :key="review.name" class="review-card"><div class="review-top"><strong>{{ review.name }}</strong><span>★★★★★</span></div><p>{{ review.text }}</p><small>{{ review.date }}</small></article>
              </div>
            </section>

            <section v-else-if="activeTab === 'rules'" class="tab-panel">
              <h2>Quy định và lưu ý</h2>
              <div class="rules-list"><p v-for="rule in rules" :key="rule"><UiIcon name="check" :size="15" /> {{ rule }}</p></div>
            </section>
          </div>
        </div>

        <aside class="booking-column">
          <div class="booking-card">
            <div class="price-row"><div><strong>{{ currentRoom.price }}</strong><span>{{ currentRoom.pricePeriod || '/ tháng' }}</span></div><span class="instant-label"><UiIcon name="bolt" :size="13" /> Đặt nhanh</span></div>
            <p class="small-note">Đã bao gồm dịch vụ và thuế</p>

            <div class="booking-fields">
              <label class="date-field"><span>Nhận phòng</span><strong>25/06/2024</strong><UiIcon name="calendar" :size="15" /></label>
              <label class="date-field"><span>Trả phòng</span><strong>26/06/2024</strong><UiIcon name="calendar" :size="15" /></label>
              <button class="guest-field" type="button" @click="guestsOpen = !guestsOpen"><span><small>Khách</small><strong>{{ guestCount }} khách</strong></span><UiIcon name="chevron-down" :size="16" /></button>
            </div>

            <div v-if="guestsOpen" class="guest-popover">
              <span>Số khách</span>
              <div class="guest-counter"><button type="button" :disabled="guestCount <= 1" @click="guestCount--">−</button><strong>{{ guestCount }}</strong><button type="button" @click="guestCount++">+</button></div>
            </div>

            <button class="primary-button" type="button" @click="bookNow">Đặt phòng ngay</button>
            <button class="secondary-button" type="button" @click="sendMessage"><UiIcon name="message" :size="15" /> Nhắn tin cho chủ nhà</button>
            <p class="booking-disclaimer">Bạn chưa bị trừ tiền. Bạn có thể huỷ miễn phí trước 24 giờ.</p>

            <div class="trust-list">
              <div v-for="trust in trustItems" :key="trust.title" class="trust-item"><span class="trust-icon"><UiIcon :name="trust.icon" :size="14" /></span><span><strong>{{ trust.title }}</strong><small>{{ trust.description }}</small></span></div>
            </div>
          </div>

          <div class="host-card">
            <div class="host-header"><img src="/images/rooms/living.png" alt="Minh House" /><div><span>Chủ nhà: Minh House</span><small><span class="host-stars">★</span> Superhost · 1.248 đánh giá</small></div><UiIcon name="chevron-right" :size="17" /></div>
            <p>Tham gia từ 05/2021</p>
            <div class="host-stats"><span><strong>128</strong><small>Bất động sản</small></span><span><strong>98%</strong><small>Tỷ lệ phản hồi</small></span><span><strong>&lt; 1 giờ</strong><small>Thời gian phản hồi</small></span></div>
            <button type="button" @click="sendMessage">Xem trang cá nhân</button>
          </div>
        </aside>
      </section>

      <section class="lower-content">
        <div class="lower-grid">
          <div class="lower-main">
            <section class="lower-section amenities-detail">
              <div class="section-heading"><h2>Tiện ích nổi bật</h2><span class="section-caption">Mọi thứ bạn cần cho một kỳ nghỉ thoải mái</span></div>
              <div class="detailed-amenities">
                <div v-for="amenity in detailedAmenities" :key="amenity.label" class="detailed-amenity"><span class="detailed-amenity-icon"><UiIcon :name="amenity.icon" :size="16" /></span><span>{{ amenity.label }}</span></div>
              </div>
            </section>

            <section class="lower-section description-detail">
              <h2>Mô tả chi tiết</h2>
              <div class="description-points">
                <p v-for="point in descriptionPoints" :key="point"><UiIcon name="check" :size="14" /> {{ point }}</p>
              </div>
              <button class="description-more" type="button" @click="activeTab = 'rules'">Xem thêm <UiIcon name="chevron-down" :size="13" /></button>
            </section>

            <section class="lower-section reviews-detail">
              <h2>Đánh giá từ khách hàng</h2>
              <div class="reviews-layout">
                <div class="review-score-column">
                  <div class="review-score-box"><strong>4.8</strong><span>/ 5</span><div class="score-stars">★★★★★</div><small>76 đánh giá</small></div>
                  <button class="write-review" type="button" @click="notify('Tính năng viết đánh giá sẽ sớm được mở')">Viết đánh giá</button>
                </div>
                <div class="rating-breakdown">
                  <div v-for="row in ratingBreakdown" :key="row.stars" class="rating-row"><span>{{ row.stars }} <UiIcon name="star" :size="11" fill="currentColor" /></span><div class="rating-track"><i :style="{ width: row.percent + '%' }"></i></div><strong>{{ row.count }}</strong></div>
                </div>
                <div class="review-feed">
                  <article v-for="review in detailedReviews" :key="review.name" class="feed-review"><img :src="review.avatar" :alt="review.name" /><div><div class="feed-review-heading"><strong>{{ review.name }}</strong><span>{{ review.date }}</span></div><div class="feed-review-stars">★★★★★</div><p>{{ review.text }}</p></div></article>
                  <button class="all-reviews" type="button" @click="activeTab = 'reviews'">Xem tất cả 76 đánh giá <span>→</span></button>
                </div>
              </div>
            </section>
          </div>

          <aside class="location-card">
            <h2>Vị trí trên bản đồ</h2>
            <div class="map-canvas" aria-label="Bản đồ khu vực Bến Nghé">
              <div class="map-road road-one"></div><div class="map-road road-two"></div><div class="map-road road-three"></div><div class="map-road road-four"></div>
              <span class="map-label label-one">Nguyễn Huệ</span><span class="map-label label-two">Tôn Đức Thắng</span><span class="map-label label-three">Lê Thánh Tôn</span>
              <span class="map-marker"><UiIcon name="home" :size="16" /></span>
              <span class="map-point point-one"></span><span class="map-point point-two"></span><span class="map-point point-three"></span>
            </div>
            <h3>Bến Nghé, Quận 1, TP. Hồ Chí Minh</h3>
            <p class="location-note">Vị trí thuận tiện, gần nhiều địa điểm nổi tiếng</p>
            <div class="nearby-list"><div v-for="place in nearbyPlaces" :key="place.name"><span><i></i>{{ place.name }}</span><small>{{ place.time }}</small></div></div>
            <button class="nearby-more" type="button" @click="notify('Đang mở bản đồ khu vực')">Xem thêm địa điểm xung quanh <span>→</span></button>
          </aside>
        </div>

        <section class="similar-section">
          <div class="similar-heading"><h2>Phòng tương tự</h2><button type="button" @click="notify('Đã hiển thị thêm các phòng tương tự')">Xem tất cả</button></div>
          <div class="similar-list">
            <article v-for="room in similarRooms" :key="room.title" class="similar-card" @click="openSimilarRoom(room)">
              <div class="similar-image"><img :src="room.image" :alt="room.title" /><button type="button" aria-label="Lưu phòng" @click.stop="toggleFavorite"><UiIcon name="heart" :size="15" /></button></div>
              <div class="similar-body"><h3>{{ room.title }}</h3><p>{{ room.location }}</p><div class="similar-bottom"><strong>{{ room.price }}</strong><span><UiIcon name="star" :size="12" fill="currentColor" /> {{ room.rating }} <small>({{ room.reviews }})</small></span></div></div>
            </article>
          </div>
          <button class="similar-arrow left" type="button" aria-label="Phòng trước"><UiIcon name="arrow-left" :size="16" /></button><button class="similar-arrow right" type="button" aria-label="Phòng tiếp theo"><UiIcon name="arrow-right" :size="16" /></button>
        </section>

        <footer class="detail-footer">
          <div class="footer-brand"><button class="brand" type="button" @click="goBack"><span class="brand-mark">R</span><span class="brand-name">RentOps</span></button><p>Nền tảng tìm kiếm và đặt phòng đáng tin cậy, giúp bạn tìm không gian lý tưởng cho mỗi hành trình.</p><div class="social-links"><button type="button" @click="notify('Đang mở Facebook')">f</button><button type="button" @click="notify('Đang mở Instagram')">◎</button><button type="button" @click="notify('Đang mở TikTok')">♪</button><button type="button" @click="notify('Đang mở Youtube')">▶</button></div></div>
          <div v-for="column in footerColumns" :key="column.title" class="footer-column"><h3>{{ column.title }}</h3><button v-for="item in column.items" :key="item" type="button" @click="notify(item)">{{ item }}</button></div>
        </footer>
        <div class="footer-bottom"><span>© 2024 RentOps. Tất cả quyền được bảo lưu.</span><button type="button" aria-label="Lên đầu trang" @click="scrollToTop">↑</button></div>
      </section>
    </main>

    <div v-if="toastMessage" class="toast-message" role="status"><UiIcon name="check" :size="16" /> {{ toastMessage }}</div>

    <div v-if="showGallery" class="modal-backdrop" @click.self="showGallery = false">
      <section class="gallery-modal" role="dialog" aria-modal="true" aria-label="Tất cả ảnh">
        <div class="modal-header"><h2>Tất cả ảnh</h2><button type="button" aria-label="Đóng" @click="showGallery = false">×</button></div>
        <div class="modal-grid"><button v-for="(image, index) in galleryImages" :key="image.src" type="button" @click="activeImageIndex = index; showGallery = false"><img :src="image.src" :alt="image.alt" /></button></div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { computed, h, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

onMounted(() => {
  window.scrollTo({ top: 0, left: 0, behavior: 'instant' })
})

const route = useRoute()
const router = useRouter()

const roomDatabase = {
  '1': {
    id: 1,
    title: 'Phòng trọ cao cấp Full nội thất',
    category: 'Phòng trọ',
    location: 'Quận 1, TP. Hồ Chí Minh',
    address: '15 Nguyễn Thị Minh Khai, Phường Đa Kao, Quận 1',
    price: '4.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 120,
    area: '25m²',
    badge: 'Được yêu thích',
    description: 'Phòng trọ cao cấp nằm ngay trung tâm Quận 1, trang bị đầy đủ máy lạnh, tủ lạnh, giường nệm gối và ban công siêu thoáng.',
    images: [
      { src: '/images/suite.png', alt: 'Phòng trọ cao cấp 1' },
      { src: '/images/rooms/living.png', alt: 'Phòng khách' },
      { src: '/images/rooms/kitchen.png', alt: 'Bếp tiện nghi' },
      { src: '/images/rooms/bathroom.png', alt: 'Phòng tắm hiện đại' },
      { src: '/images/bedroom.png', alt: 'Không gian phòng ngủ' }
    ]
  },
  '2': {
    id: 2,
    title: 'Căn hộ mini ban công thoáng mát',
    category: 'Căn hộ mini',
    location: 'Bình Thạnh, TP. Hồ Chí Minh',
    address: '225 Điện Biên Phủ, Phường 15, Bình Thạnh',
    price: '5.800.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.9',
    reviewsCount: 98,
    area: '32m²',
    badge: 'MỚI PHÁT HÀNH',
    description: 'Căn hộ mini thiết kế dạng Duplex gác xếp hiện đại, ban công rộng ngập ánh sáng tự nhiên. Giờ giấc tự do, không chung chủ.',
    images: [
      { src: '/images/studio.png', alt: 'Căn hộ mini ban công' },
      { src: '/images/rooms/main.png', alt: 'Góc phòng khách' },
      { src: '/images/bedroom.png', alt: 'Gác xếp giường ngủ' },
      { src: '/images/rooms/kitchen.png', alt: 'Khu vực bếp' },
      { src: '/images/rooms/bathroom.png', alt: 'Phòng tắm' }
    ]
  },
  '3': {
    id: 3,
    title: 'Căn hộ dịch vụ cao cấp view thành phố',
    category: 'Căn hộ dịch vụ',
    location: 'Phú Nhuận, TP. Hồ Chí Minh',
    address: '88 Nguyễn Văn Trỗi, Phường 8, Phú Nhuận',
    price: '8.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 76,
    area: '45m²',
    badge: 'VIP',
    description: 'Căn hộ dịch vụ tiêu chuẩn 4 sao view sông Sài Gòn, miễn phí dịch vụ dọn phòng 2 lần/tuần, sử dụng hồ bơi & phòng gym free.',
    images: [
      { src: '/images/rooms/main.png', alt: 'Phòng khách sang trọng' },
      { src: '/images/bedroom.png', alt: 'Phòng ngủ ấm cúng' },
      { src: '/images/rooms/kitchen.png', alt: 'Bếp Âu hiện đại' },
      { src: '/images/rooms/bathroom.png', alt: 'Phòng tắm bồn nằm' },
      { src: '/images/suite.png', alt: 'Khu vực tiếp khách' }
    ]
  },
  '4': {
    id: 4,
    title: 'Homestay xinh xắn không gian xanh',
    category: 'Homestay',
    location: 'Đà Lạt, Lâm Đồng',
    address: '12 Khởi Nghĩa Bắc Sơn, Phường 10, Đà Lạt',
    price: '600.000 đ',
    pricePeriod: '/ đêm',
    rating: '4.9',
    reviewsCount: 56,
    area: '20m²',
    badge: 'HOMESTAY',
    description: 'Homestay mang phong cách mộc mạc ngập tràn ánh nắng và sắc hoa Đà Lạt. Phù hợp cho cặp đôi nghỉ dưỡng cuối tuần.',
    images: [
      { src: '/images/rooms/kitchen.png', alt: 'Góc homestay dễ thương' },
      { src: '/images/rooms/main.png', alt: 'View núi mộng mơ' },
      { src: '/images/bedroom.png', alt: 'Phòng ngủ đệm êm' },
      { src: '/images/studio.png', alt: 'Khu vực đọc sách' }
    ]
  },
  '101': {
    id: 101,
    title: 'Phòng trọ cao cấp Full nội thất ban công',
    category: 'Phòng trọ',
    location: 'Quận 1, TP. Hồ Chí Minh',
    address: '42 Lê Duẩn, Phường Bến Nghé, Quận 1',
    price: '4.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 120,
    area: '25m²',
    badge: 'VIP',
    description: 'Phòng trọ mới xây 100%, nội thất nhập khẩu, khu vực an ninh yên tĩnh ngay trung tâm Quận 1.',
    images: [
      { src: '/images/suite.png', alt: 'Phòng trọ cao cấp' },
      { src: '/images/rooms/living.png', alt: 'Không gian sống' },
      { src: '/images/bedroom.png', alt: 'Giường ngủ' }
    ]
  },
  '102': {
    id: 102,
    title: 'Căn hộ mini ban công thoáng mát view phố',
    category: 'Căn hộ mini',
    location: 'Bình Thạnh, TP. Hồ Chí Minh',
    address: '56 D5, Phường 25, Bình Thạnh',
    price: '5.800.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.9',
    reviewsCount: 98,
    area: '32m²',
    badge: 'HOT',
    description: 'Căn hộ mini ban công hướng Đông Nam lộng gió, trang bị máy giặt riêng, cửa cuốn bảo vệ 2 lớp.',
    images: [
      { src: '/images/studio.png', alt: 'Căn hộ mini' },
      { src: '/images/rooms/main.png', alt: 'Nội thất phòng' }
    ]
  },
  '103': {
    id: 103,
    title: 'Căn hộ dịch vụ cao cấp view sông hồ bơi',
    category: 'Căn hộ dịch vụ',
    location: 'Phú Nhuận, TP. Hồ Chí Minh',
    address: '120 Phan Xích Long, Phường 2, Phú Nhuận',
    price: '8.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 76,
    area: '45m²',
    badge: 'CHỦ NHÀ UY TÍN',
    description: 'Căn hộ dịch vụ thiết kế phong cách Scandinavian ấm cúng, miễn phí giữ xe máy và dịch vụ giặt ủi.',
    images: [
      { src: '/images/bedroom.png', alt: 'Căn hộ dịch vụ' },
      { src: '/images/rooms/kitchen.png', alt: 'Phòng bếp' }
    ]
  },
  '104': {
    id: 104,
    title: 'Homestay xinh xắn ngập ánh nắng thiên nhiên',
    category: 'Homestay',
    location: 'Đà Lạt, Lâm Đồng',
    address: '55 Hoàng Hoa Thám, Phường 10, Đà Lạt',
    price: '600.000 đ',
    pricePeriod: '/ đêm',
    rating: '4.9',
    reviewsCount: 56,
    area: '20m²',
    badge: 'SIÊU HOT',
    description: 'Căn homestay gỗ ấm áp nhìn ra thung lũng thông xanh ngát, sẵn sàng nướng BBQ ngoài trời.',
    images: [
      { src: '/images/rooms/kitchen.png', alt: 'Homestay Đà Lạt' },
      { src: '/images/rooms/main.png', alt: 'Góc chill' }
    ]
  },
  '201': {
    id: 201,
    title: 'Phòng trọ cao cấp Full nội thất ban công',
    category: 'Phòng trọ',
    location: 'Quận 1, TP. Hồ Chí Minh',
    address: '10 Nguyễn Trãi, Phường Bến Thành, Quận 1',
    price: '4.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 120,
    area: '25m²',
    badge: 'VIP',
    description: 'Phòng trọ khép kín, có ban công trồng cây xanh, nội thất cao cấp full option.',
    images: [
      { src: '/images/suite.png', alt: 'Phòng trọ 201' },
      { src: '/images/rooms/living.png', alt: 'Nội thất' }
    ]
  },
  '202': {
    id: 202,
    title: 'Phòng trọ sinh viên đỗ xe máy miễn phí',
    category: 'Phòng trọ',
    location: 'Thủ Đức, TP. Hồ Chí Minh',
    address: '18 Võ Văn Nâng, Linh Trung, Thủ Đức',
    price: '2.200.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.7',
    reviewsCount: 45,
    area: '18m²',
    badge: 'HOT',
    description: 'Phòng trọ sạch đẹp cho sinh viên gần Làng Đại Học, khu sinh hoạt chung văn minh, giá điện nước bình ổn.',
    images: [
      { src: '/images/rooms/living.png', alt: 'Phòng trọ sinh viên' },
      { src: '/images/rooms/bathroom.png', alt: 'WC riêng' }
    ]
  },
  '203': {
    id: 203,
    title: 'Căn hộ mini ban công thoáng mát view phố',
    category: 'Căn hộ mini',
    location: 'Bình Thạnh, TP. Hồ Chí Minh',
    address: '142 Bùi Đình Túy, Phường 12, Bình Thạnh',
    price: '5.800.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.9',
    reviewsCount: 98,
    area: '32m²',
    badge: 'GIÁ TỐT',
    description: 'Căn hộ mini có gác lửng thông thoáng, cửa sổ kính tràn ngắm view thành phố về đêm.',
    images: [
      { src: '/images/studio.png', alt: 'Căn hộ mini 203' },
      { src: '/images/rooms/main.png', alt: 'Bên trong phòng' }
    ]
  },
  '204': {
    id: 204,
    title: 'Căn hộ mini duplex gác xếp hiện đại',
    category: 'Căn hộ mini',
    location: 'Quận 7, TP. Hồ Chí Minh',
    address: '79 Lâm Văn Bền, Phường Tân Quy, Quận 7',
    price: '6.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.9',
    reviewsCount: 88,
    badge: 'VIP',
    description: 'Căn hộ Duplex gác cao đứng không đụng đầu, bảo vệ trực ban 24/7, thang máy thẻ từ cao cấp.',
    images: [
      { src: '/images/rooms/main.png', alt: 'Duplex gác xếp' },
      { src: '/images/bedroom.png', alt: 'Giường gác' }
    ]
  },
  '205': {
    id: 205,
    title: 'Căn hộ dịch vụ cao cấp view sông hồ bơi',
    category: 'Căn hộ dịch vụ',
    location: 'Phú Nhuận, TP. Hồ Chí Minh',
    address: '202 Hoàng Văn Thụ, Phường 9, Phú Nhuận',
    price: '8.500.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.8',
    reviewsCount: 76,
    badge: 'VIP',
    description: 'Căn hộ dịch vụ trọn gói dịch vụ, thích hợp khách nước ngoài và gia đình trẻ lưu trú.',
    images: [
      { src: '/images/bedroom.png', alt: 'Căn hộ dịch vụ 205' },
      { src: '/images/suite.png', alt: 'Phòng khách' }
    ]
  },
  '206': {
    id: 206,
    title: 'Homestay xinh xắn ngập ánh nắng thiên nhiên',
    category: 'Homestay',
    location: 'Đà Lạt, Lâm Đồng',
    address: '15 Yersin, Phường 9, Đà Lạt',
    price: '600.000 đ',
    pricePeriod: '/ đêm',
    rating: '4.9',
    reviewsCount: 56,
    area: '20m²',
    badge: 'HOMESTAY',
    description: 'Không gian ấm cúng, thiết kế tinh tế với khu vườn nhỏ xinh để thưởng trà mỗi sáng.',
    images: [
      { src: '/images/rooms/kitchen.png', alt: 'Homestay 206' },
      { src: '/images/rooms/living.png', alt: 'Khu sảnh' }
    ]
  },
  '207': {
    id: 207,
    title: 'Ở ghép giường tầng căn hộ cao cấp bảo vệ 24/7',
    category: 'Ở ghép',
    location: 'Quận 2, TP. Hồ Chí Minh',
    address: 'Thảo Điền Pearl, 12 Quốc Hương, Quận 2',
    price: '1.200.000 đ',
    pricePeriod: '/ người / tháng',
    rating: '4.6',
    reviewsCount: 34,
    area: '15m²',
    badge: 'Ở GHÉP',
    description: 'Tìm bạn ở ghép chung cư cao cấp Thảo Điền, đầy đủ tiện ích hồ bơi, gym, môi trường lịch sự văn minh.',
    images: [
      { src: '/images/rooms/bathroom.png', alt: 'Phòng ở ghép' },
      { src: '/images/suite.png', alt: 'Khu vực sinh hoạt chung' }
    ]
  },
  '208': {
    id: 208,
    title: 'Phòng trọ yên tĩnh giờ giấc tự do',
    category: 'Phòng trọ',
    location: 'Gò Vấp, TP. Hồ Chí Minh',
    address: '350 Phạm Văn Đồng, Phường 1, Gò Vấp',
    price: '3.000.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.7',
    reviewsCount: 52,
    area: '22m²',
    badge: 'GIỜ TỰ DO',
    description: 'Phòng trọ ngõ rộng ô tô vào tận cửa, giờ giấc đi lại tự do ra vào vân tay bảo mật.',
    images: [
      { src: '/images/hero_banner.png', alt: 'Phòng trọ Gò Vấp' },
      { src: '/images/rooms/living.png', alt: 'Góc phòng' }
    ]
  },
  '301': {
    id: 301,
    title: 'Căn hộ Studio thiết kế sang trọng',
    category: 'Căn hộ mini',
    location: 'Đa Kao, Quận 1, TP. Hồ Chí Minh',
    address: '12 Nguyễn Thị Minh Khai, Phường Đa Kao, Quận 1',
    price: '6.200.000 đ',
    pricePeriod: '/ tháng',
    rating: '4.9',
    reviewsCount: 84,
    area: '30m²',
    badge: 'ĐƯỢC YÊU THÍCH',
    description: 'Căn hộ Studio khép kín ngay Phường Đa Kao Quận 1, nội thất cao cấp hiện đại ngập tràn ánh nắng.',
    images: [
      { src: '/images/rooms/main.png', alt: 'Studio Đa Kao' },
      { src: '/images/rooms/living.png', alt: 'Phòng khách' },
      { src: '/images/rooms/kitchen.png', alt: 'Bếp mini' }
    ]
  }
}

const fallbackRoom = (id) => {
  const numId = Number(id) || 101
  const categoriesList = ['Phòng trọ', 'Căn hộ mini', 'Căn hộ dịch vụ', 'Homestay', 'Ở ghép']
  const cat = categoriesList[numId % categoriesList.length]
  const imagesPool = [
    { src: '/images/rooms/main.png', alt: 'Phòng chính' },
    { src: '/images/suite.png', alt: 'Căn hộ sang trọng' },
    { src: '/images/rooms/living.png', alt: 'Phòng khách' },
    { src: '/images/bedroom.png', alt: 'Phòng ngủ' },
    { src: '/images/studio.png', alt: 'Góc làm việc' },
    { src: '/images/rooms/kitchen.png', alt: 'Phòng bếp' }
  ]
  return {
    id: numId,
    title: `${cat} cao cấp thiết kế hiện đại #${numId}`,
    category: cat,
    location: 'Quận 1, TP. Hồ Chí Minh',
    address: `Số ${numId} Nguyễn Thị Minh Khai, Phường Đa Kao, Quận 1, TP. Hồ Chí Minh`,
    price: `${(3.2 + (numId % 5) * 0.9).toFixed(1)}00.000 đ`,
    pricePeriod: cat === 'Homestay' ? '/ đêm' : '/ tháng',
    rating: (4.5 + (numId % 5) * 0.1).toFixed(1),
    reviewsCount: 30 + (numId % 70),
    area: `${20 + (numId % 25)}m²`,
    badge: 'XÁC THỰC 100%',
    description: `Căn hộ khép kín đầy đủ tiện nghi mã số #${numId}, không gian thoáng mát, yên tĩnh, ban công hướng nắng cực đẹp.`,
    images: imagesPool
  }
}

const currentRoom = computed(() => {
  const idStr = String(route.params.id || '101')
  return roomDatabase[idStr] || fallbackRoom(idStr)
})

const activeImageIndex = ref(0)
const activeTab = ref('overview')
const isFavorite = ref(false)
const guestsOpen = ref(false)
const guestCount = ref(2)
const showGallery = ref(false)
const toastMessage = ref('')
let toastTimer

watch(() => route.params.id, () => {
  activeImageIndex.value = 0
  window.scrollTo({ top: 0, behavior: 'smooth' })
})

const galleryImages = computed(() => currentRoom.value.images || [])
const activeImage = computed(() => galleryImages.value[activeImageIndex.value] || galleryImages.value[0] || { src: '/images/rooms/main.png', alt: 'Căn hộ' })

const quickFeatures = computed(() => [
  { icon: 'home', value: currentRoom.value.area || '25m²', label: 'Diện tích' },
  { icon: 'bed', value: '1', label: 'Phòng ngủ' },
  { icon: 'bath', value: '1', label: 'Phòng tắm' },
  { icon: 'sofa', value: '1', label: 'Phòng khách' },
  { icon: 'wifi', value: 'Miễn phí', label: 'Wi-Fi' }
])

const tabs = [
  { key: 'overview', label: 'Tổng quan' },
  { key: 'amenities', label: 'Tiện nghi' },
  { key: 'reviews', label: 'Đánh giá' },
  { key: 'rules', label: 'Quy định' },
  { key: 'overview', label: 'Chủ nhà' }
]

const amenities = [
  { icon: 'wifi', label: 'Wi-Fi tốc độ cao' },
  { icon: 'tv', label: 'TV thông minh' },
  { icon: 'air', label: 'Điều hòa' },
  { icon: 'kitchen', label: 'Bếp đầy đủ' },
  { icon: 'washing', label: 'Máy giặt' },
  { icon: 'parking', label: 'Chỗ đậu xe' },
  { icon: 'desk', label: 'Bàn làm việc' },
  { icon: 'lock', label: 'Khóa thông minh' }
]

const reviews = [
  { name: 'Ngọc Anh', text: 'Căn hộ rất sạch sẽ, đúng như hình. Vị trí trung tâm và chủ nhà hỗ trợ cực kỳ nhanh.', date: 'Tháng 5, 2024' },
  { name: 'Minh Tuấn', text: 'Không gian đẹp, yên tĩnh. Mình sẽ quay lại trong chuyến công tác sau.', date: 'Tháng 4, 2024' }
]

const rules = ['Không hút thuốc trong căn hộ', 'Không tổ chức tiệc hoặc sự kiện', 'Giữ yên lặng sau 22:00', 'Nhận phòng từ 14:00, trả phòng trước 12:00']
const detailedAmenities = [
  { icon: 'air', label: 'Điều hòa' },
  { icon: 'wifi', label: 'Wi-Fi miễn phí' },
  { icon: 'tv', label: 'TV màn hình phẳng' },
  { icon: 'kitchen', label: 'Bếp đầy đủ' },
  { icon: 'washing', label: 'Máy giặt' },
  { icon: 'lock', label: 'Tủ lạnh' },
  { icon: 'parking', label: 'Bãi đỗ xe' },
  { icon: 'home', label: 'Thang máy' },
  { icon: 'shield', label: 'Bảo vệ 24/7' },
  { icon: 'users', label: 'Hồ bơi' },
  { icon: 'sofa', label: 'Phòng gym' },
  { icon: 'check', label: 'Không hút thuốc' }
]
const descriptionPoints = [
  'Tọa lạc tại vị trí đắc địa ngay trung tâm thành phố, chỉ vài phút đi bộ đến các tuyến đường lớn.',
  'Căn hộ được thiết kế hiện đại, nội thất cao cấp, đầy đủ tiện nghi.',
  'Không gian làm việc riêng, Wi-Fi tốc độ cao, phù hợp cho người đi làm và học tập.',
  'Khu vực an ninh, yên tĩnh, bảo mật khóa thẻ từ / vân tay.'
]
const ratingBreakdown = [
  { stars: 5, percent: 86, count: 68 },
  { stars: 4, percent: 15, count: 6 },
  { stars: 3, percent: 5, count: 1 },
  { stars: 2, percent: 2, count: 1 },
  { stars: 1, percent: 0, count: 0 }
]
const detailedReviews = [
  { name: 'Trần Minh Tuấn', date: '2 tuần trước', avatar: '/images/rooms/main.png', text: 'Căn hộ đẹp, sạch sẽ, view thành phố tuyệt vời. Chủ nhà thân thiện và hỗ trợ nhanh chóng.' },
  { name: 'Nguyễn Thảo Vy', date: '1 tháng trước', avatar: '/images/rooms/living.png', text: 'Vị trí quá tiện lợi, gần trung tâm và nhiều quán ăn ngon. Sẽ quay lại lần sau!' },
  { name: 'Lê Hoàng Nam', date: '2 tháng trước', avatar: '/images/rooms/kitchen.png', text: 'Không gian thoải mái, đầy đủ tiện nghi.' }
]
const nearbyPlaces = [
  { name: 'Trung tâm thương mại', time: '5 phút đi bộ' },
  { name: 'Siêu thị tiện lợi 24/7', time: '2 phút đi bộ' },
  { name: 'Công viên cây xanh', time: '10 phút đi bộ' }
]
const similarRooms = [
  { id: 201, title: 'Phòng trọ cao cấp Full nội thất', location: 'Quận 1, TP. Hồ Chí Minh', price: '4.500.000 đ / tháng', rating: '4.8', reviews: 120, image: '/images/suite.png' },
  { id: 203, title: 'Căn hộ mini ban công thoáng mát', location: 'Bình Thạnh, TP. Hồ Chí Minh', price: '5.800.000 đ / tháng', rating: '4.9', reviews: 98, image: '/images/studio.png' },
  { id: 205, title: 'Căn hộ dịch vụ cao cấp view sông', location: 'Phú Nhuận, TP. Hồ Chí Minh', price: '8.500.000 đ / tháng', rating: '4.8', reviews: 76, image: '/images/bedroom.png' },
  { id: 204, title: 'Căn hộ Duplex gác xếp hiện đại', location: 'Quận 7, TP. Hồ Chí Minh', price: '6.500.000 đ / tháng', rating: '4.9', reviews: 88, image: '/images/rooms/main.png' }
]
const footerColumns = [
  { title: 'Về chúng tôi', items: ['Giới thiệu', 'Tuyển dụng', 'Tin tức', 'Điều khoản dịch vụ', 'Chính sách bảo mật'] },
  { title: 'Hỗ trợ', items: ['Trung tâm trợ giúp', 'Hướng dẫn đặt phòng', 'Chính sách hủy', 'Liên hệ hỗ trợ'] },
  { title: 'Dành cho chủ nhà', items: ['Đăng cho thuê phòng', 'Quản lý phòng', 'Chính sách hợp tác', 'Bảng giá dịch vụ'] },
  { title: 'Liên hệ', items: ['1900 1234', 'support@rentops.vn', '123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh'] }
]
const trustItems = [
  { icon: 'shield', title: 'Xác nhận ngay lập tức', description: 'Đặt phòng và nhận hướng dẫn tự động' },
  { icon: 'clock', title: 'Hỗ trợ 24/7', description: 'Đội ngũ hỗ trợ luôn sẵn sàng giúp bạn' },
  { icon: 'lock', title: 'Thanh toán an toàn', description: 'Bảo mật thông tin và giao dịch của bạn' }
]

const notify = (message) => {
  toastMessage.value = message
  window.clearTimeout(toastTimer)
  toastTimer = window.setTimeout(() => { toastMessage.value = '' }, 2800)
}

const previousImage = () => { activeImageIndex.value = (activeImageIndex.value - 1 + galleryImages.value.length) % galleryImages.value.length }
const nextImage = () => { activeImageIndex.value = (activeImageIndex.value + 1) % galleryImages.value.length }
const toggleFavorite = () => { isFavorite.value = !isFavorite.value; notify(isFavorite.value ? 'Đã lưu căn hộ vào danh sách yêu thích' : 'Đã bỏ lưu căn hộ') }
const shareRoom = async () => {
  try {
    await navigator.clipboard?.writeText(window.location.href)
    notify('Đã sao chép liên kết căn hộ')
  } catch {
    notify('Bạn có thể sao chép liên kết trên thanh địa chỉ')
  }
}
const bookNow = () => notify('Yêu cầu đặt phòng đã được ghi nhận')
const sendMessage = () => notify('Đã mở cuộc trò chuyện với chủ nhà')
const goBack = () => router.push('/landing')
const openSimilarRoom = (targetRoom) => {
  activeImageIndex.value = 0
  router.push(`/room-detail/${targetRoom.id || 101}`)
}
const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' })

const iconPaths = {
  'arrow-left': 'M15 5l-7 7 7 7M8 12h12', 'arrow-right': 'M9 5l7 7-7 7M16 12H4',
  heart: 'M20.8 8.7c0 5.1-8.8 10.1-8.8 10.1S3.2 13.8 3.2 8.7A4.7 4.7 0 0 1 12 6.5a4.7 4.7 0 0 1 8.8 2.2Z',
  share: 'M18 8a3 3 0 1 0-2.8-4A3 3 0 0 0 15 5c0 .3 0 .5.1.8l-6.3 3.6a3 3 0 1 0 0 5.2l6.3 3.6A3 3 0 1 0 16 16c0-.3 0-.6-.1-.8l6.3-3.6A3 3 0 0 0 18 8ZM6 14a2 2 0 1 1 0-4 2 2 0 0 1 0 4Zm10-8a2 2 0 1 1 4 0 2 2 0 0 1-4 0Zm0 12a2 2 0 1 1 4 0 2 2 0 0 1-4 0Z',
  pin: 'M12 21s7-5.3 7-12A7 7 0 0 0 5 9c0 6.7 7 12 7 12Z M12 11.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z',
  star: 'm12 3 2.8 5.7 6.2.9-4.5 4.4 1.1 6.2-5.6-3-5.6 3 1.1-6.2-4.5-4.4 6.2-.9L12 3Z',
  check: 'm5 12 4.2 4.2L19 6.5', spark: 'm12 2 1.6 6.4L20 10l-6.4 1.6L12 18l-1.6-6.4L4 10l6.4-1.6L12 2Z',
  grid: 'M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z', bolt: 'm13 2-8 11h6l-1 9 8-12h-6l1-8Z',
  calendar: 'M5 4h14v16H5zM8 2v4M16 2v4M5 9h14', 'chevron-down': 'm6 9 6 6 6-6', 'chevron-right': 'm9 6 6 6-6 6',
  message: 'M20 11.5a7.5 7.5 0 0 1-8 7.5 8.7 8.7 0 0 1-3.8-.9L4 20l1.4-3.6A7.4 7.4 0 0 1 4 11.5 7.7 7.7 0 0 1 12 4a7.7 7.7 0 0 1 8 7.5Z',
  shield: 'M12 3 19 6v5c0 4.6-3 8.1-7 10-4-1.9-7-5.4-7-10V6l7-3Z', clock: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Zm0-14v5l3 2',
  home: 'm3 10 9-7 9 7v10H3V10Zm6 10v-6h6v6', bed: 'M3 18v-7h18v7M3 14h18M6 11V8h5v3M3 18v3M21 18v3', bath: 'M4 12h16M6 12V6a3 3 0 0 1 5.7-1.3M4 12c0 4 2 6 8 6s8-2 8-6M6 18l-1 3M18 18l1 3', sofa: 'M4 14v-3a3 3 0 0 1 3-3h10a3 3 0 0 1 3 3v3M3 14h18v4H3zM6 18v2M18 18v2', wifi: 'M3 9a14 14 0 0 1 18 0M6 13a9 9 0 0 1 12 0M9 17a4 4 0 0 1 6 0M12 20h.01',
  tv: 'M4 6h16v11H4zM8 21h8M12 17v4M9 3l3 3 3-3', air: 'M4 8h16M6 12h12M8 16h8M5 5h.01M19 5h.01', kitchen: 'M6 3v18M10 3v5a2 2 0 0 1-4 0V3M15 3v18M19 3v18M15 8h4', washing: 'M5 4h14v17H5zM8 8h.01M12 14a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z', parking: 'M5 20V4h7a4 4 0 0 1 0 8H5M5 12h7', desk: 'M4 6h16v8H4zM7 14v6M17 14v6M3 20h18', lock: 'M6 10V7a6 6 0 0 1 12 0v3M5 10h14v11H5z', users: 'M16 20v-1a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v1M9.5 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM16 11a3 3 0 0 0-2.8-2.9M17 15h1a3 3 0 0 1 3 3v1',
}

const UiIcon = (props) => h('svg', { width: props.size || 18, height: props.size || 18, viewBox: '0 0 24 24', fill: props.fill || 'none', stroke: 'currentColor', 'stroke-width': 1.8, 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'aria-hidden': 'true', class: 'ui-icon' }, [h('path', { d: iconPaths[props.name] || iconPaths.check, fill: props.fill && props.fill !== 'none' ? props.fill : 'none' })])
</script>

<style scoped>
:global(*) { box-sizing: border-box; }
:global(body) { background: #f8fafc; font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
button { font: inherit; }
.detail-page { min-height: 100vh; padding-top: 76px; color: #172033; background: #fff; font-size: 15px; font-family: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif; }
.home-container { width: min(1280px, calc(100% - 64px)); margin: 0 auto; }
.home-header { position: fixed; z-index: 20; top: 0; right: 0; left: 0; height: 76px; border-bottom: 1px solid #eef0f5; background: rgba(255,255,255,.96); box-shadow: 0 4px 18px rgba(28,38,67,.06); backdrop-filter: blur(14px); }
.home-header-inner { display: flex; align-items: center; justify-content: space-between; height: 100%; }
.home-brand { display: flex; align-items: center; gap: 10px; color: #172033; border: 0; background: transparent; cursor: pointer; font-size: 22px; font-weight: 800; white-space: nowrap; }
.home-brand-mark { display: grid; place-items: center; width: 44px; height: 44px; color: #fff; border-radius: 16px; background: linear-gradient(135deg,#5e87f5,#5545e8); box-shadow: 0 8px 16px rgba(79,70,229,.22); font-size: 20px; }
.home-nav { display: flex; align-items: center; gap: 30px; margin-left: auto; margin-right: 28px; white-space: nowrap; }
.home-nav a, .favorite-action { color: #4f5b70; border: 0; background: transparent; cursor: pointer; font-size: 15px; font-weight: 700; text-decoration: none; }
.home-nav a:hover, .favorite-action:hover { color: #5147db; }
.home-actions { display: flex; align-items: center; gap: 13px; white-space: nowrap; }
.favorite-action { display: inline-flex; align-items: center; gap: 4px; }
.home-login, .home-listing { display: inline-flex; align-items: center; justify-content: center; height: 45px; border-radius: 16px; cursor: pointer; font-size: 15px; font-weight: 700; text-decoration: none; }
.home-login { width: 128px; color: #5549e8; border: 1px solid #c9c9fb; background: #fff; }.home-login:hover { background: #f8f7ff; }
.home-listing { width: 175px; color: #fff; border: 0; background: linear-gradient(100deg,#4e43de,#873be7); box-shadow: 0 9px 17px rgba(94,63,224,.23); }.home-listing:hover { filter: brightness(.96); }
.header-link, .avatar-button, .round-action, .gallery-arrow, .photo-count, .thumbnail, .detail-tabs button, .read-more, .section-heading button, .host-card button, .modal-header button { border: 0; background: transparent; cursor: pointer; }
.content-shell { padding: 24px 0 80px; }
.breadcrumbs { display: flex; gap: 8px; align-items: center; color: #4f46e5; font-size: 14px; margin-bottom: 14px; }
.breadcrumbs button { border: 0; background: none; padding: 0; color: inherit; cursor: pointer; }
.breadcrumbs .muted { color: #929bad; }
.title-row { display: flex; align-items: flex-end; justify-content: space-between; gap: 20px; margin-bottom: 15px; }
.eyebrow { display: inline-flex; align-items: center; gap: 5px; margin-bottom: 6px; color: #6558df; font-size: 13px; font-weight: 700; }
.verified-dot { width: 18px; height: 18px; border-radius: 50%; display: grid; place-items: center; background: #6456e5; color: #fff; }
h1 { margin: 0; color: #1a2435; font-size: clamp(24px, 2.3vw, 30px); line-height: 1.2; letter-spacing: -.035em; }
.property-meta { display: flex; align-items: center; flex-wrap: wrap; gap: 8px; margin-top: 8px; color: #6e788c; font-size: 14px; }
.location, .rating { display: inline-flex; align-items: center; gap: 4px; }
.rating { color: #f59e0b; font-weight: 800; }
.rating .ui-icon { color: #f59e0b; }
.dot { color: #c5cad4; }
.review-link { border: 0; padding: 0; color: #6e788c; background: none; cursor: pointer; text-decoration: underline; text-underline-offset: 2px; }
.title-actions { display: flex; gap: 8px; }
.round-action { display: grid; place-items: center; width: 38px; height: 38px; color: #6c7587; border: 1px solid #e2e5eb; border-radius: 50%; }
.round-action:hover, .round-action.active { color: #4f46e5; border-color: #c8c4fa; background: #f7f6ff; }
.main-grid { display: grid; grid-template-columns: minmax(0, 1fr) 365px; gap: 25px; align-items: start; }
.hero-gallery { position: relative; height: 430px; overflow: hidden; border-radius: 12px; background: #e8e7e3; }
.hero-image { width: 100%; height: 100%; display: block; object-fit: cover; }
.image-shade { position: absolute; inset: 0; pointer-events: none; background: linear-gradient(180deg, rgba(16,24,40,.08), transparent 27%, transparent 70%, rgba(16,24,40,.12)); }
.gallery-badge { position: absolute; top: 14px; left: 14px; display: inline-flex; align-items: center; gap: 5px; padding: 6px 10px; border-radius: 5px; color: #fff; background: #5a4de5; font-size: 12px; font-weight: 700; box-shadow: 0 4px 12px rgba(24,31,70,.2); }
.gallery-arrow { position: absolute; top: 50%; display: grid; place-items: center; width: 34px; height: 34px; transform: translateY(-50%); border-radius: 50%; color: #4e596d; background: rgba(255,255,255,.95); box-shadow: 0 3px 12px rgba(15,23,42,.13); }
.gallery-arrow:hover { color: #4f46e5; background: #fff; }
.gallery-arrow.previous { left: 12px; }.gallery-arrow.next { right: 12px; }
.photo-count { position: absolute; right: 13px; bottom: 13px; display: flex; align-items: center; gap: 5px; padding: 7px 11px; border-radius: 7px; color: #fff; background: rgba(22,30,48,.62); font-size: 13px; font-weight: 600; backdrop-filter: blur(6px); }
.thumbnail-row { display: grid; grid-template-columns: repeat(5, 1fr); gap: 8px; margin-top: 9px; }
.thumbnail { position: relative; height: 67px; padding: 0; overflow: hidden; border-radius: 7px; background: #f1f2f4; }
.thumbnail img { display: block; width: 100%; height: 100%; object-fit: cover; opacity: .82; transition: opacity .15s; }
.thumbnail:hover img, .thumbnail.selected img { opacity: 1; }.thumbnail.selected { outline: 2px solid #6257df; outline-offset: 1px; }
.more-photos { position: absolute; inset: 0; display: grid; place-items: center; color: #fff; background: rgba(20,26,40,.47); font-size: 14px; font-weight: 800; }
.detail-tabs { display: flex; gap: 25px; height: 52px; margin-top: 14px; border-bottom: 1px solid #eceef2; }
.detail-tabs button { position: relative; padding: 0 0 3px; color: #7d8798; font-size: 14px; font-weight: 600; }
.detail-tabs button.active { color: #4f46e5; }.detail-tabs button.active::after { position: absolute; right: 0; bottom: -1px; left: 0; height: 2px; content: ''; border-radius: 2px 2px 0 0; background: #5549dc; }
.tab-content { padding-top: 19px; }.intro-section h2, .amenity-section h2, .tab-panel h2 { margin: 0 0 8px; color: #242d3e; font-size: 16px; font-weight: 800; }.intro-section p { max-width: 680px; margin: 0; color: #667286; font-size: 14px; line-height: 1.75; }.read-more { display: inline-flex; gap: 7px; margin-top: 7px; padding: 0; color: #4f46e5; font-size: 13px; font-weight: 700; }.read-more span { font-size: 16px; line-height: 10px; }
.feature-strip { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; margin-top: 19px; padding: 15px 10px; border: 1px solid #eff0f4; border-radius: 10px; box-shadow: 0 4px 14px rgba(29,38,62,.03); }.feature-item { display: flex; align-items: center; justify-content: center; gap: 7px; min-width: 0; color: #667286; }.feature-icon { display: grid; place-items: center; width: 30px; height: 30px; flex: 0 0 30px; color: #584fe0; border-radius: 8px; background: #f0efff; }.feature-item span:last-child { display: flex; flex-direction: column; gap: 2px; min-width: 0; }.feature-item strong { color: #394359; font-size: 13px; white-space: nowrap; }.feature-item small { overflow: hidden; color: #97a0af; font-size: 11px; text-overflow: ellipsis; white-space: nowrap; }
.amenity-section { margin-top: 23px; padding-top: 17px; border-top: 1px solid #f0f1f4; }.section-heading { display: flex; align-items: center; justify-content: space-between; }.section-heading button { color: #5549dc; font-size: 13px; font-weight: 700; }.amenity-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px 18px; margin-top: 12px; }.amenity-grid.expanded { grid-template-columns: repeat(3, minmax(0, 1fr)); max-width: 700px; }.amenity-item { display: flex; align-items: center; gap: 9px; color: #6a7487; font-size: 14px; }.amenity-item .ui-icon { color: #6860dd; }
.booking-column { position: sticky; top: 94px; }.booking-card, .host-card { border: 1px solid #e8eaf0; border-radius: 12px; background: #fff; box-shadow: 0 6px 23px rgba(26,35,59,.08); }.booking-card { position: relative; padding: 20px; }.price-row { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }.price-row strong { color: #1c2536; font-size: 24px; letter-spacing: -.03em; }.price-row > div > span { margin-left: 3px; color: #7f8998; font-size: 13px; }.instant-label { display: inline-flex; align-items: center; gap: 3px; color: #4f46e5; font-size: 12px; font-weight: 700; }.small-note { margin: 4px 0 15px; color: #9aa2b0; font-size: 12px; }.booking-fields { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }.date-field, .guest-field { position: relative; display: flex; flex-direction: column; gap: 4px; min-height: 54px; padding: 9px 28px 8px 10px; text-align: left; color: #374054; border: 1px solid #e4e6ec; border-radius: 7px; background: #fff; }.date-field span, .guest-field small { color: #929aaa; font-size: 11px; }.date-field strong, .guest-field strong { font-size: 12px; font-weight: 700; }.date-field .ui-icon, .guest-field .ui-icon { position: absolute; top: 19px; right: 9px; color: #747f92; }.guest-field { grid-column: 1 / -1; flex-direction: row; align-items: center; justify-content: space-between; padding: 8px 10px; }.guest-field span { display: flex; flex-direction: column; gap: 3px; }.guest-field .ui-icon { position: static; }.guest-popover { position: absolute; z-index: 2; right: 18px; left: 18px; display: flex; align-items: center; justify-content: space-between; padding: 11px 12px; color: #555f72; border: 1px solid #e2e5ec; border-radius: 8px; background: #fff; box-shadow: 0 9px 25px rgba(22,33,59,.15); font-size: 13px; }.guest-counter { display: flex; align-items: center; gap: 12px; }.guest-counter button { display: grid; place-items: center; width: 24px; height: 24px; color: #5147d7; border: 1px solid #d9daf3; border-radius: 50%; background: #fafaff; cursor: pointer; }.guest-counter button:disabled { color: #bdc2cb; cursor: not-allowed; }.guest-counter strong { color: #222c3c; font-size: 14px; }
.primary-button, .secondary-button { width: 100%; min-height: 40px; border-radius: 7px; cursor: pointer; font-size: 13px; font-weight: 700; }.primary-button { margin-top: 14px; color: #fff; border: 1px solid #5549dc; background: #594dde; box-shadow: 0 5px 12px rgba(83,73,220,.2); }.primary-button:hover { background: #4e43ce; }.secondary-button { display: flex; align-items: center; justify-content: center; gap: 6px; margin-top: 7px; color: #5549dc; border: 1px solid #bdb9f4; background: #fff; }.secondary-button:hover { background: #f8f7ff; }.booking-disclaimer { margin: 12px 0 16px; color: #9ba3b0; text-align: center; font-size: 11px; line-height: 1.45; }.trust-list { padding-top: 13px; border-top: 1px solid #eff0f3; }.trust-item { display: flex; align-items: flex-start; gap: 9px; margin-top: 12px; }.trust-item:first-child { margin-top: 0; }.trust-icon { display: grid; place-items: center; width: 27px; height: 27px; flex: 0 0 27px; color: #6259dd; border-radius: 50%; background: #f0efff; }.trust-item > span:last-child { display: flex; flex-direction: column; gap: 3px; }.trust-item strong { color: #4d576a; font-size: 12px; }.trust-item small { color: #9ba3b0; font-size: 11px; }
.host-card { margin-top: 12px; padding: 16px; }.host-header { display: flex; align-items: center; gap: 9px; }.host-header img { width: 42px; height: 42px; object-fit: cover; object-position: 58% 45%; border: 2px solid #eeeaff; border-radius: 50%; }.host-header > div { display: flex; flex: 1; flex-direction: column; gap: 4px; }.host-header span { color: #303a4c; font-size: 13px; font-weight: 800; }.host-header small { color: #8a94a3; font-size: 11px; }.host-stars { color: #f1ab24; }.host-header > .ui-icon { color: #99a1af; }.host-card > p { margin: 11px 0 13px 47px; color: #a0a8b4; font-size: 11px; }.host-stats { display: grid; grid-template-columns: repeat(3, 1fr); padding: 11px 0; border-top: 1px solid #f0f1f3; border-bottom: 1px solid #f0f1f3; text-align: center; }.host-stats span { display: flex; flex-direction: column; gap: 3px; border-right: 1px solid #f0f1f3; }.host-stats span:last-child { border-right: 0; }.host-stats strong { color: #4b5567; font-size: 12px; }.host-stats small { color: #9da5b1; font-size: 10px; }.host-card > button { width: 100%; margin-top: 11px; padding: 9px; color: #5549dc; border: 1px solid #c7c3f6; border-radius: 6px; font-size: 12px; font-weight: 700; }.host-card > button:hover { background: #f8f7ff; }
.tab-panel { min-height: 180px; }.review-summary { display: flex; align-items: center; gap: 14px; padding: 15px; border-radius: 10px; background: #f8f7ff; }.big-rating { color: #302b8c; font-size: 32px; font-weight: 800; }.review-summary > span:last-child { display: flex; flex-direction: column; gap: 3px; }.stars, .review-top span { color: #f3a925; letter-spacing: 2px; }.review-summary small { color: #8490a1; font-size: 13px; }.review-list { display: grid; gap: 10px; margin-top: 15px; }.review-card { padding: 13px; border: 1px solid #eceef3; border-radius: 9px; }.review-top { display: flex; justify-content: space-between; }.review-top strong { color: #394255; font-size: 13px; }.review-top span { font-size: 12px; }.review-card p { margin: 7px 0; color: #707b8d; font-size: 13px; line-height: 1.5; }.review-card small { color: #a0a7b2; font-size: 11px; }.rules-list { display: grid; gap: 10px; }.rules-list p { display: flex; align-items: center; gap: 8px; margin: 0; color: #6b7688; font-size: 14px; }.rules-list .ui-icon { color: #5b51dc; }
.toast-message { position: fixed; z-index: 20; right: 22px; bottom: 22px; display: flex; align-items: center; gap: 8px; padding: 11px 15px; color: #fff; border-radius: 8px; background: #253047; box-shadow: 0 10px 28px rgba(15,23,42,.2); font-size: 14px; }.toast-message .ui-icon { color: #a8f0cc; }
.modal-backdrop { position: fixed; z-index: 30; inset: 0; display: grid; place-items: center; padding: 25px; background: rgba(13,19,33,.65); backdrop-filter: blur(4px); }.gallery-modal { width: min(860px, 100%); max-height: min(700px, 90vh); overflow: auto; padding: 20px; border-radius: 15px; background: #fff; }.modal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px; }.modal-header h2 { margin: 0; font-size: 19px; }.modal-header button { width: 30px; height: 30px; color: #657084; border: 1px solid #e5e7ec; border-radius: 50%; font-size: 22px; line-height: 1; }.modal-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }.modal-grid button { min-height: 160px; overflow: hidden; padding: 0; border: 0; border-radius: 8px; background: #f1f2f4; cursor: pointer; }.modal-grid img { display: block; width: 100%; height: 100%; object-fit: cover; }
.lower-content { margin-top: 46px; }
.lower-grid { display: grid; grid-template-columns: minmax(0, 1fr) 365px; gap: 25px; align-items: start; }
.lower-main { min-width: 0; }
.lower-section { padding: 25px 0; border-top: 1px solid #edf0f4; }
.lower-section:first-child { padding-top: 0; border-top: 0; }
.lower-section h2, .location-card h2, .similar-heading h2 { margin: 0; color: #242d3e; font-size: 18px; letter-spacing: -.02em; }
.section-caption { color: #a0a8b5; font-size: 12px; }
.detailed-amenities { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 17px 12px; margin-top: 20px; }
.detailed-amenity { display: flex; align-items: center; gap: 8px; color: #657084; font-size: 13px; }
.detailed-amenity-icon { display: grid; place-items: center; width: 29px; height: 29px; flex: 0 0 29px; color: #5b50d8; border-radius: 8px; background: #f3f2ff; }
.description-points { display: grid; gap: 10px; margin-top: 17px; }
.description-points p { display: flex; align-items: flex-start; gap: 9px; margin: 0; color: #687489; font-size: 13px; line-height: 1.5; }
.description-points .ui-icon { flex: 0 0 auto; margin-top: 2px; color: #5c55d9; }
.description-more { display: inline-flex; align-items: center; gap: 4px; margin-top: 11px; padding: 0; color: #5549dc; border: 0; background: transparent; cursor: pointer; font-size: 12px; font-weight: 700; }
.reviews-detail { padding-bottom: 0; }
.reviews-layout { display: grid; grid-template-columns: 110px 225px minmax(0, 1fr); gap: 14px; margin-top: 17px; }
.review-score-column { display: flex; flex-direction: column; gap: 12px; }
.review-score-box { display: flex; flex-direction: column; align-items: center; padding: 12px 5px; border-radius: 8px; background: #f7f7ff; }
.review-score-box strong { color: #252b79; font-size: 30px; line-height: 1; }.review-score-box > span { margin-top: 3px; color: #8f98a7; font-size: 12px; }.score-stars { margin-top: 7px; color: #f6b014; font-size: 14px; letter-spacing: 1px; }.review-score-box small { margin-top: 3px; color: #9ca5b3; font-size: 11px; }
.write-review { min-height: 34px; color: #5549dc; border: 1px solid #bebaf3; border-radius: 6px; background: #fff; cursor: pointer; font-size: 12px; font-weight: 700; }.write-review:hover { background: #f8f7ff; }
.rating-breakdown { display: flex; flex-direction: column; justify-content: center; gap: 11px; padding-right: 15px; border-right: 1px solid #ebedf1; }.rating-row { display: grid; grid-template-columns: 36px minmax(0, 1fr) 22px; align-items: center; gap: 7px; color: #535d70; font-size: 12px; }.rating-row > span { display: flex; align-items: center; gap: 3px; white-space: nowrap; }.rating-row > span .ui-icon { color: #f3ac1c; }.rating-row strong { color: #86909f; text-align: right; font-size: 11px; }.rating-track { height: 6px; overflow: hidden; border-radius: 99px; background: #edf0f4; }.rating-track i { display: block; height: 100%; border-radius: inherit; background: #5549df; }
.review-feed { display: grid; gap: 11px; padding-left: 1px; }.feed-review { display: grid; grid-template-columns: 34px minmax(0, 1fr); gap: 8px; }.feed-review img { width: 34px; height: 34px; object-fit: cover; border-radius: 50%; }.feed-review-heading { display: flex; align-items: baseline; justify-content: space-between; gap: 8px; }.feed-review-heading strong { color: #3a4558; font-size: 12px; }.feed-review-heading span { color: #9aa2af; font-size: 10px; }.feed-review-stars { margin-top: 2px; color: #f4ae1c; font-size: 11px; letter-spacing: 1px; }.feed-review p { margin: 3px 0 0; color: #697488; font-size: 11px; line-height: 1.4; }.all-reviews { justify-self: start; margin: 2px 0 0 39px; padding: 0; color: #5549dc; border: 0; background: transparent; cursor: pointer; font-size: 12px; font-weight: 700; }.all-reviews span, .nearby-more span { margin-left: 4px; font-size: 14px; }
.location-card { padding: 18px; border: 1px solid #e7eaf0; border-radius: 12px; box-shadow: 0 6px 23px rgba(26,35,59,.06); }.location-card h2 { font-size: 15px; }.map-canvas { position: relative; height: 145px; overflow: hidden; margin: 11px 0 12px; border-radius: 8px; background: #e8f1e9; background-image: linear-gradient(35deg, transparent 44%, rgba(255,255,255,.8) 45%, rgba(255,255,255,.8) 48%, transparent 49%), linear-gradient(145deg, transparent 46%, rgba(255,255,255,.75) 47%, rgba(255,255,255,.75) 50%, transparent 51%), radial-gradient(circle at 23% 60%, #bddbbb 0 10%, transparent 10.5%), radial-gradient(circle at 79% 22%, #c4dfbf 0 15%, transparent 15.5%); }.map-canvas::before { position: absolute; inset: -20px; content: ''; opacity: .55; background: repeating-linear-gradient(27deg, transparent 0 24px, rgba(255,255,255,.7) 25px 27px, transparent 28px 52px), repeating-linear-gradient(112deg, transparent 0 36px, rgba(255,255,255,.55) 37px 39px, transparent 40px 65px); transform: rotate(-8deg); }.map-road { position: absolute; z-index: 1; height: 5px; border-radius: 99px; background: rgba(255,255,255,.95); box-shadow: 0 1px 1px rgba(102,132,107,.16); transform-origin: center; }.road-one { top: 55px; left: -18px; width: 210px; transform: rotate(12deg); }.road-two { top: 93px; left: 88px; width: 240px; transform: rotate(-25deg); }.road-three { top: 29px; right: -32px; width: 230px; transform: rotate(-42deg); }.road-four { top: 108px; left: -35px; width: 390px; transform: rotate(3deg); }.map-label { position: absolute; z-index: 2; color: #7f9a87; font-size: 10px; font-weight: 600; }.label-one { top: 26px; left: 30px; }.label-two { right: 13px; bottom: 25px; }.label-three { top: 88px; left: 35px; }.map-marker { position: absolute; z-index: 3; top: 51px; left: 50%; display: grid; place-items: center; width: 32px; height: 32px; color: #fff; border: 3px solid #fff; border-radius: 50% 50% 50% 5px; background: #6356e2; box-shadow: 0 4px 10px rgba(55,52,159,.26); transform: translate(-50%, -50%) rotate(-45deg); }.map-marker .ui-icon { transform: rotate(45deg); }.map-point { position: absolute; z-index: 2; width: 7px; height: 7px; border: 2px solid #fff; border-radius: 50%; background: #65b5d2; }.point-one { top: 66px; left: 23%; }.point-two { right: 17%; bottom: 23%; background: #eba949; }.point-three { top: 24%; right: 31%; background: #e78378; }
.location-card h3 { margin: 0; color: #344055; font-size: 13px; }.location-note { margin: 4px 0 12px; color: #8d97a5; font-size: 11px; }.nearby-list { display: grid; gap: 8px; }.nearby-list > div { display: flex; align-items: center; justify-content: space-between; gap: 8px; color: #647085; font-size: 11px; }.nearby-list span { display: flex; align-items: center; gap: 6px; }.nearby-list i { width: 6px; height: 6px; border: 1px solid #9099a9; border-radius: 50%; }.nearby-list small { color: #7b8596; white-space: nowrap; }.nearby-more { margin-top: 14px; padding: 0; color: #5549dc; border: 0; background: transparent; cursor: pointer; font-size: 11px; font-weight: 700; }
.similar-section { position: relative; margin-top: 35px; padding-top: 23px; border-top: 1px solid #edf0f4; }.similar-heading { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }.similar-heading h2 { font-size: 18px; }.similar-heading button { padding: 0; color: #5549dc; border: 0; background: transparent; cursor: pointer; font-size: 12px; font-weight: 700; }.similar-list { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 15px; }.similar-card { overflow: hidden; border: 1px solid #e7eaf0; border-radius: 9px; background: #fff; cursor: pointer; transition: transform .15s, box-shadow .15s; }.similar-card:hover { box-shadow: 0 8px 20px rgba(36,44,73,.11); transform: translateY(-2px); }.similar-image { position: relative; height: 125px; overflow: hidden; background: #eee; }.similar-image img { display: block; width: 100%; height: 100%; object-fit: cover; }.similar-image button { position: absolute; top: 8px; right: 8px; display: grid; place-items: center; width: 26px; height: 26px; color: #6b7586; border: 1px solid #e4e7ec; border-radius: 50%; background: rgba(255,255,255,.94); cursor: pointer; }.similar-image button:hover { color: #4f46e5; }.similar-body { padding: 10px 9px 11px; }.similar-body h3 { overflow: hidden; margin: 0; color: #3e485b; font-size: 12px; text-overflow: ellipsis; white-space: nowrap; }.similar-body p { overflow: hidden; margin: 4px 0 11px; color: #9aa2af; font-size: 11px; text-overflow: ellipsis; white-space: nowrap; }.similar-bottom { display: flex; align-items: center; justify-content: space-between; gap: 5px; }.similar-bottom strong { color: #4f46db; font-size: 12px; }.similar-bottom span { display: inline-flex; align-items: center; gap: 3px; color: #8b95a2; font-size: 11px; }.similar-bottom span .ui-icon { color: #f2aa16; }.similar-bottom small { color: #a3aab5; font-size: 10px; }.similar-arrow { position: absolute; top: 49%; display: grid; place-items: center; width: 33px; height: 33px; color: #5c55db; border: 1px solid #e1e3f5; border-radius: 50%; background: #fff; box-shadow: 0 3px 10px rgba(38,43,80,.1); cursor: pointer; }.similar-arrow.left { left: -15px; }.similar-arrow.right { right: -15px; }.similar-arrow:hover { background: #f7f6ff; }
.detail-footer { display: grid; grid-template-columns: 1.6fr repeat(4, 1fr); gap: 35px; margin-top: 53px; padding: 27px 12px 22px; border-top: 1px solid #edf0f4; }.footer-brand .brand { padding: 0; }.footer-brand p { max-width: 220px; margin: 13px 0; color: #8b95a5; font-size: 11px; line-height: 1.65; }.social-links { display: flex; gap: 8px; }.social-links button { display: grid; place-items: center; width: 23px; height: 23px; color: #667184; border: 0; border-radius: 50%; background: #f1f3f7; cursor: pointer; font-size: 12px; font-weight: 800; }.footer-column { display: flex; flex-direction: column; align-items: flex-start; gap: 10px; }.footer-column h3 { margin: 3px 0 3px; color: #354054; font-size: 12px; }.footer-column button { padding: 0; color: #8b95a4; border: 0; background: transparent; cursor: pointer; text-align: left; font-size: 11px; line-height: 1.45; }.footer-column button:hover { color: #5549dc; }.footer-bottom { display: flex; align-items: center; justify-content: center; min-height: 30px; color: #9da5b2; border-top: 1px solid #f1f2f5; font-size: 10px; }.footer-bottom button { position: absolute; right: 23px; display: grid; place-items: center; width: 26px; height: 26px; color: #5f55df; border: 0; border-radius: 50%; background: #eae9ff; cursor: pointer; font-size: 16px; }
@media (max-width: 900px) { .main-grid { grid-template-columns: minmax(0, 1fr) 320px; gap: 15px; }.header-inner, .content-shell { padding-right: 16px; padding-left: 16px; }.feature-strip { gap: 5px; }.feature-item { gap: 4px; } }
@media (max-width: 760px) { .detail-page { padding-top: 70px; }.detail-header { height: 70px; }.detail-nav { display: none; }.header-inner { padding-right: 16px; padding-left: 16px; }.header-actions { gap: 9px; }.login-button { width: 92px; height: 40px; border-radius: 13px; font-size: 12px; }.list-room-button { display: none; }.brand-mark { width: 40px; height: 40px; border-radius: 13px; font-size: 17px; }.brand-name { font-size: 18px; }.content-shell { padding-top: 15px; }.title-row { align-items: flex-start; }.title-actions { padding-top: 10px; }.main-grid { display: block; }.hero-gallery { height: min(64vw, 420px); min-height: 250px; }.booking-column { position: static; margin-top: 23px; }.booking-card { max-width: 520px; }.feature-strip { overflow-x: auto; justify-content: start; }.feature-item { min-width: 98px; justify-content: flex-start; }.detail-tabs { gap: 19px; overflow-x: auto; }.detail-tabs button { flex: 0 0 auto; }.thumbnail { height: 58px; }.amenity-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }.amenity-grid.expanded { grid-template-columns: repeat(2, minmax(0, 1fr)); }.modal-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 430px) { .brand-name { font-size: 15px; }.login-button { width: 82px; height: 36px; font-size: 11px; }.breadcrumbs { font-size: 11px; }.title-row { gap: 8px; } h1 { font-size: 20px; }.property-meta { gap: 5px; font-size: 11px; }.gallery-badge { top: 10px; left: 10px; }.photo-count { right: 9px; bottom: 9px; }.thumbnail-row { gap: 5px; }.thumbnail { height: 50px; }.detail-tabs { gap: 17px; margin-top: 9px; }.detail-tabs button { font-size: 11px; }.feature-strip { margin-right: -16px; margin-left: -16px; padding: 12px 16px; border-right: 0; border-left: 0; border-radius: 0; }.amenity-grid { gap: 12px 8px; }.host-stats strong { font-size: 9px; }.host-stats small { font-size: 7px; } }
@media (max-width: 900px) { .lower-grid { grid-template-columns: minmax(0, 1fr) 320px; gap: 15px; }.detailed-amenities { grid-template-columns: repeat(3, minmax(0, 1fr)); }.detail-footer { gap: 20px; } }
@media (max-width: 760px) { .lower-content { margin-top: 32px; }.lower-grid { display: block; }.location-card { margin-top: 28px; }.reviews-layout { grid-template-columns: 100px 1fr; }.review-feed { grid-column: 1 / -1; padding-top: 8px; border-top: 1px solid #edf0f4; }.similar-list { grid-template-columns: repeat(2, minmax(0, 1fr)); }.similar-image { height: 145px; }.similar-arrow { display: none; }.detail-footer { grid-template-columns: repeat(2, minmax(0, 1fr)); margin-top: 35px; padding-right: 0; padding-left: 0; }.footer-brand { grid-column: 1 / -1; }.footer-brand p { max-width: 280px; } }
@media (max-width: 430px) { .section-caption { display: none; }.detailed-amenities { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px 8px; }.reviews-layout { grid-template-columns: 88px minmax(0, 1fr); gap: 9px; }.rating-breakdown { padding-right: 0; border-right: 0; }.similar-list { gap: 8px; }.similar-image { height: 105px; }.similar-body { padding-right: 7px; padding-left: 7px; }.similar-bottom { align-items: flex-start; flex-direction: column; gap: 5px; }.similar-bottom strong { font-size: 9px; }.detail-footer { gap: 18px 12px; }.footer-column button { font-size: 8px; }.footer-bottom { justify-content: flex-start; padding-right: 38px; }.footer-bottom button { right: 12px; } }
</style>
