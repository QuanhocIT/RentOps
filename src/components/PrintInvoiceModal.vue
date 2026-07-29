<template>
  <div v-if="bill" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-2xl w-full p-8 shadow-2xl space-y-6 max-h-[90vh] overflow-y-auto">
      <div class="flex items-center justify-between border-b border-slate-200 pb-4 print:hidden">
        <h3 class="text-lg font-bold text-slate-900">Mẫu In Hóa Đơn A4</h3>
        <div class="flex items-center gap-3">
          <button @click="printReceipt" class="px-4 py-2 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md">
            🖨️ In Hóa Đơn (A4)
          </button>
          <button @click="$emit('close')" class="text-slate-400 hover:text-slate-700 font-bold">✕</button>
        </div>
      </div>

      <!-- Printable Document Container -->
      <div id="printable-receipt" class="p-6 bg-white border border-slate-300 rounded-xl space-y-6 text-slate-900 font-serif">
        <div class="flex items-start justify-between border-b-2 border-slate-900 pb-4">
          <div>
            <h2 class="text-2xl font-black uppercase tracking-wider text-slate-900 font-sans">GIẤY BÁO THU TIỀN PHÒNG & ĐIỆN NƯỚC</h2>
            <p class="text-xs text-slate-500 font-sans mt-0.5">Tòa nhà / Tenant: <strong>RentOps SaaS System</strong></p>
          </div>
          <div class="text-right font-sans">
            <div class="text-sm font-bold text-indigo-600 font-mono">{{ bill.bill_code }}</div>
            <div class="text-xs text-slate-500">Kỳ tháng: {{ bill.billing_month }}</div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 text-sm font-sans">
          <div>
            <span class="text-slate-500">Phòng thuê:</span> <strong>Phòng {{ bill.room_number }}</strong>
          </div>
          <div>
            <span class="text-slate-500">Hạn thanh toán:</span> <strong>{{ bill.due_date || 'Cuối tháng' }}</strong>
          </div>
        </div>

        <!-- Breakdown table -->
        <table class="w-full text-left text-sm border-collapse font-sans">
          <thead>
            <tr class="bg-slate-100 border-y border-slate-300">
              <th class="py-2.5 px-3">Khoản mục</th>
              <th class="py-2.5 px-3 text-right">Số tiền (VNĐ)</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-200 font-mono">
            <tr>
              <td class="py-2.5 px-3 font-sans">Tiền thuê phòng hằng tháng</td>
              <td class="py-2.5 px-3 text-right font-bold">{{ formatCurrency(bill.room_fee || bill.total_amount) }}</td>
            </tr>
            <tr>
              <td class="py-2.5 px-3 font-sans">Tiền Điện & Nước tiêu thụ</td>
              <td class="py-2.5 px-3 text-right font-bold text-amber-700">{{ formatCurrency(bill.utility_fee || 0) }}</td>
            </tr>
            <tr>
              <td class="py-2.5 px-3 font-sans">Dịch vụ (Internet, rác, vệ sinh)</td>
              <td class="py-2.5 px-3 text-right font-bold">{{ formatCurrency(bill.service_fee || 0) }}</td>
            </tr>
            <tr class="bg-slate-50 font-bold border-t-2 border-slate-900 text-base">
              <td class="py-3 px-3 font-sans">TỔNG CỘNG THANH TOÁN:</td>
              <td class="py-3 px-3 text-right text-indigo-700">{{ formatCurrency(bill.total_amount) }}</td>
            </tr>
          </tbody>
        </table>

        <!-- VietQR Box -->
        <div class="flex items-center gap-6 p-4 bg-slate-50 rounded-2xl border border-slate-200 font-sans">
          <img :src="bill.vietqr_url" alt="VietQR" class="w-32 h-32 object-contain rounded-xl border border-white shadow-sm" />
          <div class="text-xs space-y-1.5 font-mono">
            <div class="font-bold text-sm text-slate-900 font-sans">Quét mã VietQR để thanh toán nhanh</div>
            <div>Ngân hàng: <strong>MB (MBBank)</strong></div>
            <div>Số TK: <strong class="text-indigo-600">0901234567</strong></div>
            <div>Nội dung CK: <strong class="bg-amber-200 px-1.5 py-0.5 rounded">{{ bill.bill_code }}</strong></div>
          </div>
        </div>

        <div class="grid grid-cols-2 text-center text-xs font-sans pt-6">
          <div>
            <div class="font-bold">ĐẠI DIỆN BÊN CHO THUÊ</div>
            <div class="text-slate-400 italic mt-1">(Ký & ghi rõ họ tên)</div>
          </div>
          <div>
            <div class="font-bold">KHÁCH THUÊ PHÒNG</div>
            <div class="text-slate-400 italic mt-1">(Ký & ghi rõ họ tên)</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  bill: Object
})

defineEmits(['close'])

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const printReceipt = () => {
  window.print()
}
</script>
