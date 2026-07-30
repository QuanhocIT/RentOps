<template>
  <div class="superadmin-page">
    <aside class="sa-sidebar" :class="{ 'is-open': mobileSidebarOpen }">
      <div class="sa-brand">
        <div class="sa-brand-mark"><span>⌂</span></div>
        <div>
          <div class="sa-brand-name">StayRent</div>
          <div class="sa-brand-caption">SaaS Rental Platform</div>
        </div>
      </div>

      <nav class="sa-nav" aria-label="Điều hướng Superadmin">
        <button
          v-for="item in mainNavItems"
          :key="item.id"
          type="button"
          class="sa-nav-link"
          :class="{ active: activeNavGroup === item.group }"
          @click="setActiveTab(item.tab, item.group)"
        >
          <span class="sa-nav-icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
          <span v-if="item.chevron" class="sa-nav-chevron">›</span>
        </button>

        <div class="sa-nav-section">BÁO CÁO & PHÂN TÍCH</div>
        <button
          v-for="item in reportNavItems"
          :key="item.id"
          type="button"
          class="sa-nav-link"
          :class="{ active: activeNavGroup === item.group }"
          @click="setActiveTab(item.tab, item.group)"
        >
          <span class="sa-nav-icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
          <span v-if="item.chevron" class="sa-nav-chevron">›</span>
        </button>

        <div class="sa-nav-section">BẢO MẬT & KIỂM DUYỆT</div>
        <button
          v-for="item in securityNavItems"
          :key="item.id"
          type="button"
          class="sa-nav-link"
          :class="{ active: activeNavGroup === item.group }"
          @click="setActiveTab(item.tab, item.group)"
        >
          <span class="sa-nav-icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
          <span v-if="item.chevron" class="sa-nav-chevron">›</span>
        </button>
      </nav>

      <div class="sa-security-card">
        <div class="sa-security-icon">⬟</div>
        <div class="sa-security-title">Hệ thống an toàn</div>
        <div class="sa-security-copy">Bảo mật liên tục 24/7<br />100% dữ liệu được mã hóa</div>
        <button type="button" @click="setActiveTab('health')">Xem chi tiết</button>
      </div>
      <div class="sa-sidebar-footer">
        <button type="button" class="sa-sidebar-logout" @click="handleLogout">
          🚪 Đăng xuất
        </button>
        <div class="sa-copyright-text">© 2025 StayRent SaaS</div>
      </div>
    </aside>

    <div v-if="mobileSidebarOpen" class="sa-sidebar-backdrop" @click="mobileSidebarOpen = false"></div>

    <div class="sa-shell">
      <header class="sa-topbar">
        <div class="sa-topbar-left">
          <button type="button" class="sa-menu-button" aria-label="Mở menu" @click="mobileSidebarOpen = !mobileSidebarOpen">☰</button>
          <div>
            <h1>{{ headerTitle }}</h1>
            <p>Tổng quan hệ thống cho thuê phòng, căn hộ</p>
          </div>
        </div>

        <div class="sa-topbar-actions">
          <label class="sa-search">
            <span>⌕</span>
            <input v-model="searchTerm" type="search" placeholder="Tìm kiếm nhanh..." />
            <kbd>Ctrl + K</kbd>
          </label>
          <button type="button" class="sa-icon-button" aria-label="Đổi giao diện">☾</button>
          <button type="button" class="sa-icon-button sa-notification-button" aria-label="Thông báo">
            ♧<span>12</span>
          </button>
          <button type="button" class="sa-icon-button" aria-label="Ngôn ngữ">◎</button>

          <div class="sa-user-wrapper">
            <div class="sa-user-menu" @click="showProfileDropdown = !showProfileDropdown">
              <div class="sa-avatar">{{ adminInitials }}</div>
              <div class="sa-user-copy">
                <strong>{{ adminName }}</strong>
                <small>{{ adminEmail }}</small>
              </div>
              <span class="sa-user-chevron">⌄</span>
            </div>

            <div v-if="showProfileDropdown" class="sa-profile-dropdown">
              <div class="sa-dropdown-header">
                <strong>{{ adminName }}</strong>
                <p>{{ adminEmail }}</p>
              </div>
              <div class="sa-dropdown-divider"></div>
              <button type="button" class="sa-dropdown-item sa-logout-item" @click="handleLogout">
                🚪 Đăng xuất tài khoản
              </button>
            </div>
          </div>
        </div>
      </header>

      <main class="sa-content">
        <div class="sa-page-toolbar">
          <div></div>
          <button type="button" class="sa-date-filter"><span>▣</span> 01/06/2025 - 30/06/2025 <span>⌄</span></button>
        </div>

        <section v-if="activeTab === 'tenants'" class="sa-dashboard">
          <div class="sa-kpi-grid">
            <article v-for="metric in metrics" :key="metric.label" class="sa-kpi-card">
              <div class="sa-kpi-head">
                <span>{{ metric.label }}</span>
                <span class="sa-kpi-icon" :class="`tone-${metric.tone}`">{{ metric.icon }}</span>
              </div>
              <div class="sa-kpi-value">{{ metric.value }}</div>
              <div class="sa-kpi-foot" :class="metric.trendTone">
                <span>{{ metric.trend }}</span>
                <small>{{ metric.caption }}</small>
              </div>
            </article>
          </div>

          <div class="sa-dashboard-grid">
            <article class="sa-card sa-revenue-card">
              <div class="sa-card-heading">
                <div>
                  <h2>Doanh thu hệ thống <span class="sa-info">i</span></h2>
                  <div class="sa-card-number">{{ formatCurrency(data.mrr_estimate) }} <span>↗ 22.1% so với tháng trước</span></div>
                </div>
                <div class="sa-chart-filters"><button type="button">Doanh thu⌄</button><button type="button">Theo ngày⌄</button><button type="button">⋮</button></div>
              </div>
              <div class="sa-line-chart">
                <div class="sa-y-axis"><span>3B</span><span>2.5B</span><span>2B</span><span>1.5B</span><span>1B</span><span>500M</span><span>0</span></div>
                <svg viewBox="0 0 640 220" preserveAspectRatio="none" aria-label="Biểu đồ doanh thu">
                  <defs>
                    <linearGradient id="revenueFill" x1="0" x2="0" y1="0" y2="1">
                      <stop offset="0" stop-color="#7750e8" stop-opacity=".28" />
                      <stop offset="1" stop-color="#7750e8" stop-opacity="0" />
                    </linearGradient>
                  </defs>
                  <g class="sa-grid-lines"><path d="M0 22H640" /><path d="M0 57H640" /><path d="M0 92H640" /><path d="M0 127H640" /><path d="M0 162H640" /><path d="M0 197H640" /></g>
                  <path class="sa-revenue-area" d="M0 180 C22 178 30 174 48 176 S80 170 95 154 S114 133 128 152 S148 172 165 151 S192 158 208 142 S234 149 254 114 S270 122 288 103 S308 123 326 130 S350 143 372 120 S397 140 418 137 S441 150 460 130 S477 142 500 126 S521 143 544 127 S565 97 581 57 S599 40 611 72 S628 79 640 67 V220 H0Z" />
                  <path class="sa-revenue-line" d="M0 180 C22 178 30 174 48 176 S80 170 95 154 S114 133 128 152 S148 172 165 151 S192 158 208 142 S234 149 254 114 S270 122 288 103 S308 123 326 130 S350 143 372 120 S397 140 418 137 S441 150 460 130 S477 142 500 126 S521 143 544 127 S565 97 581 57 S599 40 611 72 S628 79 640 67" />
                  <circle cx="288" cy="103" r="4" class="sa-chart-point" />
                </svg>
                <div class="sa-chart-tooltip"><small>15/06/2025</small><strong>Thu: 2.350.000.000 VNĐ</strong></div>
                <div class="sa-x-axis"><span>01/06</span><span>05/06</span><span>10/06</span><span>15/06</span><span>20/06</span><span>25/06</span><span>30/06</span></div>
              </div>
            </article>

            <article class="sa-card sa-service-card">
              <div class="sa-card-heading"><h2>Doanh thu theo gói dịch vụ</h2><button type="button" class="sa-more">⋮</button></div>
              <div class="sa-donut-row">
                <div class="sa-donut"><div><strong>2.45B</strong><small>VNĐ</small></div></div>
                <div class="sa-legend">
                  <div v-for="item in serviceBreakdown" :key="item.name"><span class="sa-legend-dot" :style="{ background: item.color }"></span><div><strong>{{ item.name }}</strong><small>{{ item.value }} ({{ item.percent }})</small></div></div>
                </div>
              </div>
              <div class="sa-donut-total"><span>Tổng doanh thu</span><strong>{{ formatCurrency(data.mrr_estimate) }}</strong></div>
            </article>

            <article class="sa-card sa-system-card">
              <div class="sa-card-heading"><h2>Tình trạng hệ thống</h2><button type="button" class="sa-link" @click="setActiveTab('health')">Xem chi tiết</button></div>
              <div class="sa-health-list">
                <div v-for="service in systemServices" :key="service.name" class="sa-health-row"><span class="sa-health-icon">{{ service.icon }}</span><span>{{ service.name }}</span><span class="sa-health-status" :class="service.tone"><i></i>{{ service.status }}</span></div>
              </div>
            </article>

            <article class="sa-card sa-plan-highlight">
              <div class="sa-plan-copy"><small>Gói dịch vụ phổ biến nhất</small><strong>{{ topPlan.name }}</strong><span>59.2% tổng doanh thu</span></div>
              <div class="sa-plan-crown">♛</div>
            </article>

            <article class="sa-card sa-growth-card">
              <div class="sa-card-heading"><h2>Tăng trưởng doanh nghiệp</h2><small>12 tháng gần nhất</small></div>
              <div class="sa-growth-chart">
                <div class="sa-growth-y"><span>1.6K</span><span>1.2K</span><span>800</span><span>400</span><span>0</span></div>
                <div class="sa-bars"><div v-for="(bar, index) in growthBars" :key="index" class="sa-bar-wrap"><span class="sa-bar" :style="{ height: `${bar}%` }"></span><small>T{{ index + 1 }}</small></div></div>
              </div>
              <div class="sa-growth-total"><strong>{{ data.total_tenants || 0 }}</strong><span>doanh nghiệp</span></div>
            </article>
          </div>

          <article class="sa-card sa-enterprise-card">
            <div class="sa-card-heading">
              <div><h2>Doanh nghiệp mới đăng ký</h2><p>Danh sách các chủ trọ và tòa nhà mới tham gia hệ thống</p></div>
              <div class="sa-heading-actions"><button type="button" class="sa-link" @click="openCreateTenantModal">＋ Thêm doanh nghiệp</button><button type="button" class="sa-link" @click="setActiveTab('tenants', 'businesses')">Xem tất cả doanh nghiệp →</button></div>
            </div>
            <div class="sa-table-wrap">
              <table class="sa-enterprise-table">
                <thead><tr><th>Doanh nghiệp</th><th>Gói dịch vụ</th><th>Người dùng</th><th>Phòng / Căn hộ</th><th>Ngày đăng ký</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                  <tr v-for="tenant in filteredTenants.slice(0, 6)" :key="tenant.id">
                    <td><div class="sa-company"><span class="sa-company-logo" :class="companyTone(tenant)">{{ tenantInitial(tenant) }}</span><span><strong>{{ tenant.name }}</strong><small>{{ tenant.subdomain || 'rentops' }}@example.com</small></span></div></td>
                    <td><span class="sa-plan-pill" :class="planTone(tenant.plan)">{{ tenant.plan?.name || 'Gói Free' }}</span></td>
                    <td>{{ tenant.user_count || 0 }}</td><td>{{ tenant.room_count || data.total_rooms || 0 }}</td>
                    <td>{{ formatDate(tenant.created_at) }}</td>
                    <td><span class="sa-status-pill" :class="tenant.status === 'suspended' ? 'warning' : 'success'">{{ tenant.status === 'suspended' ? 'Chờ duyệt' : 'Hoạt động' }}</span></td>
                    <td><div class="sa-row-actions"><select aria-label="Đổi gói dịch vụ" @change="changePlan(tenant.id, $event.target.value)"><option value="" disabled selected>Đổi gói</option><option v-for="plan in data.plans" :key="plan.id" :value="plan.id">{{ plan.name }}</option></select><button type="button" class="sa-row-action" :title="tenant.status === 'suspended' ? 'Mở khóa' : 'Khóa'" @click="toggleTenantStatus(tenant.id)">{{ tenant.status === 'suspended' ? '◉' : '⊘' }}</button><button type="button" class="sa-row-action danger" title="Xóa tenant" @click="deleteTenant(tenant)">×</button></div></td>
                  </tr>
                  <tr v-if="filteredTenants.length === 0"><td colspan="7" class="sa-empty">Chưa có doanh nghiệp nào được ghi nhận.</td></tr>
                </tbody>
              </table>
            </div>
          </article>

          <article class="sa-card sa-plans-card">
            <div class="sa-card-heading"><div><h2>Gói dịch vụ RentOps</h2><p>Quản lý các gói SaaS đang cung cấp cho doanh nghiệp</p></div><button type="button" class="sa-primary-button" @click="openCreatePlanModal()">＋ Tạo gói mới</button></div>
            <div class="sa-plan-grid"><div v-for="plan in data.plans" :key="plan.id" class="sa-plan-item"><div><strong>{{ plan.name }}</strong><small>{{ plan.description || `Tối đa ${plan.max_rooms} phòng` }}</small></div><div class="sa-plan-price">{{ formatCurrency(plan.monthly_price) }}<button type="button" @click="openCreatePlanModal(plan)">Sửa</button></div></div></div>
          </article>
        </section>

        <section v-else-if="activeTab === 'health'" class="sa-tab-content">
          <article class="sa-card sa-tab-card"><div class="sa-card-heading"><div><h2>⚡ Môi trường server & hạ tầng kỹ thuật</h2><p>Thông số runtime, phiên bản phần mềm và kiểm tra sức khỏe hệ thống</p></div><button type="button" class="sa-secondary-button" @click="fetchSystemHealth">↻ Làm mới</button></div><div class="sa-health-metrics"><div><small>Ruby Engine</small><strong>{{ healthData.ruby_version || '3.2.x' }}</strong></div><div><small>Rails Framework</small><strong>{{ healthData.rails_version || '7.1.x' }}</strong></div><div><small>Cơ sở dữ liệu</small><strong>{{ healthData.database_adapter || 'PostgreSQL' }}</strong></div><div><small>Trạng thái hệ thống</small><strong class="text-success"><i></i>{{ healthData.uptime_info || 'Online • Normal' }}</strong></div></div></article>
          <article class="sa-card sa-tab-card"><div class="sa-card-heading"><div><h2>📊 Thống kê toàn nền tảng</h2><p>Các chỉ số đang được đồng bộ từ hệ thống RentOps</p></div></div><div class="sa-health-metrics four"><div><small>Tổng tòa nhà / khu trọ</small><strong>{{ healthData.total_properties || 0 }}</strong></div><div><small>Tổng phòng trọ</small><strong>{{ healthData.total_rooms || 0 }}</strong></div><div><small>Tổng hợp đồng</small><strong>{{ healthData.total_contracts || 0 }}</strong></div><div><small>Tổng hóa đơn phát hành</small><strong>{{ healthData.total_bills || 0 }}</strong></div></div></article>
        </section>

        <section v-else-if="activeTab === 'broadcast'" class="sa-tab-content"><article class="sa-card sa-tab-card sa-broadcast-card"><div class="sa-card-heading"><div><h2>📢 Phát thông báo toàn hệ thống</h2><p>Gửi thông điệp quan trọng, lịch bảo trì hoặc cập nhật tính năng tới toàn bộ chủ trọ</p></div></div><form @submit.prevent="sendBroadcast" class="sa-form"><label>Tiêu đề thông báo *<input v-model="broadcastForm.title" required type="text" placeholder="[BẢO TRÌ HỆ THỐNG] Nâng cấp Server" /></label><label>Kênh phát thông báo<select v-model="broadcastForm.channel"><option value="zns">ZNS / Zalo Official Notification</option><option value="sms">SMS Brandname</option><option value="email">Email System</option></select></label><label>Nội dung thông báo *<textarea v-model="broadcastForm.content" required rows="5" placeholder="Nhập nội dung thông báo muốn gửi..."></textarea></label><button type="submit" class="sa-primary-button">🚀 Phát thông báo ngay</button></form></article></section>

        <section v-else-if="activeTab === 'reports_overview' || activeTab === 'analytics'" class="sa-tab-content">
          <article class="sa-card sa-tab-card">
            <div class="sa-card-heading">
              <div><h2>📊 Báo cáo & Phân tích tổng quan</h2><p>Thống kê hiệu suất kinh doanh, tăng trưởng doanh nghiệp và chỉ số MRR</p></div>
              <button type="button" class="sa-secondary-button" @click="fetchOverview">↻ Làm mới dữ liệu</button>
            </div>
            <div class="sa-health-metrics four">
              <div><small>Ước tính MRR</small><strong>{{ formatCurrency(data.mrr_estimate) }}</strong></div>
              <div><small>Doanh nghiệp hoạt động</small><strong>{{ data.active_tenants || data.total_tenants || 0 }}</strong></div>
              <div><small>Tổng số phòng</small><strong>{{ data.total_rooms || 0 }}</strong></div>
              <div><small>Tỷ lệ lấp đầy</small><strong>{{ occupancyRate }}%</strong></div>
            </div>
          </article>
        </section>

        <section v-else-if="activeTab === 'kyc'" class="sa-tab-content">
          <article class="sa-card sa-tab-card">
            <div class="sa-card-heading">
              <div><h2>🛡️ KYC & Xác minh doanh nghiệp</h2><p>Duyệt giấy phép kinh doanh và xác thực danh tính chủ trọ</p></div>
            </div>
            <div class="sa-table-wrap">
              <table class="sa-enterprise-table">
                <thead><tr><th>Doanh nghiệp</th><th>Số ĐK KDD / MST</th><th>Người đại diện</th><th>Ngày gửi</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                <tbody>
                  <tr v-for="tenant in filteredTenants.slice(0, 5)" :key="'kyc-' + tenant.id">
                    <td><strong>{{ tenant.name }}</strong></td>
                    <td><code>0318{{ tenant.id }}892</code></td>
                    <td>{{ tenant.owner_name || 'Chủ trọ StayRent' }}</td>
                    <td>{{ formatDate(tenant.created_at) }}</td>
                    <td><span class="sa-status-pill success">Đã xác minh</span></td>
                    <td><button type="button" class="sa-link">Xem hồ sơ</button></td>
                  </tr>
                  <tr v-if="filteredTenants.length === 0"><td colspan="6" class="sa-empty">Chưa có thông tin KYC.</td></tr>
                </tbody>
              </table>
            </div>
          </article>
        </section>

        <section v-else-if="activeTab === 'user_control'" class="sa-tab-content">
          <article class="sa-card sa-tab-card">
            <div class="sa-card-heading">
              <div><h2>👥 Kiểm soát người dùng toàn hệ thống</h2><p>Quản lý tài khoản, phân quyền và trạng thái người dùng</p></div>
            </div>
            <div class="sa-health-metrics four">
              <div><small>Tổng tài khoản</small><strong>{{ userCount }}</strong></div>
              <div><small>Chủ trọ / QLV</small><strong>{{ data.total_tenants || 0 }}</strong></div>
              <div><small>Khách thuê</small><strong>{{ data.total_renters || 0 }}</strong></div>
              <div><small>Trạng thái</small><strong class="text-success">Hoạt động bình thường</strong></div>
            </div>
          </article>
        </section>

        <section v-else-if="activeTab === 'alerts'" class="sa-tab-content">
          <article class="sa-card sa-tab-card">
            <div class="sa-card-heading">
              <div><h2>⚠️ Cảnh báo & Vi phạm hệ thống</h2><p>Giám sát các hành vi bất thường và cảnh báo sự cố an toàn thông tin</p></div>
            </div>
            <div class="sa-table-wrap">
              <table class="sa-enterprise-table">
                <thead><tr><th>Mức độ</th><th>Loại cảnh báo</th><th>Đối tượng</th><th>Thời gian</th><th>Trạng thái</th></tr></thead>
                <tbody>
                  <tr><td><span class="sa-status-pill success">Thấp</span></td><td>Đăng nhập hệ thống mới</td><td>Super Admin</td><td>Vừa xong</td><td>Đã ghi nhận</td></tr>
                  <tr><td><span class="sa-status-pill warning">Trung bình</span></td><td>Tần suất API cao</td><td>Tenant System</td><td>10 phút trước</td><td>Đã tự động xử lý</td></tr>
                </tbody>
              </table>
            </div>
          </article>
        </section>

        <section v-else class="sa-tab-content"><article class="sa-card sa-tab-card"><div class="sa-card-heading"><div><h2>📜 Nhật ký thao tác toàn nền tảng</h2><p>Giám sát mọi thao tác trên hệ thống RentOps</p></div><button type="button" class="sa-secondary-button" @click="fetchGlobalAuditLogs">↻ Làm mới nhật ký</button></div><div class="sa-table-wrap"><table class="sa-enterprise-table sa-audit-table"><thead><tr><th>Thời gian</th><th>Tòa nhà / Tenant</th><th>Người thực hiện</th><th>Hành động</th><th>Đối tượng</th><th>Chi tiết</th></tr></thead><tbody><tr v-for="log in globalAuditLogs" :key="log.id"><td>{{ new Date(log.created_at).toLocaleString('vi-VN') }}</td><td><strong>{{ log.tenant_name }}</strong></td><td>{{ log.user_name }}</td><td><span class="sa-plan-pill pro">{{ log.action }}</span></td><td>{{ log.record_type }} #{{ log.record_id }}</td><td class="audit-payload">{{ log.payload }}</td></tr><tr v-if="globalAuditLogs.length === 0"><td colspan="6" class="sa-empty">Chưa có nhật ký thao tác nào được ghi nhận.</td></tr></tbody></table></div></article></section>

        <footer class="sa-footer"><span>© 2025 StayRent SaaS. All rights reserved.</span><span>Phiên bản 2.1.0　🇻🇳 Tiếng Việt⌄</span></footer>
      </main>
    </div>

    <div v-if="showCreateTenantModal" class="sa-modal-layer"><div class="sa-modal"><div class="sa-modal-header"><h3>🏢 Tạo chủ trọ / tòa nhà mới</h3><button type="button" @click="showCreateTenantModal = false">×</button></div><form @submit.prevent="submitCreateTenant" class="sa-form"><label>Tên tòa nhà / tên chủ trọ *<input v-model="tenantForm.name" required type="text" placeholder="Chuỗi căn hộ dịch vụ X" /></label><div class="sa-form-grid"><label>Subdomain *<input v-model="tenantForm.subdomain" required type="text" /></label><label>Số điện thoại *<input v-model="tenantForm.phone" required type="text" /></label></div><div class="sa-form-inset"><strong>Tài khoản đăng nhập chủ trọ</strong><label>Họ & tên chủ trọ<input v-model="tenantForm.owner_name" required type="text" /></label><div class="sa-form-grid"><label>Email đăng nhập *<input v-model="tenantForm.owner_email" required type="email" /></label><label>Mật khẩu khởi tạo *<input v-model="tenantForm.owner_password" required type="password" /></label></div></div><label>Gói cước ban đầu<select v-model="tenantForm.plan_id"><option v-for="plan in data.plans" :key="plan.id" :value="plan.id">{{ plan.name }} ({{ formatCurrency(plan.monthly_price) }}/tháng)</option></select></label><div class="sa-modal-actions"><button type="button" class="sa-secondary-button" @click="showCreateTenantModal = false">Hủy</button><button type="submit" class="sa-primary-button">Tạo chủ trọ mới</button></div></form></div></div>
    <div v-if="showPlanModal" class="sa-modal-layer"><div class="sa-modal sa-modal-small"><div class="sa-modal-header"><h3>{{ planForm.id ? '✏️ Cập nhật gói cước' : '💎 Tạo gói SaaS mới' }}</h3><button type="button" @click="showPlanModal = false">×</button></div><form @submit.prevent="submitPlanForm" class="sa-form"><label>Tên gói cước *<input v-model="planForm.name" required type="text" /></label><div class="sa-form-grid"><label>Giới hạn phòng *<input v-model="planForm.max_rooms" required type="number" /></label><label>Giá hàng tháng (đ) *<input v-model="planForm.monthly_price" required type="number" /></label></div><label>Mô tả gói<textarea v-model="planForm.description" rows="3"></textarea></label><div class="sa-modal-actions"><button type="button" class="sa-secondary-button" @click="showPlanModal = false">Hủy</button><button type="submit" class="sa-primary-button">{{ planForm.id ? 'Lưu thay đổi' : 'Tạo gói SaaS' }}</button></div></form></div></div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useToastStore } from '../stores/toast'
