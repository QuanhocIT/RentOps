<template>
  <div v-if="contract" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-3xl w-full p-8 shadow-2xl space-y-6 max-h-[92vh] overflow-y-auto">
      <div class="flex items-center justify-between border-b border-slate-200 pb-4 print:hidden">
        <h3 class="text-lg font-bold text-slate-900">Mẫu In Hợp Đồng Thuê Nhà (A4)</h3>
        <div class="flex items-center gap-3">
          <button @click="printDoc" class="px-4 py-2 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md">
            🖨️ In Hợp Đồng (A4)
          </button>
          <button @click="$emit('close')" class="text-slate-400 hover:text-slate-700 font-bold">✕</button>
        </div>
      </div>

      <!-- Document Content -->
      <div id="printable-contract" class="p-8 bg-white border border-slate-300 rounded-xl space-y-6 text-slate-900 font-serif leading-relaxed text-sm">
        <div class="text-center space-y-1">
          <h1 class="text-base font-bold uppercase tracking-wider">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</h1>
          <h2 class="text-sm font-semibold underline">Độc lập - Tự do - Hạnh phúc</h2>
          <div class="pt-4 text-xl font-black uppercase text-indigo-950 font-sans tracking-wide">HỢP ĐỒNG THUÊ PHÒNG TRỌ / CĂN HỘ</div>
          <p class="text-xs text-slate-500 font-mono">Mã số hợp đồng: {{ contract.contract_code }}</p>
        </div>

        <div class="space-y-3 font-sans">
          <p>Hôm nay, ngày {{ currentDate }}, tại hệ thống quản lý RentOps, chúng tôi gồm có:</p>

          <div class="bg-slate-50 p-4 rounded-xl space-y-1 border border-slate-200">
            <h3 class="font-bold text-slate-900 uppercase">BÊN CHO THUÊ (BÊN A):</h3>
            <p>Đại diện: <strong>BAN QUẢN LÝ TÒA NHÀ RENTOPS</strong></p>
            <p>Khu vực quản lý: <strong>{{ contract.property_name || 'Tòa nhà Landmark' }}</strong></p>
          </div>

          <div class="bg-slate-50 p-4 rounded-xl space-y-1 border border-slate-200">
            <h3 class="font-bold text-slate-900 uppercase">BÊN THUÊ (BÊN B):</h3>
            <p>Họ và tên: <strong>{{ contract.renter_name || 'Nguyễn Văn An' }}</strong></p>
            <p>Thuê tại phòng: <strong class="text-indigo-600">Phòng {{ contract.room_number }}</strong></p>
          </div>
        </div>

        <div class="space-y-3 font-sans">
          <h3 class="font-bold text-slate-900 border-b pb-1 uppercase">ĐIỀU 1: ĐIỀU KHOẢN THUÊ VÀ GIÁ CẢ</h3>
          <ul class="list-disc list-inside space-y-1 text-slate-700">
            <li><strong>Phòng thuê:</strong> Phòng {{ contract.room_number }} thuộc {{ contract.property_name || 'Tòa nhà Landmark' }}.</li>
            <li><strong>Giá thuê phòng:</strong> <span class="font-mono font-bold text-indigo-600">{{ formatCurrency(contract.monthly_rent) }}</span> / tháng.</li>
            <li><strong>Tiền cọc giữ chỗ:</strong> <span class="font-mono font-bold text-emerald-600">{{ formatCurrency(contract.deposit_amount) }}</span> (Hoàn trả sau khi hết hợp đồng).</li>
            <li><strong>Thời hạn hợp đồng:</strong> Từ ngày <strong>{{ contract.start_date || '01/01/2026' }}</strong> đến ngày <strong>{{ contract.end_date || '31/12/2026' }}</strong>.</li>
          </ul>
        </div>

        <div class="space-y-3 font-sans">
          <h3 class="font-bold text-slate-900 border-b pb-1 uppercase">ĐIỀU 2: TRÁCH NHIỆM HAI BÊN</h3>
          <p class="text-slate-700 text-xs">
            1. Bên B có trách nhiệm thanh toán tiền nhà đúng hạn từ ngày 01 đến ngày 05 hằng tháng qua VietQR.<br>
            2. Giữ gìn an ninh trật tự, vệ sinh chung và bảo quản tài sản được trang bị trong phòng.<br>
            3. Bên A cam kết bảo đảm điện nước tiêu chuẩn và hỗ trợ kỹ thuật sửa chữa sự cố phát sinh.
          </p>
        </div>

        <div class="grid grid-cols-2 text-center text-xs font-sans pt-8">
          <div>
            <div class="font-bold uppercase text-slate-900">ĐẠI DIỆN BÊN A</div>
            <div class="text-slate-400 italic mt-1">(Ký & ghi rõ họ tên)</div>
            <div class="h-16"></div>
          </div>
          <div>
            <div class="font-bold uppercase text-slate-900">BÊN THUÊ (BÊN B)</div>
            <div class="text-slate-400 italic mt-1">(Ký & ghi rõ họ tên)</div>
            <div class="h-16"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

defineProps({
  contract: Object
})

defineEmits(['close'])

const currentDate = computed(() => {
  const d = new Date()
  return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}`
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const printDoc = () => {
  window.print()
}
</script>
