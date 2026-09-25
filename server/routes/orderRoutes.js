const express = require('express');
const router = express.Router();
const { createOrder, getMyOrders, updateOrderStatus } = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/auth');

router.route('/').post(protect, createOrder).get(protect, getMyOrders);
router.route('/:id/status').patch(protect, authorize('merchant', 'driver', 'admin'), updateOrderStatus);

module.exports = router;
