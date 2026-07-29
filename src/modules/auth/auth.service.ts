import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import prisma from '../../prisma/client';
import { config } from '../../config';
import { JwtPayload } from '../../types/auth';
import { UnauthorizedError, ConflictError, NotFoundError } from '../../utils/errors';
import { UserRole } from '@prisma/client';

export interface RegisterTenantDto {
  tenantName: string;
  tenantSlug: string;
  tenantEmail: string;
  ownerFullName: string;
  ownerEmail: string;
  ownerPassword: string;
  ownerPhone?: string;
}

export interface LoginDto {
  email: string;
  password: string;
  tenantSlug: string;
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

const signTokenPair = (payload: Omit<JwtPayload, 'iat' | 'exp'>): TokenPair => ({
  accessToken: jwt.sign(payload, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
  } as jwt.SignOptions),
  refreshToken: jwt.sign(
    { sub: payload.sub, tenantId: payload.tenantId },
    config.jwt.refreshSecret,
    { expiresIn: config.jwt.refreshExpiresIn } as jwt.SignOptions,
  ),
});

export const registerTenant = async (dto: RegisterTenantDto) => {
  // Check slug uniqueness
  const existing = await prisma.tenant.findUnique({ where: { slug: dto.tenantSlug } });
  if (existing) {
    throw new ConflictError(`Tenant slug '${dto.tenantSlug}' is already taken`);
  }

  const emailExists = await prisma.tenant.findUnique({ where: { email: dto.tenantEmail } });
  if (emailExists) {
    throw new ConflictError('Tenant email is already registered');
  }

  const passwordHash = await bcrypt.hash(dto.ownerPassword, 12);

  const tenant = await prisma.tenant.create({
    data: {
      name: dto.tenantName,
      slug: dto.tenantSlug,
      email: dto.tenantEmail,
      users: {
        create: {
          email: dto.ownerEmail,
          passwordHash,
          fullName: dto.ownerFullName,
          phone: dto.ownerPhone,
          role: UserRole.OWNER,
        },
      },
    },
    include: { users: true },
  });

  const owner = tenant.users[0];
  const tokens = signTokenPair({
    sub: owner.id,
    tenantId: tenant.id,
    email: owner.email,
    role: owner.role,
  });

  return { tenant, owner, tokens };
};

export const login = async (dto: LoginDto) => {
  const tenant = await prisma.tenant.findUnique({ where: { slug: dto.tenantSlug } });
  if (!tenant || !tenant.isActive) {
    throw new UnauthorizedError('Invalid credentials');
  }

  const user = await prisma.user.findUnique({
    where: { tenantId_email: { tenantId: tenant.id, email: dto.email } },
  });

  if (!user || !user.isActive) {
    throw new UnauthorizedError('Invalid credentials');
  }

  const passwordMatch = await bcrypt.compare(dto.password, user.passwordHash);
  if (!passwordMatch) {
    throw new UnauthorizedError('Invalid credentials');
  }

  await prisma.user.update({
    where: { id: user.id },
    data: { lastLoginAt: new Date() },
  });

  const tokens = signTokenPair({
    sub: user.id,
    tenantId: tenant.id,
    email: user.email,
    role: user.role,
  });

  return { user, tokens };
};

export const refreshToken = async (token: string): Promise<TokenPair> => {
  let payload: { sub: string; tenantId: string };
  try {
    payload = jwt.verify(token, config.jwt.refreshSecret) as { sub: string; tenantId: string };
  } catch {
    throw new UnauthorizedError('Invalid or expired refresh token');
  }

  const user = await prisma.user.findUnique({ where: { id: payload.sub } });
  if (!user || !user.isActive) {
    throw new NotFoundError('User');
  }

  return signTokenPair({
    sub: user.id,
    tenantId: user.tenantId,
    email: user.email,
    role: user.role,
  });
};
