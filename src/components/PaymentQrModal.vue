<template>
  <div v-if="show" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
    <div class="bg-slate-900 border border-slate-700/60 rounded-2xl max-w-md w-full p-6 text-white shadow-2xl relative animate-scale-in">
      <button @click="$emit('close')" class="absolute top-4 right-4 text-slate-400 hover:text-white text-xl">✕</button>

      <div class="text-center mb-6">
        <h3 class="text-xl font-bold bg-gradient-to-r from-emerald-400 to-teal-200 bg-clip-text text-transparent">
          Thanh Toán VietQR Tự Động
        </h3>
        <p class="text-xs text-slate-400 mt-1">Mã hóa đơn: <span class="text-amber-400 font-mono font-bold">{{ bill.bill_code }}</span></p>
      </div>

      <!-- QR Box -->
      <div class="bg-white p-4 rounded-2xl flex flex-col items-center justify-center border-4 border-emerald-500/30 shadow-inner">
        <img :src="vietQrUrl" alt="VietQR Payment Code" class="w-64 h-64 object-contain rounded-lg" />
        <div class="text-slate-900 text-center mt-3">
          <p class="text-xs font-semibold uppercase tracking-wider text-slate-500">{{ bill.bank_code || 'MB BANK' }}</p>
          <p class="font-mono font-bold text-lg text-slate-900">{{ bill.bank_account || '0901234567' }}</p>
          <p class="text-xs text-slate-600 font-medium">{{ bill.bank_account_name || 'RENTOPS DEMO' }}</p>
        </div>
      </div>

      <!-- Details -->
      <div class="mt-5 space-y-2 bg-slate-800/60 p-4 rounded-xl text-sm border border-slate-700/50">
        <div class="flex justify-between">
          <span class="text-slate-400">Số tiền cần thanh toán:</span>
          <span class="font-bold text-emerald-400 text-base">{{ formatCurrency(bill.total_amount) }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-slate-400">Nội dung chuyển khoản:</span>
          <span class="font-mono text-amber-400 font-bold bg-slate-900 px-2 py-0.5 rounded border border-amber-500/30">{{ bill.bill_code }}</span>
        </div>
        <div class="flex justify-between text-xs">
          <span class="text-slate-400">Trạng thái:</span>
          <span :class="bill.status === 'paid' ? 'text-emerald-400 font-bold' : 'text-amber-400 font-bold animate-pulse'">
            {{ bill.status === 'paid' ? '✓ Đã gạch nợ thành công' : '⏳ Đang chờ ngân hàng báo Webhook...' }}
          </span>
        </div>
      </div>

      <!-- Bank Webhook Simulation Button for Demo -->
      <div class="mt-6">
        <button
          @click="simulateWebhook"
          :disabled="loading || bill.status === 'paid'"
          class="w-full py-3 bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 disabled:opacity-50 text-white font-bold rounded-xl shadow-lg transition flex items-center justify-center space-x-2 text-sm"
        >
          <span v-if="loading" class="animate-spin">🔄</span>
          <span>{{ bill.status === 'paid' ? '✓ Hóa đơn Đã Thanh Toán' : '⚡ Giả Lập Ngân Hàng Chuyển Khoản (Auto Webhook)' }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  show: Boolean,
  bill: Object
})

const emit = defineEmits(['close', 'payment-success'])
const loading = ref(false)

const vietQrUrl = computed(() => {
  if (!props.bill) return ''
  const bank = props.bill.bank_code || 'MB'
  const acc = props.bill.bank_account || '0901234567'
  const name = props.bill.bank_account_name || 'RENTOPS DEMO'
  const amt = Math.round(props.bill.total_amount || 0)
  const info = props.bill.bill_code || ''

  return `https://img.vietqr.io/image/${bank}-${acc}-compact2.png?amount=${amt}&addInfo=${encodeURIComponent(info)}&accountName=${encodeURIComponent(name)}`
})

const formatCurrency = (val) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
}

import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const simulateWebhook = async () => {
  loading.value = true
  try {
    const res = await fetch('/api/v1/payment_transactions/webhook', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        bill_code: props.bill.bill_code,
        amount: props.bill.total_amount
      })
    })

    const data = await res.json()
    if (res.ok && data.success) {
      props.bill.status = 'paid'
      toastStore.success('Xác nhận thanh toán VietQR thành công!')
      emit('payment-success', props.bill)
    } else {
      toastStore.error(data.message || 'Chuyển khoản thất bại')
    }
  } catch (err) {
    toastStore.error('Lỗi kết nối ngân hàng webhook simulation')
  } finally {
    loading.value = false
  }
}
</script>
