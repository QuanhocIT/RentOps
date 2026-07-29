import prisma from '../../prisma/client';
import { NotFoundError, BadRequestError } from '../../utils/errors';
import { getPagination, buildMeta } from '../../utils/response';
import { InvoiceStatus, InvoiceItemType, PaymentMethod } from '@prisma/client';

export interface InvoiceItemDto {
  type: InvoiceItemType;
  description: string;
  quantity: number;
  unitPrice: number;
  utilityReadingId?: string;
}

export interface CreateInvoiceDto {
  contractId: string;
  billingMonth: number;
  billingYear: number;
  dueDate: string | Date;
  items: InvoiceItemDto[];
  notes?: string;
}

export interface RecordPaymentDto {
  amount: number;
  method?: PaymentMethod;
  reference?: string;
  paidAt?: string | Date;
  notes?: string;
}

const generateInvoiceCode = (tenantId: string, month: number, year: number): string => {
  const prefix = tenantId.slice(0, 4).toUpperCase();
  return `INV-${prefix}-${year}${String(month).padStart(2, '0')}-${Date.now().toString(36).toUpperCase()}`;
};

export const listInvoices = async (
  tenantId: string,
  page: number,
  limit: number,
  status?: InvoiceStatus,
  contractId?: string,
) => {
  const { skip, take } = getPagination(page, limit);
  const where = {
    tenantId,
    ...(status ? { status } : {}),
    ...(contractId ? { contractId } : {}),
  };
  const [data, total] = await Promise.all([
    prisma.invoice.findMany({
      where,
      skip,
      take,
      orderBy: [{ billingYear: 'desc' }, { billingMonth: 'desc' }],
      include: {
        contract: {
          include: { room: { include: { property: true } }, renter: true },
        },
      },
    }),
    prisma.invoice.count({ where }),
  ]);
  return { data, meta: buildMeta(total, page, limit) };
};

export const getInvoice = async (tenantId: string, id: string) => {
  const invoice = await prisma.invoice.findFirst({
    where: { id, tenantId },
    include: {
      items: true,
      payments: { orderBy: { paidAt: 'desc' } },
      contract: {
        include: { room: { include: { property: true } }, renter: true },
      },
    },
  });
  if (!invoice) throw new NotFoundError('Invoice');
  return invoice;
};

export const createInvoice = async (
  tenantId: string,
  userId: string,
  dto: CreateInvoiceDto,
) => {
  const contract = await prisma.contract.findFirst({
    where: { id: dto.contractId, tenantId },
  });
  if (!contract) throw new NotFoundError('Contract');

  const totalAmount = dto.items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
  const invoiceCode = generateInvoiceCode(tenantId, dto.billingMonth, dto.billingYear);

  return prisma.invoice.create({
    data: {
      tenantId,
      contractId: dto.contractId,
      createdById: userId,
      invoiceCode,
      billingMonth: dto.billingMonth,
      billingYear: dto.billingYear,
      dueDate: new Date(dto.dueDate),
      totalAmount,
      notes: dto.notes,
      items: {
        create: dto.items.map(item => ({
          type: item.type,
          description: item.description,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          amount: item.quantity * item.unitPrice,
          utilityReadingId: item.utilityReadingId,
        })),
      },
    },
    include: { items: true },
  });
};

export const recordPayment = async (
  tenantId: string,
  invoiceId: string,
  dto: RecordPaymentDto,
) => {
  const invoice = await prisma.invoice.findFirst({
    where: { id: invoiceId, tenantId },
  });
  if (!invoice) throw new NotFoundError('Invoice');
  if (invoice.status === InvoiceStatus.CANCELLED) {
    throw new BadRequestError('Cannot pay a cancelled invoice');
  }

  const newPaidAmount = Number(invoice.paidAmount) + dto.amount;
  const newStatus = newPaidAmount >= Number(invoice.totalAmount)
    ? InvoiceStatus.PAID
    : InvoiceStatus.PARTIAL;

  return prisma.$transaction(async (tx) => {
    await tx.payment.create({
      data: {
        tenantId,
        invoiceId,
        amount: dto.amount,
        method: dto.method ?? PaymentMethod.CASH,
        reference: dto.reference,
        paidAt: dto.paidAt ? new Date(dto.paidAt) : new Date(),
        notes: dto.notes,
      },
    });
    return tx.invoice.update({
      where: { id: invoiceId },
      data: {
        paidAmount: newPaidAmount,
        status: newStatus,
        paidAt: newStatus === InvoiceStatus.PAID ? new Date() : undefined,
      },
      include: { items: true, payments: true },
    });
  });
};

export const cancelInvoice = async (tenantId: string, id: string) => {
  const invoice = await prisma.invoice.findFirst({ where: { id, tenantId } });
  if (!invoice) throw new NotFoundError('Invoice');
  if (invoice.status === InvoiceStatus.PAID) {
    throw new BadRequestError('Cannot cancel a paid invoice');
  }
  return prisma.invoice.update({
    where: { id },
    data: { status: InvoiceStatus.CANCELLED },
  });
};
