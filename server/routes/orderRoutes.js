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

router.route('/all')
  .get(protect, authorize('admin'), getAllOrders);

router.route('/:id/verify')
  .put(protect, authorize('admin'), verifyOrder);

router.route('/:id/status')
  .patch(protect, authorize('merchant', 'driver', 'admin'), updateOrderStatus);

module.exports = router;
