<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Quản Lý Căn Hộ & Phòng</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Property Units</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Danh Sách Căn Hộ & Phòng Cho Thuê</h1>
          <p class="text-slate-500 text-sm mt-0.5">Cấu hình chi tiết layout: Số phòng ngủ (2 PN), Phòng khách (1 PK), WC, Ban công & Diện tích</p>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="openModal()"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center gap-1.5"
          >
            <span>🔑</span>
            <span>Thêm Căn Hộ / Phòng Mới</span>
          </button>
        </div>
      </div>

      <!-- Stat Badges -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Số Căn / Phòng</span>
            <span>🔑</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ rooms.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Toàn bộ bất động sản</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Đang Trống</span>
            <span>🟢</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'vacant' || r.status === 0).length }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Sẵn sàng bàn giao</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Đang Ở / Đang Thuê</span>
            <span>🔴</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'rented' || r.status === 'occupied' || r.status === 1).length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Đã có hợp đồng</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-amber-600 flex items-center justify-between">
            <span>Đã Cọc / Bảo Trì</span>
            <span>🟡</span>
          </div>
          <p class="text-2xl font-black text-amber-700 mt-2 font-mono">{{ rooms.filter(r => r.status === 'reserved' || r.status === 'maintenance' || r.status === 2).length }}</p>
          <p class="text-[11px] text-amber-600 font-semibold mt-1">Cần theo dõi</p>
        </div>
      </div>

      <!-- Rooms List -->
      <div class="bg-white/90 backdrop-blur-md rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div class="font-extrabold text-slate-900 text-base flex items-center gap-2">
            <span>Danh Sách Tất Cả Căn Hộ</span>
            <span class="text-xs font-normal text-slate-400">({{ filteredRooms.length }} phòng)</span>
          </div>
          
          <div class="flex flex-wrap items-center gap-3">
            <!-- View Mode Switcher (Dạng Bảng / Dạng Thẻ) -->
            <div class="flex items-center bg-slate-100 p-1 rounded-xl border border-slate-200">
              <button 
                @click="viewMode = 'table'"
                :class="['px-3 py-1.5 rounded-lg text-xs font-bold transition flex items-center gap-1.5', viewMode === 'table' ? 'bg-indigo-600 text-white shadow-xs' : 'text-slate-600 hover:text-slate-900']"
              >
                <span>📊</span> Dạng Bảng
              </button>
              <button 
                @click="viewMode = 'grid'"
                :class="['px-3 py-1.5 rounded-lg text-xs font-bold transition flex items-center gap-1.5', viewMode === 'grid' ? 'bg-indigo-600 text-white shadow-xs' : 'text-slate-600 hover:text-slate-900']"
              >
                <span>🎴</span> Dạng Thẻ
              </button>
            </div>

            <select v-model="filterProperty" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả tòa nhà / khu</option>
              <option v-for="p in properties" :key="p.id" :value="p.id">{{ p.name }} ({{ p.property_type_label }})</option>
            </select>

            <select v-model="filterStatus" class="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:outline-none focus:ring-2 focus:ring-indigo-500">
              <option value="">Tất cả trạng thái</option>
              <option value="vacant">Trống 🟢</option>
              <option value="occupied">Đang ở 🔴</option>
              <option value="reserved">Đã cọc 🟡</option>
              <option value="maintenance">Bảo trì 🔧</option>
            </select>

            <input v-model="searchQuery" class="w-56 rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="Tìm số phòng hoặc layout..." />
            <button class="p-2 text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200 transition" @click="loadData">🔄</button>
          </div>
        </div>

        <!-- Table View Mode -->
        <div v-if="viewMode === 'table' && filteredRooms.length" class="overflow-x-auto rounded-2xl border border-slate-200/80 bg-white">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-slate-100/80 border-b border-slate-200/80 text-[11px] font-extrabold uppercase text-slate-600 tracking-wider">
                <th class="py-3.5 px-4">Mã / Số Phòng</th>
                <th class="py-3.5 px-4">Tòa Nhà / Bất Động Sản</th>
                <th class="py-3.5 px-4">Vị Trí & Mô Hình</th>
                <th class="py-3.5 px-4">Giá Thuê</th>
                <th class="py-3.5 px-4">Trạng Thái</th>
                <th class="py-3.5 px-4 text-right">Thao Tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 text-xs">
              <tr v-for="item in filteredRooms" :key="item.id" class="hover:bg-indigo-50/30 transition-colors">
                <td class="py-3.5 px-4 font-black text-slate-900 text-sm whitespace-nowrap">
                  Mã/Phòng {{ item.room_number }}
                </td>
                <td class="py-3.5 px-4 whitespace-nowrap">
                  <span class="font-bold text-slate-800 flex items-center gap-1.5">
                    <span>{{ item.property_type_icon || '🏢' }}</span>
                    <span>{{ item.property_name }}</span>
                  </span>
                </td>
                <td class="py-3.5 px-4 whitespace-nowrap">
                  <div class="font-bold text-slate-700">Tầng {{ item.floor || 1 }}</div>
                  <div class="text-[10px] font-extrabold uppercase text-indigo-600">
                    {{ item.room_type_label || getRoomTypeLabel(item.room_type) }}
                  </div>
                </td>
                <td class="py-3.5 px-4 font-mono font-black text-indigo-600 text-sm whitespace-nowrap">
                  {{ formatCurrency(item.price) }} <span class="text-[10px] font-medium text-slate-400">/tháng</span>
                </td>
                <td class="py-3.5 px-4 whitespace-nowrap">
                  <div class="flex items-center gap-2">
                    <span :class="['px-2.5 py-1 rounded-full text-[10px] font-extrabold uppercase shadow-2xs', getStatusBadge(item.status)]">
                      {{ getStatusLabel(item.status) }}
                    </span>
                    <select
                      :value="item.status"
                      @change="quickUpdateStatus(item, $event.target.value)"
                      class="px-2 py-1 bg-white border border-slate-200 rounded-lg text-xs font-bold text-slate-700 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                    >
                      <option value="vacant">Trống</option>
                      <option value="occupied">Đang ở</option>
                      <option value="reserved">Đã cọc</option>
                      <option value="maintenance">Bảo trì</option>
                    </select>
                  </div>
                </td>
                <td class="py-3.5 px-4 text-right whitespace-nowrap">
                  <div class="flex items-center justify-end gap-2">
                    <button
                      @click="openDetailModal(item)"
                      class="px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md shadow-indigo-600/20 transition flex items-center gap-1"
                    >
                      <span>👁️</span> <span>Xem Chi Tiết</span>
                    </button>
                    <button @click="openModal(item)" class="text-xs font-bold text-slate-700 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-xl transition">
                      Sửa
                    </button>
                    <button @click="deleteRoom(item.id)" class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-3 py-1.5 rounded-xl transition">
                      Xóa
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Grid View Mode -->
        <div v-else-if="viewMode === 'grid' && filteredRooms.length" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
          <div v-for="item in filteredRooms" :key="item.id" class="rounded-2xl border border-slate-200/80 p-5 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col justify-between space-y-4 bg-slate-50/50 group">
            <div>
              <div class="flex items-center justify-between gap-1">
                <span class="text-[10px] font-extrabold uppercase text-indigo-600 tracking-wider truncate block max-w-[130px]">
                  {{ item.property_type_icon || '🏢' }} {{ item.property_name }}
                </span>
                <span :class="['px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase shadow-2xs whitespace-nowrap', getStatusBadge(item.status)]">
                  {{ getStatusLabel(item.status) }}
                </span>
              </div>

              <h3 class="text-2xl font-black text-slate-900 mt-2 group-hover:scale-105 transition-transform flex items-center gap-1.5">
                <span>Mã/Phòng {{ item.room_number }}</span>
              </h3>

              <div class="flex items-center justify-between text-xs text-slate-500 mt-1">
                <span>Vị trí: <strong>Tầng {{ item.floor || 1 }}</strong></span>
                <span class="px-2 py-0.5 bg-slate-200/70 text-slate-700 font-extrabold rounded-md text-[10px] uppercase">
                  {{ item.room_type_label || getRoomTypeLabel(item.room_type) }}
                </span>
              </div>

              <div class="text-lg font-black text-indigo-600 font-mono mt-3">{{ formatCurrency(item.price) }} / tháng</div>
            </div>

            <div class="space-y-2 border-t border-slate-200/80 pt-3">
              <div class="flex items-center justify-between text-xs">
                <span class="text-slate-500 font-medium">Trạng thái:</span>
                <select
                  :value="item.status"
                  @change="quickUpdateStatus(item, $event.target.value)"
                  class="px-2 py-1 bg-white border border-slate-200 rounded-lg text-xs font-bold text-slate-700 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="vacant">Trống</option>
                  <option value="occupied">Đang ở</option>
                  <option value="reserved">Đã cọc</option>
                  <option value="maintenance">Bảo trì</option>
                </select>
              </div>

              <div class="flex items-center justify-between gap-1.5 pt-1">
                <button
                  @click="openDetailModal(item)"
                  class="flex-1 px-2.5 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md shadow-indigo-600/20 transition flex items-center justify-center gap-1"
                >
                  <span>👁️</span> <span>Chi Tiết</span>
                </button>
                <button @click="openModal(item)" class="text-xs font-bold text-slate-700 bg-slate-200/70 hover:bg-slate-300 px-2.5 py-1.5 rounded-xl transition">
                  Sửa
                </button>
                <button @click="deleteRoom(item.id)" class="text-xs font-bold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1.5 rounded-xl transition">
                  Xóa
                </button>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!filteredRooms.length" class="text-center py-12 bg-slate-50 rounded-2xl border border-dashed border-slate-300">
          <span class="text-4xl block mb-2">🔑</span>
          <p class="text-sm font-bold text-slate-700">Chưa có phòng / căn hộ nào phù hợp.</p>
        </div>
      </div>

      <!-- Add / Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl space-y-4 animate-scale-in max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <div>
              <h3 class="text-lg font-extrabold text-slate-900">{{ editingRoom ? 'Chỉnh Sửa Layout Căn Hộ' : 'Thêm Căn Hộ / Phòng Mới' }}</h3>
              <p class="text-xs text-slate-500">Cấu hình mô hình cho thuê (Chung cư mini, Căn hộ cao cấp, Nhà nguyên căn)</p>
            </div>
            <button @click="showModal = false" class="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
          </div>

          <form @submit.prevent="saveRoom" class="space-y-4">
            <div>
              <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Thuộc Tòa Nhà / Bất Động Sản</label>
              <select v-model="form.propertyId" @change="onPropertySelect" required class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                <option value="" disabled>-- Chọn Tòa nhà --</option>
                <option v-for="p in properties" :key="p.id" :value="p.id">
                  {{ p.property_type_icon || '🏢' }} {{ p.name }}
                </option>
              </select>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Loại Mô Hình Căn Hộ</label>
                <select v-model="form.room_type" required class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                  <option value="can_ho_2pn">🏢 Căn hộ 2 Phòng Ngủ + 1 PK</option>
                  <option value="can_ho_1pn">🏢 Căn hộ 1 Phòng Ngủ</option>
                  <option value="can_ho_3pn">🏢 Căn hộ 3 Phòng Ngủ</option>
                  <option value="studio">✨ Căn hộ Studio</option>
                  <option value="duplex">🌆 Căn hộ Duplex / Loft</option>
                  <option value="nha_nguyen_can">🏡 Nhà Nguyên Căn</option>
                  <option value="phong_don">🏠 Phòng đơn khép kín</option>
                </select>
              </div>

              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Mã Căn / Số Phòng</label>
                <input v-model="form.roomNumber" required type="text" placeholder="VD: P103 hoặc R05" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-indigo-500" />
              </div>
            </div>

            <!-- Detailed Layout Config (2 Bedrooms, 1 Living Room, 1 WC, Kitchen, etc.) -->
            <div class="bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100 space-y-3">
              <span class="text-xs font-extrabold text-indigo-900 uppercase tracking-wider block">📐 Cấu Hình Layout & Tiện Ích</span>

              <div class="grid grid-cols-4 gap-2">
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số Phòng Ngủ</label>
                  <input v-model.number="form.bedrooms_count" required type="number" min="0" max="10" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Phòng Khách</label>
                  <input v-model.number="form.living_rooms_count" required type="number" min="0" max="5" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Nhà Vệ Sinh</label>
                  <input v-model.number="form.bathrooms_count" required type="number" min="1" max="10" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Số Bếp</label>
                  <input v-model.number="form.kitchens_count" required type="number" min="0" max="5" class="w-full px-2.5 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold text-center" />
                </div>
              </div>

              <div class="grid grid-cols-3 gap-3 pt-1">
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Diện tích (m²)</label>
                  <input v-model.number="form.area" required type="number" min="10" step="0.5" class="w-full px-3 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold" placeholder="45" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Tầng số</label>
                  <input v-model.number="form.floor" required type="number" min="1" class="w-full px-3 py-2 bg-white border border-indigo-200 rounded-xl text-xs font-mono font-bold" placeholder="3" />
                </div>
                <div>
                  <label class="block text-[10px] font-extrabold text-slate-600 uppercase mb-1">Tình Trạng Nội Thất</label>
                  <select v-model="form.furnished_status" class="w-full px-2 py-2 bg-white border border-indigo-200 rounded-xl text-[11px] font-bold">
                    <option value="full_noi_that">🛋️ Full Nội Thất</option>
                    <option value="co_ban">🪑 Nội Thất Cơ Bản</option>
                    <option value="nha_tho">🧱 Bàn Giao Thô</option>
                  </select>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-2 pt-1 text-[11px]">
                <div class="flex items-center gap-1.5">
                  <input v-model="form.has_balcony" type="checkbox" id="balcony_check" class="w-4 h-4 text-indigo-600 rounded border-slate-300 focus:ring-indigo-500" />
                  <label for="balcony_check" class="font-bold text-slate-700 cursor-pointer">🌅 Ban công</label>
                </div>
                <div class="flex items-center gap-1.5">
                  <input v-model="form.is_mezzanine" type="checkbox" id="mezzanine_check" class="w-4 h-4 text-purple-600 rounded border-slate-300 focus:ring-purple-500" />
                  <label for="mezzanine_check" class="font-bold text-purple-800 cursor-pointer">🏠 Gác lửng</label>
                </div>
                <div class="flex items-center gap-1.5">
                  <input v-model="form.is_shared_bathroom" type="checkbox" id="shared_wc_check" class="w-4 h-4 text-amber-600 rounded border-slate-300 focus:ring-amber-500" />
                  <label for="shared_wc_check" class="font-bold text-amber-800 cursor-pointer">🚽 WC chung</label>
                </div>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Giá Thuê Thỏa Thuận (VNĐ/tháng)</label>
                <input v-model.number="form.price" required type="number" placeholder="5200000" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-mono font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500" />
              </div>
              <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Trạng Thái Hiện Tại</label>
                <select v-model="form.status" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-xs font-bold focus:bg-white focus:ring-2 focus:ring-indigo-500">
                  <option value="vacant">Sẵn sàng (Trống)</option>
                  <option value="occupied">Đang cho thuê</option>
                  <option value="reserved">Khách đã đặt cọc</option>
                  <option value="maintenance">Đang bảo trì / sửa chữa</option>
                </select>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 border-t border-slate-100 pt-3">
              <button type="button" @click="showModal = false" class="px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-xs transition">
                Hủy
              </button>
              <button type="submit" class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-xs shadow-lg shadow-indigo-600/30 transition">
                Lưu Thay Đổi Layout
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Room Detail View Modal -->
      <div v-if="showDetailModal && selectedDetailRoom" class="fixed inset-0 z-50 bg-slate-950/70 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
        <div class="bg-white rounded-3xl max-w-xl w-full p-6 shadow-2xl space-y-5 animate-scale-in max-h-[90vh] overflow-y-auto">
          <!-- Modal Header -->
          <div class="flex items-start justify-between border-b border-slate-100 pb-4">
            <div class="space-y-1">
              <div class="flex items-center gap-2">
                <span class="text-xs font-extrabold uppercase px-2.5 py-0.5 bg-indigo-100 text-indigo-700 rounded-lg">
                  {{ selectedDetailRoom.property_type_icon || '🏢' }} {{ selectedDetailRoom.property_name }}
                </span>
                <span :class="['px-2.5 py-0.5 rounded-full text-[10px] font-extrabold uppercase', getStatusBadge(selectedDetailRoom.status)]">
                  {{ getStatusLabel(selectedDetailRoom.status) }}
                </span>
              </div>
              <h2 class="text-2xl font-black text-slate-900">Chi Tiết Căn Hộ / Phòng {{ selectedDetailRoom.room_number }}</h2>
              <p class="text-xs text-slate-500 font-medium">📍 Tầng {{ selectedDetailRoom.floor || 1 }} • {{ selectedDetailRoom.room_type_label || getRoomTypeLabel(selectedDetailRoom.room_type) }}</p>
            </div>
            <button @click="showDetailModal = false" class="w-9 h-9 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 font-bold flex items-center justify-center transition">✕</button>
          </div>

          <!-- Price & Summary Badge -->
          <div class="bg-gradient-to-r from-indigo-900 to-indigo-700 rounded-2xl p-5 text-white flex items-center justify-between shadow-lg">
            <div>
              <span class="text-xs font-medium text-indigo-200 uppercase tracking-wider block">Giá thuê niêm yết</span>
              <div class="text-2xl md:text-3xl font-black font-mono mt-0.5">{{ formatCurrency(selectedDetailRoom.price) }} <span class="text-xs font-normal text-indigo-200">/tháng</span></div>
            </div>
            <div class="text-right">
              <span class="text-xs font-medium text-indigo-200 block">Diện tích</span>
              <span class="text-xl font-bold font-mono">{{ selectedDetailRoom.area || 45 }} m²</span>
            </div>
          </div>

          <!-- Detailed Specs Grid -->
          <div class="space-y-3">
            <h3 class="text-xs font-extrabold text-slate-700 uppercase tracking-wider">📐 Cấu Trúc Layout & Không Gian</h3>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
              <div class="bg-slate-50 p-3 rounded-2xl border border-slate-200/80 text-center">
                <span class="text-lg block">🛏️</span>
                <span class="font-bold text-slate-800 text-sm font-mono block mt-1">{{ selectedDetailRoom.bedrooms_count || 1 }}</span>
                <span class="text-[10px] text-slate-500 uppercase font-semibold">Phòng Ngủ</span>
              </div>
              <div class="bg-slate-50 p-3 rounded-2xl border border-slate-200/80 text-center">
                <span class="text-lg block">🛋️</span>
                <span class="font-bold text-slate-800 text-sm font-mono block mt-1">{{ selectedDetailRoom.living_rooms_count || 0 }}</span>
                <span class="text-[10px] text-slate-500 uppercase font-semibold">Phòng Khách</span>
              </div>
              <div class="bg-slate-50 p-3 rounded-2xl border border-slate-200/80 text-center">
                <span class="text-lg block">🚿</span>
                <span class="font-bold text-slate-800 text-sm font-mono block mt-1">{{ selectedDetailRoom.bathrooms_count || 1 }}</span>
                <span class="text-[10px] text-slate-500 uppercase font-semibold">Nhà Vệ Sinh</span>
              </div>
              <div class="bg-slate-50 p-3 rounded-2xl border border-slate-200/80 text-center">
                <span class="text-lg block">🍳</span>
                <span class="font-bold text-slate-800 text-sm font-mono block mt-1">{{ selectedDetailRoom.kitchens_count || 1 }}</span>
                <span class="text-[10px] text-slate-500 uppercase font-semibold">Khu Bếp</span>
              </div>
            </div>
          </div>

          <!-- Extra Amenities & Features Badges -->
          <div class="space-y-2">
            <h3 class="text-xs font-extrabold text-slate-700 uppercase tracking-wider">✨ Đặc Điểm & Tiện Ích Đi Kèm</h3>
            <div class="flex flex-wrap gap-2 text-xs font-semibold">
              <span class="px-3 py-1.5 bg-slate-100 text-slate-700 rounded-xl border border-slate-200 flex items-center gap-1">
                {{ getFurnishedLabel(selectedDetailRoom.furnished_status) }}
              </span>
              <span v-if="selectedDetailRoom.has_balcony" class="px-3 py-1.5 bg-emerald-50 text-emerald-700 rounded-xl border border-emerald-200 flex items-center gap-1">
                🌅 Có Ban Công Thông Thoáng
              </span>
              <span v-if="selectedDetailRoom.is_mezzanine" class="px-3 py-1.5 bg-purple-50 text-purple-700 rounded-xl border border-purple-200 flex items-center gap-1">
                🏠 Có Gác Lửng Tối Ưu Diện Tích
              </span>
              <span v-if="!selectedDetailRoom.is_shared_bathroom" class="px-3 py-1.5 bg-blue-50 text-blue-700 rounded-xl border border-blue-200 flex items-center gap-1">
                🚽 Nhà Vệ Sinh Khép Kín Riêng
              </span>
              <span class="px-3 py-1.5 bg-amber-50 text-amber-700 rounded-xl border border-amber-200 flex items-center gap-1">
                🔑 Khóa Vân Tay / Giờ Giấc Tự Do
              </span>
            </div>
          </div>

          <!-- Maintenance History & Cost Analysis (Issue #11) -->
          <div class="bg-rose-50/60 p-4 rounded-2xl border border-rose-100 space-y-3">
            <div class="flex items-center justify-between">
              <h3 class="font-extrabold text-rose-900 text-xs uppercase tracking-wider flex items-center gap-1.5">
                <span>🔧</span> <span>Lịch Sử & Chi Phí Bảo Trì Phòng</span>
              </h3>
              <span class="text-xs font-mono font-black text-rose-700 bg-rose-100 px-2 py-0.5 rounded-lg">
                Tổng chi phí: {{ formatCurrency(dataStore.getRoomMaintenanceCost(selectedDetailRoom.id)) }}
              </span>
            </div>

            <div v-if="dataStore.getRoomMaintenanceHistory(selectedDetailRoom.id).length" class="space-y-2 max-h-36 overflow-y-auto pr-1">
              <div
                v-for="item in dataStore.getRoomMaintenanceHistory(selectedDetailRoom.id)"
                :key="item.id"
                class="bg-white p-2.5 rounded-xl border border-rose-100 flex items-center justify-between text-xs"
              >
                <div>
                  <strong class="text-slate-900 block text-[11px]">{{ item.title }}</strong>
                  <small class="text-slate-400 font-mono">{{ item.createdDate || item.created_at }} • {{ item.status }}</small>
                </div>
                <span class="font-mono font-bold text-rose-600">{{ formatCurrency(item.cost) }}</span>
              </div>
            </div>
            <p v-else class="text-[11px] text-slate-500 italic">Phòng này chưa có lịch sử sửa chữa hoặc phát sinh chi phí bảo trì.</p>
          </div>

          <!-- Utility Standard Pricing -->
          <div class="bg-indigo-50/60 p-4 rounded-2xl border border-indigo-100 space-y-2 text-xs">
            <h3 class="font-extrabold text-indigo-900 uppercase tracking-wider flex items-center gap-1.5">
              <span>⚡</span> <span>Biểu Phí Điện Nước Dịch Vụ Chuẩn</span>
            </h3>
            <div class="grid grid-cols-2 sm:grid-cols-3 gap-2 text-[11px] text-slate-700 font-medium pt-1">
              <div>⚡ Điện: <strong>3.500đ / kWh</strong></div>
              <div>💧 Nước: <strong>100.000đ / người</strong></div>
              <div>📶 Wifi & Rác: <strong>Miễn phí</strong></div>
            </div>
          </div>

          <!-- Modal Actions -->
          <div class="flex items-center justify-between border-t border-slate-100 pt-4">
            <button
              @click="openModal(selectedDetailRoom); showDetailModal = false"
              class="px-4 py-2.5 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 font-bold text-xs rounded-xl transition flex items-center gap-1.5"
            >
              <span>⚙️</span> <span>Chỉnh Sửa Layout</span>
            </button>
            <button
              @click="showDetailModal = false"
              class="px-6 py-2.5 bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs rounded-xl shadow-md transition"
            >
              Đóng
            </button>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import { useDataStore } from '../stores/data'
import { useToastStore } from '../stores/toast'

import { useAuthStore } from '../stores/auth'

const dataStore = useDataStore()
const authStore = useAuthStore()
const toastStore = useToastStore()

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const showModal = ref(false)
const editingRoom = ref(null)
const filterStatus = ref('')
const filterProperty = ref('')
const searchQuery = ref('')
const viewMode = ref('table')
const showDetailModal = ref(false)
const selectedDetailRoom = ref(null)

const rooms = computed(() => {
  const isStaff = authStore.currentUser?.role === 'staff'
  const assignedPropId = authStore.currentUser?.assignedPropertyId
  let list = dataStore.rooms
  if (isStaff && assignedPropId) {
    list = list.filter(r => Number(r.propertyId) === Number(assignedPropId))
  }
  return list.map(r => ({
    ...r,
    propertyId: r.propertyId,
    propertyName: r.propertyName,
    roomNumber: r.roomNumber,
    bedrooms_count: r.bedrooms_count || 1,
    living_rooms_count: r.living_rooms_count || 1,
    bathrooms_count: r.bathrooms_count || 1,
    kitchens_count: r.kitchens_count || 1,
    layout_summary: `${r.area}m² • Tầng ${r.floor} • ${r.renterName ? 'Khách: ' + r.renterName : 'Phòng trống'}`
  }))
})

const properties = computed(() => {
  return dataStore.properties.map(p => ({
    id: p.id,
    name: p.name,
    property_type: 'chung_cu_mini',
    property_type_label: 'Chung cư mini',
    property_type_icon: '🏢'
  }))
})

const openDetailModal = (room) => {
  selectedDetailRoom.value = room
  showDetailModal.value = true
}

const getFurnishedLabel = (status) => {
  switch (status) {
    case 'full_noi_that': return '🛋️ Full Nội Thất Premium'
    case 'co_ban': return '🪑 Nội Thất Cơ Bản'
    case 'nha_tho': return '🧱 Bàn Giao Thô'
    default: return '🛋️ Đầy đủ nội thất'
  }
}

const form = ref({
  propertyId: '',
  propertyName: '',
  roomNumber: '',
  floor: 1,
  area: 30,
  price: 5000000,
  status: 'vacant',
  room_type: 'can_ho_1pn',
  bedrooms_count: 1,
  living_rooms_count: 1,
  bathrooms_count: 1,
  kitchens_count: 1,
  has_balcony: true,
  is_mezzanine: false,
  is_shared_bathroom: false,
  furnished_status: 'full_noi_that'
})

const filteredRooms = computed(() => {
  return rooms.value.filter(r => {
    const matchStatus = !filterStatus.value ||
      r.status === filterStatus.value ||
      (filterStatus.value === 'occupied' && (r.status === 'rented' || r.status === 1)) ||
      (filterStatus.value === 'rented' && (r.status === 'occupied' || r.status === 1))
    const matchProp = !filterProperty.value || String(r.propertyId) === String(filterProperty.value)
    const q = searchQuery.value.toLowerCase()
    const matchQuery = !q || (r.roomNumber || '').toLowerCase().includes(q) || (r.propertyName || '').toLowerCase().includes(q)
    return matchStatus && matchProp && matchQuery
  })
})

const openModal = (room = null) => {
  editingRoom.value = room
  if (room) {
    form.value = {
      ...room,
      propertyId: room.propertyId || room.property_id,
      propertyName: room.propertyName || room.property_name,
      roomNumber: room.roomNumber || room.room_number
    }
  } else {
    const defaultProp = properties.value[0] || {}
    form.value = {
      propertyId: defaultProp.id || 1,
      propertyName: defaultProp.name || '',
      roomNumber: '',
      floor: 1,
      area: 30,
      price: 5000000,
      status: 'vacant',
      room_type: 'can_ho_1pn',
      bedrooms_count: 1,
      living_rooms_count: 1,
      bathrooms_count: 1,
      kitchens_count: 1,
      has_balcony: true,
      is_mezzanine: false,
      is_shared_bathroom: false,
      furnished_status: 'full_noi_that'
    }
  }
  showModal.value = true
}

const onPropertySelect = () => {
  const p = properties.value.find(item => String(item.id) === String(form.value.propertyId))
  if (p) {
    form.value.propertyName = p.name
  }
}

const saveRoom = () => {
  if (editingRoom.value) {
    dataStore.updateRoom(editingRoom.value.id, form.value)
  } else {
    dataStore.addRoom(form.value)
  }
  showModal.value = false
}

const quickUpdateStatus = (room, newStatus) => {
  dataStore.updateRoom(room.id, { status: newStatus })
}

const deleteRoom = (id) => {
  if (!confirm('Bạn có chắc chắn muốn xóa căn hộ/phòng này? (Phòng sẽ được chuyển vào thùng rác)')) return
  dataStore.deleteRoom(id)
}

const formatLayout = (r) => {
  const parts = []
  if (r.bedrooms_count) parts.push(`${r.bedrooms_count} PN`)
  if (r.living_rooms_count) parts.push(`${r.living_rooms_count} PK`)
  if (r.bathrooms_count) parts.push(`${r.bathrooms_count} WC`)
  if (r.area) parts.push(`${r.area}m²`)
  return parts.join(' • ')
}

const getRoomTypeLabel = (type) => {
  switch (type) {
    case 'can_ho_2pn': return 'Căn hộ 2PN + 1PK'
    case 'can_ho_1pn': return 'Căn hộ 1PN'
    case 'can_ho_3pn': return 'Căn hộ 3PN'
    case 'studio': return 'Căn hộ Studio'
    case 'duplex': return 'Căn hộ Duplex'
    case 'nha_nguyen_can': return 'Nhà nguyên căn'
    default: return 'Phòng đơn'
  }
}

const getStatusBadge = (status) => {
  if (status === 'vacant' || status === 0) return 'bg-emerald-100 text-emerald-800'
  if (status === 'occupied' || status === 'rented' || status === 1) return 'bg-rose-100 text-rose-800'
  if (status === 'reserved' || status === 2) return 'bg-amber-100 text-amber-800'
  return 'bg-slate-200 text-slate-700'
}

const getStatusLabel = (status) => {
  if (status === 'vacant' || status === 0) return 'Trống'
  if (status === 'occupied' || status === 'rented' || status === 1) return 'Đang ở'
  if (status === 'reserved' || status === 2) return 'Đã cọc'
  if (status === 'maintenance') return 'Bảo trì'
  return 'Khác'
}

const loadData = () => {
  toastStore.success('Đã tải lại danh sách căn hộ & phòng!')
}

onMounted(() => {
  loadData()
})
</script>
