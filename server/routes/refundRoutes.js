const express = require('express');
const router = express.Router();
const c = require('../controllers/refundController');
const { protect, authorize } = require('../middleware/auth');
router.route('/').get(protect, authorize('admin'), c.getAllRefunds).post(protect, c.createRefund);
router.route('/my').get(protect, c.getMyRefunds);
router.route('/:id').patch(protect, authorize('admin'), c.updateRefundStatus).delete(protect, authorize('admin'), c.deleteRefund);
module.exports = router;
