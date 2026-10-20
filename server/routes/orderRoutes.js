const express = require('express');
const router = express.Router();
const {
  createOrder, getMyOrders, updateOrderStatus,
  getAllOrders, verifyOrder
} = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .post(protect, createOrder)
  .get(protect, getMyOrders);

router.route('/merchant').get(protect, authorize('merchant', 'admin'), require('../controllers/orderController').getMerchantOrders);

router.route('/driver').get(protect, authorize('driver','admin'), require('../controllers/orderController').getDriverOrders);

router.route('/all')
  .get(protect, authorize('admin'), getAllOrders);

router.route('/:id/verify')
  .put(protect, authorize('admin'), verifyOrder);

router.route('/:id/assign-driver').patch(protect, authorize('driver','admin'), require('../controllers/orderController').assignDriver);

router.route('/:id/deliver').post(protect, authorize('driver','admin'), require('../controllers/orderController').deliverOrder);

router.route('/:id/status')
  .patch(protect, authorize('merchant', 'driver', 'admin'), updateOrderStatus);

router.route('/:id/stage').patch(protect, authorize('driver', 'admin', 'merchant'), require('../controllers/orderController').updateOrderStage);

router.get('/my-orders', protect, require('../controllers/orderController').getMyOrders);

module.exports = router;
