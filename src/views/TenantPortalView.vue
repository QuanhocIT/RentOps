<template>
  <div class="tenant-shell">
    <!-- Toast Notification -->
    <transition name="fade">
      <div v-if="toast.show" class="toast-notification" :class="toast.type">
        <span class="toast-icon">{{ toast.type === 'success' ? '✓' : 'ℹ' }}</span>
        <span>{{ toast.message }}</span>
      </div>
    </transition>

    <!-- LEFT SIDEBAR -->
    <aside class="tenant-sidebar">
      <div class="brand" @click="setActiveTab('home')" style="cursor: pointer;">
        <div class="brand-mark">⌂</div>
        <div class="brand-name">RentOps</div>
      </div>

      <nav class="side-nav">
        <button
          v-for="item in navItems"
          :key="item.id"
          class="nav-item"
          :class="{ active: currentTab === item.id }"
          @click="setActiveTab(item.id)"
        >
          <span class="nav-icon">{{ item.icon }}</span>
          <span>{{ item.name }}</span>
          <span v-if="item.badge" class="side-badge">{{ item.badge }}</span>
        </button>
      </nav>

      <div class="reward-card">
        <div class="reward-title">Giới thiệu &amp; nhận thưởng</div>
        <p>Giới thiệu bạn bè và nhận ngay 500.000đ vào tài khoản</p>
        <div class="reward-bottom">
          <button @click="showToast('Đã sao chép link giới thiệu của bạn!')">Giới thiệu ngay</button>
          <span>🎁</span>
        </div>
      </div>
    </aside>

    <!-- MAIN AREA -->
    <div class="tenant-main">
      <!-- TOPBAR -->
      <header class="topbar">
        <div class="search-box">
          <span class="search-icon">⌕</span>
          <input
            v-model="searchQuery"
            placeholder="Bạn muốn tìm phòng ở đâu? (Nhập quận, địa điểm...)"
            @keyup.enter="handleSearchSubmit"
          />
          <button v-if="searchQuery" class="clear-search" @click="searchQuery = ''">✕</button>
        </div>

        <div class="top-actions">
          <button class="top-link" @click="setActiveTab('favorites')">
            <span>♡</span> Yêu thích
            <b v-if="savedRooms.length">{{ savedRooms.length }}</b>
          </button>
          
          <button class="top-link has-badge" @click="setActiveTab('messages')">
            <span>💬</span> Tin nhắn
            <b>{{ unreadMessagesCount }}</b>
          </button>
          
          <button class="bell" @click="setActiveTab('notifications')">
            <span>🔔</span>
            <b v-if="unreadNotificationsCount">{{ unreadNotificationsCount }}</b>
          </button>

          <div class="profile-widget" @click="toggleProfileMenu">
            <img :src="userAvatar" alt="avatar" />
            <div class="profile-info">
              <strong>{{ tenantName }}</strong>
              <small>Cư Dân RentOps</small>
            </div>
            <span>⌄</span>

            <div v-if="showProfileDropdown" class="profile-dropdown">
              <div class="dropdown-header">
                <strong>{{ tenantName }}</strong>
                <p>{{ currentUser.email || 'renter@rentops.vn' }}</p>
              </div>
              <button @click="setActiveTab('contracts')">▤ Hợp đồng của tôi</button>
              <button @click="setActiveTab('bills')">▭ Hóa đơn &amp; Thanh toán</button>
              <button @click="setActiveTab('support')">🔧 Yêu cầu sửa chữa</button>
              <hr />
              <button class="logout-btn" @click="handleLogout">🚪 Đăng xuất</button>
            </div>
          </div>
        </div>
      </header>

      <div class="content-grid">
        <!-- MAIN CONTENT CONTAINER -->
        <main class="center-column">

          <!-- TAB 1: HOME DASHBOARD -->
          <div v-if="currentTab === 'home'">
            <!-- HERO SEARCH PANEL -->
            <section class="hero-panel">
              <img :src="heroImage" alt="Không gian phòng" />
              <div class="hero-overlay"></div>
              <h1>Tìm không gian sống lý tưởng<br />cho cuộc sống của bạn</h1>

              <div class="hero-search">
                <div class="search-tabs">
                  <button :class="{ selected: searchMode === 'search' }" @click="searchMode = 'search'">Tìm kiếm</button>
                  <button :class="{ selected: searchMode === 'map' }" @click="searchMode = 'map'">Tìm theo bản đồ</button>
                </div>
                <div class="search-fields">
                  <div class="search-field">
                    <strong>Địa điểm</strong>
                    <input v-model="filterLocation" placeholder="Quận 1, Bình Thạnh, Thủ Đức..." />
                  </div>
                  <div class="search-field">
                    <strong>Loại phòng</strong>
                    <select v-model="filterCategory">
                      <option value="">Tất cả loại phòng</option>
                      <option value="Phòng trọ">Phòng trọ</option>
                      <option value="Căn hộ mini">Căn hộ mini</option>
                      <option value="Căn hộ dịch vụ">Căn hộ dịch vụ</option>
                      <option value="Homestay">Homestay</option>
                      <option value="Ở ghép">Ở ghép</option>
                    </select>
                  </div>
                  <div class="search-field">
                    <strong>Ngân sách</strong>
                    <select v-model="filterPriceRange">
                      <option value="">Tất cả mức giá</option>
                      <option value="under_3m">Dưới 3 triệu</option>
                      <option value="3m_5m">3 - 5 triệu</option>
                      <option value="5m_8m">5 - 8 triệu</option>
                      <option value="above_8m">Trên 8 triệu</option>
                    </select>
                  </div>
                  <div class="search-field">
                    <strong>Tiện nghi</strong>
                    <span>{{ selectedAmenitiesCount > 0 ? selectedAmenitiesCount + ' tiện nghi' : 'Điều hòa, Wifi...' }}</span>
                  </div>
                  <button class="search-submit" @click="handleSearchSubmit">⌕ Tìm kiếm</button>
                </div>
              </div>
            </section>

            <!-- KHÁM PHÁ THEO NHU CẦU -->
            <section class="section-block">
              <h2>Khám phá theo nhu cầu</h2>
              <div class="category-row">
                <article
                  v-for="item in categories"
                  :key="item.title"
                  class="category-card"
                  :class="{ active: filterCategory === item.title }"
                  @click="selectCategoryFilter(item.title)"
                >
                  <div class="category-icon" :class="item.color">{{ item.icon }}</div>
                  <div>
                    <strong>{{ item.title }}</strong>
                    <span>{{ item.price }}</span>
                  </div>
                </article>
              </div>
            </section>

            <!-- PHÒNG NỔI BẬT DÀNH CHO BẠN (REAL DATA) -->
            <section class="section-block">
              <div class="section-head">
                <h2>Phòng nổi bật dành cho bạn</h2>
                <a href="#" @click.prevent="setActiveTab('search')">Xem tất cả ({{ displayRooms.length }}) ›</a>
              </div>

              <div v-if="loadingRooms" class="loading-state">
                <div class="spinner"></div>
                <p>Đang tải danh sách phòng trọ thực tế...</p>
              </div>

              <div v-else class="room-grid">
                <article
                  v-for="room in featuredRoomsDisplay"
                  :key="room.id"
                  class="room-card"
                  @click="openRoomDetail(room)"
                >
                  <div class="room-photo">
                    <img :src="room.image" :alt="room.title" />
                    <span v-if="room.badge" class="vip">VIP</span>
                    <button class="fav-btn" :class="{ is_fav: isSaved(room.id) }" @click.stop="toggleSaveRoom(room)">
                      {{ isSaved(room.id) ? '♥' : '♡' }}
                    </button>
                    <small>▣ {{ room.photos || '1/12' }}</small>
                  </div>
                  <div class="room-body">
                    <h3>{{ room.title }}</h3>
                    <p>⌾ {{ room.location }}</p>
                    <strong>{{ formatCurrency(room.price) }}/tháng</strong>
                    <div class="room-tags">
                      <span v-for="tag in room.tags" :key="tag">{{ tag }}</span>
                    </div>
                    <div class="rating">★ <span>{{ room.rating || '4.8 (76)' }}</span></div>
                  </div>
                </article>
              </div>
            </section>

            <!-- KHU VỰC PHỔ BIẾN & QUAN TÂM -->
            <section class="bottom-grid">
              <div class="section-block">
                <div class="section-head">
                  <h2>Khu vực phổ biến</h2>
                  <a href="#" @click.prevent="setActiveTab('search')">Xem tất cả ›</a>
                </div>
                <div class="area-grid">
                  <article
                    v-for="area in areas"
                    :key="area.name"
                    class="area-card"
                    @click="filterByArea(area.name)"
                  >
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
                  <a href="#" @click.prevent="setActiveTab('search')">Xem tất cả ›</a>
                </div>
                <div class="interest-row">
                  <article v-for="item in interestItems" :key="item.title" class="interest-card" @click="setActiveTab('search')">
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

            <!-- SAVED ROOMS & RECENT ROOMS -->
            <section class="list-pair">
              <div class="section-block">
                <div class="section-head">
                  <h2>Phòng bạn đã lưu ({{ savedRooms.length }})</h2>
                  <a href="#" @click.prevent="setActiveTab('favorites')">Xem tất cả ›</a>
                </div>
                <div v-if="savedRooms.length === 0" class="empty-state-mini">
                  <p>Chưa có phòng nào trong danh sách yêu thích</p>
                </div>
                <div v-else class="compact-list">
                  <article v-for="room in savedRooms.slice(0, 3)" :key="room.id" class="compact-room" @click="openRoomDetail(room)">
                    <img :src="room.image" :alt="room.title" />
                    <div>
                      <strong>{{ room.title }}</strong>
                      <p>{{ room.location }}</p>
                      <b>{{ formatCurrency(room.price) }}/tháng</b>
                      <small>{{ room.meta || '28m² · Studio' }}</small>
                    </div>
                    <button class="remove-fav" @click.stop="toggleSaveRoom(room)">♥</button>
                  </article>
                </div>
              </div>

              <div class="section-block">
                <div class="section-head">
                  <h2>Bạn đã xem gần đây ({{ recentRooms.length }})</h2>
                  <a href="#" @click.prevent="setActiveTab('history')">Xem tất cả ›</a>
                </div>
                <div v-if="recentRooms.length === 0" class="empty-state-mini">
                  <p>Bạn chưa xem phòng nào gần đây</p>
                </div>
                <div v-else class="compact-list">
                  <article v-for="room in recentRooms.slice(0, 3)" :key="room.id" class="compact-room" @click="openRoomDetail(room)">
                    <img :src="room.image" :alt="room.title" />
                    <div>
                      <strong>{{ room.title }}</strong>
                      <p>{{ room.location }}</p>
                      <b>{{ formatCurrency(room.price) }}/tháng</b>
                      <small>{{ room.meta || '25m² · 1 PN' }}</small>
                    </div>
                  </article>
                </div>
              </div>
            </section>

            <!-- UƯ ĐÃI DÀNH RIÊNG CHO BẠN -->
            <section class="section-block">
              <div class="section-head">
                <h2>Ưu đãi dành riêng cho bạn</h2>
                <a href="#" @click.prevent="showToast('Danh sách ưu đãi đã cập nhật!')">Xem tất cả ›</a>
              </div>
              <div class="wide-offers">
                <article v-for="offer in wideOffers" :key="offer.title" :class="offer.tone">
                  <div>
                    <strong>{{ offer.title }}</strong>
                    <p>{{ offer.desc }}</p>
                    <span>HSD: {{ offer.expiry }}</span>
                    <button @click="claimOffer(offer)">Lưu mã {{ offer.code }}</button>
                  </div>
                  <img :src="offer.image" :alt="offer.title" />
                </article>
              </div>
            </section>

            <!-- REASONS & APP BANNER -->
            <section class="section-block">
              <h2>Vì sao chọn RentOps?</h2>
              <div class="reason-row">
                <article v-for="reason in reasons" :key="reason.title">
                  <div>{{ reason.icon }}</div>
                  <strong>{{ reason.title }}</strong>
                  <p>{{ reason.desc }}</p>
                </article>
              </div>
            </section>

            <section class="app-banner">
              <div>
                <h2>Tải ứng dụng RentOps ngay hôm nay!</h2>
                <p>Trải nghiệm tìm phòng nhanh hơn, quản lý hợp đồng &amp; hóa đơn dễ dàng</p>
                <div class="store-row">
                  <button @click="showToast('Tính năng tải ứng dụng iOS đang chuẩn bị phát hành!')">▣ App Store</button>
                  <button @click="showToast('Tính năng tải ứng dụng Android đang chuẩn bị phát hành!')">▷ Google Play</button>
                </div>
              </div>
              <div class="phone-preview">
                <img :src="phoneImage" alt="RentOps app" />
              </div>
              <div class="qr-box">
                <div class="qr-content">QR CODE</div>
              </div>
            </section>
          </div>

          <!-- TAB 2: TÌM PHÒNG (SEARCH VIEW) -->
          <div v-else-if="currentTab === 'search'" class="search-view-container">
            <div class="view-header">
              <h2>Tìm phòng trọ / căn hộ cho thuê</h2>
              <p>Tìm thấy {{ displayRooms.length }} phòng phù hợp</p>
            </div>

            <div class="search-filter-bar">
              <input v-model="searchQuery" placeholder="Nhập tên phòng, địa chỉ, quận..." class="filter-input" />
              <select v-model="filterCategory" class="filter-select">
                <option value="">Tất cả loại phòng</option>
                <option value="Phòng trọ">Phòng trọ</option>
                <option value="Căn hộ mini">Căn hộ mini</option>
                <option value="Căn hộ dịch vụ">Căn hộ dịch vụ</option>
                <option value="Homestay">Homestay</option>
                <option value="Ở ghép">Ở ghép</option>
              </select>
              <select v-model="filterPriceRange" class="filter-select">
                <option value="">Tất cả khoảng giá</option>
                <option value="under_3m">Dưới 3 triệu</option>
                <option value="3m_5m">3 - 5 triệu</option>
                <option value="5m_8m">5 - 8 triệu</option>
                <option value="above_8m">Trên 8 triệu</option>
              </select>
              <select v-model="sortBy" class="filter-select">
                <option value="default">Sắp xếp: Mới nhất</option>
                <option value="price_asc">Giá: Thấp đến Cao</option>
                <option value="price_desc">Giá: Cao đến Thấp</option>
                <option value="area_desc">Diện tích: Rộng nhất</option>
              </select>
            </div>

            <div class="room-grid">
              <article
                v-for="room in displayRooms"
                :key="room.id"
                class="room-card"
                @click="openRoomDetail(room)"
              >
                <div class="room-photo">
                  <img :src="room.image" :alt="room.title" />
                  <span v-if="room.badge" class="vip">VIP</span>
                  <button class="fav-btn" :class="{ is_fav: isSaved(room.id) }" @click.stop="toggleSaveRoom(room)">
                    {{ isSaved(room.id) ? '♥' : '♡' }}
                  </button>
                  <small>▣ {{ room.photos || '1/10' }}</small>
                </div>
                <div class="room-body">
                  <h3>{{ room.title }}</h3>
                  <p>⌾ {{ room.location }}</p>
                  <strong>{{ formatCurrency(room.price) }}/tháng</strong>
                  <div class="room-tags">
                    <span v-for="tag in room.tags" :key="tag">{{ tag }}</span>
                  </div>
                  <div class="rating">★ <span>{{ room.rating || '4.8' }}</span></div>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 3: PHÒNG YÊU THÍCH -->
          <div v-else-if="currentTab === 'favorites'" class="tab-view-container">
            <div class="view-header">
              <h2>Danh sách phòng yêu thích ({{ savedRooms.length }})</h2>
            </div>
            <div v-if="savedRooms.length === 0" class="empty-state-large">
              <div class="empty-icon">♡</div>
              <h3>Chưa có phòng nào được chọn yêu thích</h3>
              <p>Hãy bấm vào biểu tượng trái tim ở các căn hộ bạn quan tâm để lưu lại tại đây.</p>
              <button class="primary-btn" @click="setActiveTab('search')">Khám phá danh sách phòng</button>
            </div>
            <div v-else class="room-grid">
              <article v-for="room in savedRooms" :key="room.id" class="room-card" @click="openRoomDetail(room)">
                <div class="room-photo">
                  <img :src="room.image" :alt="room.title" />
                  <button class="fav-btn is_fav" @click.stop="toggleSaveRoom(room)">♥</button>
                </div>
                <div class="room-body">
                  <h3>{{ room.title }}</h3>
                  <p>⌾ {{ room.location }}</p>
                  <strong>{{ formatCurrency(room.price) }}/tháng</strong>
                  <div class="room-tags">
                    <span v-for="tag in room.tags" :key="tag">{{ tag }}</span>
                  </div>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 4: LỊCH SỬ TÌM KIẾM -->
          <div v-else-if="currentTab === 'history'" class="tab-view-container">
            <div class="view-header">
              <h2>Lịch sử các phòng bạn đã xem</h2>
            </div>
            <div v-if="recentRooms.length === 0" class="empty-state-large">
              <div class="empty-icon">◷</div>
              <h3>Chưa có lịch sử xem phòng</h3>
              <p>Các phòng bạn bấm vào xem chi tiết sẽ được tự động lưu lại ở đây.</p>
              <button class="primary-btn" @click="setActiveTab('search')">Tìm phòng ngay</button>
            </div>
            <div v-else class="room-grid">
              <article v-for="room in recentRooms" :key="room.id" class="room-card" @click="openRoomDetail(room)">
                <div class="room-photo">
                  <img :src="room.image" :alt="room.title" />
                </div>
                <div class="room-body">
                  <h3>{{ room.title }}</h3>
                  <p>⌾ {{ room.location }}</p>
                  <strong>{{ formatCurrency(room.price) }}/tháng</strong>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 5: HỢP ĐỒNG CỦA TÔI -->
          <div v-else-if="currentTab === 'contracts'" class="tab-view-container">
            <div class="view-header">
              <h2>Hợp đồng thuê nhà của tôi</h2>
              <p>Quản lý các hợp đồng đang hiệu lực và lịch sử giữ chỗ</p>
            </div>

            <div v-if="loadingContracts" class="loading-state">
              <div class="spinner"></div>
              <p>Đang tải thông tin hợp đồng...</p>
            </div>

            <div v-else-if="contracts.length === 0" class="empty-state-large">
              <div class="empty-icon">▤</div>
              <h3>Bạn chưa có hợp đồng thuê nhà nào</h3>
              <p>Nếu bạn đã đăng ký thuê phòng, vui lòng liên hệ Ban quản lý tòa nhà để cập nhật thông tin hợp đồng lên hệ thống.</p>
              <button class="primary-btn" @click="setActiveTab('search')">Tìm phòng muốn thuê</button>
            </div>

            <div v-else class="contracts-list">
              <article v-for="contract in contracts" :key="contract.id" class="contract-card">
                <div class="contract-header">
                  <div>
                    <span class="contract-code">Mã HĐ: {{ contract.contract_code }}</span>
                    <h3>Phòng {{ contract.room_number }} - {{ contract.property_name || 'Tòa nhà RentOps' }}</h3>
                  </div>
                  <span class="status-badge" :class="contract.status">
                    {{ contract.status === 'active' ? '● Đang hiệu lực' : contract.status }}
                  </span>
                </div>

                <div class="contract-body">
                  <div class="info-row">
                    <span>Giá thuê hàng tháng:</span>
                    <strong>{{ formatCurrency(contract.monthly_rent) }}/tháng</strong>
                  </div>
                  <div class="info-row">
                    <span>Tiền cọc đã gửi:</span>
                    <strong>{{ formatCurrency(contract.deposit_amount) }}</strong>
                  </div>
                  <div class="info-row">
                    <span>Thời hạn hợp đồng:</span>
                    <span>{{ formatDate(contract.start_date) }} - {{ formatDate(contract.end_date) }}</span>
                  </div>
                  <div class="info-row">
                    <span>Người thuê chính:</span>
                    <span>{{ contract.renter_name || tenantName }}</span>
                  </div>
                </div>

                <div class="contract-actions">
                  <button class="secondary-btn" @click="openContractDetail(contract)">📄 Xem chi tiết hợp đồng</button>
                  <button class="primary-btn" @click="setActiveTab('bills')">💳 Xem hóa đơn thanh toán</button>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 6: THANH TOÁN & HÓA ĐƠN -->
          <div v-else-if="currentTab === 'bills'" class="tab-view-container">
            <div class="view-header">
              <h2>Hóa đơn &amp; Thanh toán</h2>
              <p>Theo dõi các khoản phí phòng trọ, điện, nước và thanh toán qua VietQR</p>
            </div>

            <div v-if="loadingBills" class="loading-state">
              <div class="spinner"></div>
              <p>Đang kiểm tra hóa đơn hàng tháng...</p>
            </div>

            <div v-else-if="bills.length === 0" class="empty-state-large">
              <div class="empty-icon">▭</div>
              <h3>Không có hóa đơn nào phát sinh</h3>
              <p>Tất cả các khoản thanh toán của bạn hiện tại đã hoàn tất sạch sẽ.</p>
            </div>

            <div v-else class="bills-list">
              <article v-for="bill in bills" :key="bill.id" class="bill-card" :class="{ unpaid: bill.status !== 'paid' }">
                <div class="bill-header">
                  <div>
                    <strong>Tháng {{ bill.billing_month }} - Mã {{ bill.bill_code }}</strong>
                    <p>Phòng {{ bill.room_number || '102' }}</p>
                  </div>
                  <span class="status-badge" :class="bill.status">
                    {{ bill.status === 'paid' ? '✓ Đã thanh toán' : '⚠️ Chưa thanh toán' }}
                  </span>
                </div>

                <div class="bill-breakdown">
                  <div class="bill-item">
                    <span>Tiền phòng:</span>
                    <span>{{ formatCurrency(bill.room_fee) }}</span>
                  </div>
                  <div class="bill-item">
                    <span>Tiền điện + nước:</span>
                    <span>{{ formatCurrency(bill.utility_fee) }}</span>
                  </div>
                  <div class="bill-item">
                    <span>Phí dịch vụ (Rác, Wifi):</span>
                    <span>{{ formatCurrency(bill.service_fee) }}</span>
                  </div>
                  <div class="bill-item total">
                    <span>Tổng tiền hóa đơn:</span>
                    <strong>{{ formatCurrency(bill.total_amount) }}</strong>
                  </div>
                </div>

                <div class="bill-actions">
                  <button v-if="bill.status !== 'paid'" class="primary-btn pay-btn" @click="openVietQRModal(bill)">
                    ⚡ Thanh toán ngay qua VietQR
                  </button>
                  <button v-else class="success-btn" disabled>✓ Đã hoàn tất thanh toán</button>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 7: THÔNG BÁO -->
          <div v-else-if="currentTab === 'notifications'" class="tab-view-container">
            <div class="view-header">
              <h2>Thông báo hệ thống</h2>
            </div>
            <div class="notifications-list">
              <article v-for="noti in notifications" :key="noti.id" class="noti-card" :class="{ unread: !noti.read }">
                <div class="noti-icon">🔔</div>
                <div class="noti-content">
                  <p>{{ noti.content }}</p>
                  <small>{{ noti.created_at || 'Vừa xong' }}</small>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 8: HỖ TRỢ & YÊU CẦU SỬA CHỮA -->
          <div v-else-if="currentTab === 'support'" class="tab-view-container">
            <div class="view-header flex-between">
              <div>
                <h2>Báo sự cố &amp; Yêu cầu sửa chữa</h2>
                <p>Gửi yêu cầu sửa chữa thiết bị hỏng hóc trong phòng trọ</p>
              </div>
              <button class="primary-btn" @click="showNewMaintenanceModal = true">+ Gửi yêu cầu mới</button>
            </div>

            <div v-if="maintenanceRequests.length === 0" class="empty-state-large">
              <div class="empty-icon">🔧</div>
              <h3>Chưa có yêu cầu sửa chữa nào</h3>
              <p>Nếu căn hộ của bạn gặp sự cố về điện, nước, bóng đèn, điều hòa... Hãy tạo yêu cầu để kỹ thuật tới xử lý.</p>
              <button class="primary-btn" @click="showNewMaintenanceModal = true">+ Tạo yêu cầu sửa chữa</button>
            </div>

            <div v-else class="tickets-list">
              <article v-for="req in maintenanceRequests" :key="req.id" class="ticket-card">
                <div class="ticket-header">
                  <strong>{{ req.title }}</strong>
                  <span class="status-badge" :class="req.status">
                    {{ req.status === 'resolved' ? '✓ Đã xong' : '⏳ Đang xử lý' }}
                  </span>
                </div>
                <p class="ticket-desc">{{ req.description }}</p>
                <div class="ticket-meta">
                  <span>Phòng {{ req.room_number || '102' }}</span> •
                  <span>Độ ưu tiên: <b>{{ req.priority || 'Trung bình' }}</b></span>
                </div>
              </article>
            </div>
          </div>

          <!-- TAB 9: MESSAGES / TIN NHẮN -->
          <div v-else-if="currentTab === 'messages'" class="tab-view-container">
            <div class="view-header">
              <h2>Tin nhắn với Ban Quản Lý Tòa Nhà</h2>
            </div>
            <div class="chat-box">
              <div class="chat-messages">
                <div class="message-bubble income">
                  <p>Chào bạn {{ tenantName }}! Ban quản lý tòa nhà có thể hỗ trợ gì cho bạn hôm nay?</p>
                  <small>09:00 AM</small>
                </div>
                <div v-for="(msg, idx) in chatMessages" :key="idx" class="message-bubble outgoing">
                  <p>{{ msg.text }}</p>
                  <small>{{ msg.time }}</small>
                </div>
              </div>
              <div class="chat-input-row">
                <input v-model="newChatMessage" placeholder="Nhập tin nhắn..." @keyup.enter="sendChatMessage" />
                <button class="primary-btn" @click="sendChatMessage">Gửi ➢</button>
              </div>
            </div>
          </div>

          <!-- FOOTER -->
          <footer class="tenant-footer">
            <div class="footer-brand">
              <div class="brand compact">
                <div class="brand-mark">⌂</div>
                <div class="brand-name">RentOps</div>
              </div>
              <p>Nền tảng tìm kiếm, đặt phòng và quản lý thuê nhà thông minh, tin cậy.</p>
              <div class="socials">
                <span>f</span>
                <span>◎</span>
                <span>♪</span>
                <span>▶</span>
              </div>
            </div>
            <div v-for="group in footerGroups" :key="group.title">
              <strong>{{ group.title }}</strong>
              <a v-for="link in group.links" :key="link" href="#" @click.prevent>{{ link }}</a>
            </div>
          </footer>
          <div class="copyright">© 2026 RentOps Platform. All rights reserved.</div>
        </main>

        <!-- RIGHT SIDEBAR PANEL -->
        <aside class="right-panel">
          <section class="user-card">
            <div class="user-row">
              <img :src="userAvatar" alt="avatar" />
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
              <div class="progress-track"><i style="width: 68%;"></i></div>
              <small>Còn 650 điểm để lên hạng Vàng</small>
            </div>
          </section>

          <section class="wallet-card">
            <h2>Ví của tôi</h2>
            <div class="wallet-balance">
              <div>
                <span>Số dư hiện tại</span>
                <strong>{{ formatCurrency(walletBalance) }}</strong>
              </div>
              <button @click="openTopUpModal">Nạp tiền</button>
            </div>
            <button class="wallet-link" @click="showToast('Lịch sử giao dịch: 03 giao dịch gần đây')">
              ▤ Lịch sử giao dịch <span>›</span>
            </button>
            <button class="wallet-link" @click="showToast('Phương thức thanh toán: MoMo, VietQR, Chuyển khoản')">
              ▭ Phương thức thanh toán <span>›</span>
            </button>
          </section>

          <section class="offer-card">
            <h2>Ưu đãi dành riêng cho bạn</h2>
            <article v-for="offer in offers" :key="offer.title">
              <div>
                <strong>{{ offer.title }}</strong>
                <p>{{ offer.desc }}</p>
                <span>HSD: {{ offer.expiry }}</span>
              </div>
              <button @click="claimOffer(offer)">Lưu mã</button>
            </article>
            <a href="#" @click.prevent="showToast('Các ưu đãi mới nhất sẽ tự động gửi vào ví quà tặng')">Xem tất cả ưu đãi ›</a>
          </section>
        </aside>
      </div>
    </div>

    <!-- MODAL: ROOM DETAIL -->
    <div v-if="selectedRoomDetail" class="modal-backdrop" @click.self="selectedRoomDetail = null">
      <div class="modal-card room-detail-modal">
        <button class="modal-close" @click="selectedRoomDetail = null">✕</button>
        
        <div class="modal-hero">
          <img :src="selectedRoomDetail.image" :alt="selectedRoomDetail.title" />
          <div class="modal-hero-badge">{{ selectedRoomDetail.property_type_label || 'Phòng cho thuê' }}</div>
        </div>

        <div class="modal-body">
          <h2>{{ selectedRoomDetail.title }}</h2>
          <p class="location-line">📍 {{ selectedRoomDetail.location || selectedRoomDetail.property_name }}</p>
          <div class="price-hero">{{ formatCurrency(selectedRoomDetail.price) }} / tháng</div>

          <div class="room-specs">
            <div class="spec-item">
              <span>Diện tích</span>
              <strong>{{ selectedRoomDetail.area || 28 }} m²</strong>
            </div>
            <div class="spec-item">
              <span>Tầng</span>
              <strong>Tầng {{ selectedRoomDetail.floor || 1 }}</strong>
            </div>
            <div class="spec-item">
              <span>Phòng ngủ</span>
              <strong>{{ selectedRoomDetail.bedrooms_count || 1 }} PN</strong>
            </div>
            <div class="spec-item">
              <span>Phòng tắm</span>
              <strong>{{ selectedRoomDetail.bathrooms_count || 1 }} WC</strong>
            </div>
          </div>

          <div class="amenity-section">
            <h3>Tiện nghi có sẵn:</h3>
            <div class="amenity-chips">
              <span v-for="am in (selectedRoomDetail.amenities || ['Điều hòa', 'Tủ lạnh', 'Wifi', 'Nóng lạnh'])" :key="am" class="chip">
                ✓ {{ am }}
              </span>
            </div>
          </div>

          <div class="modal-actions">
            <button class="secondary-btn" @click="toggleSaveRoom(selectedRoomDetail)">
              {{ isSaved(selectedRoomDetail.id) ? '♥ Đã lưu phòng' : '♡ Lưu phòng này' }}
            </button>
            <button class="primary-btn" @click="submitBookingRequest(selectedRoomDetail)">
              📞 Đặt giữ chỗ / Thuê ngay
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- MODAL: VIETQR PAYMENT -->
    <div v-if="activeVietQRBill" class="modal-backdrop" @click.self="activeVietQRBill = null">
      <div class="modal-card qr-modal">
        <button class="modal-close" @click="activeVietQRBill = null">✕</button>
        <div class="qr-header">
          <h3>Thanh toán Hóa đơn qua VietQR</h3>
          <p>Mã hóa đơn: <b>{{ activeVietQRBill.bill_code }}</b></p>
        </div>

        <div class="qr-image-container">
          <img :src="getVietQRUrl(activeVietQRBill)" alt="VietQR Code" />
        </div>

        <div class="qr-details">
          <div class="qr-row">
            <span>Ngân hàng:</span>
            <strong>{{ activeVietQRBill.bank_code || 'MB Bank' }}</strong>
          </div>
          <div class="qr-row">
            <span>Số tài khoản:</span>
            <strong>{{ activeVietQRBill.bank_account || '0901234567' }}</strong>
          </div>
          <div class="qr-row">
            <span>Chủ tài khoản:</span>
            <strong>{{ activeVietQRBill.bank_account_name || 'RENTOPS DEMO' }}</strong>
          </div>
          <div class="qr-row">
            <span>Số tiền:</span>
            <strong class="highlight-amt">{{ formatCurrency(activeVietQRBill.total_amount) }}</strong>
          </div>
          <div class="qr-row">
            <span>Nội dung chuyển khoản:</span>
            <code>{{ activeVietQRBill.bill_code }}</code>
          </div>
        </div>

        <div class="modal-actions">
          <button class="secondary-btn" @click="activeVietQRBill = null">Hủy</button>
          <button class="primary-btn" @click="confirmPayment(activeVietQRBill)">
            ✓ Tôi đã chuyển khoản xong
          </button>
        </div>
      </div>
    </div>

    <!-- MODAL: NEW MAINTENANCE REQUEST -->
    <div v-if="showNewMaintenanceModal" class="modal-backdrop" @click.self="showNewMaintenanceModal = false">
      <div class="modal-card form-modal">
        <button class="modal-close" @click="showNewMaintenanceModal = false">✕</button>
        <h3>Tạo yêu cầu sửa chữa thiết bị</h3>
        
        <form @submit.prevent="submitMaintenanceRequest" class="form-grid">
          <div class="form-group">
            <label>Tiêu đề sự cố *</label>
            <input v-model="newTicket.title" placeholder="VD: Điều hòa không mát, Rò rỉ vòi nước..." required />
          </div>

          <div class="form-group">
            <label>Mức độ ưu tiên</label>
            <select v-model="newTicket.priority">
              <option value="low">Thấp (Xử lý trong 3 ngày)</option>
              <option value="medium">Trung bình (Xử lý trong ngày)</option>
              <option value="high">Khẩn cấp (Cần xử lý ngay)</option>
            </select>
          </div>

          <div class="form-group">
            <label>Mô tả chi tiết sự cố</label>
            <textarea v-model="newTicket.description" rows="4" placeholder="Mô tả cụ thể vị trí và tình trạng hỏng hóc..."></textarea>
          </div>

          <div class="modal-actions">
            <button type="button" class="secondary-btn" @click="showNewMaintenanceModal = false">Hủy</button>
            <button type="submit" class="primary-btn">Gửi yêu cầu kỹ thuật</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'

