import { Router, Request, Response, NextFunction } from 'express';
import { body, param, query } from 'express-validator';
import { InvoiceStatus, InvoiceItemType, PaymentMethod } from '@prisma/client';
import { authenticate } from '../../middleware/authenticate';
import { requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as invoiceService from './invoice.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();
router.use(authenticate);

router.get(
  '/',
  [
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
    query('status').optional().isIn(Object.values(InvoiceStatus)),
    query('contractId').optional().isUUID(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await invoiceService.listInvoices(
        req.tenantId!,
        Number(req.query.page) || 1,
        Number(req.query.limit) || 20,
        req.query.status as InvoiceStatus | undefined,
        req.query.contractId as string | undefined,
      );
      sendSuccess(res, result.data, undefined, 200, result.meta);
    } catch (err) { next(err); }
  },
);

router.get(
  '/:id',
  [param('id').isUUID()],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const invoice = await invoiceService.getInvoice(req.tenantId!, req.params.id);
      sendSuccess(res, invoice);
    } catch (err) { next(err); }
  },
);

router.post(
  '/',
  requireMinRole('STAFF'),
  [
    body('contractId').isUUID(),
    body('billingMonth').isInt({ min: 1, max: 12 }).toInt(),
    body('billingYear').isInt({ min: 2000 }).toInt(),
    body('dueDate').isISO8601(),
    body('items').isArray({ min: 1 }).withMessage('At least one item is required'),
    body('items.*.type').isIn(Object.values(InvoiceItemType)),
    body('items.*.description').notEmpty().trim(),
    body('items.*.quantity').isFloat({ min: 0 }).toFloat(),
    body('items.*.unitPrice').isFloat({ min: 0 }).toFloat(),
    body('notes').optional().trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const invoice = await invoiceService.createInvoice(
        req.tenantId!,
        req.user!.sub,
        req.body,
      );
      sendCreated(res, invoice, 'Invoice created');
    } catch (err) { next(err); }
  },
);

router.post(
  '/:id/payments',
  requireMinRole('STAFF'),
  [
    param('id').isUUID(),
    body('amount').isFloat({ min: 0.01 }).toFloat(),
    body('method').optional().isIn(Object.values(PaymentMethod)),
    body('reference').optional().trim(),
    body('paidAt').optional().isISO8601(),
    body('notes').optional().trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const invoice = await invoiceService.recordPayment(
        req.tenantId!,
        req.params.id,
        req.body,
      );
      sendSuccess(res, invoice, 'Payment recorded');
    } catch (err) { next(err); }
  },
);

router.post(
  '/:id/cancel',
  requireMinRole('MANAGER'),
  [param('id').isUUID()],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const invoice = await invoiceService.cancelInvoice(req.tenantId!, req.params.id);
      sendSuccess(res, invoice, 'Invoice cancelled');
    } catch (err) { next(err); }
  },
);

export default router;
