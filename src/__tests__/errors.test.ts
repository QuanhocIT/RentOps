import {
  AppError,
  NotFoundError,
  UnauthorizedError,
  ForbiddenError,
  BadRequestError,
  ConflictError,
} from '../utils/errors';

describe('AppError', () => {
  it('sets statusCode and message', () => {
    const err = new AppError('Test error', 400);
    expect(err.message).toBe('Test error');
    expect(err.statusCode).toBe(400);
    expect(err.isOperational).toBe(true);
    expect(err instanceof Error).toBe(true);
  });

  it('defaults statusCode to 500', () => {
    const err = new AppError('Server error');
    expect(err.statusCode).toBe(500);
  });
});

describe('NotFoundError', () => {
  it('returns 404 with resource name', () => {
    const err = new NotFoundError('Property');
    expect(err.statusCode).toBe(404);
    expect(err.message).toContain('Property');
  });

  it('uses default resource name', () => {
    const err = new NotFoundError();
    expect(err.message).toContain('Resource');
  });
});

describe('UnauthorizedError', () => {
  it('returns 401', () => {
    const err = new UnauthorizedError();
    expect(err.statusCode).toBe(401);
  });
});

describe('ForbiddenError', () => {
  it('returns 403', () => {
    const err = new ForbiddenError();
    expect(err.statusCode).toBe(403);
  });
});

describe('BadRequestError', () => {
  it('returns 400', () => {
    const err = new BadRequestError('Invalid input');
    expect(err.statusCode).toBe(400);
    expect(err.message).toBe('Invalid input');
  });
});

describe('ConflictError', () => {
  it('returns 409', () => {
    const err = new ConflictError('Duplicate entry');
    expect(err.statusCode).toBe(409);
    expect(err.message).toBe('Duplicate entry');
  });
});
