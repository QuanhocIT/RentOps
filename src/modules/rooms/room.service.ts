import prisma from '../../prisma/client';
import { NotFoundError, ConflictError } from '../../utils/errors';
import { getPagination, buildMeta } from '../../utils/response';
import { RoomStatus } from '@prisma/client';

export interface CreateRoomDto {
  propertyId: string;
  roomTypeId?: string;
  number: string;
  floor?: number;
  area?: number;
  rentPrice: number;
  depositAmount: number;
  description?: string;
  imageUrl?: string;
}

export interface UpdateRoomDto extends Partial<Omit<CreateRoomDto, 'propertyId'>> {
  status?: RoomStatus;
}

const ensurePropertyBelongsToTenant = async (tenantId: string, propertyId: string) => {
  const property = await prisma.property.findFirst({ where: { id: propertyId, tenantId } });
  if (!property) throw new NotFoundError('Property');
  return property;
};

export const listRooms = async (
  tenantId: string,
  propertyId: string,
  page: number,
  limit: number,
  status?: RoomStatus,
) => {
  await ensurePropertyBelongsToTenant(tenantId, propertyId);
  const { skip, take } = getPagination(page, limit);
  const where = { propertyId, ...(status ? { status } : {}) };
  const [data, total] = await Promise.all([
    prisma.room.findMany({
      where,
      skip,
      take,
      orderBy: { number: 'asc' },
      include: { roomType: true },
    }),
    prisma.room.count({ where }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const getRoom = async (tenantId: string, id: string) => {
  const room = await prisma.room.findFirst({
    where: { id, property: { tenantId } },
    include: {
      property: true,
      roomType: true,
      contracts: {
        where: { status: { in: ['ACTIVE', 'DRAFT'] } },
        take: 1,
        orderBy: { createdAt: 'desc' },
        include: { renter: true },
      },
    },
  });
  if (!room) throw new NotFoundError('Room');
  return room;
};

export const createRoom = async (tenantId: string, dto: CreateRoomDto) => {
  await ensurePropertyBelongsToTenant(tenantId, dto.propertyId);
  return prisma.room.create({ data: dto });
};

export const updateRoom = async (tenantId: string, id: string, dto: UpdateRoomDto) => {
  const room = await prisma.room.findFirst({
    where: { id, property: { tenantId } },
  });
  if (!room) throw new NotFoundError('Room');
  return prisma.room.update({ where: { id }, data: dto });
};

export const deleteRoom = async (tenantId: string, id: string) => {
  const room = await prisma.room.findFirst({
    where: { id, property: { tenantId } },
  });
  if (!room) throw new NotFoundError('Room');
  return prisma.room.update({ where: { id }, data: { status: RoomStatus.INACTIVE } });
};
