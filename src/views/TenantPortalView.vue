<template>
  <div class="max-w-4xl mx-auto space-y-6 p-4 sm:p-6">
    <!-- Header banner -->
    <div class="bg-gradient-to-r from-teal-900/80 via-slate-800 to-indigo-900/80 p-6 rounded-3xl border border-teal-500/30 shadow-2xl backdrop-blur relative overflow-hidden">
      <div class="absolute -right-10 -bottom-10 w-48 h-48 bg-emerald-500/10 rounded-full blur-3xl"></div>
      <div class="relative z-10 flex justify-between items-center">
        <div>
          <span class="px-3 py-1 bg-emerald-500/20 text-emerald-400 font-bold text-xs rounded-full border border-emerald-500/30 uppercase tracking-widest">
            Tenant Self-Service Portal
          </span>
          <h1 class="text-3xl font-black text-white mt-2">Xin chào, Nguyễn Văn An 👋</h1>
          <p class="text-xs text-teal-200/80 mt-1">Phòng 102 • Tòa nhà Landmark Residence</p>
        </div>

        <div class="text-right">
          <p class="text-xs text-slate-400">Trạng thái thuê</p>
          <span class="px-3 py-1 bg-emerald-500 text-slate-950 font-black text-xs rounded-full shadow-lg">
            Hợp Đồng Đang Hiệu Lực
          </span>
        </div>
      </div>
    </div>

    <!-- Active Bill Alert Card -->
    <div class="bg-slate-800/90 rounded-2xl border border-amber-500/40 p-6 shadow-xl relative overflow-hidden">
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <div class="flex items-center space-x-2">
            <span class="w-3 h-3 bg-amber-400 rounded-full animate-ping"></span>
            <h3 class="text-lg font-bold text-white">Hóa Đơn Tháng 07/2026 Cần Thanh Toán</h3>
          </div>
          <p class="text-xs text-slate-400 mt-1">Mã hóa đơn: <span class="text-amber-400 font-mono">HD2026-07-102</span> • Hạn thanh toán: 05/08/2026</p>
          <p class="text-2xl font-black text-emerald-400 mt-2">3.850.000 ₫</p>
        </div>

        <button
          @click="showPayQr = true"
          class="px-6 py-3 bg-gradient-to-r from-emerald-400 to-teal-500 hover:from-emerald-500 hover:to-teal-600 font-black text-slate-950 rounded-2xl shadow-xl transition flex items-center space-x-2"
        >
          <span>📱 Quét VietQR Thanh Toán Ngay</span>
        </button>
      </div>
    </div>

    <!-- Service Tabs -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg">
        <h4 class="font-bold text-teal-300 text-sm mb-2">📋 Chi Tiết Tiền Điện / Nước</h4>
        <div class="space-y-2 text-xs text-slate-300">
          <div class="flex justify-between">
            <span>Điện (Cũ: 120, Mới: 185):</span>
            <span class="font-mono text-emerald-400">65 kWh x 3.500₫</span>
          </div>
          <div class="flex justify-between">
            <span>Nước (Cũ: 45, Mới: 52):</span>
            <span class="font-mono text-emerald-400">7 m³ x 12.000₫</span>
          </div>
          <div class="flex justify-between">
            <span>Dịch vụ (Vệ sinh, Wifi):</span>
            <span class="font-mono text-emerald-400">150.000 ₫</span>
          </div>
        </div>
      </div>

      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg">
        <h4 class="font-bold text-amber-300 text-sm mb-2">✍️ Hợp Đồng & Chữ Ký Số</h4>
        <p class="text-xs text-slate-400">Thời hạn: 01/01/2026 - 31/12/2026</p>
        <p class="text-xs text-slate-400 mt-1">Tiền cọc giữ chỗ: <span class="text-emerald-400 font-bold">3.500.000 ₫</span></p>

        <button @click="showSignModal = true" class="mt-3 px-3 py-1.5 bg-slate-700 hover:bg-slate-600 text-amber-400 font-bold text-xs rounded-xl border border-amber-500/30 transition">
          ✍️ Ký Tên Điện Tử
        </button>
      </div>

      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg">
        <h4 class="font-bold text-rose-300 text-sm mb-2">🛠️ Gửi Yêu Cầu Báo Hỏng</h4>
        <p class="text-xs text-slate-400 mb-3">Gửi ticket sự cố thiết bị (điều hòa, đường nước) cho Ban quản lý.</p>
        <button @click="alert('Tạo ticket sự cố thành công! Ban quản lý sẽ liên hệ sửa chữa.')" class="px-3 py-1.5 bg-rose-500/20 hover:bg-rose-500/30 text-rose-300 font-bold text-xs rounded-xl border border-rose-500/40 transition">
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
</template>

<script setup>
import { ref } from 'vue'
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