const router = useRouter()
const authStore = useAuthStore()
const dataStore = useDataStore()

// ACTIVE STATES & TABS
const currentTab = ref('home')
const searchQuery = ref('')
const searchMode = ref('search')
const showProfileDropdown = ref(false)

const filterLocation = ref('')
const filterCategory = ref('')
const filterPriceRange = ref('')
const selectedAmenitiesCount = ref(0)
const sortBy = ref('default')

// ASSETS & DEMO IMAGES
const currentUser = computed(() => authStore.currentUser || {})
const tenantName = computed(() => currentUser.value.full_name || 'Khách Thuê (Cư Dân)')
const userAvatar = '/images/rooms/main.png'
const walletBalance = ref(2350000)

// TOAST NOTIFICATION STATE
const toast = ref({ show: false, message: '', type: 'success' })
function showToast(message, type = 'success') {
  toast.value = { show: true, message, type }
  setTimeout(() => { toast.value.show = false }, 3000)
}

// REAL DATA STORES
const rooms = computed(() => {
  const imgList = ['/images/suite.png', '/images/studio.png', '/images/bedroom.png', '/images/rooms/living.png', '/images/rooms/main.png']
  return dataStore.rooms.map((r, i) => ({
    ...r,
    title: `Phòng ${r.roomNumber} - ${r.propertyName}`,
    location: r.propertyName,
    image: (r.images && r.images[0]) || imgList[i % imgList.length],
    tags: [`${r.area || 28}m²`, `Tầng ${r.floor}`, r.status === 'vacant' ? 'Phòng trống' : 'Đã có người'],
    price: r.price,
    badge: r.status === 'vacant'
  }))
})

