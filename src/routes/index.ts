import { Router } from 'express';
import authRoutes from '../modules/auth/auth.routes';
import tenantRoutes from '../modules/tenants/tenant.routes';
import propertyRoutes from '../modules/properties/property.routes';
import roomRoutes from '../modules/rooms/room.routes';
import contractRoutes from '../modules/contracts/contract.routes';
import invoiceRoutes from '../modules/invoices/invoice.routes';
import utilityRoutes from '../modules/utilities/utility.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/tenants', tenantRoutes);
router.use('/properties', propertyRoutes);
router.use('/rooms', roomRoutes);
router.use('/contracts', contractRoutes);
router.use('/invoices', invoiceRoutes);
router.use('/utilities', utilityRoutes);

export default router;
