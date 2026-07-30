/**
 * Composable usePermissions - RentOps
 * Kiểm tra quyền truy cập route & tính năng theo vai trò người dùng (RBAC)
 */

import { useAuthStore } from '../stores/auth'
import { PERMISSIONS, ACTION_PERMISSIONS } from '../config/permissions'

export function usePermissions() {
  const authStore = useAuthStore()

  /**
   * Kiểm tra người dùng có quyền truy cập route name hay không
   */
  const canAccessRoute = (routeName) => {
    const role = authStore.user?.role || 'owner'
    const allowedRoutes = PERMISSIONS[role] || []
    return allowedRoutes.includes(routeName)
  }

  /**
   * Kiểm tra người dùng có quyền thực hiện hành động cụ thể hay không
   */
  const hasActionPermission = (actionKey) => {
    const role = authStore.user?.role || 'owner'
    const allowedRoles = ACTION_PERMISSIONS[actionKey] || []
    return allowedRoles.includes(role)
  }

  return {
    canAccessRoute,
    hasActionPermission,
    currentRole: authStore.user?.role || 'owner'
  }
}
