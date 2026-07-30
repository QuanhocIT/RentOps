<template>
  <AppLayout>
    <div class="owner-dashboard">
      <section class="dashboard-heading">
        <div>
          <span class="dashboard-kicker">BUSINESS OVERVIEW</span>
          <h1>Tổng quan</h1>
          <p>Cập nhật tình hình kinh doanh của bạn hôm nay</p>
        </div>
        <div class="dashboard-filters">
          <button type="button" class="date-filter">
            <span>01/06/2024 - 31/06/2024</span>
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4" y="5" width="16" height="15" rx="2" stroke="currentColor" stroke-width="1.6" /><path d="M8 3v4M16 3v4M4 10h16" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" /></svg>
          </button>
          <button type="button" class="filter-icon" aria-label="Chọn ngày">
            <svg viewBox="0 0 24 24" fill="none" aria-hidden="true"><rect x="4" y="5" width="16" height="15" rx="2" stroke="currentColor" stroke-width="1.6" /><path d="M8 3v4M16 3v4M4 10h16M8 14h.01M12 14h.01M16 14h.01M8 17h.01M12 17h.01" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" /></svg>
          </button>
        </div>
      </section>

      <section class="dashboard-kpis" aria-label="Chỉ số tổng quan">
        <article v-for="card in statCards" :key="card.label" class="metric-card">
          <div class="metric-topline">
            <span class="metric-icon" :class="card.iconClass"><svg viewBox="0 0 24 24" fill="none" v-html="card.icon"></svg></span>
            <span class="metric-delta">↑ {{ card.delta }}</span>
          </div>
          <div class="metric-label">{{ card.label }}</div>
          <div class="metric-value">{{ card.value }}</div>
          <div class="metric-caption">↑ <span>{{ card.caption || 'so với tháng trước' }}</span></div>
        </article>
      </section>

      <section class="dashboard-chart-grid">
        <article class="dashboard-panel revenue-panel">
          <div class="panel-heading">
            <div>
              <h2>Doanh thu</h2>
              <p>Biểu đồ 6 tháng gần nhất</p>
            </div>
            <button type="button" class="chart-period">Theo ngày <span>⌄</span></button>
          </div>

          <div class="revenue-chart-wrap">
            <div class="chart-y-axis"><span>100M</span><span>80M</span><span>60M</span><span>40M</span><span>20M</span><span>0</span></div>
            <div class="revenue-chart-area">
              <div class="chart-grid-lines"><i v-for="line in 6" :key="line"></i></div>
              <svg class="revenue-chart" viewBox="0 0 760 240" preserveAspectRatio="none" aria-label="Biểu đồ doanh thu">
                <defs>
                  <linearGradient id="revenueFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0" stop-color="#6256f5" stop-opacity=".22" />
                    <stop offset="1" stop-color="#6256f5" stop-opacity="0" />
                  </linearGradient>
                </defs>
                <path d="M0 201 C25 200 30 196 50 202 S75 194 92 198 S110 184 126 179 S143 146 158 153 S177 149 191 137 S207 146 220 139 S238 142 253 127 S267 119 278 128 S298 114 309 115 S327 129 341 125 S357 103 371 116 S391 106 403 118 S419 145 433 148 S447 167 462 161 S477 137 490 150 S506 184 521 175 S536 181 551 169 S567 143 580 152 S595 172 609 167 S626 135 642 141 S657 165 671 178 S687 185 700 153 S722 159 737 149 S752 143 760 132 L760 240 L0 240Z" fill="url(#revenueFill)" />
                <path d="M0 201 C25 200 30 196 50 202 S75 194 92 198 S110 184 126 179 S143 146 158 153 S177 149 191 137 S207 146 220 139 S238 142 253 127 S267 119 278 128 S298 114 309 115 S327 129 341 125 S357 103 371 116 S391 106 403 118 S419 145 433 148 S447 167 462 161 S477 137 490 150 S506 184 521 175 S536 181 551 169 S567 143 580 152 S595 172 609 167 S626 135 642 141 S657 165 671 178 S687 185 700 153 S722 159 737 149 S752 143 760 132" fill="none" stroke="#5149ed" stroke-width="3" stroke-linecap="round" vector-effect="non-scaling-stroke" />
                <line x1="371" y1="0" x2="371" y2="240" stroke="#dce0ee" stroke-dasharray="5 5" />
                <circle cx="371" cy="116" r="5" fill="#fff" stroke="#5149ed" stroke-width="3" vector-effect="non-scaling-stroke" />
              </svg>
              <div class="chart-tooltip"><strong>16/06/2024</strong><span><i></i> Doanh thu: 68.500.000 đ</span></div>
              <div class="chart-x-axis"><span>01/06</span><span>06/06</span><span>11/06</span><span>16/06</span><span>21/06</span><span>26/06</span><span>31/06</span></div>
            </div>
          </div>
        </article>

        <article class="dashboard-panel occupancy-panel">
          <div class="panel-heading">
            <div>
              <h2>Tỷ lệ lấp đầy phòng</h2>
              <p>Theo trạng thái phòng hiện tại</p>
            </div>
          </div>
          <div class="occupancy-content">
            <div class="occupancy-ring" :style="{ '--occupied': `${occupancyRate}%` }">
              <div class="occupancy-ring-inner"><strong>{{ occupancyRate }}%</strong><span>Đã lấp đầy</span></div>
            </div>
            <div class="occupancy-legend">
              <div><span><i class="legend-dot legend-dot--occupied"></i>Đã đặt</span><strong>{{ occupiedCount }} phòng</strong></div>
              <div><span><i class="legend-dot legend-dot--vacant"></i>Còn trống</span><strong>{{ vacantCount }} phòng</strong></div>
              <div><span><i class="legend-dot legend-dot--maintenance"></i>Bảo trì</span><strong>{{ maintenanceCount }} phòng</strong></div>
            </div>
          </div>
        </article>
      </section>

      <section class="quick-actions">
        <button v-for="action in quickActions" :key="action.title" type="button" class="quick-action" @click="$router.push(action.path)">
          <span class="quick-action-icon" :class="action.iconClass"><svg viewBox="0 0 24 24" fill="none" v-html="action.icon"></svg></span>
          <span><strong>{{ action.title }}</strong><small>{{ action.desc }}</small></span>
          <svg class="quick-action-arrow" viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="m9 18 6-6-6-6" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" /></svg>
        </button>
      </section>

      <section class="dashboard-data-grid">
        <article class="dashboard-panel table-panel booking-panel">
          <div class="panel-heading">
            <div><h2>Đặt phòng mới nhất</h2><p>Các giao dịch cần theo dõi</p></div>
            <RouterLink to="/contracts">Xem tất cả</RouterLink>
          </div>
          <div class="table-scroll">
            <table>
              <thead><tr><th>Mã đặt phòng</th><th>Khách hàng</th><th>Phòng</th><th>Nhận phòng</th><th>Trạng thái</th><th class="align-right">Tổng tiền</th></tr></thead>
              <tbody>
                <tr v-for="row in bookingRows" :key="row.code">
                  <td class="code-cell">{{ row.code }}</td>
                  <td><strong>{{ row.customer }}</strong><small>{{ row.email }}</small></td>
                  <td><strong>{{ row.room }}</strong><small>{{ row.property }}</small></td>
                  <td>{{ row.checkin }}</td>
                  <td><span class="status-pill" :class="row.statusClass">{{ row.status }}</span></td>
                  <td class="align-right money-cell">{{ row.total }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </article>

        <article class="dashboard-panel active-rooms-panel">
          <div class="panel-heading">
            <div><h2>Phòng hoạt động</h2><p>Xem nhanh mức lấp đầy</p></div>
            <RouterLink to="/properties">Xem tất cả</RouterLink>
          </div>
          <div class="active-room-list">
            <div v-for="room in activeRooms" :key="room.name" class="active-room">
              <img :src="room.image" :alt="room.name" />
              <div class="active-room-copy"><strong>{{ room.name }}</strong><small>{{ room.rooms }}</small><div class="room-progress"><i :style="{ width: `${room.fill}%` }"></i></div></div>
              <span>{{ room.occupancy }}</span>
            </div>
          </div>
        </article>
      </section>

      <section class="dashboard-data-grid dashboard-data-grid--bottom">
        <article class="dashboard-panel table-panel revenue-room-panel">
          <div class="panel-heading">
            <div><h2>Doanh thu theo phòng</h2><p>Hiệu suất doanh thu theo từng phòng</p></div>
            <RouterLink to="/reports">Xem báo cáo chi tiết</RouterLink>
          </div>
          <div class="table-scroll">
            <table>
              <thead><tr><th>Phòng</th><th>Doanh thu</th><th>Đặt phòng</th><th>Tỷ lệ lấp đầy</th><th class="align-right">Giá trung bình</th></tr></thead>
              <tbody>
                <tr v-for="row in revenueByRoom" :key="row.name">
                  <td><strong>{{ row.name }}</strong></td><td class="money-cell">{{ row.revenue }}</td><td>{{ row.bookings }}</td>
                  <td><div class="fill-cell"><span>{{ row.fillLabel }}</span><i><b :class="row.fillColor" :style="{ width: row.fillLabel }"></b></i></div></td><td class="align-right">{{ row.avg }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </article>

        <article class="dashboard-panel notifications-panel">
          <div class="panel-heading"><div><h2>Thông báo mới</h2><p>Những việc cần xử lý ngay</p></div><RouterLink to="/notifications">Xem tất cả</RouterLink></div>
          <div class="notification-list">
            <div v-for="item in notifications" :key="item.title" class="notification-item">
              <span class="notification-icon" :class="item.iconClass"><svg viewBox="0 0 24 24" fill="none" v-html="item.icon"></svg></span>
              <span class="notification-copy"><strong>{{ item.title }}</strong><small>{{ item.desc }}</small></span><time>{{ item.time }}</time>
            </div>
          </div>
        </article>
      </section>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const dashboardData = ref(null)
const rooms = ref([])
const hasLiveRooms = ref(false)

const fallbackRooms = [
  { id: 1, property_name: 'Deluxe City View', room_number: '101', price: 2850000, status: 'occupied', floor: 1 },
  { id: 2, property_name: 'Studio Balcony', room_number: '203', price: 1950000, status: 'vacant', floor: 2 },
  { id: 3, property_name: 'Family Room', room_number: '301', price: 3200000, status: 'occupied', floor: 3 },
  { id: 4, property_name: 'Standard Room', room_number: '102', price: 1560000, status: 'occupied', floor: 1 },
  { id: 5, property_name: 'Penthouse Suite', room_number: '501', price: 4250000, status: 'maintenance', floor: 5 }
]

const normalizeStatus = (status) => {
  if (status === 0 || status === '0') return 'vacant'
  if (status === 1 || status === '1') return 'occupied'
  if (status === 2 || status === '2') return 'reserved'
  if (status === 3 || status === '3') return 'maintenance'
  return status
}

const fetchData = async () => {
  try {
    const [roomsResponse, dashboardResponse] = await Promise.all([api.get('/rooms'), api.get('/dashboard/summary')])
    const roomsPayload = Array.isArray(roomsResponse) ? roomsResponse : roomsResponse?.data
    rooms.value = Array.isArray(roomsPayload) ? roomsPayload.map((room) => ({ ...room, status: normalizeStatus(room.status) })) : fallbackRooms
    hasLiveRooms.value = Array.isArray(roomsPayload)
    dashboardData.value = dashboardResponse?.data || dashboardResponse || null
  } catch {
    rooms.value = fallbackRooms
    hasLiveRooms.value = false
  }
}

onMounted(fetchData)

const liveCount = (status, demoValue) => computed(() => hasLiveRooms.value ? rooms.value.filter((room) => normalizeStatus(room.status) === status).length : demoValue)
const vacantCount = liveCount('vacant', 36)
const occupiedCount = liveCount('occupied', 156)
const maintenanceCount = liveCount('maintenance', 8)
const occupancyRate = computed(() => {
  if (!hasLiveRooms.value) return Number(dashboardData.value?.occupancy_rate || 78)
  const total = rooms.value.length || 1
  return Math.round((occupiedCount.value / total) * 100)
})

const formatCurrency = (value) => `${new Intl.NumberFormat('vi-VN').format(value || 0)} đ`

const iconPaths = {
  wallet: '<rect x="4" y="6" width="16" height="13" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M4 9h16M15 14h2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  document: '<path d="M7 3h8l3 3v15H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M14 3v4h4M9 11h6M9 15h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  heart: '<path d="M20.8 8.8c0 5.2-8.8 10-8.8 10s-8.8-4.8-8.8-10A4.8 4.8 0 0 1 8 4c1.5 0 3 .7 4 1.9A5 5 0 0 1 16 4a4.8 4.8 0 0 1 4.8 4.8Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  star: '<path d="m12 3 2.8 5.7 6.2.9-4.5 4.4 1.1 6.2-5.6-3-5.6 3 1.1-6.2L3 9.6l6.2-.9L12 3Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  house: '<path d="m4 10 8-6 8 6v9a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-9Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/><path d="M9 20v-6h6v6" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  calendar: '<rect x="4" y="5" width="16" height="15" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M8 3v4M16 3v4M4 10h16M8 14h.01M12 14h.01M16 14h.01" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>',
  chart: '<path d="M4 19V5m0 14h16" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/><path d="m7 15 3.2-3.5 2.7 2.2L19 7" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  bell: '<path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9ZM10 21h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>',
  message: '<path d="M5 6.5A3.5 3.5 0 0 1 8.5 3h7A3.5 3.5 0 0 1 19 6.5v5a3.5 3.5 0 0 1-3.5 3.5H12l-4 3v-3.5A3.5 3.5 0 0 1 5 11.5v-5Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>',
  sparkle: '<path d="m12 3 1.4 5.6L19 10l-5.6 1.4L12 17l-1.4-5.6L5 10l5.6-1.4L12 3Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/>'
}

const statCards = computed(() => [
  { label: 'Tổng doanh thu', value: formatCurrency(dashboardData.value?.financials?.paid_billed || 128500000), delta: '18.5%', icon: iconPaths.wallet, iconClass: 'metric-icon--purple' },
  { label: 'Đơn đặt phòng', value: dashboardData.value?.bookings_count || '156', delta: '12.5%', icon: iconPaths.document, iconClass: 'metric-icon--blue' },
  { label: 'Tỷ lệ lấp đầy', value: `${occupancyRate.value}%`, delta: '8.3%', icon: iconPaths.heart, iconClass: 'metric-icon--orange' },
  { label: 'Đánh giá trung bình', value: '4.8/5', delta: '0.3', caption: 'so với tháng trước', icon: iconPaths.star, iconClass: 'metric-icon--lavender' }
])

const quickActions = [
  { title: 'Thêm phòng mới', desc: 'Đăng phòng cho thuê', path: '/rooms', icon: iconPaths.house, iconClass: 'quick-icon--purple' },
  { title: 'Quản lý giá', desc: 'Cập nhật giá phòng', path: '/rooms', icon: iconPaths.wallet, iconClass: 'quick-icon--green' },
  { title: 'Xem lịch đặt phòng', desc: 'Quản lý lịch & đặt phòng', path: '/contracts', icon: iconPaths.calendar, iconClass: 'quick-icon--blue' },
  { title: 'Báo cáo doanh thu', desc: 'Xem chi tiết báo cáo', path: '/reports', icon: iconPaths.chart, iconClass: 'quick-icon--orange' }
]

const bookingRows = [
  { code: '#BK12456', customer: 'Trần Thị Mai', email: 'maitran@email.com', room: 'Deluxe City View', property: '101', checkin: '20/06/2024', status: 'Đã xác nhận', statusClass: 'status-confirmed', total: '2.500.000 đ' },
  { code: '#BK12455', customer: 'Lê Hoàng Nam', email: 'namle@email.com', room: 'Studio Balcony', property: '203', checkin: '21/06/2024', status: 'Chờ xác nhận', statusClass: 'status-pending', total: '1.800.000 đ' },
  { code: '#BK12454', customer: 'Phạm Minh Anh', email: 'anhpham@email.com', room: 'Family Room', property: '301', checkin: '22/06/2024', status: 'Đã thanh toán', statusClass: 'status-paid', total: '3.200.000 đ' },
  { code: '#BK12453', customer: 'Nguyễn Văn Hùng', email: 'hungnguyen@email.com', room: 'Deluxe City View', property: '102', checkin: '23/06/2024', status: 'Đã xác nhận', statusClass: 'status-confirmed', total: '2.500.000 đ' },
  { code: '#BK12452', customer: 'Vũ Thị Hương', email: 'huongvu@email.com', room: 'Studio Balcony', property: '204', checkin: '24/06/2024', status: 'Đã hủy', statusClass: 'status-cancelled', total: '1.800.000 đ' }
]

const activeRooms = [
  { name: 'Deluxe City View', rooms: '12 phòng', fill: 86, occupancy: '10/12 phòng', image: '/images/rooms/main.png' },
  { name: 'Studio Balcony', rooms: '8 phòng', fill: 70, occupancy: '6/8 phòng', image: '/images/rooms/living.png' },
  { name: 'Family Room', rooms: '6 phòng', fill: 83, occupancy: '5/6 phòng', image: '/images/rooms/kitchen.png' },
  { name: 'Standard Room', rooms: '10 phòng', fill: 70, occupancy: '7/10 phòng', image: '/images/rooms/bathroom.png' },
  { name: 'Penthouse Suite', rooms: '2 phòng', fill: 50, occupancy: '1/2 phòng', image: '/images/bedroom.png' }
]

const revenueByRoom = [
  { name: 'Deluxe City View', revenue: '28.500.000 đ', bookings: 35, fillLabel: '85%', fillColor: 'fill-green', avg: '2.850.000 đ' },
  { name: 'Studio Balcony', revenue: '18.200.000 đ', bookings: 28, fillLabel: '70%', fillColor: 'fill-yellow', avg: '1.950.000 đ' },
  { name: 'Family Room', revenue: '24.800.000 đ', bookings: 22, fillLabel: '73%', fillColor: 'fill-green', avg: '3.200.000 đ' },
  { name: 'Standard Room', revenue: '15.600.000 đ', bookings: 30, fillLabel: '60%', fillColor: 'fill-orange', avg: '1.560.000 đ' },
  { name: 'Penthouse Suite', revenue: '8.500.000 đ', bookings: 8, fillLabel: '50%', fillColor: 'fill-red', avg: '4.250.000 đ' }
]

const notifications = [
  { icon: iconPaths.house, iconClass: 'notification-icon--green', title: 'Đặt phòng mới', desc: 'Trần Thị Mai đã đặt phòng Deluxe City View', time: '2 phút trước' },
  { icon: iconPaths.star, iconClass: 'notification-icon--yellow', title: 'Nhận xét mới', desc: 'Khách hàng đã để lại đánh giá 5 sao', time: '15 phút trước' },
  { icon: iconPaths.wallet, iconClass: 'notification-icon--blue', title: 'Thanh toán thành công', desc: 'Lê Hoàng Nam đã thanh toán thành công', time: '1 giờ trước' },
  { icon: iconPaths.bell, iconClass: 'notification-icon--purple', title: 'Nhắc nhở', desc: 'Có 3 đặt phòng sẽ đến trong hôm nay', time: '2 giờ trước' }
]
</script>

<style scoped>
.owner-dashboard {
  max-width: 1440px;
  margin: 0 auto;
  color: #1d2946;
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.dashboard-heading,
.panel-heading,
.metric-topline,
.dashboard-filters,
.quick-action,
.fill-cell,
.notification-item {
  display: flex;
  align-items: center;
}

.dashboard-heading {
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 20px;
}

.dashboard-kicker {
  display: block;
  margin-bottom: 7px;
  color: #7564ea;
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.18em;
}

.dashboard-heading h1 {
  margin: 0;
  color: #1b2642;
  font-size: 27px;
  font-weight: 800;
  letter-spacing: -0.04em;
}

.dashboard-heading p,
.panel-heading p {
  margin: 5px 0 0;
  color: #8993a8;
  font-size: 11px;
}

.dashboard-filters {
  gap: 10px;
}

.date-filter,
.filter-icon,
.chart-period {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  min-height: 38px;
  border: 1px solid #e3e8f1;
  border-radius: 10px;
  color: #52607a;
  font: inherit;
  font-size: 11px;
  font-weight: 650;
  background: #fff;
  box-shadow: 0 2px 4px rgba(33, 49, 85, 0.025);
  cursor: pointer;
}

.date-filter {
  padding: 0 12px;
}

.filter-icon {
  width: 38px;
  padding: 0;
  color: #7660ed;
}

.date-filter svg,
.filter-icon svg {
  width: 15px;
  height: 15px;
  color: #7f8ba2;
}

.dashboard-kpis {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 15px;
  margin-bottom: 18px;
}

.metric-card,
.dashboard-panel,
.quick-action {
  border: 1px solid #e4e9f2;
  background: #fff;
  box-shadow: 0 5px 18px rgba(40, 54, 88, 0.035);
}

.metric-card {
  min-width: 0;
  min-height: 137px;
  padding: 17px 18px 15px;
  border-radius: 15px;
}

.metric-topline {
  justify-content: space-between;
}

.metric-icon,
.quick-action-icon,
.notification-icon {
  display: grid;
  place-items: center;
  border-radius: 11px;
}

.metric-icon {
  width: 38px;
  height: 38px;
}

.metric-icon svg,
.quick-action-icon svg,
.notification-icon svg {
  width: 19px;
  height: 19px;
}

.metric-icon--purple,
.quick-icon--purple,
.notification-icon--purple {
  color: #6954ef;
  background: #efedff;
}

.metric-icon--blue,
.quick-icon--blue,
.notification-icon--blue {
  color: #468fe9;
  background: #eaf5ff;
}

.metric-icon--orange,
.quick-icon--orange,
.notification-icon--yellow {
  color: #f2a51c;
  background: #fff5de;
}

.metric-icon--lavender {
  color: #8a55e9;
  background: #f2edff;
}

.metric-delta,
.metric-caption {
  color: #0aa874;
  font-size: 10px;
  font-weight: 750;
}

.metric-label {
  margin-top: 14px;
  color: #68738b;
  font-size: 11px;
  font-weight: 650;
}

.metric-value {
  margin-top: 4px;
  color: #15213d;
  font-size: 23px;
  font-weight: 800;
  letter-spacing: -0.04em;
  white-space: nowrap;
}

.metric-caption {
  margin-top: 8px;
  font-size: 10px;
}

.metric-caption span {
  color: #8792a7;
  font-weight: 500;
}

.dashboard-chart-grid,
.dashboard-data-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.65fr) minmax(330px, 1fr);
  gap: 15px;
  margin-bottom: 18px;
}

.dashboard-panel {
  min-width: 0;
  border-radius: 15px;
}

.revenue-panel,
.occupancy-panel {
  min-height: 330px;
  padding: 20px;
}

.panel-heading {
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 16px;
}

.panel-heading h2 {
  margin: 0;
  color: #1c2845;
  font-size: 14px;
  font-weight: 800;
}

.panel-heading a {
  flex: 0 0 auto;
  color: #5d48ef;
  font-size: 10px;
  font-weight: 750;
  text-decoration: none;
}

.chart-period {
  min-height: 31px;
  padding: 0 10px;
  font-size: 10px;
  font-weight: 600;
}

.chart-period span {
  color: #6b55ec;
  font-size: 13px;
}

.revenue-chart-wrap {
  display: grid;
  grid-template-columns: 35px 1fr;
  gap: 8px;
  height: 240px;
}

.chart-y-axis {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 2px 0 28px;
  color: #8e98ab;
  font-size: 9px;
  text-align: right;
}

.revenue-chart-area {
  position: relative;
  min-width: 0;
}

.chart-grid-lines {
  position: absolute;
  inset: 0 0 29px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.chart-grid-lines i {
  display: block;
  width: 100%;
  border-top: 1px dashed #e7ebf3;
}

.revenue-chart {
  position: absolute;
  inset: 0 0 29px;
  width: 100%;
  height: calc(100% - 29px);
  overflow: visible;
}

.chart-tooltip {
  position: absolute;
  top: 5px;
  left: 44%;
  display: flex;
  flex-direction: column;
  gap: 5px;
  padding: 9px 11px;
  border: 1px solid #e5e8f1;
  border-radius: 8px;
  color: #718098;
  font-size: 9px;
  background: #fff;
  box-shadow: 0 7px 18px rgba(36, 50, 87, 0.1);
}

.chart-tooltip strong {
  color: #34415e;
  font-size: 9px;
}

.chart-tooltip i {
  display: inline-block;
  width: 5px;
  height: 5px;
  margin-right: 4px;
  border-radius: 50%;
  background: #5c50ee;
}

.chart-x-axis {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  display: flex;
  justify-content: space-between;
  color: #8390a7;
  font-size: 9px;
}

.occupancy-content {
  display: flex;
  align-items: center;
  justify-content: space-around;
  gap: 22px;
  min-height: 240px;
}

.occupancy-ring {
  position: relative;
  display: grid;
  width: 180px;
  height: 180px;
  flex: 0 0 auto;
  place-items: center;
  border-radius: 50%;
  background: conic-gradient(#5347ec 0 var(--occupied), #59a9ed var(--occupied) 96%, #f3a21a 96% 100%);
}

.occupancy-ring::after {
  position: absolute;
  inset: 17px;
  border-radius: 50%;
  background: #fff;
  content: "";
}

.occupancy-ring-inner {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.occupancy-ring-inner strong {
  color: #192542;
  font-size: 25px;
  font-weight: 800;
}

.occupancy-ring-inner span {
  margin-top: 2px;
  color: #8d96aa;
  font-size: 10px;
}

.occupancy-legend {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 20px;
  min-width: 130px;
}

.occupancy-legend > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  color: #69758d;
  font-size: 10px;
}

.occupancy-legend span {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.occupancy-legend strong {
  color: #27334f;
  font-size: 10px;
  white-space: nowrap;
}

.legend-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
}

.legend-dot--occupied { background: #5c50ed; }
.legend-dot--vacant { background: #59a9ed; }
.legend-dot--maintenance { background: #f3a21a; }

.quick-actions {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 15px;
  margin-bottom: 18px;
}

.quick-action {
  gap: 11px;
  min-width: 0;
  padding: 13px;
  border-radius: 12px;
  text-align: left;
  cursor: pointer;
}

.quick-action:hover {
  border-color: #cec8ff;
  transform: translateY(-1px);
}

.quick-action-icon {
  width: 36px;
  height: 36px;
  flex: 0 0 auto;
}

.quick-icon--green,
.notification-icon--green {
  color: #25ad79;
  background: #e8f8ee;
}

.quick-action > span:nth-child(2) {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-width: 0;
}

.quick-action strong,
.quick-action small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.quick-action strong {
  color: #27334f;
  font-size: 11px;
  font-weight: 800;
}

.quick-action small {
  margin-top: 4px;
  color: #8c96a9;
  font-size: 9px;
}

.quick-action-arrow {
  width: 14px;
  height: 14px;
  color: #a0a8b8;
}

.dashboard-data-grid {
  grid-template-columns: minmax(0, 1.75fr) minmax(310px, 1fr);
}

.table-panel,
.active-rooms-panel,
.notifications-panel {
  padding: 19px 20px 20px;
}

.table-panel .panel-heading,
.active-rooms-panel .panel-heading,
.notifications-panel .panel-heading {
  margin-bottom: 14px;
}

.table-scroll {
  width: 100%;
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  color: #68738a;
  font-size: 9px;
  white-space: nowrap;
}

th {
  padding: 10px 9px;
  color: #7e899e;
  font-size: 8px;
  font-weight: 800;
  text-align: left;
  background: #fafbfe;
}

td {
  padding: 11px 9px;
  border-top: 1px solid #f0f2f6;
  vertical-align: middle;
}

td strong,
td small {
  display: block;
}

td strong {
  color: #2a3550;
  font-size: 9px;
  font-weight: 750;
}

td small {
  margin-top: 3px;
  color: #a1a9b7;
  font-size: 8px;
}

.code-cell {
  color: #5262ad;
  font-weight: 750;
}

.money-cell {
  color: #2a3550;
  font-weight: 750;
}

.align-right {
  text-align: right;
}

.status-pill {
  display: inline-block;
  padding: 4px 7px;
  border-radius: 5px;
  font-size: 8px;
  font-weight: 750;
}

.status-confirmed { color: #15905b; background: #e7f8ee; }
.status-pending { color: #cd8a10; background: #fff4d9; }
.status-paid { color: #277bc2; background: #e9f3ff; }
.status-cancelled { color: #dd5365; background: #ffebee; }

.active-room-list,
.notification-list {
  display: flex;
  flex-direction: column;
}

.active-room {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 0;
}

.active-room + .active-room,
.notification-item + .notification-item {
  border-top: 1px solid #f0f2f6;
}

.active-room img {
  width: 38px;
  height: 38px;
  flex: 0 0 auto;
  border-radius: 8px;
  object-fit: cover;
}

.active-room-copy {
  flex: 1;
  min-width: 0;
}

.active-room-copy strong,
.active-room-copy small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.active-room-copy strong {
  color: #2a3550;
  font-size: 10px;
  font-weight: 800;
}

.active-room-copy small {
  margin-top: 3px;
  color: #929cad;
  font-size: 8px;
}

.room-progress {
  height: 4px;
  margin-top: 7px;
  overflow: hidden;
  border-radius: 99px;
  background: #edf0f6;
}

.room-progress i {
  display: block;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, #6047ec, #7658ed);
}

.active-room > span {
  color: #69758c;
  font-size: 9px;
  white-space: nowrap;
}

.dashboard-data-grid--bottom {
  margin-bottom: 0;
}

.fill-cell {
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
  min-width: 78px;
}

.fill-cell span {
  color: #69758c;
  font-size: 8px;
}

.fill-cell > i {
  display: block;
  width: 70px;
  height: 4px;
  overflow: hidden;
  border-radius: 99px;
  background: #edf0f5;
}

.fill-cell b {
  display: block;
  height: 100%;
  border-radius: inherit;
}

.fill-green { background: #18a66c; }
.fill-yellow { background: #f3bb27; }
.fill-orange { background: #f2982d; }
.fill-red { background: #eb4e58; }

.notification-item {
  gap: 9px;
  padding: 10px 0;
}

.notification-icon {
  width: 34px;
  height: 34px;
  flex: 0 0 auto;
}

.notification-icon--green { color: #22aa78; background: #e9f8ef; }
.notification-icon--yellow { color: #e4a01a; background: #fff4dc; }
.notification-icon--blue { color: #438de4; background: #eaf5ff; }

.notification-copy {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-width: 0;
}

.notification-copy strong,
.notification-copy small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notification-copy strong {
  color: #2b3651;
  font-size: 10px;
  font-weight: 800;
}

.notification-copy small {
  margin-top: 4px;
  color: #8f99ab;
  font-size: 8px;
}

.notification-item time {
  align-self: flex-start;
  color: #a1a9b7;
  font-size: 8px;
  white-space: nowrap;
}

@media (max-width: 1180px) {
  .dashboard-kpis,
  .quick-actions {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .dashboard-chart-grid,
  .dashboard-data-grid {
    grid-template-columns: 1fr;
  }

  .occupancy-content {
    justify-content: center;
  }
}

@media (max-width: 680px) {
  .dashboard-heading {
    align-items: flex-start;
    flex-direction: column;
  }

  .dashboard-filters {
    width: 100%;
  }

  .date-filter {
    flex: 1;
  }

  .dashboard-kpis,
  .quick-actions {
    grid-template-columns: 1fr;
  }

  .metric-value {
    font-size: 21px;
  }

  .revenue-panel,
  .occupancy-panel,
  .table-panel,
  .active-rooms-panel,
  .notifications-panel {
    padding: 16px;
  }

  .occupancy-content {
    align-items: center;
    flex-direction: column;
  }

  .occupancy-legend {
    width: 100%;
  }

  .panel-heading a {
    font-size: 9px;
  }
}
</style>
