/**
 * Matrix Phân Quyền RBAC - RentOps
 * Định nghĩa chi tiết các quyền hạn theo từng vai trò người dùng
 */

export const ROLES = {
  SUPER_ADMIN: 'super_admin',
  OWNER: 'owner',
  STAFF: 'staff',
  RENTER: 'renter'
}

export const PERMISSIONS = {
  [ROLES.SUPER_ADMIN]: [
    'dashboard',
    'super-admin',
    'audit-logs',
    'properties',
    'rooms',
    'bills',
    'contracts',
    'renters',
    'reports',
    'settings',
    'maintenance',
    'assets',
    'expenses',
    'ai-advisor'
  ],
  [ROLES.OWNER]: [
    'dashboard',
    'properties',
    'rooms',
    'bills',
    'contracts',
    'renters',
    'utility-readings',
    'reports',
    'settings',
    'maintenance',
    'assets',
    'expenses',
    'ai-advisor',
    'audit-logs',
    'notifications'
  ],
  [ROLES.STAFF]: [
    'dashboard',
    'rooms',
    'utility-readings',
    'maintenance',
    'notifications',
    'assets'
  ],
  [ROLES.RENTER]: [
    'tenant-portal',
    'notifications'
  ]
}

export const ACTION_PERMISSIONS = {
  delete_bill: [ROLES.SUPER_ADMIN, ROLES.OWNER],
  terminate_contract: [ROLES.SUPER_ADMIN, ROLES.OWNER],
  view_sensitive_data: [ROLES.SUPER_ADMIN, ROLES.OWNER],
  manage_settings: [ROLES.SUPER_ADMIN, ROLES.OWNER],
  access_super_admin: [ROLES.SUPER_ADMIN]
}
