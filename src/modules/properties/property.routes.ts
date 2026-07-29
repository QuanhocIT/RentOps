import { Router, Request, Response, NextFunction } from 'express';
import { body, param, query } from 'express-validator';
import { authenticate } from '../../middleware/authenticate';
import { requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as propertyService from './property.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();
router.use(authenticate);

router.get(
  '/',
  [
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const page = Number(req.query.page) || 1;
      const limit = Number(req.query.limit) || 20;
      const result = await propertyService.listProperties(req.tenantId!, page, limit);
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
      const property = await propertyService.getProperty(req.tenantId!, req.params.id);
      sendSuccess(res, property);
    } catch (err) { next(err); }
  },
);

router.post(
  '/',
  requireMinRole('MANAGER'),
  [
    body('name').notEmpty().trim(),
    body('address').notEmpty().trim(),
    body('city').notEmpty().trim(),
    body('district').optional().trim(),
    body('ward').optional().trim(),
    body('description').optional().trim(),
    body('imageUrl').optional().isURL(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const property = await propertyService.createProperty(req.tenantId!, req.body);
      sendCreated(res, property, 'Property created');
    } catch (err) { next(err); }
  },
);

router.patch(
  '/:id',
  requireMinRole('MANAGER'),
  [
    param('id').isUUID(),
    body('name').optional().notEmpty().trim(),
    body('address').optional().notEmpty().trim(),
    body('city').optional().notEmpty().trim(),
    body('isActive').optional().isBoolean(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const property = await propertyService.updateProperty(req.tenantId!, req.params.id, req.body);
      sendSuccess(res, property, 'Property updated');
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
      await propertyService.deleteProperty(req.tenantId!, req.params.id);
      sendSuccess(res, null, 'Property deleted');
    } catch (err) { next(err); }
  },
);

export default router;
