import prisma from '../prisma/client';
import bcrypt from 'bcryptjs';

async function main() {
  console.log('Seeding database...');

  const passwordHash = await bcrypt.hash('password123', 12);

  const tenant = await prisma.tenant.upsert({
    where: { slug: 'demo-landlord' },
    update: {},
    create: {
      name: 'Demo Landlord Co.',
      slug: 'demo-landlord',
      email: 'admin@demo-landlord.com',
      plan: 'PROFESSIONAL',
      users: {
        create: [
          {
            email: 'owner@demo-landlord.com',
            passwordHash,
            fullName: 'Demo Owner',
            role: 'OWNER',
          },
          {
            email: 'manager@demo-landlord.com',
            passwordHash,
            fullName: 'Demo Manager',
            role: 'MANAGER',
          },
        ],
      },
    },
  });

  console.log(`Created tenant: ${tenant.name} (${tenant.slug})`);

  const property = await prisma.property.upsert({
    where: { id: 'seed-property-001' },
    update: {},
    create: {
      id: 'seed-property-001',
      tenantId: tenant.id,
      name: 'Chung cư Mini Trung Tâm',
      address: '123 Nguyễn Văn Linh',
      city: 'Hà Nội',
      district: 'Thanh Xuân',
    },
  });

  console.log(`Created property: ${property.name}`);

  const roomType = await prisma.roomType.upsert({
    where: { tenantId_name: { tenantId: tenant.id, name: 'Studio' } },
    update: {},
    create: {
      tenantId: tenant.id,
      name: 'Studio',
      description: 'Phòng studio tiện nghi',
      baseRent: 3000000,
      area: 25,
      maxOccupants: 2,
    },
  });

  for (let i = 1; i <= 5; i++) {
    await prisma.room.upsert({
      where: { propertyId_number: { propertyId: property.id, number: `10${i}` } },
      update: {},
      create: {
        propertyId: property.id,
        roomTypeId: roomType.id,
        number: `10${i}`,
        floor: 1,
        area: 25,
        rentPrice: 3000000,
        depositAmount: 6000000,
        status: i <= 3 ? 'OCCUPIED' : 'AVAILABLE',
      },
    });
  }

  console.log('Created 5 sample rooms');
  console.log('Seeding complete!');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
