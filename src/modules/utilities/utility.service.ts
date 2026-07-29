import prisma from '../../prisma/client';
import { NotFoundError } from '../../utils/errors';
import { getPagination, buildMeta } from '../../utils/response';
import { UtilityType } from '@prisma/client';

export interface CreateUtilityReadingDto {
  roomId: string;
  type: UtilityType;
  readingDate: string | Date;
  previousReading: number;
  currentReading: number;
  unitPrice: number;
  notes?: string;
}

export const listReadings = async (
  tenantId: string,
  roomId: string,
  page: number,
  limit: number,
  type?: UtilityType,
) => {
  // Ensure room belongs to tenant
  const room = await prisma.room.findFirst({ where: { id: roomId, property: { tenantId } } });
  if (!room) throw new NotFoundError('Room');

  const { skip, take } = getPagination(page, limit);
  const where = { roomId, ...(type ? { type } : {}) };
  const [data, total] = await Promise.all([
    prisma.utilityReading.findMany({
      where,
      skip,
      take,
      orderBy: { readingDate: 'desc' },
    }),
    prisma.utilityReading.count({ where }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const createReading = async (tenantId: string, dto: CreateUtilityReadingDto) => {
  const room = await prisma.room.findFirst({
    where: { id: dto.roomId, property: { tenantId } },
  });
  if (!room) throw new NotFoundError('Room');

  return prisma.utilityReading.create({
    data: {
      tenantId,
      roomId: dto.roomId,
      type: dto.type,
      readingDate: new Date(dto.readingDate),
      previousReading: dto.previousReading,
      currentReading: dto.currentReading,
      unitPrice: dto.unitPrice,
      notes: dto.notes,
    },
  });
};

export const getUsageSummary = (reading: {
  previousReading: number | string;
  currentReading: number | string;
  unitPrice: number | string;
}) => {
  const consumed = Number(reading.currentReading) - Number(reading.previousReading);
  const amount = consumed * Number(reading.unitPrice);
  return { consumed, amount };
};
