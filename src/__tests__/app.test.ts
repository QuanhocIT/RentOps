import request from 'supertest';

// Mock prisma so no real DB needed
jest.mock('../prisma/client', () => ({
  __esModule: true,
  default: {
    $connect: jest.fn().mockResolvedValue(undefined),
    $disconnect: jest.fn().mockResolvedValue(undefined),
    $transaction: jest.fn().mockImplementation(
      async (fn: (tx: unknown) => Promise<unknown>) => fn({}),
    ),
    tenant: { findUnique: jest.fn(), findFirst: jest.fn(), create: jest.fn() },
    user: { findUnique: jest.fn(), update: jest.fn() },
    property: { findMany: jest.fn(), count: jest.fn() },
    room: { findMany: jest.fn(), count: jest.fn() },
    contract: { findMany: jest.fn(), count: jest.fn() },
    invoice: { findMany: jest.fn(), count: jest.fn() },
    renter: { findMany: jest.fn(), count: jest.fn() },
    utilityReading: { findMany: jest.fn(), count: jest.fn() },
  },
}));

import app from '../app';

describe('App', () => {
  describe('GET /health', () => {
    it('returns 200 with status ok', async () => {
      const res = await request(app).get('/health');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('ok');
      expect(res.body.version).toBe('1.0.0');
      expect(res.body.timestamp).toBeDefined();
    });
  });

  describe('404 handler', () => {
    it('returns 404 for unknown routes', async () => {
      const res = await request(app).get('/api/v1/nonexistent-route');
      expect(res.status).toBe(404);
      expect(res.body.success).toBe(false);
    });
  });

  describe('API routes are mounted', () => {
    it('GET /api/v1/auth/me returns 401 without token', async () => {
      const res = await request(app).get('/api/v1/auth/me');
      expect(res.status).toBe(401);
    });

    it('GET /api/v1/properties returns 401 without token', async () => {
      const res = await request(app).get('/api/v1/properties');
      expect(res.status).toBe(401);
    });

    it('GET /api/v1/rooms returns 401 without token', async () => {
      const res = await request(app).get('/api/v1/rooms');
      expect(res.status).toBe(401);
    });

    it('GET /api/v1/contracts returns 401 without token', async () => {
      const res = await request(app).get('/api/v1/contracts');
      expect(res.status).toBe(401);
    });

    it('GET /api/v1/invoices returns 401 without token', async () => {
      const res = await request(app).get('/api/v1/invoices');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/auth/register validation', () => {
    it('returns 422 when required fields are missing', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({});
      expect(res.status).toBe(422);
      expect(res.body.success).toBe(false);
    });

    it('returns 422 for invalid slug format', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          tenantName: 'Test',
          tenantSlug: 'Invalid Slug!',
          tenantEmail: 'test@test.com',
          ownerFullName: 'Test User',
          ownerEmail: 'owner@test.com',
          ownerPassword: 'password123',
        });
      expect(res.status).toBe(422);
    });

    it('returns 422 for short password', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          tenantName: 'Test',
          tenantSlug: 'test-slug',
          tenantEmail: 'test@test.com',
          ownerFullName: 'Test User',
          ownerEmail: 'owner@test.com',
          ownerPassword: 'short',
        });
      expect(res.status).toBe(422);
    });
  });

  describe('POST /api/v1/auth/login validation', () => {
    it('returns 422 when fields are missing', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({});
      expect(res.status).toBe(422);
    });

    it('returns 422 for invalid email', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({ email: 'not-an-email', password: 'test', tenantSlug: 'test' });
      expect(res.status).toBe(422);
    });
  });
});
