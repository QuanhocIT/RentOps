/**
 * Composable useFormatCurrency - RentOps
 * Formatter tiền tệ VNĐ và định dạng ngày tháng chuẩn dùng chung toàn ứng dụng.
 */

export function useFormatCurrency() {
  const formatCurrency = (val) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)
  }

  const formatDate = (dateStr) => {
    if (!dateStr) return 'N/A'
    try {
      const d = new Date(dateStr)
      if (isNaN(d.getTime())) return dateStr
      return d.toLocaleDateString('vi-VN')
    } catch (e) {
      return dateStr
    }
  }

  return {
    formatCurrency,
    formatDate
  }
}
