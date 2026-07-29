import { Router, Request, Response, NextFunction } from 'express';
import { body, param } from 'express-validator';
import { authenticate } from '../../middleware/authenticate';
import { requireRole, requireMinRole } from '../../middleware/authorize';
import { validate } from '../../middleware/validate';
import * as tenantService from './tenant.service';
import { sendSuccess } from '../../utils/response';

const router = Router();
router.use(authenticate);

router.get('/me', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const tenant = await tenantService.getTenant(req.tenantId!);
    sendSuccess(res, tenant);
  } catch (err) { next(err); }
});

router.patch(
  '/me',
  requireRole('OWNER'),
  [
    body('name').optional().notEmpty().trim(),
    body('phone').optional().trim(),
    body('address').optional().trim(),
    body('logoUrl').optional().isURL(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const tenant = await tenantService.updateTenant(req.tenantId!, req.body);
      sendSuccess(res, tenant, 'Tenant updated');
    } catch (err) { next(err); }
  },
);

router.get('/users', requireMinRole('MANAGER'), async (req: Request, res: Response, next: NextFunction) => {
  try {
    const users = await tenantService.listUsers(req.tenantId!);
    sendSuccess(res, users);
  } catch (err) { next(err); }
});

router.post(
  '/users',
  requireRole('OWNER'),
  [
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8 }),
    body('fullName').notEmpty().trim(),
    body('phone').optional().trim(),
    body('role').optional().isIn(['OWNER', 'MANAGER', 'STAFF']),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await tenantService.inviteUser(req.tenantId!, req.body);
      sendSuccess(res, user, 'User created', 201);
    } catch (err) { next(err); }
  },
);

router.delete(
  '/users/:id',
  requireRole('OWNER'),
  [param('id').isUUID()],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await tenantService.deactivateUser(
        req.tenantId!,
        req.params.id,
        req.user!.sub,
      );
      sendSuccess(res, user, 'User deactivated');
    } catch (err) { next(err); }
  },
);

export default router;
