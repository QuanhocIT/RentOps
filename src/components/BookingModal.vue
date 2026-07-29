<template>
  <div class="fixed inset-0 z-50 bg-slate-950/85 backdrop-blur-md flex items-center justify-center p-4 overflow-y-auto animate-fade-in">
    <div class="bg-slate-900 border border-slate-700/80 rounded-3xl max-w-xl w-full overflow-hidden shadow-2xl space-y-0 my-8 animate-scale-in">
      <!-- Modal Header -->
      <div class="bg-gradient-to-r from-indigo-900 via-slate-800 to-indigo-950 p-6 relative flex justify-between items-start border-b border-slate-800">
        <div>
          <span class="px-3 py-1 bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 text-xs font-bold rounded-lg uppercase">
            ⚡ Đặt Cọc Giữ Phòng Online 24/7
          </span>
          <h2 class="text-2xl font-black text-white mt-1">Đặt Cọc Phòng {{ room.room_number }}</h2>
          <p class="text-xs text-indigo-300">{{ room.property_name }}</p>
        </div>
        <button @click="$emit('close')" class="w-9 h-9 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-300 flex items-center justify-center font-bold text-lg transition">
          ✕
        </button>
      </div>

      <!-- Modal Body -->
      <div class="p-6 space-y-6 max-h-[75vh] overflow-y-auto">
        <!-- Step 1: Booking Details Form -->
        <div v-if="step === 1" class="space-y-4">
          <div class="bg-slate-800/60 p-4 rounded-2xl border border-slate-700/60 flex justify-between items-center text-xs">
            <div>
              <span class="text-slate-400">Giá thuê niêm yết:</span>
              <div class="text-lg font-black text-emerald-400 font-mono">{{ formatCurrency(room.price) }} / tháng</div>
            </div>
            <div class="text-right">
              <span class="text-slate-400">Tiền cọc gợi ý:</span>
              <div class="text-lg font-black text-amber-400 font-mono">{{ formatCurrency(room.price) }}</div>
            </div>
          </div>

          <div class="space-y-3">
            <div>
              <label class="block text-xs font-bold text-slate-300 uppercase mb-1">Họ và tên người thuê phòng</label>
              <input v-model="form.full_name" required placeholder="Nguyễn Văn A" class="w-full bg-slate-950 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-bold text-slate-300 uppercase mb-1">Số điện thoại liên hệ (nhận VietQR)</label>
              <input v-model="form.phone" required type="tel" placeholder="0988777666" class="w-full bg-slate-950 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-bold text-slate-300 uppercase mb-1">Dự kiến ngày dọn vào ở</label>
              <input v-model="form.move_in_date" required type="date" class="w-full bg-slate-950 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500" />
            </div>

            <div>
              <label class="block text-xs font-bold text-slate-300 uppercase mb-1">Số tiền muốn cọc (VNĐ)</label>
              <select v-model.number="form.deposit_amount" class="w-full bg-slate-950 border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono font-bold">
                <option :value="room.price">Cọc 1 tháng tiền nhà ({{ formatCurrency(room.price) }})</option>
                <option :value="room.price * 2">Cọc 2 tháng tiền nhà ({{ formatCurrency(room.price * 2) }})</option>
                <option :value="1000000">Cọc giữ chỗ trước 1.000.000 VNĐ</option>
                <option :value="2000000">Cọc giữ chỗ trước 2.000.000 VNĐ</option>
              </select>
            </div>
          </div>

          <button
            @click="generateQR"
            :disabled="!form.full_name || !form.phone || !form.move_in_date"
            class="w-full py-3.5 bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 disabled:opacity-50 text-white font-black text-xs rounded-2xl shadow-xl shadow-indigo-600/30 transition flex items-center justify-center space-x-2"
          >
            <span>📱</span> <span>Tạo Mã VietQR Thanh Toán Đặt Cọc</span>
          </button>
        </div>

        <!-- Step 2: VietQR Display & Payment Confirmation -->
        <div v-else-if="step === 2" class="space-y-5 text-center">
          <div class="bg-indigo-950/40 p-4 rounded-2xl border border-indigo-500/30 text-xs text-indigo-300">
            Mã giữ phòng: <strong class="font-mono text-emerald-400 text-sm">{{ bookingCode }}</strong>
            <p class="text-[11px] text-slate-400 mt-0.5">Vui lòng dùng ứng dụng Ngân hàng / ZaloPay / MoMo quét mã bên dưới:</p>
          </div>

          <!-- VietQR Image Container -->
          <div class="bg-white p-4 rounded-2xl inline-block shadow-2xl border-4 border-indigo-500/30 relative group">
            <img :src="vietqrUrl" alt="VietQR Payment Code" class="w-64 h-64 object-contain mx-auto" />
            <span class="block text-[10px] text-slate-500 font-bold mt-2 font-mono uppercase">Hệ Thống Thanh Toán Tự Động NAPAS 24/7</span>
          </div>

          <!-- Bank Details Breakdown -->
          <div class="bg-slate-800/80 p-4 rounded-2xl border border-slate-700 text-xs space-y-2 text-left font-mono">
            <div class="flex justify-between border-b border-slate-700/60 pb-1.5">
              <span class="text-slate-400 font-sans">Ngân hàng thụ hưởng:</span>
              <strong class="text-white">MB Bank (NH Quân Đội)</strong>
            </div>
            <div class="flex justify-between border-b border-slate-700/60 pb-1.5">
              <span class="text-slate-400 font-sans">Số tài khoản:</span>
              <strong class="text-emerald-400">0901234567</strong>
            </div>
            <div class="flex justify-between border-b border-slate-700/60 pb-1.5">
              <span class="text-slate-400 font-sans">Chủ tài khoản:</span>
              <strong class="text-white">RENTOPS SAAS DEMO</strong>
            </div>
            <div class="flex justify-between border-b border-slate-700/60 pb-1.5">
              <span class="text-slate-400 font-sans">Số tiền chuyển cọc:</span>
              <strong class="text-amber-400 text-sm">{{ formatCurrency(form.deposit_amount) }}</strong>
            </div>
            <div class="flex justify-between">
              <span class="text-slate-400 font-sans">Nội dung chuyển khoản:</span>
              <strong class="text-indigo-400">{{ bookingCode }}</strong>
            </div>
          </div>

          <div class="flex gap-3 pt-2">
            <button @click="step = 1" class="flex-1 py-3 bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold text-xs rounded-xl border border-slate-700 transition">
              ⬅️ Sửa thông tin
            </button>
            <button @click="confirmPaid" class="flex-2 py-3 bg-emerald-600 hover:bg-emerald-700 text-white font-black text-xs rounded-xl shadow-lg shadow-emerald-600/30 transition">
              ✓ Tôi Đã Chuyển Tiền Cọc
            </button>
          </div>
        </div>

        <!-- Step 3: Success Pass -->
        <div v-else-if="step === 3" class="space-y-4 text-center py-4">
          <div class="w-16 h-16 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 flex items-center justify-center text-3xl font-bold mx-auto">
            ✓
          </div>
          <h3 class="text-2xl font-black text-white">Xác Nhận Đặt Cọc Thành Công!</h3>
          <p class="text-xs text-slate-300 max-w-md mx-auto leading-relaxed">
            Hệ thống RentOps đã ghi nhận yêu cầu đặt cọc cho <strong>Phòng {{ room.room_number }}</strong>. Mã xác nhận giữ phòng của bạn là <strong class="text-emerald-400 font-mono">{{ bookingCode }}</strong>.
          </p>

          <div class="bg-slate-800/80 p-4 rounded-2xl border border-slate-700 text-xs text-left space-y-2">
            <div>👤 Họ tên người thuê: <strong>{{ form.full_name }}</strong></div>
            <div>📞 SĐT liên hệ: <strong>{{ form.phone }}</strong></div>
            <div>📅 Ngày dọn vào ở: <strong>{{ form.move_in_date }}</strong></div>
            <div>💰 Tiền cọc đã ghi nhận: <strong class="text-emerald-400 font-mono">{{ formatCurrency(form.deposit_amount) }}</strong></div>
          </div>

          <button @click="$emit('close')" class="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-lg transition">
            Hoàn Tất & Đóng
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  room: {
    type: Object,
    required: true
  }
})

defineEmits(['close'])

const step = ref(1)
const bookingCode = ref('')
const vietqrUrl = ref('')

const form = ref({
  full_name: '',
  phone: '',
  move_in_date: new Date().toISOString().split('T')[0],
  deposit_amount: props.room.price
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const generateQR = () => {
  bookingCode.value = `DEPOSIT-${props.room.room_number}-${form.value.phone.slice(-4)}`
  const bank = 'MB'
  const acc = '0901234567'
  const accName = encodeURIComponent('RENTOPS SAAS DEMO')
  const amt = form.value.deposit_amount
  const addInfo = bookingCode.value

  vietqrUrl.value = `https://img.vietqr.io/image/${bank}-${acc}-compact2.png?amount=${amt}&addInfo=${addInfo}&accountName=${accName}`
  step.value = 2
}

const confirmPaid = () => {
  step.value = 3
}
</script>