const contracts = computed(() => {
  return dataStore.contracts.map(c => ({
    ...c,
    contract_code: c.contractNumber,
    room_number: c.roomNumber,
    property_name: c.propertyName,
    start_date: c.startDate,
    end_date: c.endDate,
    monthly_rent: c.price,
    deposit_amount: c.deposit
  }))
})

const bills = computed(() => {
  return dataStore.bills.map(b => ({
    ...b,
    bill_code: b.code,
    room_number: b.roomNumber,
    property_name: b.propertyName,
    billing_month: b.month,
    room_fee: b.roomPrice,
    utility_fee: (b.electricCost || 0) + (b.waterCost || 0),
    service_fee: b.serviceFee || 150000,
    total_amount: b.totalAmount
  }))
})

const maintenanceRequests = computed(() => {
  return dataStore.maintenance.map(m => ({
    ...m,
    room_number: m.roomNumber
  }))
})

const notifications = computed(() => {
  return dataStore.notifications.map(n => ({
    id: n.id,
    content: n.message,
    read: n.read,
    created_at: n.createdDate
  }))
})

const savedRooms = ref([])
const recentRooms = ref([])
const selectedRoomDetail = ref(null)
const activeVietQRBill = ref(null)
const showNewMaintenanceModal = ref(false)

