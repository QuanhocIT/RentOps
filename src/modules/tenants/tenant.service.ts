import prisma from '../../prisma/client';
import { NotFoundError, ForbiddenError } from '../../utils/errors';

export interface UpdateTenantDto {
  name?: string;
  phone?: string;
  address?: string;
  logoUrl?: string;
}

export interface CreateUserDto {
  email: string;
  password: string;
  fullName: string;
  phone?: string;
  role?: 'OWNER' | 'MANAGER' | 'STAFF';
}

export const getTenant = async (tenantId: string) => {
  const tenant = await prisma.tenant.findUnique({
    where: { id: tenantId },
    include: {
      _count: {
        select: { users: true, properties: true },
      },
    },
  });
  if (!tenant) throw new NotFoundError('Tenant');
  return tenant;
};

export const updateTenant = async (tenantId: string, dto: UpdateTenantDto) => {
  return prisma.tenant.update({ where: { id: tenantId }, data: dto });
};

export const listUsers = async (tenantId: string) => {
  return prisma.user.findMany({
    where: { tenantId },
    select: {
      id: true,
      email: true,
      fullName: true,
      phone: true,
      role: true,
      isActive: true,
      lastLoginAt: true,
      createdAt: true,
    },
    orderBy: { createdAt: 'asc' },
  });
};

export const inviteUser = async (tenantId: string, dto: CreateUserDto) => {
  const bcrypt = await import('bcryptjs');
  const passwordHash = await bcrypt.hash(dto.password, 12);
  return prisma.user.create({
    data: {
      tenantId,
      email: dto.email,
      passwordHash,
      fullName: dto.fullName,
      phone: dto.phone,
      role: dto.role ?? 'STAFF',
    },
    select: {
      id: true, email: true, fullName: true, phone: true, role: true, createdAt: true,
    },
  });
};

export const deactivateUser = async (tenantId: string, userId: string, requesterId: string) => {
  if (userId === requesterId) {
    throw new ForbiddenError('Cannot deactivate yourself');
  }
  const user = await prisma.user.findFirst({ where: { id: userId, tenantId } });
  if (!user) throw new NotFoundError('User');
  return prisma.user.update({
    where: { id: userId },
    data: { isActive: false },
    select: { id: true, email: true, isActive: true },
  });
};