import api from '../services/api'

const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()
const activeTab = ref('tenants')
const activeNavGroup = ref('overview')
const mobileSidebarOpen = ref(false)
const showProfileDropdown = ref(false)
const searchTerm = ref('')

const handleLogout = () => {
  authStore.logout()
  router.push('/login')
}

const data = ref({ tenants: [], plans: [], total_tenants: 0, active_tenants: 0, mrr_estimate: 0, total_rooms: 0, total_contracts: 0, total_renters: 0 })
const healthData = ref({})
const globalAuditLogs = ref([])
const showCreateTenantModal = ref(false)
const showPlanModal = ref(false)
const broadcastForm = ref({ title: '', content: '', channel: 'zns' })
const tenantForm = ref({ name: '', subdomain: '', phone: '', owner_name: '', owner_email: '', owner_password: 'Password123!', plan_id: null })
const planForm = ref({ id: null, name: '', max_rooms: 50, monthly_price: 299000, description: '' })

const mainNavItems = [
  { id: 'overview', label: 'Tổng quan', icon: '⌂', tab: 'tenants', group: 'overview' },
  { id: 'businesses', label: 'Quản lý doanh nghiệp', icon: '▦', tab: 'tenants', group: 'businesses', chevron: true },
  { id: 'users', label: 'Quản lý người dùng', icon: '♙', tab: 'tenants', group: 'users', chevron: true },
  { id: 'rooms', label: 'Quản lý phòng / căn hộ', icon: '⌂', tab: 'tenants', group: 'rooms', chevron: true },
  { id: 'plans', label: 'Gói dịch vụ & Bảng giá', icon: '◇', tab: 'tenants', group: 'plans', chevron: true },
  { id: 'revenue', label: 'Thanh toán & Doanh thu', icon: '◉', tab: 'tenants', group: 'revenue', chevron: true },
  { id: 'support', label: 'Yêu cầu & Hỗ trợ', icon: '?', tab: 'tenants', group: 'support', chevron: true },
  { id: 'broadcast', label: 'Thông báo hệ thống', icon: '♧', tab: 'broadcast', group: 'broadcast', chevron: true },
  { id: 'audit', label: 'Nhật ký hoạt động', icon: '▤', tab: 'audit', group: 'audit', chevron: true },
  { id: 'settings', label: 'Cấu hình hệ thống', icon: '⚙', tab: 'health', group: 'settings', chevron: true }
]

