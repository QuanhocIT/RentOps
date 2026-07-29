import { requireMinRole, requireRole } from '../middleware/authorize';
import { Request, Response, NextFunction } from 'express';
import { ForbiddenError } from '../utils/errors';

const mockReq = (role?: string): Partial<Request> => ({
  user: role ? { sub: 'user-id', tenantId: 'tenant-id', email: 'u@t.com', role: role as never } : undefined,
});

describe('requireRole', () => {
  it('calls next() when user has required role', () => {
    const req = mockReq('OWNER');
    const next = jest.fn();
    requireRole('OWNER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith(); // no error
  });

  it('calls next with ForbiddenError when role does not match', () => {
    const req = mockReq('STAFF');
    const next = jest.fn();
    requireRole('OWNER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith(expect.any(ForbiddenError));
  });

  it('calls next with ForbiddenError when no user', () => {
    const req = mockReq();
    const next = jest.fn();
    requireRole('OWNER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith(expect.any(ForbiddenError));
  });
});

describe('requireMinRole', () => {
  it('allows OWNER when minimum is MANAGER', () => {
    const req = mockReq('OWNER');
    const next = jest.fn();
    requireMinRole('MANAGER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith();
  });

  it('allows MANAGER when minimum is MANAGER', () => {
    const req = mockReq('MANAGER');
    const next = jest.fn();
    requireMinRole('MANAGER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith();
  });

  it('rejects STAFF when minimum is MANAGER', () => {
    const req = mockReq('STAFF');
    const next = jest.fn();
    requireMinRole('MANAGER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith(expect.any(ForbiddenError));
  });

  it('rejects STAFF when minimum is OWNER', () => {
    const req = mockReq('STAFF');
    const next = jest.fn();
    requireMinRole('OWNER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith(expect.any(ForbiddenError));
  });

  it('allows OWNER when minimum is OWNER', () => {
    const req = mockReq('OWNER');
    const next = jest.fn();
    requireMinRole('OWNER')(req as Request, {} as Response, next as NextFunction);
    expect(next).toHaveBeenCalledWith();
  });
});
