import { Router, Request, Response, NextFunction } from 'express';
import { body, param, query } from 'express-validator';
import { UtilityType } from '@prisma/client';
import { authenticate } from '../../middleware/authenticate';
import { requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as utilityService from './utility.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();
router.use(authenticate);

router.get(
  '/',
  [
    query('roomId').isUUID().withMessage('Valid roomId is required'),
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
    query('type').optional().isIn(Object.values(UtilityType)),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await utilityService.listReadings(
        req.tenantId!,
        req.query.roomId as string,
        Number(req.query.page) || 1,
        Number(req.query.limit) || 20,
        req.query.type as UtilityType | undefined,
      );
      sendSuccess(res, result.data, undefined, 200, result.meta);
    } catch (err) { next(err); }
  },
);

router.post(
  '/',
  requireMinRole('STAFF'),
  [
    body('roomId').isUUID(),
    body('type').isIn(Object.values(UtilityType)),
    body('readingDate').isISO8601(),
    body('previousReading').isFloat({ min: 0 }).toFloat(),
    body('currentReading').isFloat({ min: 0 }).toFloat(),
    body('unitPrice').isFloat({ min: 0 }).toFloat(),
    body('notes').optional().trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const reading = await utilityService.createReading(req.tenantId!, req.body);
      sendCreated(res, reading, 'Utility reading recorded');
    } catch (err) { next(err); }
  },
);

export default router;