const newTicket = ref({ title: '', priority: 'medium', description: '' })
const chatMessages = ref([
  { text: 'Tôi muốn báo giờ nhận phòng trọ tháng này.', time: '09:05 AM' }
])
const newChatMessage = ref('')

// NAVIGATION ITEMS
const navItems = [
  { id: 'home', name: 'Trang chủ', icon: '⌂' },
  { id: 'search', name: 'Tìm phòng', icon: '⌕' },
  { id: 'favorites', name: 'Phòng yêu thích', icon: '♡' },
  { id: 'history', name: 'Lịch sử tìm kiếm', icon: '◷' },
  { id: 'bookings', name: 'Đặt phòng của tôi', icon: '▣' },
  { id: 'contracts', name: 'Hợp đồng của tôi', icon: '▤' },
  { id: 'bills', name: 'Thanh toán', icon: '▭' },
  { id: 'notifications', name: 'Thông báo', icon: '🔔' },
  { id: 'messages', name: 'Tin nhắn', icon: '💬' },
  { id: 'reviews', name: 'Đánh giá của tôi', icon: '☆' },
  { id: 'support', name: 'Hỗ trợ / Sửa chữa', icon: '🔧' }
]

const categories = [
  { title: 'Phòng trọ', price: 'Giá từ 1 triệu', icon: '▥', color: 'orange' },
  { title: 'Căn hộ mini', price: 'Giá từ 3 triệu', icon: '▣', color: 'violet' },
  { title: 'Căn hộ dịch vụ', price: 'Giá từ 5 triệu', icon: '▤', color: 'pink' },
  { title: 'Homestay', price: 'Giá từ 500k/đêm', icon: '⌂', color: 'blue' },
  { title: 'Ở ghép', price: 'Giá từ 800k/người', icon: '●●', color: 'red' }
]

