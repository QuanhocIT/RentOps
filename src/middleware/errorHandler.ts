import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors';
import { sendError } from '../utils/response';
import logger from '../utils/logger';

export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void => {
  if (err instanceof AppError) {
    if (err.statusCode >= 500) {
      logger.error(err);
    }
    sendError(res, err.message, err.statusCode);
    return;
  }

  // Prisma unique constraint errors
  if ((err as { code?: string }).code === 'P2002') {
    sendError(res, 'A record with the same unique field already exists', 409);
    return;
  }

  // Prisma not-found errors
  if ((err as { code?: string }).code === 'P2025') {
    sendError(res, 'Record not found', 404);
    return;
  }

  logger.error('Unhandled error:', err);
  sendError(res, 'Internal server error', 500);
};
