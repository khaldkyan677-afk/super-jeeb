const express = require('express');
const router = express.Router();
const c = require('../controllers/merchantController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllMerchants)
  .post(protect, c.createMerchant);

router.route('/me')
  .get(protect, c.getMyMerchant);

router.route('/:id')
  .get(c.getMerchantById)
  .put(protect, authorize('admin'), c.updateMerchant)
  .delete(protect, authorize('admin'), c.deleteMerchant);

router.route('/:id/verify')
  .patch(protect, authorize('admin'), c.verifyMerchant);

module.exports = router;