const footerGroups = [
  { title: 'Về chúng tôi', links: ['Giới thiệu RentOps', 'Tuyển dụng', 'Tin tức', 'Điều khoản dịch vụ', 'Chính sách bảo mật'] },
  { title: 'Hỗ trợ khách thuê', links: ['Trung tâm trợ giúp', 'Hướng dẫn thanh toán VietQR', 'Câu hỏi thường gặp', 'Liên hệ hotline'] },
  { title: 'Dành cho chủ nhà', links: ['Đăng cho thuê căn hộ', 'Quản lý hợp đồng & hóa đơn', 'Chính sách hợp tác'] },
  { title: 'Liên hệ', links: ['1900 6868', 'support@rentops.vn', 'Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội'] }
]

// COMPUTED BADGES & COUNTS
const unreadMessagesCount = computed(() => chatMessages.value.length)
const unreadNotificationsCount = computed(() => dataStore.unreadNotificationsCount)

// ROOM COMPUTED FILTERS
const displayRooms = computed(() => {
  let result = [...rooms.value]

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    result = result.filter(r =>
      (r.title && r.title.toLowerCase().includes(q)) ||
      (r.location && r.location.toLowerCase().includes(q)) ||
      (r.propertyName && r.propertyName.toLowerCase().includes(q))
    )
  }

  if (filterLocation.value.trim()) {
    const loc = filterLocation.value.toLowerCase()
    result = result.filter(r => (r.location || '').toLowerCase().includes(loc) || (r.propertyName || '').toLowerCase().includes(loc))
  }

  return result
})

const featuredRoomsDisplay = computed(() => {
  return displayRooms.value.slice(0, 8)
})

