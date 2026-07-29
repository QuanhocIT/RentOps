import { Router, Request, Response, NextFunction } from 'express';
import { body, param, query } from 'express-validator';
import { ContractStatus } from '@prisma/client';
import { authenticate } from '../../middleware/authenticate';
import { requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as contractService from './contract.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();
router.use(authenticate);

// ── Renters ─────────────────────────────────────────────────────────────────

router.get('/renters', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await contractService.listRenters(
      req.tenantId!,
      Number(req.query.page) || 1,
      Number(req.query.limit) || 20,
    );
    sendSuccess(res, result.data, undefined, 200, result.meta);
  } catch (err) { next(err); }
});

router.post(
  '/renters',
  requireMinRole('STAFF'),
  [
    body('fullName').notEmpty().trim(),
    body('phone').notEmpty().trim(),
    body('email').optional().isEmail().normalizeEmail(),
    body('idNumber').optional().trim(),
    body('dateOfBirth').optional().isISO8601().toDate(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const renter = await contractService.createRenter(req.tenantId!, req.body);
      sendCreated(res, renter, 'Renter created');
    } catch (err) { next(err); }
  },
);

router.get(
  '/renters/:id',
  [param('id').isUUID()],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const renter = await contractService.getRenter(req.tenantId!, req.params.id);
      sendSuccess(res, renter);
    } catch (err) { next(err); }
  },
);

// ── Contracts ────────────────────────────────────────────────────────────────

router.get(
  '/',
  [
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
    query('status').optional().isIn(Object.values(ContractStatus)),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await contractService.listContracts(
        req.tenantId!,
        Number(req.query.page) || 1,
        Number(req.query.limit) || 20,
        req.query.status as ContractStatus | undefined,
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
      const contract = await contractService.getContract(req.tenantId!, req.params.id);
      sendSuccess(res, contract);
    } catch (err) { next(err); }
  },
);

router.post(
  '/',
  requireMinRole('STAFF'),
  [
    body('roomId').isUUID(),
    body('renterId').isUUID(),
    body('startDate').isISO8601(),
    body('endDate').optional().isISO8601(),
    body('rentAmount').isFloat({ min: 0 }).toFloat(),
    body('depositAmount').isFloat({ min: 0 }).toFloat(),
    body('paymentDay').optional().isInt({ min: 1, max: 28 }).toInt(),
    body('notes').optional().trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const contract = await contractService.createContract(
        req.tenantId!,
        req.user!.sub,
        req.body,
      );
      sendCreated(res, contract, 'Contract created');
    } catch (err) { next(err); }
  },
);

router.post(
  '/:id/terminate',
  requireMinRole('MANAGER'),
  [
    param('id').isUUID(),
    body('reason').optional().trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const contract = await contractService.terminateContract(
        req.tenantId!,
        req.params.id,
        req.body.reason,
      );
      sendSuccess(res, contract, 'Contract terminated');
    } catch (err) { next(err); }
  },
);

export default router;
