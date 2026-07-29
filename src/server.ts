import app from './app';
import { config } from './config';
import logger from './utils/logger';
import prisma from './prisma/client';

const start = async () => {
  try {
    // Test DB connection
    await prisma.$connect();
    logger.info('Database connected');

    app.listen(config.port, () => {
      logger.info(`Server running on port ${config.port} (${config.env})`);
    });
  } catch (err) {
    logger.error('Failed to start server', err);
    process.exit(1);
  }
};

process.on('SIGTERM', async () => {
  logger.info('SIGTERM received, shutting down gracefully');
  await prisma.$disconnect();
  process.exit(0);
});

start();
