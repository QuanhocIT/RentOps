import prisma from '../../prisma/client';
import { NotFoundError, ForbiddenError } from '../../utils/errors';
import { getPagination, buildMeta } from '../../utils/response';

export interface CreatePropertyDto {
  name: string;
  address: string;
  city: string;
  district?: string;
  ward?: string;
  description?: string;
  imageUrl?: string;
}

export interface UpdatePropertyDto extends Partial<CreatePropertyDto> {
  isActive?: boolean;
}

export const listProperties = async (
  tenantId: string,
  page: number,
  limit: number,
) => {
  const { skip, take } = getPagination(page, limit);
  const [data, total] = await Promise.all([
    prisma.property.findMany({
      where: { tenantId, isActive: true },
      skip,
      take,
      orderBy: { createdAt: 'desc' },
      include: {
        _count: { select: { rooms: true } },
      },
    }),
    prisma.property.count({ where: { tenantId, isActive: true } }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const getProperty = async (tenantId: string, id: string) => {
  const property = await prisma.property.findFirst({
    where: { id, tenantId },
    include: {
      rooms: {
        where: { status: { not: 'INACTIVE' } },
        orderBy: { number: 'asc' },
      },
    },
  });
  if (!property) throw new NotFoundError('Property');
  return property;
};

export const createProperty = async (tenantId: string, dto: CreatePropertyDto) => {
  return prisma.property.create({
    data: { ...dto, tenantId },
  });
};

export const updateProperty = async (
  tenantId: string,
  id: string,
  dto: UpdatePropertyDto,
) => {
  await ensurePropertyBelongsToTenant(tenantId, id);
  return prisma.property.update({ where: { id }, data: dto });
};

export const deleteProperty = async (tenantId: string, id: string) => {
  await ensurePropertyBelongsToTenant(tenantId, id);
  // Soft-delete
  return prisma.property.update({ where: { id }, data: { isActive: false } });
};

const ensurePropertyBelongsToTenant = async (tenantId: string, id: string) => {
  const property = await prisma.property.findFirst({ where: { id, tenantId } });
  if (!property) throw new NotFoundError('Property');
  return property;
};
