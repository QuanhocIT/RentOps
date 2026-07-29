import { Router, Request, Response, NextFunction } from 'express';
import { body } from 'express-validator';
import { validate } from '../../middleware/validate';
import { authenticate } from '../../middleware/authenticate';
import * as authService from './auth.service';
import { sendSuccess, sendCreated } from '../../utils/response';

const router = Router();

/**
 * POST /api/auth/register
 * Register a new tenant and its owner user
 */
router.post(
  '/register',
  [
    body('tenantName').notEmpty().withMessage('Tenant name is required').trim(),
    body('tenantSlug')
      .notEmpty()
      .withMessage('Tenant slug is required')
      .matches(/^[a-z0-9-]+$/)
      .withMessage('Slug must be lowercase letters, numbers and hyphens only')
      .trim(),
    body('tenantEmail').isEmail().withMessage('Valid tenant email is required').normalizeEmail(),
    body('ownerFullName').notEmpty().withMessage('Owner full name is required').trim(),
    body('ownerEmail').isEmail().withMessage('Valid owner email is required').normalizeEmail(),
    body('ownerPassword')
      .isLength({ min: 8 })
      .withMessage('Password must be at least 8 characters'),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await authService.registerTenant(req.body);
      const { owner, tokens, tenant } = result;
      sendCreated(res, {
        tenant: {
          id: tenant.id,
          name: tenant.name,
          slug: tenant.slug,
          plan: tenant.plan,
        },
        user: {
          id: owner.id,
          email: owner.email,
          fullName: owner.fullName,
          role: owner.role,
        },
        tokens,
      }, 'Tenant registered successfully');
    } catch (err) {
      next(err);
    }
  },
);

/**
 * POST /api/auth/login
 */
router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Valid email is required').normalizeEmail(),
    body('password').notEmpty().withMessage('Password is required'),
    body('tenantSlug').notEmpty().withMessage('Tenant slug is required').trim(),
  ],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await authService.login(req.body);
      const { user, tokens } = result;
      sendSuccess(res, {
        user: {
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          role: user.role,
          tenantId: user.tenantId,
        },
        tokens,
      }, 'Login successful');
    } catch (err) {
      next(err);
    }
  },
);

/**
 * POST /api/auth/refresh
 */
router.post(
  '/refresh',
  [body('refreshToken').notEmpty().withMessage('Refresh token is required')],
  validate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const tokens = await authService.refreshToken(req.body.refreshToken);
      sendSuccess(res, { tokens }, 'Tokens refreshed');
    } catch (err) {
      next(err);
    }
  },
);

/**
 * GET /api/auth/me
 */
router.get('/me', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await (await import('../../prisma/client')).default.user.findUnique({
      where: { id: req.user!.sub },
      select: {
        id: true,
        email: true,
        fullName: true,
        phone: true,
        role: true,
        tenantId: true,
        isActive: true,
        lastLoginAt: true,
        createdAt: true,
        tenant: {
          select: {
            id: true,
            name: true,
            slug: true,
            plan: true,
          },
        },
      },
    });
    sendSuccess(res, user);
  } catch (err) {
    next(err);
  }
});

export default router;
