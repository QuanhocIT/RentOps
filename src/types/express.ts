import { Request, Response, NextFunction } from 'express';
import { JwtPayload } from '../types/auth';

// Extend Express Request type globally
declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
      tenantId?: string;
    }
  }
}

export type { Request, Response, NextFunction };
