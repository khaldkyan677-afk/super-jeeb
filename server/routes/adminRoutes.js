const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { protect } = require('../middleware/auth');

router.get('/merchants', protect, adminController.getAdminMerchants);
router.put('/merchants/:id/toggle', protect, adminController.toggleMerchantStatus);
router.put('/merchants/:id/verify', protect, adminController.verifyMerchant);
router.delete('/merchants/:id', protect, adminController.deleteMerchant);
router.put('/merchants/:id/alert', protect, adminController.sendAlert);
router.put('/merchants/:id/commission', protect, adminController.updateCommission);

module.exports = router;