const reportNavItems = [
  { id: 'reports_overview', label: 'Báo cáo tổng quan', icon: '▣', tab: 'reports_overview', group: 'reports_overview' },
  { id: 'analytics', label: 'Phân tích doanh thu', icon: '⌁', tab: 'analytics', group: 'analytics' }
]

const securityNavItems = [
  { id: 'kyc', label: 'KYC & xác minh DN', icon: '◉', tab: 'kyc', group: 'kyc', chevron: true },
  { id: 'user_control', label: 'Kiểm soát người dùng', icon: '♙', tab: 'user_control', group: 'user_control', chevron: true },
  { id: 'alerts', label: 'Cảnh báo & vi phạm', icon: '⚠', tab: 'alerts', group: 'alerts', chevron: true }
]

const filteredTenants = computed(() => {
  const term = searchTerm.value.trim().toLowerCase()
  if (!term) return data.value.tenants || []
  return (data.value.tenants || []).filter((tenant) => [tenant.name, tenant.phone, tenant.subdomain].some((value) => value?.toLowerCase?.().includes(term)))
})

const adminName = computed(() => authStore.currentUser?.full_name || 'Super Admin')
const adminEmail = computed(() => authStore.currentUser?.email || 'superadmin@stayrent.vn')
const adminInitials = computed(() => adminName.value.split(' ').map((part) => part[0]).slice(-2).join('').toUpperCase() || 'SA')
const headerTitle = computed(() => ({
  overview: 'Super Admin Dashboard',
  businesses: 'Quản lý doanh nghiệp',
  users: 'Quản lý người dùng',
  rooms: 'Quản lý phòng / căn hộ',
  plans: 'Gói dịch vụ & Bảng giá',
  revenue: 'Thanh toán & Doanh thu',
  support: 'Yêu cầu & Hỗ trợ',
  broadcast: 'Thông báo hệ thống',
  audit: 'Nhật ký hoạt động',
  settings: 'Cấu hình hệ thống',
  reports_overview: 'Báo cáo tổng quan',
  analytics: 'Phân tích doanh thu toàn nền tảng',
  kyc: 'KYC & Xác minh doanh nghiệp',
  user_control: 'Kiểm soát người dùng hệ thống',
  alerts: 'Cảnh báo & Vi phạm an toàn'
}[activeNavGroup.value] || 'Super Admin Dashboard'))
const userCount = computed(() => healthData.value.total_users || data.value.total_renters || 0)
const occupancyRate = computed(() => data.value.total_rooms ? Math.min(100, Math.round((data.value.total_contracts / data.value.total_rooms) * 1000) / 10) : 78.4)
const topPlan = computed(() => (data.value.plans || []).slice().sort((a, b) => Number(b.monthly_price || 0) - Number(a.monthly_price || 0))[0] || { name: 'Gói Pro' })
const metrics = computed(() => [
  { label: 'Doanh nghiệp', value: formatNumber(data.value.total_tenants), trend: '↑ 12.5%', trendTone: 'positive', caption: 'so với tháng trước', icon: '▦', tone: 'purple' },
  { label: 'Người dùng', value: formatNumber(userCount.value), trend: '↑ 18.7%', trendTone: 'positive', caption: 'so với tháng trước', icon: '♙', tone: 'blue' },
  { label: 'Phòng / Căn hộ', value: formatNumber(data.value.total_rooms), trend: '↑ 15.3%', trendTone: 'positive', caption: 'so với tháng trước', icon: '⌂', tone: 'green' },
  { label: 'Tỷ lệ lấp đầy', value: `${occupancyRate.value}%`, trend: '↓ 6.2%', trendTone: 'negative', caption: 'so với tháng trước', icon: '◉', tone: 'orange' },
  { label: 'Doanh thu (tháng)', value: formatCurrency(data.value.mrr_estimate), trend: '↑ 22.1%', trendTone: 'negative', caption: 'so với tháng trước', icon: '↗', tone: 'pink' }
])

