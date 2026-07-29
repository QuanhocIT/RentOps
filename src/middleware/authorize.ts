import { Request, Response, NextFunction } from 'express';
import { UserRole } from '@prisma/client';
import { ForbiddenError } from '../utils/errors';

const roleHierarchy: Record<UserRole, number> = {
  OWNER: 3,
  MANAGER: 2,
  STAFF: 1,
};

export const requireRole = (...roles: UserRole[]) =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const userRole = req.user?.role;
    if (!userRole || !roles.includes(userRole)) {
      return next(new ForbiddenError('Insufficient permissions'));
    }
    next();
  };

export const requireMinRole = (minRole: UserRole) =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const userRole = req.user?.role;
    if (!userRole || roleHierarchy[userRole] < roleHierarchy[minRole]) {
      return next(new ForbiddenError('Insufficient permissions'));
    }
    next();
  };
