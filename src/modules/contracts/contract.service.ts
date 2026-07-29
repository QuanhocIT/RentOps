import prisma from '../../prisma/client';
import { NotFoundError, BadRequestError } from '../../utils/errors';
import { getPagination, buildMeta } from '../../utils/response';
import { ContractStatus, RoomStatus, IdType } from '@prisma/client';

export interface CreateContractDto {
  roomId: string;
  renterId: string;
  startDate: string | Date;
  endDate?: string | Date;
  rentAmount: number;
  depositAmount: number;
  paymentDay?: number;
  notes?: string;
}

export interface CreateRenterDto {
  fullName: string;
  phone: string;
  email?: string;
  idNumber?: string;
  idType?: IdType;
  dateOfBirth?: string | Date;
  permanentAddress?: string;
  temporaryAddress?: string;
  notes?: string;
}

const generateContractCode = (tenantId: string): string => {
  const prefix = tenantId.slice(0, 4).toUpperCase();
  const timestamp = Date.now().toString(36).toUpperCase();
  return `CT-${prefix}-${timestamp}`;
};

export const listContracts = async (
  tenantId: string,
  page: number,
  limit: number,
  status?: ContractStatus,
) => {
  const { skip, take } = getPagination(page, limit);
  const where = { tenantId, ...(status ? { status } : {}) };
  const [data, total] = await Promise.all([
    prisma.contract.findMany({
      where,
      skip,
      take,
      orderBy: { createdAt: 'desc' },
      include: {
        room: { include: { property: true } },
        renter: true,
      },
    }),
    prisma.contract.count({ where }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const getContract = async (tenantId: string, id: string) => {
  const contract = await prisma.contract.findFirst({
    where: { id, tenantId },
    include: {
      room: { include: { property: true, roomType: true } },
      renter: true,
      invoices: { orderBy: { createdAt: 'desc' }, take: 6 },
    },
  });
  if (!contract) throw new NotFoundError('Contract');
  return contract;
};

export const createContract = async (
  tenantId: string,
  userId: string,
  dto: CreateContractDto,
) => {
  // Verify room belongs to tenant and is available
  const room = await prisma.room.findFirst({
    where: { id: dto.roomId, property: { tenantId } },
  });
  if (!room) throw new NotFoundError('Room');
  if (room.status === RoomStatus.OCCUPIED) {
    throw new BadRequestError('Room is already occupied');
  }

  // Verify renter belongs to tenant
  const renter = await prisma.renter.findFirst({ where: { id: dto.renterId, tenantId } });
  if (!renter) throw new NotFoundError('Renter');

  const contractCode = generateContractCode(tenantId);

  const contract = await prisma.$transaction(async (tx) => {
    const created = await tx.contract.create({
      data: {
        tenantId,
        roomId: dto.roomId,
        renterId: dto.renterId,
        createdById: userId,
        contractCode,
        startDate: new Date(dto.startDate),
        endDate: dto.endDate ? new Date(dto.endDate) : null,
        rentAmount: dto.rentAmount,
        depositAmount: dto.depositAmount,
        paymentDay: dto.paymentDay ?? 5,
        notes: dto.notes,
        status: ContractStatus.ACTIVE,
      },
      include: { room: true, renter: true },
    });
    await tx.room.update({
      where: { id: dto.roomId },
      data: { status: RoomStatus.OCCUPIED },
    });
    return created;
  });

  return contract;
};

export const terminateContract = async (
  tenantId: string,
  id: string,
  reason?: string,
) => {
  const contract = await prisma.contract.findFirst({ where: { id, tenantId } });
  if (!contract) throw new NotFoundError('Contract');
  if (contract.status !== ContractStatus.ACTIVE) {
    throw new BadRequestError('Only active contracts can be terminated');
  }

  return prisma.$transaction(async (tx) => {
    const updated = await tx.contract.update({
      where: { id },
      data: {
        status: ContractStatus.TERMINATED,
        terminatedAt: new Date(),
        terminationReason: reason,
      },
    });
    await tx.room.update({
      where: { id: contract.roomId },
      data: { status: RoomStatus.AVAILABLE },
    });
    return updated;
  });
};

// ── Renter helpers ──────────────────────────────────────────────────────────

export const listRenters = async (tenantId: string, page: number, limit: number) => {
  const { skip, take } = getPagination(page, limit);
  const [data, total] = await Promise.all([
    prisma.renter.findMany({
      where: { tenantId, isActive: true },
      skip,
      take,
      orderBy: { createdAt: 'desc' },
    }),
    prisma.renter.count({ where: { tenantId, isActive: true } }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const createRenter = async (tenantId: string, dto: CreateRenterDto) => {
  return prisma.renter.create({ data: { ...dto, tenantId } });
};

export const getRenter = async (tenantId: string, id: string) => {
  const renter = await prisma.renter.findFirst({ where: { id, tenantId } });
  if (!renter) throw new NotFoundError('Renter');
  return renter;
};