const serviceBreakdown = [
  { name: 'Gói Pro', value: '1.45B VNĐ', percent: '59.2%', color: '#6841df' },
  { name: 'Gói Plus', value: '650M VNĐ', percent: '26.5%', color: '#4388f3' },
  { name: 'Gói Basic', value: '280M VNĐ', percent: '11.4%', color: '#36b67f' },
  { name: 'Gói Free', value: '70M VNĐ', percent: '2.9%', color: '#f6ad4b' }
]
const growthBars = [25, 36, 44, 53, 49, 62, 67, 73, 82, 86, 94, 100]
const systemServices = computed(() => [
  { name: 'API Server', icon: '▣', status: 'Hoạt động', tone: 'success' },
  { name: 'Database', icon: '◈', status: 'Hoạt động', tone: 'success' },
  { name: 'Storage', icon: '▤', status: 'Hoạt động', tone: 'success' },
  { name: 'Redis Cache', icon: '◇', status: 'Hoạt động', tone: 'success' },
  { name: 'Payment Gateway', icon: '◉', status: 'Hoạt động', tone: 'success' },
  { name: 'Email Service', icon: '✉', status: 'Cảnh báo', tone: 'warning' },
  { name: 'Backup Service', icon: '◫', status: 'Hoạt động', tone: 'success' }
])

const formatNumber = (value) => new Intl.NumberFormat('vi-VN').format(Number(value || 0))
const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(Number(value || 0))
const formatDate = (value) => value ? new Date(value).toLocaleDateString('vi-VN') : '30/06/2025'
const tenantInitial = (tenant) => (tenant?.name || 'DN').trim().slice(0, 1).toUpperCase()
const companyTone = (tenant) => `company-${(Number(tenant?.id || 0) % 5) + 1}`
const planTone = (plan) => plan?.name?.toLowerCase().includes('pro') ? 'pro' : plan?.name?.toLowerCase().includes('free') ? 'free' : 'plus'
const setActiveTab = (tab, group = tab) => { activeTab.value = tab; activeNavGroup.value = group; mobileSidebarOpen.value = false }

const fetchOverview = async () => {
  try {
    const res = await api.get('/super_admin/overview')
    const payload = res?.data || res
    if (payload) {
      data.value = payload
      if (!tenantForm.value.plan_id && payload.plans?.length) tenantForm.value.plan_id = payload.plans[0].id
    }
  } catch (err) { console.error('Lỗi lấy dữ liệu Super Admin:', err) }
}

const fetchSystemHealth = async () => {
  try {
    const res = await api.get('/super_admin/system_health')
    const payload = res?.data || res
    if (payload) healthData.value = payload
  } catch (err) { console.error('Lỗi lấy thông số hệ thống:', err) }
}

const fetchGlobalAuditLogs = async () => {
  try {
    const res = await api.get('/super_admin/audit_logs')
    const payload = res?.data || res
    if (payload) globalAuditLogs.value = payload
  } catch (err) { console.error('Lỗi lấy nhật ký toàn hệ thống:', err) }
}

const sendBroadcast = async () => {
  try {
    const res = await api.post('/super_admin/broadcast_notification', broadcastForm.value)
    if (res?.success) { toastStore.success(res.message || 'Đã phát thông báo thành công!'); broadcastForm.value.title = ''; broadcastForm.value.content = '' }
  } catch (err) { toastStore.error('Lỗi phát thông báo') }
}

