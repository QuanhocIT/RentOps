import { getPagination, buildMeta, sendSuccess, sendError } from '../utils/response';
import { Response } from 'express';

describe('getPagination', () => {
  it('calculates skip/take correctly', () => {
    expect(getPagination(1, 20)).toEqual({ skip: 0, take: 20, page: 1, limit: 20 });
    expect(getPagination(2, 10)).toEqual({ skip: 10, take: 10, page: 2, limit: 10 });
    expect(getPagination(3, 5)).toEqual({ skip: 10, take: 5, page: 3, limit: 5 });
  });

  it('enforces minimum page of 1', () => {
    const result = getPagination(0, 10);
    expect(result.page).toBe(1);
    expect(result.skip).toBe(0);
  });

  it('clamps limit to 100', () => {
    const result = getPagination(1, 200);
    expect(result.limit).toBe(100);
    expect(result.take).toBe(100);
  });

  it('enforces minimum limit of 1', () => {
    const result = getPagination(1, 0);
    expect(result.limit).toBe(1);
    expect(result.take).toBe(1);
  });
});

describe('buildMeta', () => {
  it('builds pagination metadata correctly', () => {
    const meta = buildMeta(100, 1, 20);
    expect(meta).toEqual({ page: 1, limit: 20, total: 100, totalPages: 5 });
  });

  it('rounds up totalPages', () => {
    const meta = buildMeta(21, 1, 20);
    expect(meta.totalPages).toBe(2);
  });

  it('returns 0 totalPages when total is 0', () => {
    const meta = buildMeta(0, 1, 20);
    expect(meta.totalPages).toBe(0);
  });
});

describe('sendSuccess and sendError', () => {
  const mockRes = () => {
    const res: Partial<Response> = {};
    res.status = jest.fn().mockReturnValue(res);
    res.json = jest.fn().mockReturnValue(res);
    return res as Response;
  };

  it('sends success response', () => {
    const res = mockRes();
    sendSuccess(res, { id: 1 }, 'OK');
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ success: true, data: { id: 1 }, message: 'OK' }),
    );
  });

  it('sends error response', () => {
    const res = mockRes();
    sendError(res, 'Something went wrong', 500);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ success: false, error: 'Something went wrong' }),
    );
  });
});
