<template>
  <div v-if="contract" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl space-y-5">
      <div class="flex items-center justify-between border-b border-slate-100 pb-3">
        <div>
          <span class="text-xs uppercase font-bold text-rose-600">Thanh Lý Hợp Đồng & Quyết Toán Cọc</span>
          <h3 class="text-xl font-black text-slate-900">{{ contract.contract_code }}</h3>
        </div>
        <button @click="$emit('close')" class="text-slate-400 hover:text-slate-700 text-lg font-bold">✕</button>
      </div>

      <!-- Financial Summary Breakdown -->
      <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 space-y-2 text-xs">
        <div class="flex justify-between">
          <span class="text-slate-500">Phòng thuê:</span>
          <span class="font-bold text-slate-900">Phòng {{ contract.room_number }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-slate-500">Tiền cọc ban đầu:</span>
          <span class="font-bold text-emerald-600 font-mono text-sm">{{ formatCurrency(contract.deposit_amount) }}</span>
        </div>
        <div v-if="contract.total_unpaid_amount > 0" class="flex justify-between text-rose-600 font-bold">
          <span>Hóa đơn chưa thanh toán:</span>
          <span class="font-mono text-sm">-{{ formatCurrency(contract.total_unpaid_amount) }}</span>
        </div>
      </div>

      <form @submit.prevent="handleCheckout" class="space-y-4">
        <div>
          <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Khấu trừ đền bù / hư hỏng tài sản (VNĐ)</label>
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
            placeholder="Ví dụ: Khấu trừ làm hỏng vòi sen, nợ tiền điện nước..."
            class="w-full px-3 py-2.5 bg-slate-50 border border-slate-300 rounded-xl text-sm focus:bg-white"
          />
        </div>

        <div v-if="contract.total_unpaid_amount > 0" class="flex items-center gap-2 bg-amber-50 p-3 rounded-xl border border-amber-200">
          <input id="settleBills" v-model="settleUnpaidWithDeposit" type="checkbox" class="w-4 h-4 rounded text-indigo-600 border-amber-300 focus:ring-indigo-500" />
          <label for="settleBills" class="text-xs font-bold text-amber-900 cursor-pointer">
            Tự động gạch nợ hóa đơn tồn bằng tiền cọc
          </label>
        </div>

        <!-- Net Refund Result -->
        <div class="bg-gradient-to-br from-emerald-50 to-teal-50 p-4 rounded-2xl border border-emerald-200 flex items-center justify-between">
          <div>
            <div class="text-[11px] uppercase font-bold text-emerald-800">Thực Trả Lại Khách (Hoàn Cọc)</div>
            <div class="text-2xl font-black text-emerald-700 font-mono mt-0.5">{{ formatCurrency(refundAmount) }}</div>
            <div class="text-[10px] text-slate-500 mt-1 font-medium">
              = Cọc ({{ formatCurrency(contract.deposit_amount) }}) - Khấu trừ ({{ formatCurrency(totalDeduction) }})
            </div>
          </div>
          <div class="text-3xl">💵</div>
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
            {{ submitting ? 'Đang thanh lý...' : 'Xác Nhận Quyết Toán & Trả Phòng' }}
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
const settleUnpaidWithDeposit = ref(true)
const submitting = ref(false)

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const totalDeduction = computed(() => {
  const manual = Number(deductionAmount.value || 0)
  const unpaid = settleUnpaidWithDeposit.value ? Number(props.contract?.total_unpaid_amount || 0) : 0
  return manual + unpaid
})

const refundAmount = computed(() => {
  const deposit = Number(props.contract?.deposit_amount || 0)
  return Math.max(0, deposit - totalDeduction.value)
})

import { useToastStore } from '../stores/toast'
import { useDataStore } from '../stores/data'

const toastStore = useToastStore()
const dataStore = useDataStore()

const handleCheckout = async () => {
  submitting.value = true
  try {
    try {
      await api.post(`/contracts/${props.contract.id}/checkout`, {
        deduction_amount: deductionAmount.value,
        deduction_reason: deductionReason.value,
        settle_unpaid_with_deposit: settleUnpaidWithDeposit.value
      })
    } catch (e) {
      console.warn('[CheckoutContractModal] Backend API unavailable, updating client store.')
    }

    const cId = props.contract.id || props.contract.contract_id
    const cCode = props.contract.contract_code || props.contract.contractNumber
    const targetContract = dataStore.contracts.find(c => c.id === cId || c.contractNumber === cCode)

    if (targetContract) {
      targetContract.status = 'terminated'
      const room = dataStore.rooms.find(r => r.id === targetContract.roomId || r.id === props.contract.room_id)
      if (room) {
        room.status = 'vacant'
        room.renterId = null
        room.renterName = ''
      }
    }

    if (settleUnpaidWithDeposit.value) {
      const roomId = props.contract.room_id || targetContract?.roomId
      if (roomId) {
        dataStore.bills.forEach(b => {
          if (b.roomId === roomId && (b.status === 'unpaid' || b.status === 'overdue')) {
            b.status = 'paid'
            b.paidDate = new Date().toISOString().split('T')[0]
            b.notes = (b.notes || '') + ' (Khấu trừ cọc khi thanh lý)'
          }
        })
      }
    }

    dataStore.addAuditLog('Thanh lý hợp đồng', cCode || 'Hợp đồng', `Khấu trừ: ${formatCurrency(totalDeduction.value)}, Hoàn cọc: ${formatCurrency(refundAmount.value)}`)
    dataStore.saveToStorage()

    toastStore.success('Thanh lý hợp đồng và quyết toán cọc thành công!')
    emit('success')
    emit('close')
  } catch (err) {
    toastStore.error(err?.message || 'Có lỗi xảy ra khi thanh lý hợp đồng')
  } finally {
    submitting.value = false
  }
}
</script>