const openCreateTenantModal = () => { tenantForm.value = { name: '', subdomain: `tenant-${Date.now().toString().slice(-4)}`, phone: '0901234567', owner_name: '', owner_email: '', owner_password: 'Password123!', plan_id: data.value.plans?.[0]?.id || null }; showCreateTenantModal.value = true }
const submitCreateTenant = async () => { try { const res = await api.post('/super_admin/create_tenant', tenantForm.value); if (res?.success) { toastStore.success(res.message || 'Tạo chủ trọ thành công!'); showCreateTenantModal.value = false; fetchOverview() } } catch (err) { toastStore.error(err?.message || 'Lỗi khi tạo chủ trọ mới') } }
const openCreatePlanModal = (plan = null) => { planForm.value = plan ? { id: plan.id, name: plan.name, max_rooms: plan.max_rooms, monthly_price: plan.monthly_price, description: plan.description || '' } : { id: null, name: '', max_rooms: 50, monthly_price: 299000, description: '' }; showPlanModal.value = true }
const submitPlanForm = async () => { try { const res = planForm.value.id ? await api.put('/super_admin/update_plan_details', planForm.value) : await api.post('/super_admin/create_plan', planForm.value); if (res?.success) { toastStore.success(res.message || 'Cập nhật gói cước thành công!'); showPlanModal.value = false; fetchOverview() } } catch (err) { toastStore.error(err?.message || 'Lỗi xử lý gói cước') } }
const changePlan = async (tenantId, planId) => { if (!planId) return; try { const res = await api.post('/super_admin/update_plan', { tenant_id: tenantId, plan_id: planId }); if (res?.success) { toastStore.success('Đã cập nhật gói cước thành công!'); fetchOverview() } } catch (err) { toastStore.error('Lỗi cập nhật gói cước') } }
const toggleTenantStatus = async (tenantId) => { try { const res = await api.post('/super_admin/toggle_tenant_status', { tenant_id: tenantId }); if (res?.success) { toastStore.success('Cập nhật trạng thái tenant thành công!'); fetchOverview() } } catch (err) { toastStore.error('Lỗi cập nhật trạng thái tenant') } }
const deleteTenant = async (tenant) => { if (!confirm(`Bạn có chắc chắn muốn xóa Tenant "${tenant.name}"? Thao tác này không thể hoàn tác.`)) return; try { const res = await api.delete('/super_admin/delete_tenant', { data: { tenant_id: tenant.id } }); if (res?.success) { toastStore.success(res.message || 'Đã xóa tenant thành công!'); fetchOverview() } } catch (err) { toastStore.error('Lỗi khi xóa tenant') } }

onMounted(() => { fetchOverview(); fetchSystemHealth(); fetchGlobalAuditLogs() })
</script>

