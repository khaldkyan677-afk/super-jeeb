const express = require('express');
const router = express.Router();
const {
  createOrder,
  getMyOrders,
  getMerchantOrders,
  getDriverOrders,
  updateOrderStatus,
  assignDriver,
  getRecentOrders,
  acceptOrder,
  rejectOrder,
  updateTripStage
} = require('../controllers/orderController');
const { cancelOrder, getOrderById } = require('../controllers/miscController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .post(protect, createOrder)
  .get(protect, getMyOrders);

router.get('/merchant', protect, authorize('merchant', 'admin'), getMerchantOrders);
router.get('/driver', protect, authorize('driver', 'admin'), getDriverOrders);

router.patch('/:id/status', protect, authorize('merchant', 'driver', 'admin'), updateOrderStatus);
router.patch('/:id/assign-driver', protect, authorize('merchant', 'admin'), assignDriver);

router.get('/recent', getRecentOrders);
router.patch('/:id/accept', acceptOrder);

router.patch('/:id/reject', rejectOrder);
router.patch('/:id/stage', updateTripStage);

router.get('/:id', getOrderById);
router.patch('/:id/cancel', cancelOrder);

module.exports = router;
