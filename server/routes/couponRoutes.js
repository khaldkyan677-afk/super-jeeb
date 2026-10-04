const express = require('express');
const router = express.Router();
const c = require('../controllers/couponController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllCoupons)
  .post(protect, authorize('admin'), c.createCoupon);

router.route('/validate/:code')
  .get(protect, c.validateCoupon);

router.route('/code/:code')
  .get(c.getCouponByCode);

router.route('/:id')
  .put(protect, authorize('admin'), c.updateCoupon)
  .delete(protect, authorize('admin'), c.deleteCoupon);

module.exports = router;
