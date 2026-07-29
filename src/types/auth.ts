import { UserRole } from '@prisma/client';

export interface JwtPayload {
  sub: string;       // user ID
  tenantId: string;
  email: string;
  role: UserRole;
  iat?: number;
  exp?: number;
}

export interface AuthenticatedRequest extends Express.Request {
  user: JwtPayload;
}
