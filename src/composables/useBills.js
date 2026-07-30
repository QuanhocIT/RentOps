/**
 * Composable useBills - RentOps
 * Quản lý logic tính phạt quá hạn (Late Payment Fee), thanh toán từng phần (Partial Payment) và sinh hóa đơn.
 */

import { useDataStore } from '../stores/data'

export function useBills() {
  const dataStore = useDataStore()

  /**
   * Tự động tính phạt chậm nộp (50.000đ/ngày hoặc 1%/ngày nếu quá hạn dueDate)
   */
  const calculateLateFee = (bill, feePerDay = 50000) => {
    if (!bill || bill.status === 'paid' || !bill.dueDate) return 0

    const now = new Date().getTime()
    const due = new Date(bill.dueDate).getTime()

    if (now <= due) return 0

    const diffDays = Math.floor((now - due) / (1000 * 60 * 60 * 24))
    return diffDays > 0 ? diffDays * feePerDay : 0
  }

  /**
   * Xử lý thanh toán từng phần (Partial Payment)
   * Cập nhật paidAmount, remainingAmount = totalAmount - paidAmount, chuyển status = 'partially_paid'
   */
  const processPartialPayment = (billId, paymentAmount, paymentMethod = 'VietQR') => {
    const bill = dataStore.bills.find(b => b.id === billId)
    if (!bill) return { success: false, message: 'Không tìm thấy hóa đơn' }

    const total = bill.totalAmount || bill.total_amount || 0
    const currentPaid = Number(bill.paidAmount || 0)
    const newPaidTotal = currentPaid + Number(paymentAmount)

    bill.paidAmount = newPaidTotal
    bill.remainingAmount = Math.max(0, total - newPaidTotal)

    if (newPaidTotal >= total) {
      bill.status = 'paid'
      bill.paidDate = new Date().toISOString().split('T')[0]
      bill.remainingAmount = 0
    } else {
      bill.status = 'partially_paid'
    }

    dataStore.addAuditLog(
      'Thanh toán từng phần',
      bill.code || bill.bill_code,
      `Đã thu: ${paymentAmount.toLocaleString()}đ, Còn nợ: ${(bill.remainingAmount).toLocaleString()}đ`
    )
    dataStore.saveToStorage()

    return {
      success: true,
      status: bill.status,
      paidAmount: bill.paidAmount,
      remainingAmount: bill.remainingAmount
    }
  }

  return {
    calculateLateFee,
    processPartialPayment
  }
}
