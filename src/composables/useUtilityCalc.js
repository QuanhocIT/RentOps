/**
 * Composable useUtilityCalc - RentOps
 * Quản lý logic tính toán chỉ số điện nước bậc thang, phát hiện công tơ quay đầu & cảnh báo tiêu thụ bất thường.
 */

export function useUtilityCalc() {
  /**
   * Tính điện bậc thang theo biểu giá quy định (hoặc giá cố định mặc định 3.800đ/kWh)
   */
  const calculateProgressiveElectricCost = (usage, mode = 'flat', flatRate = 3800) => {
    if (mode === 'flat' || !mode) {
      return Math.round(usage * flatRate)
    }

    let cost = 0
    let remaining = usage

    // Bậc 1 (0-50 kWh)
    const b1 = Math.min(remaining, 50)
    cost += b1 * 1806
    remaining -= b1

    // Bậc 2 (51-100 kWh)
    if (remaining > 0) {
      const b2 = Math.min(remaining, 50)
      cost += b2 * 1866
      remaining -= b2
    }

    // Bậc 3 (101-200 kWh)
    if (remaining > 0) {
      const b3 = Math.min(remaining, 100)
      cost += b3 * 2167
      remaining -= b3
    }

    // Bậc 4 (201-300 kWh)
    if (remaining > 0) {
      const b4 = Math.min(remaining, 100)
      cost += b4 * 2729
      remaining -= b4
    }

    // Bậc 5 (>300 kWh)
    if (remaining > 0) {
      cost += remaining * 3050
    }

    return Math.round(cost)
  }

  /**
   * Xử lý trường hợp công tơ quay đầu (Meter Reset / Rollover)
   * Ví dụ: Từ 9999 quay về 0005 (maxReading = 10000)
   */
  const calculateUsageWithRollover = (oldVal, newVal, maxReading = 10000) => {
    const prev = Number(oldVal) || 0
    const curr = Number(newVal) || 0

    if (curr >= prev) {
      return { usage: curr - prev, isRollover: false }
    }

    // Trường hợp quay đầu
    const usage = (maxReading - prev) + curr
    return { usage, isRollover: true }
  }

  /**
   * Cảnh báo bất thường khi tiêu thụ tăng >50% so với tháng trước
   */
  const checkConsumptionAnomaly = (currentUsage, lastMonthUsage) => {
    if (!lastMonthUsage || lastMonthUsage <= 0) return { isSpike: false, percentIncrease: 0 }
    const increase = currentUsage - lastMonthUsage
    const percent = (increase / lastMonthUsage) * 100
    return {
      isSpike: percent >= 50,
      percentIncrease: Math.round(percent)
    }
  }

  return {
    calculateProgressiveElectricCost,
    calculateUsageWithRollover,
    checkConsumptionAnomaly
  }
}
