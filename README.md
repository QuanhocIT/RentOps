# RentOps

Dự án là một Nền tảng Phần mềm dịch vụ (SaaS Multi-tenant) thế hệ mới chuyên quản lý kinh doanh phòng trọ, căn hộ dịch vụ và chuỗi bất động sản cho thuê. Nền tảng cho phép phục vụ hàng ngàn chủ trọ/doanh nghiệp (tenants) dùng chung một hạ tầng công nghệ nhưng vẫn đảm bảo cô lập hoàn toàn dữ liệu và tối ưu chi phí vận hành.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js 20 + TypeScript |
| Framework | Express 4 |
| ORM | Prisma 5 |
| Database | PostgreSQL 16 |
| Auth | JWT (access + refresh tokens) |
| Validation | express-validator |
| Testing | Jest + Supertest |
| Containerisation | Docker / Docker Compose |

---

## Architecture — Multi-Tenancy

Every SaaS customer (landlord / property management company) is represented as a **Tenant**. Data isolation is enforced at the application layer via a `tenantId` foreign key on every data entity. All service layer functions accept and filter by `tenantId` derived from the authenticated user's JWT, ensuring tenants can never access each other's data.

```
Request → JWT Authentication → tenantId extraction → Service (filtered query with tenantId) → DB
```

### Entities

```
Tenant ─┬─ User (OWNER | MANAGER | STAFF)
        ├─ Property ──── Room ──── Contract ──── Invoice ──── Payment
        │                   └──── UtilityReading ─────────── InvoiceItem
        └─ RoomType
```

---

## Getting Started

### Prerequisites
- Node.js ≥ 20
- PostgreSQL ≥ 14 (or use Docker Compose)

### 1. Clone & install
```bash
git clone https://github.com/QuanhocIT/RentOps.git
cd RentOps
npm install
```

### 2. Configure environment
```bash
cp .env.example .env
# Edit .env and set DATABASE_URL, JWT_SECRET, etc.
```

### 3. Database setup
```bash
npx prisma migrate dev --name init
npx prisma generate
npm run db:seed          # optional: seed demo data
```

### 4. Start development server
```bash
npm run dev
```

### Docker Compose (all-in-one)
```bash
docker-compose up
```

---

## API Reference

Base URL: `http://localhost:3000/api/v1`

### Authentication

| Method | Path | Description |
|--------|------|-------------|
| POST | `/auth/register` | Register new tenant + owner account |
| POST | `/auth/login` | Login (returns JWT pair) |
| POST | `/auth/refresh` | Refresh access token |
| GET | `/auth/me` | Get current user profile |

### Tenant Management

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/tenants/me` | Any |
| PATCH | `/tenants/me` | OWNER |
| GET | `/tenants/users` | MANAGER+ |
| POST | `/tenants/users` | OWNER |
| DELETE | `/tenants/users/:id` | OWNER |

### Properties

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/properties` | Any |
| GET | `/properties/:id` | Any |
| POST | `/properties` | MANAGER+ |
| PATCH | `/properties/:id` | MANAGER+ |
| DELETE | `/properties/:id` | OWNER |

### Rooms

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/rooms?propertyId=` | Any |
| GET | `/rooms/:id` | Any |
| POST | `/rooms` | MANAGER+ |
| PATCH | `/rooms/:id` | MANAGER+ |
| DELETE | `/rooms/:id` | OWNER |

### Contracts & Renters

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/contracts/renters` | Any |
| POST | `/contracts/renters` | STAFF+ |
| GET | `/contracts/renters/:id` | Any |
| GET | `/contracts` | Any |
| GET | `/contracts/:id` | Any |
| POST | `/contracts` | STAFF+ |
| POST | `/contracts/:id/terminate` | MANAGER+ |

### Invoices & Payments

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/invoices` | Any |
| GET | `/invoices/:id` | Any |
| POST | `/invoices` | STAFF+ |
| POST | `/invoices/:id/payments` | STAFF+ |
| POST | `/invoices/:id/cancel` | MANAGER+ |

### Utility Readings

| Method | Path | Role Required |
|--------|------|---------------|
| GET | `/utilities?roomId=` | Any |
| POST | `/utilities` | STAFF+ |

---

## Scripts

```bash
npm run dev            # start dev server with hot-reload
npm run build          # compile TypeScript to dist/
npm start              # run compiled production build
npm test               # run test suite
npm run test:coverage  # run tests with coverage report
npm run lint           # ESLint
npm run db:generate    # regenerate Prisma client
npm run db:migrate     # run DB migrations (dev)
npm run db:seed        # seed demo data
npm run db:studio      # open Prisma Studio
```

---

## User Roles

| Role | Permissions |
|------|-------------|
| **OWNER** | Full access: tenant settings, user management, all CRUD |
| **MANAGER** | Manage properties, rooms, contracts, invoices; cannot manage users |
| **STAFF** | Create renters, contracts, invoices, record utility readings and payments |

---

## Subscription Plans

| Plan | Description |
|------|-------------|
| **BASIC** | Entry level |
| **PROFESSIONAL** | Most popular |
| **ENTERPRISE** | Unlimited scale |
