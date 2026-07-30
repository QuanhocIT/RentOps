<template>
  <AppLayout>
    <div class="owner-page space-y-6 animate-slide-up">
      <!-- Title & Actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 bg-indigo-100 text-indigo-800 font-extrabold text-xs rounded-lg uppercase tracking-wider">Hóa Đơn & Thanh Toán</span>
            <span class="text-xs text-slate-400 font-medium">• RentOps Workspace</span>
          </div>
          <h1 class="text-2xl font-black text-slate-900 mt-1">Quản Lý Hóa Đơn & VietQR</h1>
          <p class="text-slate-500 text-sm mt-0.5">Tạo hóa đơn tháng, tự động tính tiền phòng + điện nước và xuất mã VietQR thanh toán</p>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <button
            @click="sendBatchDebtReminders"
            :disabled="submittingBatchReminder"
            class="px-3.5 py-2.5 bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>📩</span>
            <span>{{ submittingBatchReminder ? 'Đang gửi...' : 'Nhắc nợ 1-Click' }}</span>
          </button>

          <button
            @click="exportCSV"
            class="px-3.5 py-2.5 bg-emerald-700 hover:bg-emerald-600 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>📥</span>
            <span>Xuất CSV</span>
          </button>

          <button
            @click="showBatchModal = true"
            class="px-4 py-2.5 bg-purple-600 hover:bg-purple-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>⚡</span>
            <span>Sinh hàng loạt</span>
          </button>

          <button
            @click="showCreateModal = true"
            class="px-4 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center gap-1.5"
          >
            <span>✨</span>
            <span>Sinh 1 phòng</span>
          </button>
        </div>
      </div>

      <!-- Financial Statistics Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-slate-400 flex items-center justify-between">
            <span>Tổng Hóa Đơn</span>
            <span>📄</span>
          </div>
          <p class="text-2xl font-black text-slate-900 mt-2 font-mono">{{ bills.length }}</p>
          <p class="text-[11px] text-slate-400 font-medium mt-1">Tổng: {{ formatCurrency(totalBilledAmount) }}</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-emerald-600 flex items-center justify-between">
            <span>Đã Thanh Toán</span>
            <span>✅</span>
          </div>
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ formatCurrency(totalPaidAmount) }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Đã thu tiền</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Chưa Thanh Toán / Nợ</span>
            <span>⏳</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ formatCurrency(totalPendingAmount) }}</p>
          <p class="text-[11px] text-rose-600 font-semibold mt-1">Cần thu tiền</p>
        </div>
      </div>

      <!-- Bills List Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <!-- Filter status tabs -->
          <div class="flex items-center gap-2">
            <button
              @click="statusFilter = 'all'"
              :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition', statusFilter === 'all' ? 'bg-slate-900 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']"
            >
              Tất cả ({{ bills.length }})
            </button>
            <button
              @click="statusFilter = 'pending'"
              :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition', statusFilter === 'pending' ? 'bg-rose-600 text-white' : 'bg-rose-50 text-rose-700 hover:bg-rose-100']"
            >
              Chưa trả ({{ pendingCount }})
            </button>
            <button
              @click="statusFilter = 'paid'"
              :class="['px-3 py-1.5 rounded-xl text-xs font-bold transition', statusFilter === 'paid' ? 'bg-emerald-600 text-white' : 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100']"
            >
              Đã trả ({{ paidCount }})
            </button>
          </div>

          <div class="flex items-center gap-3">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Tìm theo mã hoặc tháng..."
              class="w-64 px-3.5 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button @click="loadBills" class="p-2 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200" title="Tải lại">
              🔄
            </button>
          </div>
        </div>

        <div v-if="loading" class="p-8 text-center text-slate-500">
          Đang tải danh sách hóa đơn...
        </div>

        <div v-else-if="filteredBills.length === 0" class="p-12 text-center text-slate-500">
          Chưa có hóa đơn nào phù hợp.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-600">
            <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-xs border-b border-slate-200">
              <tr>
                <th class="px-6 py-4">Mã Hóa Đơn</th>
                <th class="px-6 py-4">Phòng</th>
                <th class="px-6 py-4">Kỳ Tháng</th>
                <th class="px-6 py-4">Tiền Phòng</th>
                <th class="px-6 py-4">Điện Nước</th>
                <th class="px-6 py-4">Tổng Tiền</th>
                <th class="px-6 py-4">Trạng Thái</th>
                <th class="px-6 py-4 text-right">Thao Tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="b in filteredBills" :key="b.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-mono font-bold text-indigo-600">
                  {{ b.bill_code }}
                </td>
                <td class="px-6 py-4 font-bold text-slate-900">
                  Phòng {{ b.room_number || b.room_id }}
                </td>
                <td class="px-6 py-4 text-slate-500">{{ b.billing_month }}</td>
                <td class="px-6 py-4 font-mono">{{ formatCurrency(b.room_fee || b.total_amount) }}</td>
                <td class="px-6 py-4 font-mono text-amber-600">{{ formatCurrency(b.utility_fee || 0) }}</td>
                <td class="px-6 py-4 font-mono font-bold text-slate-900 text-base">
                  {{ formatCurrency(b.total_amount) }}
                </td>
                <td class="px-6 py-4">
                  <span :class="['px-2.5 py-1 rounded-full text-xs font-bold uppercase', getStatusBadge(b.status)]">
                    {{ getStatusLabel(b.status) }}
                  </span>
                </td>
                <td class="px-6 py-4 text-right flex items-center justify-end gap-2">
                  <button
                    v-if="b.status !== 'paid' && b.status !== 3"
                    @click="openPayModal(b)"
                    class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-emerald-600 text-white font-semibold rounded-lg text-xs hover:bg-emerald-700 shadow-sm transition"
                    title="Xác nhận khách đã thanh toán"
                  >
                    <span>💰</span> Đã thu tiền
                  </button>

                  <button
                    v-if="b.status !== 'paid' && b.status !== 3"
                    @click="sendDebtReminder(b.id)"
                    class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-amber-50 text-amber-800 font-semibold rounded-lg text-xs hover:bg-amber-100 border border-amber-200 transition"
                    title="Gửi tin nhắn ZNS nhắc nợ"
                  >
                    <span>📩</span> Nhắc nợ ZNS
                  </button>
                  <a
                    v-if="b.status !== 'paid' && getRenterPhone(b.renterId)"
                    :href="`https://zalo.me/${getRenterPhone(b.renterId).replace(/[^0-9]/g, '')}`"
                    target="_blank"
                    rel="noopener"
                    class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-blue-50 text-blue-800 font-semibold rounded-lg text-xs hover:bg-blue-100 border border-blue-200 transition"
                    title="Nhắn Zalo trực tiếp cho khách"
                  >
                    💬 Zalo
                  </a>
                  <a
                    v-if="b.status !== 'paid' && getRenterPhone(b.renterId)"
                    :href="`tel:${getRenterPhone(b.renterId)}`"
                    class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-emerald-50 text-emerald-800 font-semibold rounded-lg text-xs hover:bg-emerald-100 border border-emerald-200 transition"
                    title="Gọi ngay cho khách thuê"
                  >
                    📞 Gọi
                  </a>
                  <button
                    @click="selectedPrintBill = b"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-slate-100 text-slate-800 font-semibold rounded-lg text-xs hover:bg-slate-200 border border-slate-300 transition"
                  >
                    <span>🖨️</span> In A4
                  </button>
                  <button
                    @click="openQRModal(b)"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-indigo-50 text-indigo-700 font-semibold rounded-lg text-xs hover:bg-indigo-100 border border-indigo-200 transition"
                  >
                    <span>📱</span> VietQR
                  </button>
                  <button
                    @click="deleteBill(b.id)"
                    class="text-xs font-semibold text-rose-600 hover:text-rose-800 bg-rose-50 px-2.5 py-1.5 rounded-lg hover:bg-rose-100 transition"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Batch Bill Generation Modal -->
      <div v-if="showBatchModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <div>
              <h3 class="text-lg font-bold text-slate-900">⚡ Sinh Hóa Đơn Hàng Loạt</h3>
              <p class="text-xs text-slate-500 mt-0.5">Tự động quét tất cả các phòng đang có hợp đồng hoạt động</p>
            </div>
            <button @click="showBatchModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="runBatchGenerate" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Kỳ tháng sinh hóa đơn</label>
              <input
                v-model="batchForm.billing_month"
                type="month"
                required
                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-purple-500 font-bold"
              />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Phí dịch vụ mặc định (VNĐ)</label>
              <input
                v-model.number="batchForm.service_fee"
                type="number"
                placeholder="150000"
                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
              />
              <p class="text-xs text-slate-400 mt-1">Bao gồm vệ sinh, wifi, rác chung...</p>
            </div>

            <div class="bg-purple-50 p-4 rounded-xl border border-purple-100 text-xs text-purple-800 space-y-1">
              <div class="font-bold text-sm text-purple-900">ℹ️ Cách thức hoạt động:</div>
              <div>• Tiền phòng tự động lấy từ Hợp Đồng của từng phòng.</div>
              <div>• Tiền Điện/Nước tự động tính theo Chỉ số đã ghi trong tháng.</div>
              <div>• Bỏ qua các phòng đã được tạo hóa đơn trong tháng này.</div>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="showBatchModal = false"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submittingBatch"
                class="px-5 py-2 bg-purple-600 text-white font-semibold rounded-xl hover:bg-purple-700 text-sm shadow-md shadow-purple-600/30"
              >
                {{ submittingBatch ? 'Đang tự động sinh...' : '🚀 Bắt đầu sinh ngay' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Mark Paid Modal -->
      <div v-if="payModalBill" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Xác Nhận Đã Thu Tiền</h3>
            <button @click="payModalBill = null" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <div class="bg-emerald-50 border border-emerald-200 rounded-xl p-4 text-emerald-900 space-y-1">
            <div class="text-xs font-semibold uppercase text-emerald-700">Hóa đơn: {{ payModalBill.bill_code }}</div>
            <div class="text-xl font-black">{{ formatCurrency(payModalBill.total_amount) }}</div>
            <div class="text-xs text-emerald-700">Phòng {{ payModalBill.room_number }} - Kỳ tháng {{ payModalBill.billing_month }}</div>
          </div>

          <form @submit.prevent="confirmMarkAsPaid" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Hình thức thanh toán</label>
              <select
                v-model="payForm.payment_method"
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
              >
                <option value="cash">💵 Tiền mặt</option>
                <option value="bank_transfer">🏦 Chuyển khoản ngân hàng</option>
                <option value="vietqr">📱 VietQR</option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ghi chú giao dịch</label>
              <input
                v-model="payForm.note"
                type="text"
                placeholder="Ví dụ: Đã nhận chuyển khoản MB"
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
              />
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="payModalBill = null"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submittingPay"
                class="px-5 py-2 bg-emerald-600 text-white font-semibold rounded-xl hover:bg-emerald-700 text-sm shadow-md shadow-emerald-600/30"
              >
                {{ submittingPay ? 'Đang lưu...' : '✅ Hoàn tất thu tiền' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Create Single Bill Modal -->
      <div v-if="showCreateModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5">
          <div class="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 class="text-lg font-bold text-slate-900">Sinh Hóa Đơn Mới</h3>
            <button @click="showCreateModal = false" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="generateBill" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Chọn phòng trọ</label>
              <select
                v-model="form.room_id"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              >
                <option value="" disabled>-- Chọn phòng --</option>
                <option v-for="room in rooms" :key="room.id" :value="room.id">
                  Phòng {{ room.room_number }} (Giá: {{ formatCurrency(room.price) }})
                </option>
              </select>
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Kỳ tháng (YYYY-MM)</label>
              <input
                v-model="form.billing_month"
                type="month"
                required
                class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-indigo-500"
              />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Tiền phòng (VNĐ)</label>
                <input
                  v-model.number="form.room_fee"
                  type="number"
                  placeholder="Để trống tự lấy giá phòng"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-amber-700 uppercase mb-1">Tiền Điện Nước (VNĐ)</label>
                <input
                  v-model.number="form.utility_fee"
                  type="number"
                  placeholder="Ví dụ: 500000"
                  class="w-full px-3 py-2 bg-amber-50/50 border border-amber-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Phụ phí / Dịch vụ khác</label>
                <input
                  v-model.number="form.service_fee"
                  type="number"
                  placeholder="150000"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Hạn thanh toán</label>
                <input
                  v-model="form.due_date"
                  type="date"
                  class="w-full px-3 py-2 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
                />
              </div>
            </div>

            <div class="flex justify-end gap-3 pt-3">
              <button
                type="button"
                @click="showCreateModal = false"
                class="px-4 py-2 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
              >
                Hủy
              </button>
              <button
                type="submit"
                :disabled="submitting"
                class="px-5 py-2 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 text-sm shadow-md shadow-indigo-600/30"
              >
                {{ submitting ? 'Đang tạo...' : 'Sinh hóa đơn' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- VietQR Modal -->
      <div v-if="selectedQRBill" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl text-center space-y-5 relative">
          <button @click="selectedQRBill = null" class="absolute top-4 right-4 text-slate-400 hover:text-slate-700 text-lg font-bold">✕</button>

          <div>
            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 uppercase tracking-wider mb-2">
              Mã Thanh Toán VietQR
            </span>
            <h3 class="text-xl font-black text-slate-900">Hóa Đơn {{ selectedQRBill.bill_code }}</h3>
            <p class="text-sm text-slate-500 mt-0.5">Phòng {{ selectedQRBill.room_number }} - Kỳ tháng {{ selectedQRBill.billing_month }}</p>
          </div>

          <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 inline-block shadow-inner">
            <img
              :src="getVietQrUrl(selectedQRBill)"
              alt="Mã VietQR"
              class="w-64 h-64 mx-auto object-contain rounded-xl"
            />
          </div>

          <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 text-left space-y-2 text-sm font-mono">
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Số tiền:</span>
              <strong class="text-lg text-emerald-600 font-black">{{ formatCurrency(selectedQRBill.total_amount) }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Ngân hàng:</span>
              <strong class="text-slate-900">{{ selectedQRBill.bank_code || 'MBBank' }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Số tài khoản:</span>
              <strong class="text-indigo-600">{{ dataStore.settings.accountNumber || '0908123456' }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Nội dung:</span>
              <strong class="text-slate-900 bg-amber-100 px-2 py-0.5 rounded text-xs">{{ selectedQRBill.bill_code }}</strong>
            </div>
          </div>

          <button
            @click="selectedQRBill = null"
            class="w-full py-3 bg-slate-900 text-white rounded-xl font-bold text-sm hover:bg-slate-800 transition"
          >
            Đóng
          </button>
        </div>
      </div>

      <!-- Print Modal -->
      <PrintInvoiceModal
        v-if="selectedPrintBill"
        :bill="selectedPrintBill"
        @close="selectedPrintBill = null"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import PaymentQrModal from '../components/PaymentQrModal.vue'
import PrintInvoiceModal from '../components/PrintInvoiceModal.vue'
import { useDataStore } from '../stores/data'
import { useToastStore } from '../stores/toast'

const dataStore = useDataStore()
const toast = useToastStore()

const loading = ref(false)
const submitting = ref(false)
const submittingBatch = ref(false)
const submittingPay = ref(false)

const searchQuery = ref('')
const statusFilter = ref('all')

const showCreateModal = ref(false)
const showBatchModal = ref(false)
const payModalBill = ref(null)
const selectedQRBill = ref(null)
const selectedPrintBill = ref(null)

const form = ref({
  room_id: '',
  billing_month: '07/2026',
  room_fee: null,
  utility_fee: null,
  service_fee: 150000,
  due_date: '2026-08-05'
})

const batchForm = ref({
  billing_month: '07/2026',
  service_fee: 150000
})

const payForm = ref({
  payment_method: 'VietQR / Chuyển khoản MBBank',
  note: 'Xác nhận thu tiền chuyển khoản qua VietQR'
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const getRenterPhone = (renterId) => {
  const renter = dataStore.renters.find(r => r.id === Number(renterId) || r.id === renterId)
  return renter ? (renter.phone || renter.phoneNumber || '') : ''
}

const rooms = computed(() => dataStore.rooms)

const bills = computed(() => {
  return dataStore.bills.map(b => ({
    ...b,
    bill_code: b.code,
    billing_month: b.month,
    room_number: b.roomNumber,
    room_fee: b.roomPrice,
    utility_fee: (b.electricCost || 0) + (b.waterCost || 0),
    total_amount: b.totalAmount
  }))
})

const getStatusBadge = (status) => {
  if (status === 'paid' || status === 3) return 'bg-emerald-100 text-emerald-800 border border-emerald-200'
  if (status === 'partially_paid' || status === 2) return 'bg-amber-100 text-amber-800 border border-amber-200'
  if (status === 'overdue' || status === 4) return 'bg-rose-100 text-rose-800 border border-rose-200'
  return 'bg-blue-100 text-blue-800 border border-blue-200'
}

const getStatusLabel = (status) => {
  if (status === 'paid' || status === 3) return 'Đã Trả'
  if (status === 'partially_paid' || status === 2) return 'Trả 1 phần'
  if (status === 'overdue' || status === 4) return 'Quá Hạn'
  return 'Chưa Trả'
}

const totalBilledAmount = computed(() => bills.value.reduce((acc, b) => acc + Number(b.total_amount || 0), 0))
const paidCount = computed(() => bills.value.filter(b => b.status === 'paid').length)
const totalPaidAmount = computed(() => bills.value.filter(b => b.status === 'paid').reduce((acc, b) => acc + Number(b.total_amount || 0), 0))
const pendingCount = computed(() => bills.value.filter(b => b.status !== 'paid').length)
const totalPendingAmount = computed(() => bills.value.filter(b => b.status !== 'paid').reduce((acc, b) => acc + Number(b.total_amount || 0), 0))

const filteredBills = computed(() => {
  return bills.value.filter(b => {
    if (statusFilter.value === 'paid' && b.status !== 'paid') return false
    if (statusFilter.value === 'pending' && b.status === 'paid') return false

    if (!searchQuery.value) return true
    const q = searchQuery.value.toLowerCase()
    return String(b.bill_code).toLowerCase().includes(q) ||
           String(b.billing_month).toLowerCase().includes(q) ||
           String(b.room_number).toLowerCase().includes(q)
  })
})

const calculateDueDate = (billingMonthStr) => {
  if (!billingMonthStr) {
    const d = new Date()
    d.setDate(d.getDate() + 7)
    return d.toISOString().slice(0, 10)
  }
  let year = new Date().getFullYear()
  let month = new Date().getMonth() + 1
  if (billingMonthStr.includes('-')) {
    const parts = billingMonthStr.split('-')
    if (parts[0].length === 4) {
      year = parseInt(parts[0], 10)
      month = parseInt(parts[1], 10)
    } else {
      month = parseInt(parts[0], 10)
      year = parseInt(parts[1], 10)
    }
  } else if (billingMonthStr.includes('/')) {
    const parts = billingMonthStr.split('/')
    if (parts[0].length === 4) {
      year = parseInt(parts[0], 10)
      month = parseInt(parts[1], 10)
    } else {
      month = parseInt(parts[0], 10)
      year = parseInt(parts[1], 10)
    }
  }
  let nextMonth = month + 1
  let nextYear = year
  if (nextMonth > 12) {
    nextMonth = 1
    nextYear += 1
  }
  return `${nextYear}-${String(nextMonth).padStart(2, '0')}-05`
}

const getRoomUtilityReading = (roomId, monthStr) => {
  return dataStore.utilityReadings.find(u =>
    (u.roomId === roomId || u.room_id === roomId) &&
    (u.month === monthStr || u.billing_month === monthStr)
  )
}

const generateBill = () => {
  const room = dataStore.rooms.find(r => r.id === Number(form.value.room_id))
  if (!room) {
    toast.warning('Vui lòng chọn phòng để sinh hóa đơn.')
    return
  }

  const electricRate = dataStore.settings?.electricRate || 3500
  const waterRate = dataStore.settings?.waterRate || 18000
  const reading = getRoomUtilityReading(room.id, form.value.billing_month)
  const electricUsage = reading ? (reading.electricUsage || Math.max(0, (reading.currElectric || 0) - (reading.prevElectric || 0))) : 0
  const electricCost = reading ? (reading.electricCost || electricUsage * electricRate) : 0
  const waterUsage = reading ? (reading.waterUsage || Math.max(0, (reading.currWater || 0) - (reading.prevWater || 0))) : 0
  const waterCost = reading ? (reading.waterCost || waterUsage * waterRate) : 0

  const roomPrice = Number(form.value.room_fee) || room.price
  const serviceFee = Number(form.value.service_fee) || 100000
  const totalAmount = roomPrice + electricCost + waterCost + serviceFee
  const dueDate = form.value.due_date || calculateDueDate(form.value.billing_month)

  const newBill = {
    id: Date.now(),
    code: `INV-${(form.value.billing_month || '2026-07').replace(/[^0-9]/g, '')}-${room.roomNumber}`,
    month: form.value.billing_month,
    year: new Date().getFullYear(),
    roomId: room.id,
    roomNumber: room.roomNumber,
    renterId: room.renterId,
    renterName: room.renterName || 'Khách thuê',
    propertyId: room.propertyId,
    propertyName: room.propertyName,
    roomPrice,
    electricUsage,
    electricCost,
    waterUsage,
    waterCost,
    serviceFee,
    discount: 0,
    totalAmount,
    paidAmount: 0,
    status: 'unpaid',
    dueDate,
    paidDate: null,
    paymentMethod: '',
    notes: reading ? 'Tiền phòng & điện nước dịch vụ' : 'Tiền phòng & dịch vụ (Chưa có chỉ số điện nước)'
  }

  dataStore.bills.unshift(newBill)
  dataStore.addAuditLog('Sinh hóa đơn', newBill.code, `Sinh hóa đơn cho phòng ${newBill.roomNumber}`)
  dataStore.saveToStorage()

  toast.success(`Đã sinh hóa đơn ${newBill.code} cho phòng ${newBill.roomNumber}!`)
  showCreateModal.value = false
}

const runBatchGenerate = () => {
  submittingBatch.value = true
  try {
    const rentedRooms = dataStore.rooms.filter(r => r.status === 'rented' || r.status === 'occupied' || r.status === 1)
    const monthStr = batchForm.value.billing_month || '2026-07'
    const electricRate = dataStore.settings?.electricRate || 3500
    const waterRate = dataStore.settings?.waterRate || 18000
    let count = 0
    let missingReadingCount = 0

    rentedRooms.forEach(room => {
      const exists = dataStore.bills.some(b => b.roomId === room.id && b.month === monthStr)
      if (!exists) {
        const reading = getRoomUtilityReading(room.id, monthStr)
        if (!reading) missingReadingCount++

        const electricUsage = reading ? (reading.electricUsage || Math.max(0, (reading.currElectric || 0) - (reading.prevElectric || 0))) : 0
        const electricCost = reading ? (reading.electricCost || electricUsage * electricRate) : 0
        const waterUsage = reading ? (reading.waterUsage || Math.max(0, (reading.currWater || 0) - (reading.prevWater || 0))) : 0
        const waterCost = reading ? (reading.waterCost || waterUsage * waterRate) : 0
        const serviceFee = batchForm.value.service_fee || 100000
        const total = room.price + electricCost + waterCost + serviceFee
        const dueDate = calculateDueDate(monthStr)

        dataStore.bills.unshift({
          id: Date.now() + Math.random(),
          code: `INV-${monthStr.replace(/[^0-9]/g, '')}-${room.roomNumber}`,
          month: monthStr,
          year: new Date().getFullYear(),
          roomId: room.id,
          roomNumber: room.roomNumber,
          renterId: room.renterId,
          renterName: room.renterName || 'Khách thuê',
          propertyId: room.propertyId,
          propertyName: room.propertyName,
          roomPrice: room.price,
          electricUsage,
          electricCost,
          waterUsage,
          waterCost,
          serviceFee,
          discount: 0,
          totalAmount: total,
          paidAmount: 0,
          status: 'unpaid',
          dueDate,
          paidDate: null,
          paymentMethod: '',
          notes: reading ? `Hóa đơn hàng loạt tháng ${monthStr}` : `Hóa đơn tháng ${monthStr} (Cần bổ sung điện nước)`
        })
        count++
      }
    })
    dataStore.saveToStorage()
    if (count > 0) {
      if (missingReadingCount > 0) {
        toast.info(`Đã sinh ${count} hóa đơn! (Trong đó ${missingReadingCount} phòng chưa có chỉ số điện nước)`)
      } else {
        toast.success(`Đã sinh hóa đơn hàng loạt thành công cho ${count} phòng!`)
      }
    } else {
      toast.info('Tất cả các phòng đang thuê đều đã có hóa đơn kỳ này.')
    }
    showBatchModal.value = false
  } finally {
    submittingBatch.value = false
  }
}

const openPayModal = (bill) => {
  payModalBill.value = bill
  payForm.value.note = `Xác nhận thu tiền hóa đơn ${bill.bill_code}`
}

const confirmMarkAsPaid = () => {
  if (!payModalBill.value) return
  submittingPay.value = true
  try {
    dataStore.payBill(payModalBill.value.id, payForm.value.payment_method)
    toast.success('Đã xác nhận thu tiền thành công!')
    payModalBill.value = null
  } finally {
    submittingPay.value = false
  }
}

const openQRModal = (bill) => {
  selectedQRBill.value = bill
}

const getVietQrUrl = (bill) => {
  if (!bill) return ''
  const bank = bill.bank_code || dataStore.settings.bankName || 'MB'
  const acc = dataStore.settings.accountNumber || '0908123456'
  const name = dataStore.settings.accountHost || 'NGUYEN VAN MINH'
  const amt = Math.round(bill.total_amount || 0)
  const info = bill.bill_code || ''
  return `https://img.vietqr.io/image/${bank}-${acc}-compact2.png?amount=${amt}&addInfo=${encodeURIComponent(info)}&accountName=${encodeURIComponent(name)}`
}

const loadBills = () => {
  toast.success('Đã tải lại danh sách hóa đơn & đối soát VietQR!')
}

const submittingBatchReminder = ref(false)

const sendDebtReminder = (billId) => {
  const bill = dataStore.bills.find(b => b.id === billId)
  if (bill) {
    dataStore.addNotification('Nhắc nợ ZNS', `Đã gửi thông báo nhắc nợ hóa đơn ${bill.code} tới phòng ${bill.roomNumber}`, 'warning')
    toast.success(`Đã gửi tin nhắn ZNS nhắc nợ tới phòng ${bill.roomNumber}!`)
  }
}

const sendBatchDebtReminders = () => {
  if (!confirm('Bạn có chắc muốn gửi tin nhắn ZNS/SMS nhắc nợ cho TẤT CẢ các phòng chưa nộp tiền?')) return
  submittingBatchReminder.value = true
  try {
    const unpaids = dataStore.bills.filter(b => b.status === 'unpaid' || b.status === 'overdue')
    unpaids.forEach(b => {
      dataStore.addNotification('Nhắc nợ tự động', `Nhắc nợ hóa đơn ${b.code} phòng ${b.roomNumber} (${b.totalAmount.toLocaleString()} đ)`, 'warning')
    })
    toast.success(`Đã gửi tin nhắn nhắc nợ ZNS hàng loạt cho ${unpaids.length} phòng chưa nộp!`)
  } finally {
    submittingBatchReminder.value = false
  }
}

const exportCSV = () => {
  if (!bills.value.length) {
    toast.warning('Không có dữ liệu hóa đơn để xuất file.')
    return
  }

  const headers = ['Mã Hóa Đơn', 'Phòng', 'Kỳ Tháng', 'Tiền Phòng', 'Điện Nước', 'Tổng Tiền', 'Trạng Thái']
  const rows = bills.value.map(b => [
    b.bill_code,
    `Phòng ${b.room_number}`,
    b.billing_month,
    b.room_fee,
    b.utility_fee,
    b.total_amount,
    getStatusLabel(b.status)
  ])

  const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers, ...rows].map(e => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', `HoaDon_RentOps_${new Date().toISOString().slice(0, 10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  toast.success('Đã xuất file CSV thành công!')
}

const deleteBill = (id) => {
  if (!confirm('Bạn có chắc muốn xóa hóa đơn này? Hóa đơn sẽ chuyển vào thùng rác.')) return
  try {
    const bill = dataStore.bills.find(b => b.id === id)
    if (bill) {
      dataStore.trash.unshift({ id: Date.now(), originalType: 'bill', itemData: bill, deletedAt: new Date().toLocaleString() })
      dataStore.bills = dataStore.bills.filter(b => b.id !== id)
      dataStore.saveToStorage()
      toast.success('Xóa hóa đơn thành công!')
    }
  } catch (err) {
    toast.error(err?.message || 'Không thể xóa hóa đơn')
  }
}
</script>
