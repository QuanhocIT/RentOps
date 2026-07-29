<template>
  <div v-if="contract" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl space-y-5">
      <div class="flex items-center justify-between border-b border-slate-100 pb-3">
        <div>
          <span class="text-xs uppercase font-bold text-rose-600">Thanh Lý Hợp Đồng</span>
          <h3 class="text-xl font-black text-slate-900">{{ contract.contract_code }}</h3>
        </div>
        <button @click="$emit('close')" class="text-slate-400 hover:text-slate-700 text-lg font-bold">✕</button>
      </div>

      <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 space-y-2 text-sm">
        <div class="flex justify-between">
          <span class="text-slate-500">Phòng:</span>
          <span class="font-bold text-slate-900">Phòng {{ contract.room_number }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-slate-500">Tiền cọc đã nhận:</span>
          <span class="font-bold text-emerald-600 font-mono">{{ formatCurrency(contract.deposit_amount) }}</span>
        </div>
      </div>

      <form @submit.prevent="handleCheckout" class="space-y-4">
        <div>
          <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Số tiền khấu trừ (Bồi thường / Nợ cũ)</label>
          <input
            v-model.number="deductionAmount"
            type="number"
            min="0"
            placeholder="0"
            class="w-full px-3 py-2.5 bg-rose-50/50 border border-rose-300 rounded-xl text-sm font-bold text-rose-900 focus:bg-white"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Lý do khấu trừ (nếu có)</label>
          <input
            v-model="deductionReason"
            type="text"
            placeholder="Khấu trừ hỏng hóc thiết bị, nợ tiền điện nước..."
            class="w-full px-3 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
          />
        </div>

        <div class="bg-emerald-50 p-4 rounded-2xl border border-emerald-200 flex items-center justify-between">
          <div>
            <div class="text-xs uppercase font-bold text-emerald-700">Tiền Cọc Hoàn Trả Khách</div>
            <div class="text-2xl font-black text-emerald-700 font-mono mt-0.5">{{ formatCurrency(refundAmount) }}</div>
          </div>
          <div class="text-2xl">💵</div>
        </div>

        <div class="flex justify-end gap-3 pt-2">
          <button
            type="button"
            @click="$emit('close')"
            class="px-4 py-2.5 bg-slate-100 text-slate-700 font-medium rounded-xl hover:bg-slate-200 text-sm"
          >
            Hủy
          </button>
          <button
            type="submit"
            :disabled="submitting"
            class="px-5 py-2.5 bg-rose-600 text-white font-bold rounded-xl hover:bg-rose-700 text-sm shadow-lg shadow-rose-600/30"
          >
            {{ submitting ? 'Đang thanh lý...' : 'Xác nhận thanh lý & Hoàn cọc' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import api from '../services/api'

const props = defineProps({
  contract: Object
})

const emit = defineEmits(['close', 'success'])

const deductionAmount = ref(0)
const deductionReason = ref('')
const submitting = ref(false)

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const refundAmount = computed(() => {
  const deposit = Number(props.contract?.deposit_amount || 0)
  return Math.max(0, deposit - (deductionAmount.value || 0))
})

const handleCheckout = async () => {
  submitting.value = true
  try {
    await api.post(`/contracts/${props.contract.id}/checkout`, {
      deduction_amount: deductionAmount.value,
      deduction_reason: deductionReason.value
    })
    emit('success')
    emit('close')
  } catch (err) {
    alert(err?.message || 'Có lỗi xảy ra khi thanh lý hợp đồng')
  } finally {
    submitting.value = false
  }
}
</script>