// METHODS
function setActiveTab(tabId) {
  currentTab.value = tabId
  showProfileDropdown.value = false
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function handleLogout() {
  authStore.clearAuth()
  showToast('Đã đăng xuất thành công')
  router.push('/landing')
}

function formatCurrency(val) {
  if (!val) return '0 đ'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function toggleSaveRoom(room) {
  const index = savedRooms.value.findIndex(r => r.id === room.id)
  if (index > -1) {
    savedRooms.value.splice(index, 1)
    showToast('Đã xóa phòng khỏi danh sách yêu thích', 'info')
  } else {
    savedRooms.value.push(room)
    showToast('Đã lưu phòng vào danh sách yêu thích!')
  }
}

function isSaved(roomId) {
  return savedRooms.value.some(r => r.id === roomId)
}

function claimOffer(offer) {
  navigator.clipboard.writeText(offer.code || 'RENTOPS').catch(() => {})
  showToast(`Đã lưu mã ${offer.code} vào ví ưu đãi của bạn!`)
}

function openTopUpModal() {
  showToast('Tính năng nạp tiền: Vui lòng chuyển khoản tới tài khoản ví RentOps số TK: 0908123456 (MB Bank)')
}

function openVietQRModal(bill) {
  activeVietQRBill.value = bill
}

function getVietQRUrl(bill) {
  const bank = 'MB'
  const acc = dataStore.settings.accountNumber || '0908123456'
  const amount = bill.total_amount || 0
  const memo = encodeURIComponent(bill.bill_code || 'BILL-RENT')
  const name = encodeURIComponent(dataStore.settings.accountHost || 'RENTOPS DEMO')
  return `https://img.vietqr.io/image/${bank}-${acc}-compact2.png?amount=${amount}&addInfo=${memo}&accountName=${name}`
}

function confirmPayment(bill) {
  dataStore.payBill(bill.id, 'VietQR Cư Dân')
  showToast('Xác nhận thanh toán thành công! Hóa đơn đã được chuyển sang trạng thái Đã Thanh Toán.')
  activeVietQRBill.value = null
}

function submitBookingRequest(room) {
  showToast(`Đã gửi yêu cầu giữ chỗ cho phòng ${room.title}. Ban quản lý sẽ liên hệ với bạn trong 15 phút!`)
  selectedRoomDetail.value = null
}

function submitMaintenanceRequest() {
  if (!newTicket.value.title.trim()) return
  dataStore.addMaintenanceRequest({
    title: newTicket.value.title,
    priority: newTicket.value.priority === 'high' ? 'Khẩn cấp' : newTicket.value.priority === 'medium' ? 'Trung bình' : 'Thấp',
    description: newTicket.value.description,
    roomId: dataStore.rooms[0]?.id || 101
  })
  showToast('Đã gửi yêu cầu sửa chữa kỹ thuật tới ban quản lý tòa nhà!')
  newTicket.value = { title: '', priority: 'medium', description: '' }
  showNewMaintenanceModal.value = false
}

function sendChatMessage() {
  if (!newChatMessage.value.trim()) return
  chatMessages.value.push({
    text: newChatMessage.value,
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  })
  newChatMessage.value = ''
  setTimeout(() => {
    chatMessages.value.push({
      text: 'Ban quản lý đã nhận được tin nhắn của bạn và sẽ phản hồi sớm nhất.',
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    })
  }, 1000)
}

// FETCH REAL API DATA ON MOUNT
onMounted(async () => {
  // Load Public Rooms
  try {
    loadingRooms.value = true
    const res = await api.get('/public/rooms')
    if (res && res.data && res.data.length > 0) {
      rooms.value = res.data.map((r, i) => {
        const imgList = ['/images/suite.png', '/images/studio.png', '/images/bedroom.png', '/images/rooms/living.png', '/images/rooms/main.png']
        return {
          ...r,
          title: `${r.property_type_label || 'Phòng cho thuê'} ${r.room_number} - ${r.property_name}`,
          location: r.address || r.property_name || 'Quận 1, TP. Hồ Chí Minh',
          image: imgList[i % imgList.length],
          tags: [`${r.area || 28}m²`, `${r.bedrooms_count || 1} PN`, 'Ban công', 'Full NT'],
          badge: i % 2 === 0,
          rating: (4.5 + (i % 5) * 0.1).toFixed(1)
        }
      })
    }
  } catch (err) {
    console.warn('Error fetching rooms, fallback to default seed', err)
  } finally {
    loadingRooms.value = false
  }

  // If fallback rooms empty, populate default seed
  if (rooms.value.length === 0) {
    rooms.value = [
      { id: 1, title: 'Căn hộ dịch vụ cao cấp full nội thất', location: 'Số 15 Lê Đức Thọ, Nam Từ Liêm, Hà Nội', price: 8500000, image: '/images/suite.png', tags: ['40m²', '1 PN', '1 WC', 'Ban công'], badge: true, rating: '4.9', area: 40, floor: 3, bedrooms_count: 1, bathrooms_count: 1 },
      { id: 2, title: 'Studio ban công thoáng mát gần trung tâm', location: 'Số 88 Trần Thái Tông, Cầu Giấy, Hà Nội', price: 6200000, image: '/images/studio.png', tags: ['30m²', 'Studio', '1 WC'], badge: true, rating: '4.7', area: 30, floor: 2, bedrooms_count: 1, bathrooms_count: 1 },
      { id: 3, title: 'Homestay xinh xắn view vườn thoáng', location: 'Đà Lạt, Lâm Đồng', price: 3500000, image: '/images/bedroom.png', tags: ['20m²', '1 PN', '1 WC'], badge: false, rating: '4.8', area: 20, floor: 1, bedrooms_count: 1, bathrooms_count: 1 },
      { id: 4, title: 'Phòng trọ duplex hiện đại trung tâm', location: 'Số 102 Chùa Lăng, Đống Đa, Hà Nội', price: 4500000, image: '/images/rooms/living.png', tags: ['25m²', '1 PN', 'Gác lửng'], badge: false, rating: '4.6', area: 25, floor: 4, bedrooms_count: 1, bathrooms_count: 1 }
    ]
  }

  // Load Contracts
  try {
    loadingContracts.value = true
    const res = await api.get('/contracts')
    if (res && res.data) {
      contracts.value = res.data
    }
  } catch (err) {
    // fallback sample contract
    contracts.value = [
      { id: 101, contract_code: 'CTR-2026-102', room_number: '102', property_name: 'Tòa Nhà RentOps A - Nam Từ Liêm', monthly_rent: 3800000, deposit_amount: 3800000, start_date: '2026-01-01', end_date: '2026-12-31', status: 'active', renter_name: tenantName.value }
    ]
  } finally {
    loadingContracts.value = false
  }

  // Load Monthly Bills
  try {
    loadingBills.value = true
    const res = await api.get('/monthly_bills')
    if (res && res.data) {
      bills.value = res.data
    }
  } catch (err) {
    bills.value = [
      { id: 201, bill_code: 'BILL-202607-102', billing_month: '2026-07', room_number: '102', room_fee: 3800000, utility_fee: 650000, service_fee: 150000, total_amount: 4600000, status: 'issued', bank_code: 'MB', bank_account: '0901234567', bank_account_name: 'RENTOPS DEMO' }
    ]
  } finally {
    loadingBills.value = false
  }

  // Load Maintenance Requests
  try {
    const res = await api.get('/maintenance_requests')
    if (res && res.data) {
      maintenanceRequests.value = res.data
    }
  } catch (e) {
    maintenanceRequests.value = [
      { id: 1, title: 'Sửa vòi nước rò rỉ nhà vệ sinh', priority: 'medium', status: 'resolved', description: 'Vòi sen tắm chảy yếu và rò rỉ', room_number: '102' }
    ]
  }
})
</script>

<style scoped>
.tenant-shell {
  min-height: 100vh;
  display: block;
  background: #f7f8fc;
  font-family: inherit;
}

/* TOAST */
.toast-notification {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  border-radius: 8px;
  background: #121936;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
}
.toast-notification.info { background: #2188ff; }

/* SIDEBAR */
.tenant-sidebar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 40;
  width: 260px;
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
  gap: 6px;
  min-height: 0;
  overflow-y: auto;
  padding-right: 2px;
}
.nav-item {
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: flex-start;
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
  transition: all 0.15s ease;
}
.nav-item:hover {
  background: #f1f3f9;
}
.nav-item.active {
  color: #fff;
  background: #5a42e8;
  box-shadow: 0 10px 20px rgba(90, 66, 232, 0.22);
}
.nav-icon {
  width: 22px;
  text-align: center;
  font-size: 16px;
  flex: 0 0 auto;
}
.side-badge {
  margin-left: auto;
  background: #ff405b;
  color: #fff;
  font-size: 10px;
  font-weight: 900;
  padding: 2px 6px;
  border-radius: 999px;
}
.reward-card {
  border-radius: 8px;
  background: linear-gradient(135deg, #5a42e8, #6e58f4);
  color: #fff;
  padding: 16px;
  margin-top: 10px;
}
.reward-title {
  font-size: 15px;
  font-weight: 900;
}
.reward-card p {
  margin: 6px 0 0;
  color: rgba(255, 255, 255, 0.88);
  font-size: 12px;
  font-weight: 600;
  line-height: 1.45;
}
.reward-bottom {
  margin-top: 14px;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
}
.reward-bottom button {
  border: 0;
  border-radius: 7px;
  background: #fff;
  color: #5a42e8;
  cursor: pointer;
  font-size: 12px;
  font-weight: 800;
  padding: 8px 12px;
}
.reward-bottom span { font-size: 32px; }

/* MAIN CONTENT */
.tenant-main {
  min-width: 0;
  margin-left: 260px;
}
.topbar {
  height: 76px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  border-bottom: 1px solid #e6eaf2;
  background: rgba(255, 255, 255, 0.96);
  padding: 0 28px;
  position: sticky;
  top: 0;
  z-index: 20;
}
.search-box {
  width: min(460px, 100%);
  height: 44px;
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid #e1e5ef;
  border-radius: 8px;
  background: #fff;
  color: #263255;
  padding: 0 16px;
}
.search-box input {
  flex: 1;
  border: 0;
  outline: 0;
  color: #263255;
  font-size: 13px;
  font-weight: 600;
}
.clear-search {
  border: 0;
  background: transparent;
  cursor: pointer;
  color: #7d879d;
}
.top-actions {
  display: flex;
  align-items: center;
  gap: 20px;
}
.top-link, .bell {
  position: relative;
  border: 0;
  background: transparent;
  color: #121936;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
  display: flex;
  align-items: center;
  gap: 6px;
}
.top-actions b {
  position: absolute;
  top: -8px;
  right: -10px;
  min-width: 18px;
  height: 18px;
  display: grid;
  place-items: center;
  border-radius: 999px;
  color: #fff;
  font-size: 10px;
  background: #6a55ee;
  padding: 0 4px;
}
.profile-widget {
  position: relative;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}
.profile-widget img {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  object-fit: cover;
}
.profile-info strong {
  display: block;
  font-size: 13px;
  color: #121936;
}
.profile-info small {
  display: block;
  font-size: 11px;
  color: #7b849d;
}
.profile-dropdown {
  position: absolute;
  top: 54px;
  right: 0;
  width: 220px;
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
  padding: 10px;
  z-index: 100;
}
.dropdown-header {
  padding: 8px 10px;
  border-bottom: 1px solid #eef1f7;
  margin-bottom: 6px;
}
.profile-dropdown button {
  width: 100%;
  border: 0;
  background: transparent;
  text-align: left;
  padding: 10px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
  color: #303a5f;
  cursor: pointer;
}
.profile-dropdown button:hover { background: #f4f6fb; }
.logout-btn { color: #ff405b !important; }

/* CONTENT GRID */
.content-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 294px;
  gap: 18px;
  padding: 18px 22px 24px;
}
.center-column { min-width: 0; }

/* HERO PANEL */
.hero-panel {
  position: relative;
  height: 266px;
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
  background: linear-gradient(90deg, rgba(10, 14, 28, 0.8), rgba(10, 14, 28, 0.3), rgba(10, 14, 28, 0.05));
}
.hero-panel h1 {
  position: absolute;
  left: 38px;
  top: 32px;
  margin: 0;
  color: #fff;
  font-size: 30px;
  font-weight: 900;
  line-height: 1.34;
}
.hero-search {
  position: absolute;
  left: 28px;
  right: 28px;
  bottom: 18px;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 18px 48px rgba(18, 25, 54, 0.18);
  overflow: hidden;
}
.search-tabs {
  display: flex;
  border-bottom: 1px solid #eef1f7;
}
.search-tabs button {
  height: 42px;
  border: 0;
  background: transparent;
  color: #7b849d;
  cursor: pointer;
  font-size: 13px;
  font-weight: 800;
  padding: 0 24px;
}
.search-tabs .selected {
  color: #5942e9;
  box-shadow: inset 0 -2px #5942e9;
}
.search-fields {
  display: grid;
  grid-template-columns: 1.2fr 1fr 1fr 0.9fr 110px;
  align-items: center;
}
.search-field {
  border-right: 1px solid #eef1f7;
  padding: 10px 14px;
}
.search-field strong {
  display: block;
  color: #303a5f;
  font-size: 12px;
  font-weight: 900;
}
.search-field input, .search-field select {
  width: 100%;
  border: 0;
  outline: 0;
  margin-top: 4px;
  font-size: 12px;
  color: #5942e9;
  font-weight: 700;
  background: transparent;
}
.search-field span {
  display: block;
  margin-top: 4px;
  color: #7b849d;
  font-size: 12px;
  font-weight: 600;
}
.search-submit {
  width: 96px;
  height: 40px;
  justify-self: center;
  border: 0;
  border-radius: 8px;
  background: #5942e9;
  color: #fff;
  cursor: pointer;
  font-size: 13px;
  font-weight: 900;
}

/* SECTIONS */
.section-block { margin-top: 22px; }
.section-block h2, .section-head h2 {
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
.section-head a {
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
  height: 74px;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 1px solid #eef1f7;
  border-radius: 8px;
  background: #fff;
  padding: 0 14px;
  cursor: pointer;
  box-shadow: 0 8px 24px rgba(18, 25, 54, 0.04);
  transition: transform 0.15s ease;
}
.category-card:hover, .category-card.active {
  border-color: #5942e9;
  transform: translateY(-2px);
}
.category-icon {
  width: 44px;
  height: 44px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  font-size: 18px;
  background: #f1f3f9;
}
.category-card strong {
  display: block;
  color: #121936;
  font-size: 13px;
  font-weight: 900;
}
.category-card span {
  display: block;
  margin-top: 2px;
  color: #7b849d;
  font-size: 11px;
}

/* ROOM GRID */
.room-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}
.room-card {
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(18, 25, 54, 0.04);
  cursor: pointer;
  transition: transform 0.15s ease;
}
.room-card:hover { transform: translateY(-3px); }
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
  left: 10px;
  top: 10px;
  border-radius: 4px;
  background: #ff9f1c;
  color: #fff;
  font-size: 10px;
  font-weight: 900;
  padding: 3px 6px;
}
.fav-btn {
  position: absolute;
  right: 10px;
  top: 10px;
  width: 32px;
  height: 32px;
  border: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  color: #7b849d;
  cursor: pointer;
  font-size: 18px;
}
.fav-btn.is_fav { color: #ff2f75; }
.room-photo small {
  position: absolute;
  left: 10px;
  bottom: 10px;
  border-radius: 4px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  font-size: 10px;
  padding: 3px 6px;
}
.room-body { padding: 14px; }
.room-body h3 {
  min-height: 40px;
  margin: 0;
  color: #121936;
  font-size: 14px;
  font-weight: 900;
  line-height: 1.4;
}
.room-body p {
  margin: 8px 0 0;
  color: #6d7694;
  font-size: 12px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.room-body strong {
  display: block;
  margin-top: 8px;
  color: #5942e9;
  font-size: 15px;
  font-weight: 900;
}
.room-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 10px;
}
.room-tags span {
  background: #f0f2f8;
  color: #6d7694;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
}
.rating {
  margin-top: 10px;
  color: #ffb21a;
  font-size: 12px;
  font-weight: 900;
}

/* BOTTOM GRIDS */
.bottom-grid {
  display: grid;
  grid-template-columns: 1.15fr 0.85fr;
  gap: 24px;
}
.area-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 10px;
}
.area-card {
  position: relative;
  height: 108px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
}
.area-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.area-card div {
  position: absolute;
  left: 10px;
  bottom: 8px;
  color: #fff;
  z-index: 2;
}
.area-card::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(0deg, rgba(0,0,0,0.7), transparent);
}
.interest-row {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}
.interest-card {
  display: flex;
  gap: 10px;
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  padding: 10px;
  cursor: pointer;
}
.interest-card img {
  width: 68px;
  height: 68px;
  border-radius: 6px;
  object-fit: cover;
}
.interest-card b {
  display: block;
  margin-top: 6px;
  color: #5942e9;
  font-size: 12px;
}

/* LIST PAIR & OFFERS */
.list-pair {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 24px;
}
.compact-list { display: grid; gap: 10px; }
.compact-room {
  display: grid;
  grid-template-columns: 76px minmax(0, 1fr) 24px;
  gap: 12px;
  align-items: center;
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  padding: 8px;
  cursor: pointer;
}
.compact-room img {
  width: 76px;
  height: 68px;
  border-radius: 6px;
  object-fit: cover;
}
.remove-fav {
  border: 0;
  background: transparent;
  color: #ff2f75;
  font-size: 18px;
  cursor: pointer;
}
.wide-offers {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
}
.wide-offers article {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 1px solid #e4e7f0;
  border-radius: 8px;
  padding: 16px;
}
.wide-offers article.violet { background: #f2eeff; }
.wide-offers article.blue { background: #edf7ff; }
.wide-offers article.pink { background: #ffeef4; }
.wide-offers strong { color: #5942e9; font-size: 16px; font-weight: 900; }
.wide-offers button {
  margin-top: 10px;
  border: 1px solid #c7c2ff;
  border-radius: 6px;
  background: #fff;
  color: #5942e9;
  cursor: pointer;
  padding: 6px 12px;
  font-size: 12px;
  font-weight: 800;
}
.wide-offers img {
  width: 100px;
  height: 80px;
  border-radius: 8px;
  object-fit: cover;
}

/* REASONS & BANNER */
.reason-row {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  margin-top: 18px;
}
.reason-row article {
  border-right: 1px solid #dce2ed;
  padding: 0 16px;
  text-align: center;
}
.reason-row article:last-child { border-right: 0; }
.reason-row div {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  margin: 0 auto 10px;
  border-radius: 50%;
  background: #f2efff;
  color: #5942e9;
  font-size: 20px;
}
.app-banner {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 180px 140px;
  align-items: center;
  gap: 20px;
  margin-top: 30px;
  border-radius: 8px;
  background: linear-gradient(135deg, #4d3be3, #7460ff);
  color: #fff;
  padding: 24px;
}
.store-row { display: flex; gap: 10px; margin-top: 16px; }
.store-row button {
  border: 0;
  border-radius: 6px;
  background: #fff;
  color: #121936;
  padding: 10px 16px;
  font-size: 13px;
  font-weight: 900;
  cursor: pointer;
}
.phone-preview {
  height: 130px;
  overflow: hidden;
  border-radius: 16px 16px 0 0;
  border: 4px solid #151b31;
  border-bottom: 0;
}
.phone-preview img { width: 100%; height: 100%; object-fit: cover; }
.qr-box {
  width: 100px;
  height: 100px;
  display: grid;
  place-items: center;
  border-radius: 8px;
  background: #fff;
  color: #121936;
  font-weight: 900;
  font-size: 14px;
  justify-self: center;
}

/* RIGHT PANEL */
.right-panel { display: flex; flex-direction: column; gap: 16px; }
.right-panel section {
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #fff;
  padding: 18px;
}
.user-row { display: flex; align-items: center; gap: 12px; }
.user-row img { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; }
.user-row strong { display: block; font-size: 16px; color: #121936; }
.member-progress { margin-top: 18px; }
.member-progress > div { display: flex; justify-content: space-between; font-size: 12px; color: #7b849d; }
.progress-track {
  height: 8px;
  margin: 10px 0 8px;
  border-radius: 999px;
  background: #e7eaf4;
  overflow: hidden;
}
.progress-track i { display: block; height: 100%; background: #5942e9; border-radius: 999px; }
.wallet-card h2, .offer-card h2 { margin: 0; font-size: 16px; color: #121936; }
.wallet-balance { display: flex; align-items: flex-end; justify-content: space-between; margin-top: 14px; }
.wallet-balance strong { display: block; margin-top: 4px; font-size: 22px; color: #121936; }
.wallet-balance button {
  border: 0;
  border-radius: 7px;
  background: #5942e9;
  color: #fff;
  padding: 10px 14px;
  font-size: 13px;
  font-weight: 900;
  cursor: pointer;
}
.wallet-link {
  width: 100%;
  display: flex;
  justify-content: space-between;
  border: 0;
  border-top: 1px solid #eef1f7;
  background: transparent;
  color: #303a5f;
  font-size: 13px;
  font-weight: 700;
  padding: 14px 0;
  cursor: pointer;
}
.offer-card article {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-top: 12px;
  border: 1px solid #c7c2ff;
  border-radius: 8px;
  background: #fbfaff;
  padding: 12px;
}
.offer-card article strong { color: #5942e9; font-size: 13px; }
.offer-card article p { margin: 4px 0 8px; font-size: 11px; color: #303a5f; }
.offer-card article button {
  border: 1px solid #c7c2ff;
  border-radius: 6px;
  background: #fff;
  color: #5942e9;
  padding: 6px 10px;
  font-size: 11px;
  font-weight: 800;
  cursor: pointer;
}

/* TAB CONTENT CONTAINER */
.tab-view-container, .search-view-container {
  background: #fff;
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  padding: 24px;
  min-height: 500px;
}
.view-header { margin-bottom: 20px; }
.view-header.flex-between { display: flex; justify-content: space-between; align-items: center; }
.view-header h2 { margin: 0; font-size: 22px; color: #121936; font-weight: 900; }
.view-header p { margin: 4px 0 0; color: #7b849d; font-size: 13px; }

/* SEARCH BAR IN SEARCH TAB */
.search-filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}
.filter-input {
  flex: 1;
  border: 1px solid #e1e5ef;
  border-radius: 8px;
  padding: 0 14px;
  font-size: 13px;
}
.filter-select {
  border: 1px solid #e1e5ef;
  border-radius: 8px;
  padding: 0 14px;
  font-size: 13px;
  color: #303a5f;
  background: #fff;
}

/* EMPTY & LOADING STATES */
.loading-state, .empty-state-large, .empty-state-mini {
  text-align: center;
  padding: 40px 20px;
  color: #7b849d;
}
.empty-icon { font-size: 48px; color: #c7c2ff; margin-bottom: 12px; }
.spinner {
  width: 36px;
  height: 36px;
  border: 4px solid #eef1f7;
  border-top-color: #5942e9;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin: 0 auto 12px;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* BUTTONS */
.primary-btn {
  border: 0;
  border-radius: 8px;
  background: #5942e9;
  color: #fff;
  padding: 10px 18px;
  font-size: 13px;
  font-weight: 800;
  cursor: pointer;
}
.secondary-btn {
  border: 1px solid #d0d7de;
  border-radius: 8px;
  background: #fff;
  color: #24292f;
  padding: 10px 18px;
  font-size: 13px;
  font-weight: 800;
  cursor: pointer;
}
.success-btn {
  border: 0;
  border-radius: 8px;
  background: #2da44e;
  color: #fff;
  padding: 10px 18px;
  font-size: 13px;
  font-weight: 800;
}

/* CONTRACTS & BILLS CARDS */
.contracts-list, .bills-list, .tickets-list, .notifications-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.contract-card, .bill-card, .ticket-card, .noti-card {
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  padding: 18px;
  background: #fff;
}
.contract-header, .bill-header, .ticket-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}
.contract-code {
  display: inline-block;
  background: #f0f2f8;
  color: #5942e9;
  font-size: 12px;
  font-weight: 800;
  padding: 3px 8px;
  border-radius: 4px;
  margin-bottom: 4px;
}
.status-badge {
  font-size: 12px;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 999px;
  background: #eef1f7;
  color: #5942e9;
}
.status-badge.active, .status-badge.paid, .status-badge.resolved {
  background: #dafbe1;
  color: #1a7f37;
}
.status-badge.issued, .status-badge.pending, .status-badge.unpaid {
  background: #ffebe9;
  color: #cf222e;
}
.info-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
  font-size: 13px;
  border-bottom: 1px dashed #f0f2f8;
}
.contract-actions, .bill-actions {
  display: flex;
  gap: 12px;
  margin-top: 16px;
  justify-content: flex-end;
}
.bill-breakdown { margin: 14px 0; }
.bill-item {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  padding: 4px 0;
}
.bill-item.total {
  font-size: 15px;
  font-weight: 900;
  border-top: 1px solid #eef1f7;
  margin-top: 8px;
  padding-top: 8px;
}

/* CHAT BOX */
.chat-box {
  display: flex;
  flex-direction: column;
  height: 450px;
  border: 1px solid #e6eaf2;
  border-radius: 8px;
  background: #f8fafc;
}
.chat-messages {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.message-bubble {
  max-width: 70%;
  padding: 10px 14px;
  border-radius: 12px;
  font-size: 13px;
}
.message-bubble.income {
  align-self: flex-start;
  background: #fff;
  border: 1px solid #e6eaf2;
}
.message-bubble.outgoing {
  align-self: flex-end;
  background: #5942e9;
  color: #fff;
}
.message-bubble small {
  display: block;
  margin-top: 4px;
  font-size: 10px;
  opacity: 0.7;
  text-align: right;
}
.chat-input-row {
  display: flex;
  gap: 10px;
  padding: 12px;
  background: #fff;
  border-top: 1px solid #e6eaf2;
}
.chat-input-row input {
  flex: 1;
  border: 1px solid #e1e5ef;
  border-radius: 6px;
  padding: 0 14px;
  font-size: 13px;
}

/* MODALS */
.modal-backdrop {
  position: fixed;
  inset: 0;
  z-index: 1000;
  background: rgba(18, 25, 54, 0.6);
  backdrop-filter: blur(4px);
  display: grid;
  place-items: center;
  padding: 20px;
}
.modal-card {
  position: relative;
  width: min(560px, 100%);
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
}
.modal-close {
  position: absolute;
  top: 12px;
  right: 14px;
  z-index: 10;
  border: 0;
  background: rgba(0,0,0,0.5);
  color: #fff;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  cursor: pointer;
  font-weight: 900;
}
.modal-hero { position: relative; height: 220px; }
.modal-hero img { width: 100%; height: 100%; object-fit: cover; }
.modal-hero-badge {
  position: absolute;
  left: 16px;
  bottom: 16px;
  background: #5942e9;
  color: #fff;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 800;
}
.modal-body { padding: 24px; }
.modal-body h2 { margin: 0; font-size: 20px; color: #121936; }
.location-line { margin: 6px 0 12px; color: #7b849d; font-size: 13px; }
.price-hero { font-size: 24px; color: #5942e9; font-weight: 900; margin-bottom: 18px; }
.room-specs {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
  background: #f8fafc;
  padding: 12px;
  border-radius: 8px;
  text-align: center;
  margin-bottom: 18px;
}
.spec-item span { display: block; font-size: 11px; color: #7b849d; }
.spec-item strong { display: block; font-size: 13px; color: #121936; margin-top: 2px; }
.amenity-chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
.chip { background: #eef1f7; color: #303a5f; font-size: 12px; padding: 4px 10px; border-radius: 6px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }

/* QR MODAL */
.qr-modal { text-align: center; padding: 24px; }
.qr-image-container img { width: 220px; height: 220px; border-radius: 8px; border: 1px solid #e6eaf2; }
.qr-details { text-align: left; background: #f8fafc; padding: 14px; border-radius: 8px; margin: 16px 0; font-size: 13px; }
.qr-row { display: flex; justify-content: space-between; padding: 4px 0; }
.highlight-amt { color: #cf222e; font-size: 16px; }

/* FORMS */
.form-modal { padding: 24px; }
.form-grid { display: flex; flex-direction: column; gap: 14px; margin-top: 16px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group label { font-size: 13px; font-weight: 800; color: #303a5f; }
.form-group input, .form-group select, .form-group textarea {
  border: 1px solid #e1e5ef;
  border-radius: 6px;
  padding: 10px 14px;
  font-size: 13px;
  font-family: inherit;
}

/* FOOTER */
.tenant-footer {
  display: grid;
  grid-template-columns: 1.35fr repeat(4, minmax(0, 1fr));
  gap: 28px;
  margin-top: 34px;
  border-top: 1px solid #e6eaf2;
  padding: 30px 0 24px;
}
.footer-brand p { color: #6d7694; font-size: 12px; line-height: 1.6; margin-top: 12px; }
.socials { display: flex; gap: 10px; margin-top: 14px; }
.socials span {
  width: 28px;
  height: 28px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #eef1f7;
  font-size: 12px;
  font-weight: 900;
}
.tenant-footer strong { display: block; margin-bottom: 12px; color: #121936; font-size: 13px; }
.tenant-footer a { display: block; margin-top: 8px; color: #6d7694; font-size: 12px; text-decoration: none; }
.copyright { border-top: 1px solid #e6eaf2; color: #8b93a8; font-size: 12px; padding: 16px 0; text-align: center; }

@media (max-width: 1279px) {
  .content-grid { grid-template-columns: minmax(0, 1fr); }
  .right-panel { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); }
}
@media (max-width: 1100px) {
  .tenant-sidebar { display: none; }
  .tenant-main { margin-left: 0; }
  .room-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