<style scoped>
.superadmin-page { --navy: #071235; --navy-light: #101d52; --purple: #6d3fe0; --border: #e7eaf2; --muted: #7d849b; min-height: 100vh; background: #f7f8fc; color: #151b3c; font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; font-size: 12px; }
.sa-sidebar { position: fixed; inset: 0 auto 0 0; z-index: 40; display: flex; flex-direction: column; width: clamp(154px, 15vw, 232px); overflow-y: auto; background: linear-gradient(180deg, #071235 0%, #09143b 100%); color: #c4cbe3; box-shadow: 8px 0 30px rgba(22, 29, 74, .08); }
.sa-brand { display: flex; align-items: center; gap: 10px; height: 76px; padding: 0 20px; border-bottom: 1px solid rgba(255,255,255,.08); color: white; }
.sa-brand-mark { display: grid; place-items: center; width: 27px; height: 31px; color: #fff; border: 3px solid #6d78ff; border-radius: 7px 7px 10px 10px; transform: rotate(0deg); font-size: 17px; line-height: 1; }
.sa-brand-mark span { transform: translateY(-1px); }
.sa-brand-name { font-size: 15px; font-weight: 800; letter-spacing: -.3px; }
.sa-brand-caption { margin-top: 2px; color: #a2abd0; font-size: 7px; font-weight: 500; }
.sa-nav { flex: 1; padding: 14px 10px 10px; }
.sa-nav-link { display: flex; align-items: center; width: 100%; gap: 9px; min-height: 32px; padding: 7px 10px; color: #b9c2dc; border: 0; border-radius: 6px; background: transparent; font: inherit; font-size: 10px; font-weight: 500; text-align: left; cursor: pointer; transition: background .15s ease, color .15s ease; }
.sa-nav-link:hover { background: rgba(255,255,255,.07); color: #fff; }
.sa-nav-link.active { color: #fff; background: linear-gradient(90deg, #7040e7, #833ee6); box-shadow: 0 7px 18px rgba(102, 56, 219, .25); font-weight: 700; }
.sa-nav-icon { display: inline-grid; place-items: center; width: 15px; color: currentColor; font-size: 13px; }
.sa-nav-chevron { margin-left: auto; color: #aeb7d5; font-size: 15px; }
.sa-nav-section { margin: 16px 10px 7px; color: #7683ad; font-size: 7px; font-weight: 700; letter-spacing: .08em; }
.sa-security-card { margin: 10px 12px 0; padding: 12px; border: 1px solid rgba(143, 119, 255, .26); border-radius: 8px; background: linear-gradient(145deg, #1d2770, #19205b); color: #fff; }
.sa-security-icon { float: left; margin: 1px 8px 18px 0; color: #8798ff; font-size: 20px; }
.sa-security-title { font-size: 10px; font-weight: 700; }
.sa-security-copy { margin-top: 5px; color: #bbc4ed; font-size: 8px; line-height: 1.45; }
.sa-security-card button { width: 100%; margin-top: 11px; padding: 7px 4px; border: 0; border-radius: 4px; background: linear-gradient(90deg, #7440ed, #6330d8); color: #fff; font: inherit; font-size: 9px; font-weight: 700; cursor: pointer; }
.sa-sidebar-footer { padding: 13px 18px 15px; color: #7885ac; font-size: 8px; display: flex; flex-direction: column; gap: 8px; }
.sa-sidebar-logout { width: 100%; padding: 8px 10px; border: 1px solid rgba(255,255,255,.15); border-radius: 6px; background: rgba(255, 64, 91, 0.15); color: #ff6b81; font: inherit; font-size: 11px; font-weight: 700; cursor: pointer; transition: all .15s ease; text-align: center; }
.sa-sidebar-logout:hover { background: #ff405b; color: #fff; box-shadow: 0 4px 12px rgba(255,64,91,.3); }
.sa-copyright-text { font-size: 8px; opacity: .8; }
.sa-sidebar-backdrop { display: none; }
.sa-shell { min-height: 100vh; margin-left: clamp(154px, 15vw, 232px); }
.sa-topbar { position: sticky; top: 0; z-index: 30; display: flex; align-items: center; justify-content: space-between; min-height: 62px; padding: 0 26px; border-bottom: 1px solid var(--border); background: rgba(255,255,255,.94); backdrop-filter: blur(14px); }
.sa-topbar-left, .sa-topbar-actions, .sa-user-menu, .sa-card-heading, .sa-kpi-head, .sa-kpi-foot, .sa-page-toolbar { display: flex; align-items: center; }
.sa-topbar-left { gap: 12px; }
.sa-user-wrapper { position: relative; }
.sa-user-menu { cursor: pointer; padding: 4px 8px; border-radius: 8px; transition: background .15s ease; }
.sa-user-menu:hover { background: #f0f2f8; }
.sa-profile-dropdown { position: absolute; right: 0; top: calc(100% + 8px); width: 220px; padding: 12px; background: #ffffff; border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 10px 30px rgba(7, 18, 53, 0.15); z-index: 50; }
.sa-dropdown-header { display: flex; flex-direction: column; gap: 2px; }
.sa-dropdown-header strong { color: #151b3c; font-size: 13px; font-weight: 700; }
.sa-dropdown-header p { color: var(--muted); font-size: 10px; margin: 0; }
.sa-dropdown-divider { height: 1px; background: var(--border); margin: 8px 0; }
.sa-dropdown-item { display: flex; align-items: center; justify-content: center; gap: 6px; width: 100%; padding: 8px 12px; border: 0; border-radius: 8px; background: #fff0f3; color: #e11d48; font: inherit; font-size: 12px; font-weight: 700; cursor: pointer; transition: all .15s ease; }
.sa-dropdown-item:hover { background: #e11d48; color: #ffffff; box-shadow: 0 4px 12px rgba(225, 29, 72, 0.25); }
.sa-topbar-left h1 { margin: 0; color: #141b43; font-size: 17px; font-weight: 800; letter-spacing: -.35px; }
.sa-topbar-left p { margin: 3px 0 0; color: #8790a8; font-size: 9px; }
.sa-menu-button { display: none; }
.sa-topbar-actions { gap: 13px; }
.sa-search { display: flex; align-items: center; width: 188px; height: 29px; gap: 6px; padding: 0 7px; border: 1px solid #e4e7f0; border-radius: 5px; color: #9ca5bc; background: #fbfcff; }
.sa-search input { min-width: 0; flex: 1; border: 0; outline: 0; background: transparent; color: #262d4d; font: inherit; font-size: 9px; }
.sa-search kbd { padding: 2px 4px; border: 1px solid #e4e7f0; border-radius: 3px; color: #a4acc0; font-size: 7px; white-space: nowrap; }
.sa-icon-button { position: relative; padding: 3px; border: 0; background: transparent; color: #182047; font-size: 15px; cursor: pointer; }
.sa-notification-button span { position: absolute; top: -4px; right: -5px; display: grid; place-items: center; width: 13px; height: 13px; border-radius: 50%; background: #f33468; color: #fff; font-size: 7px; font-weight: 700; }
.sa-user-menu { gap: 7px; padding-left: 5px; }
.sa-avatar { display: grid; place-items: center; width: 25px; height: 25px; border-radius: 50%; background: linear-gradient(135deg, #e7a178, #3b4266 58%, #161b3b); color: #fff; font-size: 8px; font-weight: 800; }
.sa-user-copy { display: flex; flex-direction: column; gap: 2px; }
.sa-user-copy strong { color: #161b40; font-size: 9px; }
.sa-user-copy small { color: #8790a8; font-size: 7px; }
.sa-user-chevron { color: #556080; font-size: 13px; }
.sa-content { max-width: 1530px; margin: 0 auto; padding: 10px 26px 16px; }
.sa-page-toolbar { justify-content: space-between; min-height: 26px; margin-bottom: 9px; }
.sa-date-filter { display: flex; align-items: center; gap: 7px; padding: 6px 9px; border: 1px solid #e2e5ef; border-radius: 5px; background: #fff; color: #414964; font: inherit; font-size: 8px; box-shadow: 0 2px 8px rgba(44, 55, 105, .03); cursor: pointer; }
.sa-date-filter span:last-child { color: #79839d; font-size: 11px; }
.sa-kpi-grid { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 9px; }
.sa-card, .sa-kpi-card { border: 1px solid var(--border); border-radius: 7px; background: #fff; box-shadow: 0 3px 12px rgba(43, 51, 94, .04); }
.sa-kpi-card { min-height: 75px; padding: 12px; }
.sa-kpi-head { justify-content: space-between; color: #777f97; font-size: 8px; }
.sa-kpi-icon { display: grid; place-items: center; width: 25px; height: 25px; border-radius: 50%; font-size: 13px; }
.tone-purple { background: #f0eaff; color: #713fe4; }.tone-blue { background: #e7f0ff; color: #4e90f1; }.tone-green { background: #e1f7ed; color: #24aa6d; }.tone-orange { background: #fff1dc; color: #f49a2f; }.tone-pink { background: #ffe4ed; color: #e94070; }
.sa-kpi-value { margin-top: 7px; color: #1a2044; font-size: 17px; font-weight: 800; letter-spacing: -.45px; white-space: nowrap; }
.sa-kpi-foot { gap: 5px; margin-top: 4px; font-size: 8px; }.sa-kpi-foot small { color: #9299ae; font-size: 7px; }.positive span { color: #25ae73; }.negative span { color: #ed4b68; }
.sa-dashboard-grid { display: grid; grid-template-columns: minmax(0, 1.55fr) minmax(230px, .95fr) minmax(190px, .83fr); grid-template-areas: "revenue service system" "revenue service plan" "growth growth recent"; gap: 9px; margin-top: 9px; }
.sa-revenue-card { grid-area: revenue; min-height: 219px; padding: 14px; }.sa-service-card { grid-area: service; padding: 14px; }.sa-system-card { grid-area: system; padding: 13px; }.sa-plan-highlight { grid-area: plan; display: flex; justify-content: space-between; align-items: center; min-height: 67px; padding: 13px; border: 0; background: linear-gradient(135deg, #4631b3, #a643d8); color: #fff; box-shadow: 0 9px 20px rgba(105, 57, 207, .2); }.sa-growth-card { grid-area: growth; min-height: 151px; padding: 13px; }.sa-enterprise-card { grid-area: recent; min-height: 151px; padding: 13px; }
.sa-card-heading { justify-content: space-between; gap: 10px; }.sa-card-heading h2 { margin: 0; color: #1c2446; font-size: 9px; font-weight: 800; }.sa-card-heading p { margin: 5px 0 0; color: #969db0; font-size: 8px; }.sa-card-heading small { color: #9ba2b6; font-size: 7px; }.sa-more, .sa-row-action { border: 0; background: transparent; color: #8b93aa; font-size: 14px; cursor: pointer; }
.sa-info { display: inline-grid; place-items: center; width: 10px; height: 10px; border: 1px solid #aab1c1; border-radius: 50%; color: #aab1c1; font-size: 7px; font-weight: 500; }.sa-card-number { margin-top: 5px; color: #182044; font-size: 14px; font-weight: 800; }.sa-card-number span { margin-left: 6px; color: #27ad72; font-size: 7px; font-weight: 500; }.sa-chart-filters { display: flex; gap: 4px; }.sa-chart-filters button { padding: 4px 6px; border: 1px solid #e4e7ef; border-radius: 4px; background: #fff; color: #606983; font: inherit; font-size: 7px; cursor: pointer; }.sa-chart-filters button:last-child { padding: 2px 4px; border: 0; font-size: 13px; }
.sa-line-chart { position: relative; height: 156px; margin: 9px 0 0 24px; }.sa-y-axis { position: absolute; top: 4px; bottom: 19px; left: -24px; display: flex; flex-direction: column; justify-content: space-between; color: #a2a8ba; font-size: 7px; }.sa-line-chart svg { width: 100%; height: 133px; overflow: visible; }.sa-grid-lines path { stroke: #edf0f6; stroke-width: 1; stroke-dasharray: 2 3; }.sa-revenue-area { fill: url(#revenueFill); }.sa-revenue-line { fill: none; stroke: #7548e3; stroke-width: 2; }.sa-chart-point { fill: #7548e3; stroke: #fff; stroke-width: 2; }.sa-chart-tooltip { position: absolute; top: 19px; left: 39%; display: flex; flex-direction: column; gap: 3px; padding: 6px 8px; border: 1px solid #e2e6f0; border-radius: 5px; background: #fff; box-shadow: 0 7px 20px rgba(41, 48, 95, .1); font-size: 7px; }.sa-chart-tooltip small { color: #a0a7ba; }.sa-chart-tooltip strong { color: #3d4663; font-size: 7px; }.sa-x-axis { display: flex; justify-content: space-between; color: #a2a8ba; font-size: 7px; }
.sa-donut-row { display: flex; align-items: center; justify-content: space-around; gap: 8px; margin-top: 16px; }.sa-donut { display: grid; place-items: center; width: 105px; height: 105px; border-radius: 50%; background: conic-gradient(#6841df 0 59.2%, #4388f3 59.2% 85.7%, #36b67f 85.7% 97.1%, #f6ad4b 97.1% 100%); }.sa-donut > div { display: flex; flex-direction: column; align-items: center; justify-content: center; width: 60px; height: 60px; border-radius: 50%; background: #fff; }.sa-donut strong { color: #232a4d; font-size: 11px; }.sa-donut small { color: #8f97ab; font-size: 7px; }.sa-legend { display: flex; flex-direction: column; gap: 7px; }.sa-legend > div { display: flex; align-items: flex-start; gap: 5px; }.sa-legend-dot { flex: 0 0 auto; width: 6px; height: 6px; margin-top: 2px; border-radius: 50%; }.sa-legend strong, .sa-legend small { display: block; }.sa-legend strong { color: #323a5a; font-size: 8px; }.sa-legend small { margin-top: 1px; color: #9299ad; font-size: 7px; }.sa-donut-total { display: flex; justify-content: space-between; margin-top: 15px; padding-top: 9px; border-top: 1px solid #eef0f5; color: #7e879e; font-size: 8px; }.sa-donut-total strong { color: #293254; font-size: 9px; }
.sa-health-list { display: flex; flex-direction: column; gap: 8px; margin-top: 12px; }.sa-health-row { display: grid; grid-template-columns: 16px 1fr auto; align-items: center; gap: 5px; color: #4b5572; font-size: 8px; }.sa-health-icon { color: #435074; font-size: 10px; }.sa-health-status { display: flex; align-items: center; gap: 4px; font-size: 7px; }.sa-health-status i, .text-success i { display: inline-block; width: 5px; height: 5px; border-radius: 50%; background: #26b777; }.sa-health-status.warning { color: #eb9b2c; }.sa-health-status.warning i { background: #f5a82e; }.sa-health-status.success { color: #2ab176; }
.sa-plan-copy { display: flex; flex-direction: column; gap: 3px; }.sa-plan-copy small { color: #ddd4ff; font-size: 7px; }.sa-plan-copy strong { font-size: 14px; }.sa-plan-copy span { color: #eee9ff; font-size: 7px; }.sa-plan-crown { display: grid; place-items: center; width: 36px; height: 36px; border: 1px solid rgba(255,255,255,.5); border-radius: 50%; color: #ffd45f; font-size: 21px; }
.sa-growth-card .sa-card-heading { margin-bottom: 5px; }.sa-growth-chart { position: relative; height: 95px; padding-left: 28px; }.sa-growth-y { position: absolute; inset: 2px auto 17px 0; display: flex; flex-direction: column; justify-content: space-between; color: #a4abbc; font-size: 7px; }.sa-bars { display: flex; align-items: flex-end; justify-content: space-around; height: 79px; border-bottom: 1px solid #e8ebf3; background: repeating-linear-gradient(to bottom, transparent 0, transparent 18px, #edf0f6 19px, transparent 20px); }.sa-bar-wrap { display: flex; flex-direction: column; align-items: center; justify-content: flex-end; width: 7%; height: 100%; gap: 4px; }.sa-bar { display: block; width: 7px; min-height: 3px; border-radius: 2px 2px 0 0; background: #9072eb; }.sa-bar-wrap small { color: #a2a9bb; font-size: 6px; }.sa-growth-total { position: absolute; top: 2px; right: 0; display: flex; flex-direction: column; align-items: flex-end; }.sa-growth-total strong { padding: 3px 5px; border-radius: 4px; background: #f4efff; color: #7550da; font-size: 8px; }.sa-growth-total span { margin-top: 2px; color: #a0a7b9; font-size: 7px; }
.sa-enterprise-card { min-width: 0; }.sa-enterprise-card .sa-card-heading { margin-bottom: 8px; }.sa-enterprise-card .sa-card-heading > div { min-width: 0; }.sa-enterprise-card .sa-link { flex: 0 0 auto; }.sa-table-wrap { overflow-x: auto; }.sa-enterprise-table { width: 100%; border-collapse: separate; border-spacing: 0; color: #56607b; font-size: 8px; }.sa-enterprise-table th { padding: 8px 8px; border-top: 1px solid #e9ecf3; border-bottom: 1px solid #e9ecf3; background: #fafbfe; color: #7c8499; font-size: 7px; font-weight: 700; text-align: left; white-space: nowrap; }.sa-enterprise-table th:first-child { border-left: 1px solid #e9ecf3; border-radius: 5px 0 0 0; }.sa-enterprise-table th:last-child { border-right: 1px solid #e9ecf3; border-radius: 0 5px 0 0; }.sa-enterprise-table td { padding: 7px 8px; border-bottom: 1px solid #eff1f6; white-space: nowrap; }.sa-enterprise-table tr:hover td { background: #fbfaff; }.sa-company { display: flex; align-items: center; gap: 7px; min-width: 155px; }.sa-company-logo { display: grid; place-items: center; width: 22px; height: 22px; border-radius: 6px; font-size: 9px; font-weight: 800; }.company-1 { background: #e9f1ff; color: #4b83e6; }.company-2 { background: #fff0dc; color: #e79a2b; }.company-3 { background: #e4f7ee; color: #28ab74; }.company-4 { background: #f2eaff; color: #7b50d7; }.company-5 { background: #e5edff; color: #5579dc; }.sa-company strong, .sa-company small { display: block; }.sa-company strong { max-width: 158px; overflow: hidden; color: #303956; font-size: 8px; text-overflow: ellipsis; }.sa-company small { margin-top: 2px; color: #9ba2b5; font-size: 6px; }.sa-plan-pill, .sa-status-pill { display: inline-block; padding: 3px 7px; border-radius: 8px; font-size: 7px; font-weight: 600; }.sa-plan-pill.pro { background: #f1ebff; color: #7047d3; }.sa-plan-pill.plus { background: #e8f0ff; color: #467ddc; }.sa-plan-pill.free { background: #e5f7ef; color: #27a875; }.sa-status-pill.success { background: #e4f8ed; color: #29aa70; }.sa-status-pill.warning { background: #fff2df; color: #e9a030; }.sa-empty { padding: 22px !important; color: #9aa2b5; text-align: center; }.sa-link { padding: 0; border: 0; background: transparent; color: #6d43d8; font: inherit; font-size: 7px; cursor: pointer; }
.sa-heading-actions { display: flex; align-items: center; gap: 10px; }.sa-row-actions { display: flex; align-items: center; justify-content: flex-end; gap: 4px; }.sa-row-actions select { width: 64px; padding: 3px 2px; border: 1px solid #e4e7ef; border-radius: 4px; outline: 0; background: #fff; color: #68718a; font: inherit; font-size: 7px; }.sa-row-action.danger { color: #df5570; }
.sa-plans-card { margin-top: 9px; padding: 14px; }.sa-primary-button, .sa-secondary-button { padding: 7px 10px; border: 0; border-radius: 5px; font: inherit; font-size: 8px; font-weight: 700; cursor: pointer; }.sa-primary-button { background: linear-gradient(90deg, #6f3de2, #7d40e6); color: #fff; box-shadow: 0 5px 12px rgba(105, 57, 211, .16); }.sa-secondary-button { border: 1px solid #e1e5ee; background: #fff; color: #5c6680; }.sa-plan-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 12px; }.sa-plan-item { display: flex; align-items: center; justify-content: space-between; gap: 8px; padding: 10px; border: 1px solid #edf0f5; border-radius: 6px; background: #fafbfe; }.sa-plan-item strong, .sa-plan-item small { display: block; }.sa-plan-item strong { color: #2c3556; font-size: 9px; }.sa-plan-item small { max-width: 150px; margin-top: 3px; color: #9299ad; font-size: 7px; }.sa-plan-price { color: #6641d3; font-size: 9px; font-weight: 800; white-space: nowrap; }.sa-plan-price button { display: block; margin-top: 3px; padding: 0; border: 0; background: none; color: #7650d8; font: inherit; font-size: 7px; cursor: pointer; }
.sa-tab-content { display: flex; flex-direction: column; gap: 9px; }.sa-tab-card { padding: 17px; }.sa-health-metrics { display: grid; grid-template-columns: repeat(4, 1fr); gap: 9px; margin-top: 17px; }.sa-health-metrics > div { display: flex; flex-direction: column; gap: 7px; padding: 14px; border: 1px solid #edf0f5; border-radius: 6px; background: #fafbfe; }.sa-health-metrics small { color: #8d96ab; font-size: 8px; font-weight: 700; text-transform: uppercase; }.sa-health-metrics strong { color: #283153; font-size: 17px; }.sa-health-metrics .text-success { display: flex; align-items: center; gap: 6px; color: #25a971; font-size: 12px; }.sa-broadcast-card { max-width: 790px; }.sa-form { display: flex; flex-direction: column; gap: 12px; margin-top: 17px; }.sa-form label { display: flex; flex-direction: column; gap: 5px; color: #525c78; font-size: 8px; font-weight: 700; text-transform: uppercase; }.sa-form input, .sa-form select, .sa-form textarea { width: 100%; box-sizing: border-box; padding: 9px 10px; border: 1px solid #dfe4ee; border-radius: 5px; outline: 0; background: #fbfcff; color: #26304f; font: inherit; font-size: 10px; font-weight: 500; text-transform: none; }.sa-form input:focus, .sa-form select:focus, .sa-form textarea:focus { border-color: #7650dc; box-shadow: 0 0 0 3px rgba(117, 80, 220, .1); }.sa-form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }.sa-form-inset { display: flex; flex-direction: column; gap: 10px; padding: 12px; border: 1px solid #e9ecf3; border-radius: 7px; background: #fafbfe; }.sa-form-inset > strong { color: #40317e; font-size: 9px; text-transform: uppercase; }.sa-modal-layer { position: fixed; inset: 0; z-index: 80; display: grid; place-items: center; padding: 18px; background: rgba(8, 13, 41, .68); backdrop-filter: blur(4px); }.sa-modal { width: min(100%, 540px); max-height: calc(100vh - 36px); overflow-y: auto; padding: 18px; border-radius: 10px; background: #fff; box-shadow: 0 22px 70px rgba(4, 8, 28, .25); }.sa-modal-small { width: min(100%, 430px); }.sa-modal-header { display: flex; align-items: center; justify-content: space-between; padding-bottom: 12px; border-bottom: 1px solid #edf0f5; }.sa-modal-header h3 { margin: 0; color: #1e2647; font-size: 14px; }.sa-modal-header button { border: 0; background: none; color: #9098aa; font-size: 23px; cursor: pointer; }.sa-modal .sa-form { margin-top: 15px; }.sa-modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 4px; }.sa-footer { display: flex; justify-content: space-between; margin-top: 13px; padding-top: 8px; border-top: 1px solid #e7eaf1; color: #929aae; font-size: 7px; }.audit-payload { max-width: 220px; overflow: hidden; text-overflow: ellipsis; }
@media (max-width: 1180px) { .sa-topbar { padding: 0 18px; }.sa-content { padding-right: 18px; padding-left: 18px; }.sa-topbar-actions { gap: 8px; }.sa-search { width: 160px; }.sa-dashboard-grid { grid-template-columns: minmax(0, 1.45fr) minmax(220px, .9fr); grid-template-areas: "revenue service" "revenue system" "growth growth" "recent recent"; }.sa-enterprise-table { min-width: 680px; } }
@media (max-width: 820px) { .sa-sidebar { transform: translateX(-100%); transition: transform .2s ease; }.sa-sidebar.is-open { transform: translateX(0); }.sa-sidebar-backdrop { position: fixed; inset: 0; z-index: 35; display: block; background: rgba(5, 10, 35, .42); }.sa-shell { margin-left: 0; }.sa-menu-button { display: grid; place-items: center; width: 30px; height: 30px; border: 1px solid #e2e5ee; border-radius: 5px; background: #fff; color: #222a4d; font-size: 14px; }.sa-user-copy, .sa-user-chevron { display: none; }.sa-search { display: none; }.sa-kpi-grid { grid-template-columns: repeat(3, 1fr); }.sa-topbar { padding: 0 14px; }.sa-content { padding: 10px 14px 16px; } }
@media (max-width: 580px) { .sa-topbar-left h1 { font-size: 14px; }.sa-topbar-left p { display: none; }.sa-icon-button:nth-of-type(1), .sa-icon-button:nth-of-type(3) { display: none; }.sa-kpi-grid { grid-template-columns: repeat(2, 1fr); }.sa-kpi-card:last-child { grid-column: span 2; }.sa-dashboard-grid { grid-template-columns: 1fr; grid-template-areas: "revenue" "service" "system" "plan" "growth" "recent"; }.sa-revenue-card { min-height: 215px; }.sa-chart-filters button:not(:last-child) { display: none; }.sa-donut-row { justify-content: center; }.sa-enterprise-card { overflow: hidden; }.sa-plan-grid, .sa-health-metrics, .sa-form-grid { grid-template-columns: 1fr; }.sa-footer { flex-direction: column; gap: 6px; }.sa-footer span:last-child { display: none; }.sa-page-toolbar { justify-content: flex-end; } }

/* Readable typography for the Superadmin workspace */
.superadmin-page { font-size: 13px; line-height: 1.45; }
.sa-brand-name { font-size: 17px; }
.sa-brand-caption { font-size: 9px; }
.sa-nav-link { min-height: 38px; gap: 10px; padding: 8px 11px; font-size: 12px; }
.sa-nav-icon { width: 17px; font-size: 15px; }
.sa-nav-chevron { font-size: 18px; }
.sa-nav-section { margin-top: 18px; font-size: 9px; letter-spacing: .07em; }
.sa-security-title { font-size: 12px; }
.sa-security-copy { font-size: 10px; }
.sa-security-card button { font-size: 11px; }
.sa-sidebar-footer { font-size: 10px; }
.sa-topbar-left h1 { font-size: 22px; }
.sa-topbar-left p { font-size: 11px; }
.sa-search { height: 34px; width: 240px; }
.sa-search input { font-size: 11px; }
.sa-search kbd { font-size: 9px; }
.sa-icon-button { font-size: 18px; }
.sa-user-copy strong { font-size: 11px; }
.sa-user-copy small { font-size: 9px; }
.sa-date-filter { padding: 8px 11px; font-size: 10px; }
.sa-kpi-card { min-height: 96px; padding: 15px; }
.sa-kpi-head { font-size: 11px; }
.sa-kpi-icon { width: 31px; height: 31px; font-size: 16px; }
.sa-kpi-value { margin-top: 8px; font-size: 24px; }
.sa-kpi-foot { margin-top: 5px; font-size: 10px; }
.sa-kpi-foot small { font-size: 9px; }
.sa-card-heading h2 { font-size: 13px; }
.sa-card-heading p { font-size: 10px; }
.sa-card-heading small { font-size: 9px; }
.sa-card-number { font-size: 19px; }
.sa-card-number span { font-size: 9px; }
.sa-chart-filters button { font-size: 9px; }
.sa-y-axis, .sa-x-axis { font-size: 9px; }
.sa-chart-tooltip { font-size: 9px; }
.sa-chart-tooltip small, .sa-chart-tooltip strong { font-size: 9px; }
.sa-donut strong { font-size: 14px; }
.sa-donut small { font-size: 9px; }
.sa-legend strong { font-size: 10px; }
.sa-legend small { font-size: 9px; }
.sa-donut-total { font-size: 10px; }
.sa-donut-total strong { font-size: 11px; }
.sa-health-row { font-size: 10px; }
.sa-health-status { font-size: 9px; }
.sa-plan-copy small, .sa-plan-copy span { font-size: 9px; }
.sa-plan-copy strong { font-size: 18px; }
.sa-growth-y, .sa-bar-wrap small, .sa-growth-total span { font-size: 9px; }
.sa-growth-total strong { font-size: 10px; }
.sa-enterprise-table { font-size: 11px; }
.sa-enterprise-table th { padding: 10px; font-size: 9px; }
.sa-enterprise-table td { padding: 9px 10px; }
.sa-company strong { font-size: 11px; }
.sa-company small { font-size: 9px; }
.sa-plan-pill, .sa-status-pill { font-size: 9px; }
.sa-link { font-size: 9px; }
.sa-primary-button, .sa-secondary-button { padding: 9px 12px; font-size: 10px; }
.sa-plan-item strong { font-size: 11px; }
.sa-plan-item small { font-size: 9px; }
.sa-plan-price { font-size: 11px; }
.sa-plan-price button { font-size: 9px; }
.sa-health-metrics small { font-size: 10px; }
.sa-health-metrics strong { font-size: 22px; }
.sa-health-metrics .text-success { font-size: 14px; }
.sa-form label { font-size: 10px; }
.sa-form input, .sa-form select, .sa-form textarea { font-size: 12px; }
.sa-form-inset > strong { font-size: 11px; }
.sa-modal-header h3 { font-size: 17px; }
.sa-footer { font-size: 9px; }

@media (max-width: 580px) {
  .sa-topbar-left h1 { font-size: 17px; }
  .sa-kpi-card { min-height: 90px; padding: 12px; }
  .sa-kpi-value { font-size: 20px; }
  .sa-kpi-head { font-size: 10px; }
  .sa-enterprise-table { font-size: 10px; }
}

/* Final readability pass: all interface copy is intentionally larger */
.superadmin-page { font-size: 15px; }
.sa-nav-link { min-height: 42px; padding: 9px 12px; font-size: 14px; }
.sa-nav-icon { width: 19px; font-size: 17px; }
.sa-nav-section { font-size: 10px; }
.sa-brand-name { font-size: 19px; }
.sa-brand-caption { font-size: 10px; }
.sa-security-title { font-size: 14px; }
.sa-security-copy { font-size: 11px; }
.sa-security-card button { font-size: 12px; }
.sa-sidebar-footer { font-size: 11px; }
.sa-topbar-left h1 { font-size: 25px; }
.sa-topbar-left p { font-size: 13px; }
.sa-search input { font-size: 13px; }
.sa-search kbd { font-size: 10px; }
.sa-user-copy strong { font-size: 13px; }
.sa-user-copy small { font-size: 10px; }
.sa-date-filter { font-size: 12px; }
.sa-kpi-card { min-height: 108px; padding: 17px; }
.sa-kpi-head { font-size: 13px; }
.sa-kpi-icon { width: 34px; height: 34px; font-size: 18px; }
.sa-kpi-value { font-size: 29px; }
.sa-kpi-foot { font-size: 12px; }
.sa-kpi-foot small { font-size: 10px; }
.sa-card-heading h2 { font-size: 16px; }
.sa-card-heading p { font-size: 12px; }
.sa-card-heading small { font-size: 10px; }
.sa-card-number { font-size: 23px; }
.sa-card-number span { font-size: 11px; }
.sa-chart-filters button { font-size: 11px; }
.sa-y-axis, .sa-x-axis { font-size: 11px; }
.sa-chart-tooltip, .sa-chart-tooltip small, .sa-chart-tooltip strong { font-size: 11px; }
.sa-legend strong { font-size: 12px; }
.sa-legend small { font-size: 10px; }
.sa-donut-total { font-size: 12px; }
.sa-donut-total strong { font-size: 13px; }
.sa-health-row { font-size: 12px; }
.sa-health-status { font-size: 11px; }
.sa-plan-copy small, .sa-plan-copy span { font-size: 11px; }
.sa-plan-copy strong { font-size: 20px; }
.sa-growth-y, .sa-bar-wrap small, .sa-growth-total span { font-size: 11px; }
.sa-growth-total strong { font-size: 12px; }
.sa-enterprise-table { font-size: 13px; }
.sa-enterprise-table th { padding: 12px; font-size: 11px; }
.sa-enterprise-table td { padding: 11px 12px; }
.sa-company strong { font-size: 13px; }
.sa-company small { font-size: 11px; }
.sa-plan-pill, .sa-status-pill { font-size: 11px; }
.sa-link { font-size: 11px; }
.sa-primary-button, .sa-secondary-button { padding: 10px 14px; font-size: 12px; }
.sa-plan-item strong { font-size: 13px; }
.sa-plan-item small { font-size: 11px; }
.sa-plan-price { font-size: 13px; }
.sa-plan-price button { font-size: 11px; }
.sa-health-metrics small { font-size: 12px; }
.sa-health-metrics strong { font-size: 25px; }
.sa-health-metrics .text-success { font-size: 16px; }
.sa-form label { font-size: 12px; }
.sa-form input, .sa-form select, .sa-form textarea { font-size: 14px; }
.sa-form-inset > strong { font-size: 13px; }
.sa-modal-header h3 { font-size: 19px; }
.sa-footer { font-size: 11px; }

@media (max-width: 820px) {
  .sa-nav-link { font-size: 13px; }
  .sa-topbar-left h1 { font-size: 21px; }
  .sa-kpi-card { min-height: 100px; padding: 14px; }
  .sa-kpi-value { font-size: 25px; }
}

@media (max-width: 580px) {
  .sa-topbar-left h1 { font-size: 19px; }
  .sa-topbar-left p { font-size: 11px; }
  .sa-kpi-card { min-height: 96px; }
  .sa-kpi-head { font-size: 11px; }
  .sa-kpi-value { font-size: 22px; }
  .sa-card-heading h2 { font-size: 14px; }
  .sa-card-heading p { font-size: 11px; }
  .sa-enterprise-table { font-size: 12px; }
}
</style>
