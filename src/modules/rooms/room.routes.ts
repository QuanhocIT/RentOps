import { Router, Request, Response, NextFunction } from 'express';
import { body, param, query } from 'express-validator';
import { RoomStatus } from '@prisma/client';
import { authenticate } from '../../middleware/authenticate';
import { requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as roomService from './room.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();
router.use(authenticate);

router.get(
  '/',
  [
    query('propertyId').isUUID().withMessage('Valid propertyId is required'),
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
    query('status').optional().isIn(Object.values(RoomStatus)),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await roomService.listRooms(
        req.tenantId!,
        req.query.propertyId as string,
        Number(req.query.page) || 1,
        Number(req.query.limit) || 20,
        req.query.status as RoomStatus | undefined,
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
      const room = await roomService.getRoom(req.tenantId!, req.params.id);
      sendSuccess(res, room);
    } catch (err) { next(err); }
  },
);

router.post(
  '/',
  requireMinRole('MANAGER'),
  [
    body('propertyId').isUUID(),
    body('number').notEmpty().trim(),
    body('rentPrice').isFloat({ min: 0 }).toFloat(),
    body('depositAmount').isFloat({ min: 0 }).toFloat(),
    body('floor').optional().isInt().toInt(),
    body('area').optional().isFloat({ min: 0 }).toFloat(),
    body('roomTypeId').optional().isUUID(),
    body('description').optional().trim(),
    body('imageUrl').optional().isURL(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const room = await roomService.createRoom(req.tenantId!, req.body);
      sendCreated(res, room, 'Room created');
    } catch (err) { next(err); }
  },
);

router.patch(
  '/:id',
  requireMinRole('MANAGER'),
  [
    param('id').isUUID(),
    body('number').optional().notEmpty().trim(),
    body('rentPrice').optional().isFloat({ min: 0 }).toFloat(),
    body('depositAmount').optional().isFloat({ min: 0 }).toFloat(),
    body('status').optional().isIn(Object.values(RoomStatus)),
    body('floor').optional().isInt().toInt(),
    body('area').optional().isFloat({ min: 0 }).toFloat(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const room = await roomService.updateRoom(req.tenantId!, req.params.id, req.body);
      sendSuccess(res, room, 'Room updated');
    } catch (err) { next(err); }
  },
);

router.delete(
  '/:id',
  requireMinRole('OWNER'),
  [param('id').isUUID()],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      await roomService.deleteRoom(req.tenantId!, req.params.id);
      sendSuccess(res, null, 'Room deactivated');
    } catch (err) { next(err); }
  },
);

export default router;
