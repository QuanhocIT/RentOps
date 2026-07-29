<template>
  <AppLayout>
    <div class="max-w-5xl mx-auto space-y-6">
      <!-- Header banner -->
      <div class="bg-gradient-to-r from-indigo-900 via-slate-900 to-blue-900 p-6 rounded-2xl border border-indigo-700/50 shadow-xl text-white relative overflow-hidden">
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div>
            <span class="px-3 py-1 bg-indigo-500/20 text-indigo-300 font-bold text-xs rounded-full border border-indigo-400/30 uppercase tracking-wider">
              Tenant Self-Service Portal
            </span>
            <h1 class="text-2xl font-bold text-white mt-2">Xin chào, Nguyễn Văn An 👋</h1>
            <p class="text-xs text-indigo-200 mt-1">Phòng 102 • Tòa nhà Landmark Residence</p>
          </div>

          <div class="text-right">
            <p class="text-xs text-indigo-300">Trạng thái thuê</p>
            <span class="px-3 py-1 bg-emerald-500 text-white font-bold text-xs rounded-full shadow-sm inline-block mt-1">
              Hợp đồng đang hiệu lực
            </span>
          </div>
        </div>
      </div>

      <!-- Active Bill Alert Card -->
      <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm relative overflow-hidden">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <div class="flex items-center space-x-2">
              <span class="w-3 h-3 bg-amber-500 rounded-full animate-ping"></span>
              <h3 class="text-lg font-bold text-slate-900">Hóa Đơn Tháng 07/2026 Cần Thanh Toán</h3>
            </div>
            <p class="text-xs text-slate-500 mt-1">Mã hóa đơn: <span class="text-indigo-600 font-mono font-bold">HD2026-07-102</span> • Hạn thanh toán: 05/08/2026</p>
            <p class="text-3xl font-black text-slate-900 mt-2 font-mono">3.850.000 ₫</p>
          </div>

          <button
            @click="showPayQr = true"
            class="px-6 py-3 bg-emerald-600 hover:bg-emerald-700 font-bold text-white text-sm rounded-xl shadow-lg shadow-emerald-600/30 transition flex items-center space-x-2"
          >
            <span>📱 Quét VietQR Thanh Toán Ngay</span>
          </button>
        </div>
      </div>

      <!-- Service Tabs -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
          <h4 class="font-bold text-slate-900 text-sm">📋 Chi Tiết Tiền Điện / Nước</h4>
          <div class="space-y-2 text-xs text-slate-600">
            <div class="flex justify-between border-b border-slate-100 pb-1">
              <span>Điện (Cũ: 120, Mới: 185):</span>
              <span class="font-mono text-indigo-600 font-bold">65 kWh x 3.500₫</span>
            </div>
            <div class="flex justify-between border-b border-slate-100 pb-1">
              <span>Nước (Cũ: 45, Mới: 52):</span>
              <span class="font-mono text-indigo-600 font-bold">7 m³ x 12.000₫</span>
            </div>
            <div class="flex justify-between">
              <span>Dịch vụ (Vệ sinh, Wifi):</span>
              <span class="font-mono text-indigo-600 font-bold">150.000 ₫</span>
            </div>
          </div>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
          <h4 class="font-bold text-slate-900 text-sm">✍️ Hợp Đồng & Chữ Ký Số</h4>
          <p class="text-xs text-slate-500">Thời hạn: 01/01/2026 - 31/12/2026</p>
          <p class="text-xs text-slate-500">Tiền cọc giữ chỗ: <span class="text-emerald-600 font-bold font-mono">3.500.000 ₫</span></p>

          <button @click="showSignModal = true" class="w-full py-2 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 font-bold text-xs rounded-xl border border-indigo-200 transition">
            ✍️ Ký Tên Điện Tử
          </button>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
          <h4 class="font-bold text-slate-900 text-sm">🛠️ Gửi Yêu Cầu Báo Hỏng</h4>
          <p class="text-xs text-slate-500">Gửi ticket sự cố thiết bị (điều hòa, đường nước) cho Ban quản lý.</p>
          <button @click="alert('Tạo ticket sự cố thành công! Ban quản lý sẽ liên hệ sửa chữa.')" class="w-full py-2 bg-rose-50 hover:bg-rose-100 text-rose-700 font-bold text-xs rounded-xl border border-rose-200 transition">
            🚨 Báo Hỏng Sự Cố
          </button>
        </div>
      </div>

      <!-- Modals -->
      <PaymentQrModal
        :show="showPayQr"
        :bill="demoBill"
        @close="showPayQr = false"
        @payment-success="handleSuccess"
      />

      <ESignatureModal
        :show="showSignModal"
        @close="showSignModal = false"
        @save="handleSignSave"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import { ref } from 'vue'
import AppLayout from '../components/AppLayout.vue'
import PaymentQrModal from '../components/PaymentQrModal.vue'
import ESignatureModal from '../components/ESignatureModal.vue'

const showPayQr = ref(false)
const showSignModal = ref(false)

const demoBill = ref({
  bill_code: 'HD2026-07-102',
  total_amount: 3850000,
  bank_code: 'MB',
  bank_account: '0901234567',
  bank_account_name: 'RENTOPS DEMO',
  status: 'issued'
})

const handleSuccess = (bill) => {
  alert(`Cảm ơn bạn! Hóa đơn ${bill.bill_code} đã được gạch nợ thanh toán tự động.`)
  showPayQr.value = false
}

const handleSignSave = (signatureUrl) => {
  alert('Đã lưu chữ ký điện tử của bạn vào hợp đồng thành công!')
}
</script>
