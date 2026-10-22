const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { protect, authorize } = require('../middleware/auth');

router.get('/merchants', protect, authorize('admin'), adminController.getAdminMerchants);
router.put('/merchants/:id/toggle', protect, authorize('admin'), adminController.toggleMerchantStatus);
router.put('/merchants/:id/verify', protect, authorize('admin'), adminController.verifyMerchant);
router.delete('/merchants/:id', protect, authorize('admin'), adminController.deleteMerchant);
router.put('/merchants/:id/alert', protect, authorize('admin'), adminController.sendAlert);
router.put('/merchants/:id/commission', protect, authorize('admin'), adminController.updateCommission);

module.exports = router;
