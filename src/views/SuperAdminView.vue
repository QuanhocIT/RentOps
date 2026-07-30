<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-amber-100 text-amber-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Super Admin Console</span>
            <span class="text-xs text-slate-400 font-medium">• Trung Tâm Điều Hành Nền Tảng SaaS</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Nền Tảng RentOps</h1>
          <p class="text-slate-500 text-sm mt-0.5">Theo dõi chủ trọ (Tenants), gói cước (Plans), hạ tầng kỹ thuật và phát thông báo hệ thống</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="openCreateTenantModal"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>➕</span>
            <span>Tạo Chủ Trọ Mới</span>
          </button>
          
          <button
            @click="openCreatePlanModal()"
            class="px-4 py-2.5 bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>💎</span>
            <span>Tạo Gói SaaS Mới</span>
          </button>

          <div class="bg-gradient-to-br from-indigo-900 to-slate-900 border border-indigo-700/50 px-5 py-2 rounded-2xl text-right text-white shadow-lg shadow-indigo-950/20">
            <p class="text-[10px] text-indigo-300 font-bold uppercase tracking-wider">Doanh thu MRR</p>
            <p class="text-xl font-mono font-black text-emerald-400 mt-0.5">{{ formatCurrency(data.mrr_estimate) }}</p>
          </div>
        </div>
      </div>

      <!-- Navigation Tabs -->
      <div class="flex border-b border-slate-200 gap-2 overflow-x-auto">
        <button
          @click="activeTab = 'tenants'"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeTab === 'tenants'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>🏢</span>
          <span>Quản lý Tenants & Gói SaaS</span>
        </button>

        <button
          @click="activeTab = 'health'"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeTab === 'health'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>⚡</span>
          <span>Sức Khỏe System & Hạ Tầng</span>
        </button>

        <button
          @click="activeTab = 'broadcast'"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeTab === 'broadcast'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>📢</span>
          <span>Phát Thông Báo Toàn Hệ Thống</span>
        </button>

        <button
          @click="activeTab = 'audit'"
          :class="[
            'px-4 py-2.5 text-xs font-bold rounded-t-xl transition flex items-center gap-2 border-b-2',
            activeTab === 'audit'
              ? 'border-indigo-600 text-indigo-600 bg-white shadow-xs'
              : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-100/50'
          ]"
        >
          <span>📜</span>
          <span>Nhật Ký Thao Tác Toàn Nền Tảng</span>
        </button>
      </div>

      <!-- TAB 1: TENANTS & PLANS MANAGEMENT -->
      <div v-if="activeTab === 'tenants'" class="space-y-6">
        <!-- Summary Metrics Grid -->
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
          <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
              <span>Tổng Chủ Trọ</span>
              <span>🏢</span>
            </div>
            <p class="text-2xl font-black text-slate-900 mt-2">{{ data.total_tenants || 0 }}</p>
            <p class="text-[11px] text-emerald-600 font-semibold mt-1">{{ data.active_tenants || 0 }} Đang hoạt động</p>
          </div>

          <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
              <span>Tổng Phòng Trọ</span>
              <span>🔑</span>
            </div>
            <p class="text-2xl font-black text-slate-900 mt-2">{{ data.total_rooms || 0 }}</p>
            <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ các chủ trọ</p>
          </div>

          <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
              <span>Hợp Đồng Khách</span>
              <span>📄</span>
            </div>
            <p class="text-2xl font-black text-indigo-600 mt-2">{{ data.total_contracts || 0 }}</p>
            <p class="text-[11px] text-slate-400 font-medium mt-1">Hợp đồng đang hiệu lực</p>
          </div>

          <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
              <span>Khách Thuê</span>
              <span>👥</span>
            </div>
            <p class="text-2xl font-black text-slate-900 mt-2">{{ data.total_renters || 0 }}</p>
            <p class="text-[11px] text-slate-400 font-medium mt-1">Tài khoản cư dân</p>
          </div>

          <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
              <span>Gói Cước SaaS</span>
              <span>💎</span>
            </div>
            <p class="text-2xl font-black text-amber-600 mt-2">{{ (data.plans || []).length }}</p>
            <p class="text-[11px] text-slate-400 font-medium mt-1">Gói cước khả dụng</p>
          </div>
        </div>

        <!-- Tenants Table -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
          <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
            <div>
              <h3 class="font-bold text-slate-900 text-base flex items-center gap-2">
                <span>🏢 Danh Sách Chủ Trọ / Tòa Nhà (Tenants)</span>
              </h3>
              <p class="text-slate-400 text-xs mt-0.5">Quản lý phân quyền, nâng cấp gói cước và trạng thái tài khoản chủ trọ</p>
            </div>

            <div class="w-full sm:w-64">
              <input
                v-model="searchTerm"
                type="text"
                placeholder="Tìm tên hoặc SĐT chủ trọ..."
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-700">
              <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
                <tr>
                  <th class="px-6 py-3.5">Tên Chủ trọ / Tòa nhà</th>
                  <th class="px-6 py-3.5">Subdomain</th>
                  <th class="px-6 py-3.5">Số điện thoại</th>
                  <th class="px-6 py-3.5">Gói cước hiện tại</th>
                  <th class="px-6 py-3.5">Trạng thái</th>
                  <th class="px-6 py-3.5 text-right">Đổi gói cước / Hành động</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100">
                <tr v-for="tenant in filteredTenants" :key="tenant.id" class="hover:bg-slate-50/80 transition">
                  <td class="px-6 py-4">
                    <div class="font-bold text-slate-900">{{ tenant.name }}</div>
                    <div class="text-[11px] text-slate-400 font-mono">ID: {{ tenant.id }}</div>
                  </td>
                  <td class="px-6 py-4 font-mono text-xs text-indigo-600 font-semibold">{{ tenant.subdomain }}.rentops.vn</td>
                  <td class="px-6 py-4 font-mono text-slate-600">{{ tenant.phone || '0901234567' }}</td>
                  <td class="px-6 py-4 font-semibold text-amber-700">
                    <span class="inline-flex items-center px-2.5 py-1 rounded-lg bg-amber-50 text-amber-800 border border-amber-200 text-xs">
                      💎 {{ tenant.plan?.name || 'Gói Dùng Thử' }}
                    </span>
                  </td>
                  <td class="px-6 py-4">
                    <span
                      :class="[
                        'px-2.5 py-1 text-xs font-semibold rounded-full uppercase border',
                        tenant.status === 'suspended'
                          ? 'bg-rose-50 text-rose-700 border-rose-200'
                          : 'bg-emerald-50 text-emerald-700 border-emerald-200'
                      ]"
                    >
                      {{ tenant.status === 'suspended' ? 'Tạm Khóa' : 'Active' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-right space-x-2">
                    <select
                      @change="changePlan(tenant.id, $event.target.value)"
                      class="bg-slate-50 border border-slate-300 text-xs text-slate-800 rounded-xl px-2.5 py-1.5 font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    >
                      <option value="" disabled selected>-- Nâng cấp gói --</option>
                      <option v-for="p in data.plans" :key="p.id" :value="p.id">
                        {{ p.name }} ({{ formatCurrency(p.monthly_price) }}/tháng)
                      </option>
                    </select>

                    <button
                      @click="toggleTenantStatus(tenant.id)"
                      :class="tenant.status === 'suspended' ? 'bg-emerald-600 hover:bg-emerald-500 text-white' : 'bg-slate-200 hover:bg-slate-300 text-slate-700'"
                      class="px-3 py-1.5 text-xs font-bold rounded-xl transition"
                    >
                      {{ tenant.status === 'suspended' ? 'Mở Khóa' : 'Khóa' }}
                    </button>

                    <button
                      @click="deleteTenant(tenant)"
                      class="px-2.5 py-1.5 text-xs font-bold text-rose-600 hover:bg-rose-50 rounded-xl transition"
                      title="Xóa Tenant"
                    >
                      🗑️
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- SaaS Plans Section -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
          <div class="flex justify-between items-center">
            <h3 class="font-bold text-slate-900 text-base">💎 Danh Sách Các Gói Cước SaaS RentOps</h3>
            <button
              @click="openCreatePlanModal()"
              class="text-xs font-bold text-indigo-600 hover:text-indigo-800 flex items-center gap-1"
            >
              <span>➕ Thêm gói mới</span>
            </button>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div
              v-for="plan in data.plans"
              :key="plan.id"
              class="p-5 rounded-2xl border border-slate-200 bg-slate-50/50 flex flex-col justify-between space-y-3 relative group"
            >
              <div>
                <div class="flex justify-between items-center">
                  <h4 class="font-extrabold text-slate-900 text-base">{{ plan.name }}</h4>
                  <span class="text-xs font-mono font-bold px-2 py-0.5 bg-indigo-100 text-indigo-700 rounded-md">Max {{ plan.max_rooms }} phòng</span>
                </div>
                <p class="text-xs text-slate-500 mt-2">{{ plan.description || 'Gói cước dành cho chủ trọ' }}</p>
              </div>
              <div class="pt-3 border-t border-slate-200 flex justify-between items-center">
                <button
                  @click="openCreatePlanModal(plan)"
                  class="text-xs font-bold text-indigo-600 hover:underline"
                >
                  ✏️ Chỉnh sửa gói
                </button>
                <span class="text-lg font-mono font-black text-indigo-600">{{ formatCurrency(plan.monthly_price) }}/tháng</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- TAB 2: SYSTEM HEALTH & INFRASTRUCTURE -->
      <div v-else-if="activeTab === 'health'" class="space-y-6">
        <div class="bg-white rounded-2xl border border-slate-200 p-6 space-y-4">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="font-black text-slate-900 text-lg flex items-center gap-2">
                <span>⚡ Môi Trường Server & Hạ Tầng Kỹ Thuật</span>
              </h3>
              <p class="text-slate-400 text-xs mt-0.5">Thông số runtime, phiên bản phần mềm và kiểm tra sức khỏe hệ thống</p>
            </div>
            <button
              @click="fetchSystemHealth"
              class="px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition"
            >
              🔄 Làm mới
            </button>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div class="p-4 rounded-xl border border-slate-200 bg-slate-50">
              <p class="text-xs font-bold text-slate-400 uppercase">Ruby Engine</p>
              <p class="text-xl font-mono font-black text-slate-900 mt-1">{{ healthData.ruby_version || '3.2.x' }}</p>
            </div>

            <div class="p-4 rounded-xl border border-slate-200 bg-slate-50">
              <p class="text-xs font-bold text-slate-400 uppercase">Rails Framework</p>
              <p class="text-xl font-mono font-black text-indigo-600 mt-1">v{{ healthData.rails_version || '7.1.x' }}</p>
            </div>

            <div class="p-4 rounded-xl border border-slate-200 bg-slate-50">
              <p class="text-xs font-bold text-slate-400 uppercase">Cơ Sở Dữ Liệu</p>
              <p class="text-xl font-mono font-black text-emerald-600 mt-1">{{ healthData.database_adapter || 'PostgreSQL' }}</p>
            </div>

            <div class="p-4 rounded-xl border border-slate-200 bg-slate-50">
              <p class="text-xs font-bold text-slate-400 uppercase">Trạng Thái Hệ Thống</p>
              <p class="text-xl font-bold text-emerald-700 mt-1 flex items-center gap-1.5">
                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                <span>{{ healthData.uptime_info || 'Online Normal' }}</span>
              </p>
            </div>
          </div>
        </div>

        <!-- Global Objects Metrics Grid -->
        <div class="bg-white rounded-2xl border border-slate-200 p-6 space-y-4">
          <h3 class="font-bold text-slate-900 text-base">📊 Thống Kê Tổng Số Đối Tượng Trên Toàn Nền Tảng</h3>
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div class="p-4 rounded-xl border border-slate-100 bg-slate-50">
              <p class="text-xs font-bold uppercase text-slate-400">Tổng Tòa Nhà / Khu Trọ</p>
              <p class="text-2xl font-black text-slate-900 mt-1">{{ healthData.total_properties || 0 }}</p>
            </div>
            <div class="p-4 rounded-xl border border-slate-100 bg-slate-50">
              <p class="text-xs font-bold uppercase text-slate-400">Tổng Phòng Trọ</p>
              <p class="text-2xl font-black text-indigo-600 mt-1">{{ healthData.total_rooms || 0 }}</p>
            </div>
            <div class="p-4 rounded-xl border border-slate-100 bg-slate-50">
              <p class="text-xs font-bold uppercase text-slate-400">Tổng Hợp Đồng</p>
              <p class="text-2xl font-black text-emerald-600 mt-1">{{ healthData.total_contracts || 0 }}</p>
            </div>
            <div class="p-4 rounded-xl border border-slate-100 bg-slate-50">
              <p class="text-xs font-bold uppercase text-slate-400">Tổng Hóa Đơn Phát Hành</p>
              <p class="text-2xl font-black text-amber-600 mt-1">{{ healthData.total_bills || 0 }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- TAB 3: SYSTEM BROADCAST ANNOUNCEMENTS -->
      <div v-else-if="activeTab === 'broadcast'" class="space-y-6">
        <div class="bg-white rounded-2xl border border-slate-200 p-6 space-y-5">
          <div>
            <h3 class="font-black text-slate-900 text-lg flex items-center gap-2">
              <span>📢 Phát Thông Báo Tức Thì Đến Tất Cả Chủ Trọ</span>
            </h3>
            <p class="text-slate-400 text-xs mt-0.5">Gửi thông điệp quan trọng, lịch bảo trì hệ thống hoặc cập nhật tính năng tới toàn bộ danh sách chủ trọ</p>
          </div>

          <form @submit.prevent="sendBroadcast" class="space-y-4 max-w-2xl">
            <div>
              <label class="block text-xs font-bold uppercase text-slate-700 mb-1">Tiêu Đề Thông Báo *</label>
              <input
                v-model="broadcastForm.title"
                type="text"
                required
                placeholder="vd: [BẢO TRÌ HỆ THỐNG] Nâng cấp Server lúc 02:00 sáng"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm font-semibold text-slate-900"
              />
            </div>

            <div>
              <label class="block text-xs font-bold uppercase text-slate-700 mb-1">Kênh Phát Thông Báo</label>
              <select
                v-model="broadcastForm.channel"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-xs font-semibold text-slate-800"
              >
                <option value="zns">ZNS / Zalo Official Notification</option>
                <option value="sms">SMS Brandname</option>
                <option value="email">Email System</option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-bold uppercase text-slate-700 mb-1">Nội Dung Thông Báo *</label>
              <textarea
                v-model="broadcastForm.content"
                rows="4"
                required
                placeholder="Nhập nội dung thông báo muốn gửi tới tất cả chủ trọ..."
                class="w-full bg-slate-50 border border-slate-300 rounded-xl p-4 text-xs text-slate-800"
              ></textarea>
            </div>

            <button
              type="submit"
              class="px-6 py-3 bg-indigo-600 hover:bg-indigo-500 text-white font-extrabold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center gap-2"
            >
              <span>🚀</span>
              <span>Phát Thông Báo Ngay Lập Tức</span>
            </button>
          </form>
        </div>
      </div>

      <!-- TAB 4: GLOBAL AUDIT LOGS -->
      <div v-else-if="activeTab === 'audit'" class="space-y-6">
        <div class="bg-white rounded-2xl border border-slate-200 p-6 space-y-4">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="font-black text-slate-900 text-lg flex items-center gap-2">
                <span>📜 Nhật Ký Thao Tác Toàn Nền Tảng (Audit Logs)</span>
              </h3>
              <p class="text-slate-400 text-xs mt-0.5">Giám sát mọi thao tác khởi tạo hợp đồng, thu tiền, chỉnh sửa dữ liệu trên toàn hệ thống</p>
            </div>
            <button
              @click="fetchGlobalAuditLogs"
              class="px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition"
            >
              🔄 Làm mới nhật ký
            </button>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-700">
              <thead class="bg-slate-50 text-[11px] uppercase text-slate-500 font-bold border-b border-slate-200">
                <tr>
                  <th class="px-4 py-3">Thời gian</th>
                  <th class="px-4 py-3">Tòa Nhà / Tenant</th>
                  <th class="px-4 py-3">Người thực hiện</th>
                  <th class="px-4 py-3">Hành động</th>
                  <th class="px-4 py-3">Đối tượng</th>
                  <th class="px-4 py-3">Chi tiết Payload</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100">
                <tr v-for="log in globalAuditLogs" :key="log.id" class="hover:bg-slate-50/80 transition">
                  <td class="px-4 py-3 font-mono text-slate-500 whitespace-nowrap">
                    {{ new Date(log.created_at).toLocaleString('vi-VN') }}
                  </td>
                  <td class="px-4 py-3 font-bold text-indigo-900 whitespace-nowrap">{{ log.tenant_name }}</td>
                  <td class="px-4 py-3 font-semibold text-slate-800 whitespace-nowrap">{{ log.user_name }}</td>
                  <td class="px-4 py-3">
                    <span class="px-2 py-0.5 bg-indigo-50 text-indigo-700 border border-indigo-200 font-bold rounded-md uppercase">
                      {{ log.action }}
                    </span>
                  </td>
                  <td class="px-4 py-3 font-mono text-slate-600">{{ log.record_type }} #{{ log.record_id }}</td>
                  <td class="px-4 py-3 font-mono text-[11px] text-slate-500 truncate max-w-xs">{{ log.payload }}</td>
                </tr>
                <tr v-if="globalAuditLogs.length === 0">
                  <td colspan="6" class="px-4 py-8 text-center text-slate-400">
                    Chưa có nhật ký thao tác nào được ghi nhận.
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- MODAL: Tạo Chủ Trọ / Tenant Mới -->
    <div
      v-if="showCreateTenantModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-xs p-4"
    >
      <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl w-full max-w-lg p-6 space-y-5">
        <div class="flex justify-between items-center border-b border-slate-100 pb-3">
          <h3 class="font-black text-lg text-slate-900">🏢 Tạo Chủ Trọ / Tòa Nhà Mới</h3>
          <button @click="showCreateTenantModal = false" class="text-slate-400 hover:text-slate-600 text-lg">✕</button>
        </div>

        <form @submit.prevent="submitCreateTenant" class="space-y-4">
          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Tên Tòa Nhà / Tên Chủ Trọ *</label>
            <input
              v-model="tenantForm.name"
              type="text"
              required
              placeholder="vd: Chuỗi Căn Hộ Dịch Vụ X"
              class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Subdomain *</label>
              <input
                v-model="tenantForm.subdomain"
                type="text"
                required
                placeholder="vd: house-x"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm font-mono text-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Số điện thoại *</label>
              <input
                v-model="tenantForm.phone"
                type="text"
                required
                placeholder="vd: 0901234567"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          <div class="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 space-y-3">
            <p class="text-xs font-bold text-indigo-900 uppercase">Tài Khoản Đăng Nhập Chủ Trọ (Owner)</p>

            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1">Họ & Tên Chủ Trọ</label>
              <input
                v-model="tenantForm.owner_name"
                type="text"
                required
                placeholder="vd: Nguyễn Văn Minh"
                class="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs text-slate-900"
              />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Email Đăng Nhập *</label>
                <input
                  v-model="tenantForm.owner_email"
                  type="email"
                  required
                  placeholder="minh@gmail.com"
                  class="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs text-slate-900"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-600 mb-1">Mật Khẩu Khởi Tạo *</label>
                <input
                  v-model="tenantForm.owner_password"
                  type="password"
                  required
                  placeholder="Password123!"
                  class="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs text-slate-900"
                />
              </div>
            </div>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Gói Cước Ban Đầu</label>
            <select
              v-model="tenantForm.plan_id"
              class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2.5 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            >
              <option v-for="p in data.plans" :key="p.id" :value="p.id">
                {{ p.name }} (Max {{ p.max_rooms }} phòng - {{ formatCurrency(p.monthly_price) }}/tháng)
              </option>
            </select>
          </div>

          <div class="flex justify-end gap-3 pt-3">
            <button
              type="button"
              @click="showCreateTenantModal = false"
              class="px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl"
            >
              Hủy
            </button>
            <button
              type="submit"
              class="px-5 py-2 text-xs font-bold text-white bg-indigo-600 hover:bg-indigo-500 rounded-xl shadow-md"
            >
              Tạo Chủ Trọ Mới
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- MODAL: Tạo / Sửa Gói Cước SaaS -->
    <div
      v-if="showPlanModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-xs p-4"
    >
      <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl w-full max-w-md p-6 space-y-4">
        <div class="flex justify-between items-center border-b border-slate-100 pb-3">
          <h3 class="font-black text-lg text-slate-900">
            {{ planForm.id ? '✏️ Cập Nhật Gói Cước' : '💎 Tạo Gói Cước SaaS Mới' }}
          </h3>
          <button @click="showPlanModal = false" class="text-slate-400 hover:text-slate-600 text-lg">✕</button>
        </div>

        <form @submit.prevent="submitPlanForm" class="space-y-4">
          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Tên Gói Cước *</label>
            <input
              v-model="planForm.name"
              type="text"
              required
              placeholder="vd: Gói VIP Enterprise"
              class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2 text-xs font-bold text-slate-900"
            />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Giới Hạn Phòng *</label>
              <input
                v-model="planForm.max_rooms"
                type="number"
                required
                placeholder="vd: 100"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2 text-xs font-mono font-bold text-indigo-600"
              />
            </div>
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Giá Hàng Tháng (đ) *</label>
              <input
                v-model="planForm.monthly_price"
                type="number"
                required
                placeholder="vd: 499000"
                class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2 text-xs font-mono text-emerald-600"
              />
            </div>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Mô Tả Gói</label>
            <textarea
              v-model="planForm.description"
              rows="2"
              placeholder="Mô tả các quyền lợi của gói..."
              class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2 text-xs text-slate-700"
            ></textarea>
          </div>

          <div class="flex justify-end gap-3 pt-3">
            <button
              type="button"
              @click="showPlanModal = false"
              class="px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl"
            >
              Hủy
            </button>
            <button
              type="submit"
              class="px-5 py-2 text-xs font-bold text-white bg-amber-600 hover:bg-amber-500 rounded-xl shadow-md"
            >
              {{ planForm.id ? 'Lưu Thay Đổi' : 'Tạo Gói SaaS' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import api from '../services/api'

const activeTab = ref('tenants')

const data = ref({
  tenants: [],
  plans: [],
  total_tenants: 0,
  active_tenants: 0,
  mrr_estimate: 0,
  total_rooms: 0,
  total_contracts: 0,
  total_renters: 0
})

const healthData = ref({})
const globalAuditLogs = ref([])

const searchTerm = ref('')
const showCreateTenantModal = ref(false)
const showPlanModal = ref(false)

const broadcastForm = ref({
  title: '',
  content: '',
  channel: 'zns'
})

const tenantForm = ref({
  name: '',
  subdomain: '',
  phone: '',
  owner_name: '',
  owner_email: '',
  owner_password: 'Password123!',
  plan_id: null
})

const planForm = ref({
  id: null,
  name: '',
  max_rooms: 50,
  monthly_price: 299000,
  description: ''
})

const filteredTenants = computed(() => {
  if (!searchTerm.value.trim()) return data.value.tenants || []
  const term = searchTerm.value.toLowerCase()
  return (data.value.tenants || []).filter(
    (t) => t.name?.toLowerCase().includes(term) || t.phone?.includes(term) || t.subdomain?.toLowerCase().includes(term)
  )
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const fetchOverview = async () => {
  try {
    const res = await api.get('/super_admin/overview')
    const payload = res?.data || res
    if (payload) {
      data.value = payload
      if (!tenantForm.value.plan_id && payload.plans?.length) {
        tenantForm.value.plan_id = payload.plans[0].id
      }
    }
  } catch (err) {
    console.error('Lỗi lấy dữ liệu Super Admin:', err)
  }
}

const fetchSystemHealth = async () => {
  try {
    const res = await api.get('/super_admin/system_health')
    const payload = res?.data || res
    if (payload) healthData.value = payload
  } catch (err) {
    console.error('Lỗi lấy thông số sức khỏe hệ thống:', err)
  }
}

const fetchGlobalAuditLogs = async () => {
  try {
    const res = await api.get('/super_admin/audit_logs')
    const payload = res?.data || res
    if (payload) globalAuditLogs.value = payload
  } catch (err) {
    console.error('Lỗi lấy nhật ký toàn hệ thống:', err)
  }
}

const sendBroadcast = async () => {
  try {
    const res = await api.post('/super_admin/broadcast_notification', broadcastForm.value)
    if (res?.success) {
      alert(res.message || 'Đã phát thông báo toàn hệ thống thành công!')
      broadcastForm.value.title = ''
      broadcastForm.value.content = ''
    }
  } catch (err) {
    alert('Lỗi phát thông báo')
  }
}

const openCreateTenantModal = () => {
  tenantForm.value = {
    name: '',
    subdomain: `tenant-${Date.now().toString().slice(-4)}`,
    phone: '0901234567',
    owner_name: '',
    owner_email: '',
    owner_password: 'Password123!',
    plan_id: data.value.plans?.[0]?.id || null
  }
  showCreateTenantModal.value = true
}

const submitCreateTenant = async () => {
  try {
    const res = await api.post('/super_admin/create_tenant', tenantForm.value)
    if (res?.success) {
      alert(res.message || 'Tạo Chủ Trọ thành công!')
      showCreateTenantModal.value = false
      fetchOverview()
    }
  } catch (err) {
    alert(err?.message || 'Lỗi khi tạo Chủ trọ mới')
  }
}

const openCreatePlanModal = (plan = null) => {
  if (plan) {
    planForm.value = {
      id: plan.id,
      name: plan.name,
      max_rooms: plan.max_rooms,
      monthly_price: plan.monthly_price,
      description: plan.description || ''
    }
  } else {
    planForm.value = {
      id: null,
      name: '',
      max_rooms: 50,
      monthly_price: 299000,
      description: ''
    }
  }
  showPlanModal.value = true
}

const submitPlanForm = async () => {
  try {
    let res
    if (planForm.value.id) {
      res = await api.put('/super_admin/update_plan_details', planForm.value)
    } else {
      res = await api.post('/super_admin/create_plan', planForm.value)
    }
    if (res?.success) {
      alert(res.message || 'Cập nhật Gói Cước thành công!')
      showPlanModal.value = false
      fetchOverview()
    }
  } catch (err) {
    alert(err?.message || 'Lỗi xử lý gói cước')
  }
}

const changePlan = async (tenantId, planId) => {
  try {
    const res = await api.post('/super_admin/update_plan', { tenant_id: tenantId, plan_id: planId })
    if (res?.success) {
      alert('Đã cập nhật gói cước thành công!')
      fetchOverview()
    }
  } catch (err) {
    alert('Lỗi cập nhật gói cước')
  }
}

const toggleTenantStatus = async (tenantId) => {
  try {
    const res = await api.post('/super_admin/toggle_tenant_status', { tenant_id: tenantId })
    if (res?.success) {
      fetchOverview()
    }
  } catch (err) {
    alert('Lỗi cập nhật trạng thái Tenant')
  }
}

const deleteTenant = async (tenant) => {
  if (!confirm(`Bạn có chắc chắn muốn xóa Tenant "${tenant.name}"? Thao tác này không thể hoàn tác.`)) return
  try {
    const res = await api.delete('/super_admin/delete_tenant', { data: { tenant_id: tenant.id } })
    if (res?.success) {
      alert(res.message || 'Đã xóa Tenant thành công!')
      fetchOverview()
    }
  } catch (err) {
    alert('Lỗi khi xóa Tenant')
  }
}

onMounted(() => {
  fetchOverview()
  fetchSystemHealth()
  fetchGlobalAuditLogs()
})
</script>
