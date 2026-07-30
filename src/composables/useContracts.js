/**
 * Composable useContracts - RentOps
 * Quản lý logic tạo, gia hạn, thanh lý hợp đồng và tự động đồng bộ trạng thái phòng.
 */

import { useDataStore } from '../stores/data'

export function useContracts() {
  const dataStore = useDataStore()

  /**
   * Kích hoạt hợp đồng mới và tự động đổi trạng thái phòng sang 'occupied' / 'rented'
   */
  const activateContract = (contractData) => {
    const newContract = dataStore.addContract(contractData)
    const room = dataStore.rooms.find(r => r.id === Number(contractData.roomId))
    if (room) {
      room.status = 'occupied'
      dataStore.saveToStorage()
    }
    return newContract
  }

  /**
   * Gia hạn hợp đồng thêm N tháng
   */
  const renewContract = (contractId, addMonths = 6) => {
    const contract = dataStore.contracts.find(c => c.id === contractId)
    if (!contract) return false

    const currentEnd = new Date(contract.endDate || Date.now())
    currentEnd.setMonth(currentEnd.getMonth() + addMonths)
    contract.endDate = currentEnd.toISOString().split('T')[0]

    dataStore.addAuditLog('Gia hạn hợp đồng', contract.contractNumber, `Gia hạn thêm ${addMonths} tháng tới ngày ${contract.endDate}`)
    dataStore.saveToStorage()
    return true
  }

  /**
   * Thanh lý hợp đồng và tự động chuyển trạng thái phòng về 'vacant'
   */
  const checkoutContract = (contractId, deductionAmount = 0, reason = '') => {
    const contract = dataStore.contracts.find(c => c.id === contractId)
    if (!contract) return false

    contract.status = 'terminated'
    const room = dataStore.rooms.find(r => r.id === contract.roomId)
    if (room) {
      room.status = 'vacant'
      room.renterId = null
      room.renterName = ''
    }

    dataStore.addAuditLog('Thanh lý hợp đồng', contract.contractNumber, `Khấu trừ cọc: ${deductionAmount}đ (${reason})`)
    dataStore.saveToStorage()
    return true
  }

  return {
    activateContract,
    renewContract,
    checkoutContract
  }
}
