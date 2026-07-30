<template>
  <AppLayout>
    <div class="space-y-6 animate-slide-up">
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
          <p class="text-2xl font-black text-emerald-700 mt-2 font-mono">{{ formatCurrency(paidAmount) }}</p>
          <p class="text-[11px] text-emerald-600 font-semibold mt-1">Đã thu tiền</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
          <div class="text-xs font-bold uppercase text-rose-600 flex items-center justify-between">
            <span>Chưa Thanh Toán / Nợ</span>
            <span>⏳</span>
          </div>
          <p class="text-2xl font-black text-rose-700 mt-2 font-mono">{{ formatCurrency(unpaidAmount) }}</p>
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
              :src="selectedQRBill.vietqr_url"
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
              <strong class="text-slate-900">{{ selectedQRBill.bank_code || 'MB' }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-500 font-sans">Số tài khoản:</span>
              <strong class="text-indigo-600">{{ selectedQRBill.bank_account || '0901234567' }}</strong>
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
import { ref, computed, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import PrintInvoiceModal from '../components/PrintInvoiceModal.vue'
import api from '../services/api'
import { useToastStore } from '../stores/toast'

const toast = useToastStore()
const bills = ref([])
const rooms = ref([])
const loading = ref(false)
const submitting = ref(false)
const submittingBatch = ref(false)
const submittingPay = ref(false)

const showCreateModal = ref(false)
const showBatchModal = ref(false)
const payModalBill = ref(null)
const selectedQRBill = ref(null)
const selectedPrintBill = ref(null)

const searchQuery = ref('')
const statusFilter = ref('all')

const form = ref({
  room_id: '',
  billing_month: new Date().toISOString().slice(0, 7),
  room_fee: null,
  utility_fee: null,
  service_fee: 150000,
  due_date: ''
})

const batchForm = ref({
  billing_month: new Date().toISOString().slice(0, 7),
  service_fee: 150000
})

const payForm = ref({
  payment_method: 'bank_transfer',
  note: 'Xác nhận thu tiền qua ngân hàng'
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

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

const loadBills = async () => {
  loading.value = true
  try {
    const [resBills, resRooms] = await Promise.all([
      api.get('/monthly_bills'),
      api.get('/rooms')
    ])
    bills.value = resBills?.data || []
    rooms.value = resRooms?.data || []
  } catch (err) {
    console.warn('Error loading bills:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadBills)

const totalBilledAmount = computed(() => bills.value.reduce((acc, b) => acc + Number(b.total_amount || 0), 0))
const paidCount = computed(() => bills.value.filter(b => b.status === 'paid' || b.status === 3).length)
const totalPaidAmount = computed(() => bills.value.filter(b => b.status === 'paid' || b.status === 3).reduce((acc, b) => acc + Number(b.total_amount || 0), 0))
const pendingCount = computed(() => bills.value.filter(b => b.status !== 'paid' && b.status !== 3).length)
const totalPendingAmount = computed(() => bills.value.filter(b => b.status !== 'paid' && b.status !== 3).reduce((acc, b) => acc + Number(b.total_amount || 0), 0))

const filteredBills = computed(() => {
  return bills.value.filter(b => {
    // Status filter
    if (statusFilter.value === 'paid' && (b.status !== 'paid' && b.status !== 3)) return false
    if (statusFilter.value === 'pending' && (b.status === 'paid' || b.status === 3)) return false

    // Search query
    if (!searchQuery.value) return true
    const q = searchQuery.value.toLowerCase()
    return String(b.bill_code).toLowerCase().includes(q) ||
           String(b.billing_month).toLowerCase().includes(q) ||
           String(b.room_number).toLowerCase().includes(q)
  })
})

const generateBill = async () => {
  submitting.value = true
  try {
    await api.post('/monthly_bills/generate', { monthly_bill: form.value })
    toast.success('Sinh hóa đơn phòng thành công!')
    showCreateModal.value = false
    loadBills()
  } catch (err) {
    toast.error(err?.message || 'Có lỗi xảy ra khi tạo hóa đơn')
  } finally {
    submitting.value = false
  }
}

const runBatchGenerate = async () => {
  submittingBatch.value = true
  try {
    const res = await api.post('/monthly_bills/batch_generate', batchForm.value)
    toast.success(res?.message || 'Đã sinh hóa đơn hàng loạt thành công!')
    showBatchModal.value = false
    loadBills()
  } catch (err) {
    toast.error(err?.message || 'Sinh hóa đơn hàng loạt thất bại')
  } finally {
    submittingBatch.value = false
  }
}

const openPayModal = (bill) => {
  payModalBill.value = bill
  payForm.value.note = `Xác nhận thu tiền hóa đơn ${bill.bill_code}`
}

const confirmMarkAsPaid = async () => {
  if (!payModalBill.value) return
  submittingPay.value = true
  try {
    const res = await api.post(`/monthly_bills/${payModalBill.value.id}/mark_as_paid`, payForm.value)
    toast.success(res?.message || 'Đã xác nhận thanh toán thành công!')
    payModalBill.value = null
    loadBills()
  } catch (err) {
    toast.error(err?.message || 'Không thể xác nhận thanh toán')
  } finally {
    submittingPay.value = false
  }
}

const openQRModal = (bill) => {
  selectedQRBill.value = bill
}

const submittingBatchReminder = ref(false)

const sendDebtReminder = async (billId) => {
  try {
    const res = await api.post('/notifications/send_reminder', { bill_id: billId, channel: 'zns' })
    toast.success(res?.message || 'Đã gửi tin nhắn nhắc nợ thành công!')
  } catch (err) {
    toast.error(err?.message || 'Gửi nhắc nợ thất bại')
  }
}

const sendBatchDebtReminders = async () => {
  if (!confirm('Bạn có chắc muốn gửi tin nhắn ZNS/SMS nhắc nợ cho TẤT CẢ các phòng chưa nộp tiền?')) return
  submittingBatchReminder.value = true
  try {
    const res = await api.post('/notifications/send_batch_reminders', { billing_month: new Date().toISOString().slice(0, 7) })
    toast.success(res?.message || 'Đã gửi tin nhắn nhắc nợ hàng loạt thành công!')
  } catch (err) {
    toast.error(err?.message || 'Có lỗi xảy ra khi gửi tin nhắn hàng loạt')
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
    `Phòng ${b.room_number || b.room_id}`,
    b.billing_month,
    b.room_fee || b.total_amount,
    b.utility_fee || 0,
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

const deleteBill = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa hóa đơn này?')) return
  try {
    await api.delete(`/monthly_bills/${id}`)
    loadBills()
  } catch (err) {
    alert(err?.message || 'Không thể xóa hóa đơn')
  }
}
</script>
